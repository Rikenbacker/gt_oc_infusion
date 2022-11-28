local component = require("component")
local json = require('json')

local settings = {
  recipesFileName = "recipes.json",
  essentiaFileName = "essentia.json",
  maxPatternsCount = 36
}

local Essentia = {}
function Essentia.new()
	local essentia = {}
	local obj = {}
	
	local f = io.open(settings.essentiaFileName, "r")
	if f~=nil then 
		essentia = json.decode(f:read("*all"))
		io.close(f) 
	end
	
	function obj.getLabel(name)
		if (essentia[name]) == nil then
			return name
		else
			return essentia[name].label
		end
	end
	
	function obj.getAspect(name)
		if (essentia[name]) == nil then
			return name
		else
			return essentia[name].aspect
		end
	end
	
	function obj.getCount()
		return #essentia
	end
	
	function obj.getByPartName(partName)
		local result = {}
		
		for key, value in pairs(essentia) do
			if type(value) == "table" then
				if string.find(value.label, partName) ~= nil or string.find(value.aspect, partName) ~= nil then
					table.insert(result, key)
				end
			end
		end
		
		return result
	end
	
	return obj
end

local Recipes = {}
function Recipes.new()
   local recipes = {}
   local obj = {}

   local f = io.open(settings.recipesFileName, "r")
   if f~=nil then 
		recipes = json.decode(f:read("*all"))
		io.close(f) 
	end	   
	
	function obj.getCount()
		return #recipes
	end
	
	function obj.get(n)
		return recipes[n]
	end
	
	function obj.findRecipe(inputItems)
		for i = 1, #recipes do
			if #recipes[i].input == #inputItems then
				local fullMatch = true
				for j = 1, #inputItems do
					if inputItems[j].name ~= recipes[i].input[j].name or inputItems[j].size ~= recipes[i].input[j].size then
						fullMatch = false
					end
				end
				
				if fullMatch == true then
					return recipes[i]
				end
			end
		end
		return nil
	end
	
	function obj.insert(name, inputs, essentias)
		table.insert(recipes, {name = name, input = inputs, aspects = essentias})
		
		local f = io.open(settings.recipesFileName, "w")
		if f~=nil then 
			f:write(json.encode(recipes))
			io.close(f) 
		end
	end
	
	return obj
end


local Tools = {}
function Tools.new()
	local obj = {}
	local interface = "me_interface"
	local database = "database"

	for address, type in component.list() do
		if type == interface and obj[interface] == nil then
			obj[interface] = component.proxy(address)
		elseif type == database and obj[database] == nil then
			obj[database] = component.proxy(address)
		end
	end
	
	function obj.getInterface()
		return obj[interface]
	end

	function obj.getDatabase()
		return obj[database]
	end
	
	function obj.makeLabel(item)
		return item.name .. "/" .. item.damage
	end
	
	function obj.loadRecipes(recipes)
		local patterns = {}
		
		-- Получаю список шаблонов и краткую информацию для дальнейшего заполнения
		for patternSlot = 1, settings.maxPatternsCount do
			local pattern = obj[interface].getInterfacePattern(patternSlot)
			if pattern ~= nil then
				-- Заполняю входные данные те что можно без использовани БД
				local inputs = {}
				for i = 1, #pattern.inputs do
					if pattern.inputs[i].count ~= nil then
						table.insert(inputs, {position = i, size = pattern.inputs[i].count})
					end
				end
				
				-- Ищу певый заполненный выходной слот чтобы оттуда спереть наименование результата
				local outputSlot = nil
				for i = 1, #pattern.outputs do
					if pattern.outputs[i].count ~= nil and outputSlot == nil then
						outputSlot = i
					end
				end
				
				table.insert(patterns, {slot = patternSlot, name = pattern.outputs[outputSlot].name, inputSlots = inputs})
			end
		end
		print("Patterns: " .. #patterns)
		
		-- Дозаполняю рецепты по данным через БД
		for _, recipe in pairs(patterns) do
			io.write(recipe.name)		
			local items = {}
			
			for i = 1, #recipe.inputSlots do
				obj[interface].storeInterfacePatternInput(recipe.slot, recipe.inputSlots[i].position, obj[database].address, 1)
				table.insert(items, {name = obj.makeLabel(obj[database].get(1)), size = recipe.inputSlots[i].size})
			end
			
			recipe.readRecipe = items
			recipe.foundRecipe = recipes.findRecipe(items)
			if recipe.foundRecipe == nil then
				print(": New")
			else
				print ": exists"
			end
		end
		
		return patterns		
	end
	
	return obj
end

function showListRecipes(recipes)
	for i = 1, recipes.getCount() do
		print(recipes.get(i).name)
	end
end

function addNewRecipe(pattern, recipes, essentia)
	local finished = false
	local aspects = {}
	
	while finished == false do
		print(pattern.name .." now needed ".. #aspects .. " types of essentia.")
		print("To add aspect to recipe type begining of the aspect name (like \"praec\" or \"victu\") and press enter. Or input empty string for finishing.")
		io.flush()
		local aspectName = io.read("*l")
		if aspectName ~= "" then
			local essentias = essentia.getByPartName(aspectName)
			if #essentias == 0 then
				print("Matches not found. Pleace try again.")
			else
				for i, id in pairs(essentias) do
					print("("..i..") " .. essentia.getLabel(id))
				end
				print("(0) for choose another")
				local num = io.read("*n")
				io.read()
				if num < 0 or num > #essentias then
					print("Wrong number.")
				elseif num ~= 0 then
					local id = essentias[num]
					print("How much ".. essentia.getLabel(id) .. "?")
					local count = io.read("*n")
					io.read()
					table.insert(aspects, {name = id, size = count})
				end
			end
		else -- aspectName ~= ""
			print("Write new recipe? Y/n")
			local answer = io.read("*l")
			if answer == "Y" or answer == "y" then
				recipes.insert(pattern.name, pattern.readRecipe, aspects)
			end
			finished = true
		end
	end
end

function scanPatterns(tools, recipes, essentia)
	patterns = tools.loadRecipes(recipes)

	if #patterns == 0 then
		print("Patterns not fount.")
		return
	end
	
	for _, pattern in pairs(patterns) do
		if pattern.foundRecipe == nil then
			print("New recipe found: " .. pattern.name .. ". Do you want to add it? Y/n")
			result = io.read("*l")
			if result == "Y" or result == "y" then
				addNewRecipe(pattern, recipes, essentia)
			end
		end
	end
end

function main()
	local tools = Tools.new()
	local recipes = Recipes.new()
	local essentia = Essentia.new()

	if tools.getInterface() ~= nil then
		print("ME Interface found")
	else
		print("ERROR: ME Interface not found!")
		return 1
	end
	
	if tools.getDatabase() ~= nil then
		print("Database found")
	else
		print("ERROR: Database not found!")
		return 1
	end	
	
	print("Recipes loaded:", recipes.getCount())
	
	print("")
	
	local result = ""
	
	while result ~= "0" do
		print("1 - Show recipes list")
		print("2 - Scan interface for new recipes")
		print("0 - exit")
				
		result = io.read("*l")
		
		if result == "1" then
			showListRecipes(recipes)
		elseif result == "2" then
			scanPatterns(tools, recipes, essentia)
		end
	end
end

main()
