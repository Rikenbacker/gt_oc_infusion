local component = require("component")
local sides = require("sides")
local event = require("event")
local json = require('json')

local settings = {
  refreshInterval = 1.0, -- Время обновления в секундах
  refreshPiedistalInterval = 1, -- Время обновления в секундах
  inputSide = sides.north,
  altarSide = sides.top,
  piedestalSide = sides.south,
  outputSide = sides.down,
  redstonePiedestalSide = sides.south,
  redstoneInfusionSide = sides.north,
  recipesFileName = "recipes.json"
}

local stages = {
	waitInput = 1,
	waitAspects = 2,
	transferItems = 3,
	waitInfusion = 4
}

local Recipes = {}
function Recipes.new()
   local recipes = {}

   local f = io.open(settings.recipesFileName, "r")
   if f~=nil then 
		recipes = json.decode(f:read("*all"))
		io.close(f) 
	end	
	
	function recipes.getCount()
		return #recipes
	end
	
	function recipes.findRecipe(inputItems)
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
	
    return recipes
end

local Tools = {}
function Tools.new()
	local obj = {}
	local interface = "me_interface"
	local transposer = "transposer"
	local redstone = "redstone"

	for address, type in component.list() do
		if type == interface and obj[interface] == nil then
			obj[interface] = component.proxy(address)
		elseif type == transposer and obj[transposer] == nil then
			obj[transposer] = component.proxy(address)
		elseif type == redstone and obj[redstone] == nil then
			obj[redstone] = component.proxy(address)
		end
    end
	
	function obj.getInterface()
		return obj[interface]
	end
	
	function obj.getTransposer()
		return obj[transposer]
	end
	
	function obj.getRedstone()
		return obj[redstone]
	end	
	
	function obj.getInput()
		local items = {}
		local values = obj[transposer].getAllStacks(settings.inputSide).getAll()
		for i = 0, #values do
			if values[i].size ~= nil then
				table.insert(items, {name = values[i].label, size = values[i].size, position = i})
			end
		end
		
		return items
	end
	
	function obj.checkAspects(recipe)
		local aspects = obj[interface].getEssentiaInNetwork()
		
		local fullMatch = true
		for i = 1, #recipe.aspects do
			local match = false
			for j = 1, #aspects do
				if aspects[j].label == recipe.aspects[i].name .. " Gas" and aspects[j].amount >= recipe.aspects[i].size then
					match = true
				end
			end
			
			if match == false then
				fullMatch = false
				print("Not enought:", recipe.aspects[i].name)
			end
		end

		return fullMatch
	end
	
	function obj.transferItemsToAltar(inputItems)
		local itemName = inputItems[1].name

		obj[transposer].transferItem(settings.inputSide, settings.altarSide, 1, inputItems[1].position + 1, 1)		
		inputItems[1].size = inputItems[1].size - 1
		
		for i = 1, #inputItems do
			if inputItems[i].size > 0 then
				obj[transposer].transferItem(settings.inputSide, settings.piedestalSide, inputItems[i].size)
			end
		end
		
		obj[redstone].setOutput(settings.redstonePiedestalSide, 15)
		
		local notEmpty = true
		repeat 
			notEmpty = false
			local values = obj[transposer].getAllStacks(settings.altarSide).getAll()
			for i = 1, #values do
				if values[i].label ~= nil then
					notEmpty = true
				end
			end
			os.sleep(settings.refreshPiedistalInterval)
		until (notEmpty == false)
		
		obj[redstone].setOutput(settings.redstonePiedestalSide, 0)
		
		return itemName
	end
	
	function obj.waitForInfusion(itemName)
		obj[redstone].setOutput(settings.redstoneInfusionSide, 15)
	
		local isDone = false
        if obj[transposer].getStackInSlot(settings.altarSide, 1) ~= nil then
            if obj[transposer].getStackInSlot(settings.altarSide, 1).label ~= itemName then
				isDone = true
            end	
		else 
			print("Error: Result is dissapeared")
			isDone = true
		end
		
		if isDone == true then
			obj[redstone].setOutput(settings.redstoneInfusionSide, 0)
			
			local notEmpty = true
			repeat 
				notEmpty = false
				
				local values = obj[transposer].getStackInSlot(settings.altarSide, 1)
				if values ~= nil then
					notEmpty = true
				end
				
				obj[transposer].transferItem(settings.altarSide, settings.outputSide)
				
				os.sleep(settings.refreshPiedistalInterval)
			until (notEmpty == false)			
		end
		
		return isDone
	end	
	
	return obj
end

function main()
	local tools = Tools.new()
	local recipes = Recipes.new()
	
	if tools.getInterface() ~= nil then
		print("ME Interface found")
	else
		print("ERROR: ME Interface not found!")
		return 1
	end
	
	if tools.getTransposer() ~= nil then
		print("Transposer found")
	else
		print("ERROR: Transposer not found!")
		return 1
	end
	
	if tools.getRedstone() ~= nil then
		print("Redstone found")
	else
		print("ERROR: Redstone not found!")
		return 1
	end	
	
	print("Recipes loaded:", recipes.getCount())
	print("Ready to work!")
	
	local stage = stages.waitInput
	local recipe = nil
	local inputItems = {}
	local itemName = nil
	
	repeat
		if stage == stages.waitInput then
			inputItems = tools.getInput()
			if #inputItems > 0 then
				recipe = recipes.findRecipe(inputItems)
				if recipe == nil then
					print("Error: Recipe not found. Check input chest or add new recipe!")
				else
					print("New job:", recipe.name)
					stage = stages.waitAspects
				end
			end
		end
		
		if stage == stages.waitAspects then
			if tools.checkAspects(recipe) == true then
				print("Aspects successfully checked")
				stage = stages.transferItems
			end
		end	
		
		if stage == stages.transferItems then
			itemName = tools.transferItemsToAltar(inputItems)
			print("Item placed")
			stage = stages.waitInfusion
		end
		
		if stage == stages.waitInfusion then
			if tools.waitForInfusion(itemName) == true then
				print("Infusion Done!")
				stage = stages.waitInput
			end
		end
	until event.pull(settings.refreshInterval, "interrupted")
end

main()
--local interface = component.proxy(comp.get(batBuffersConfigArray[i].key))
--component.me_interface.getItemsInNetwork({ aspect = 'Perditio' })
