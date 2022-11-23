--Ёбаный пиздец тут в коде, но нужно разобраться как выдёргивать из шаблона ингридиенты, как красиво в интерфейсе реализовать подбор аспектов

local component = require("component")
local s = require("sides")
local event = require("event")
local computer = require("computer")

local arguments_as_a_table = {...}


local adresses = {}
--[[
Code Made by: Lewissaber#7231

Settuping:
Put database(tier 2+) in random adapter
Place Interfaces u want to copy patterns from, connect them with adapter
Add their adresses and number of them to config 
in interface slot #36 put indicator pattern
place interfaces you want to copy TO
fill them with random pattern(pattern need to have 1 input and 1 output(like 1 oak plank makes 1 mushroom)) and place indicator pattern in slot 36
indicator pattern is pattern that you use to connect your interfaces, interfaces with same indicator pattern will share same recipes(indicator item is pattern output)

program call examples:
 copypasеe a  b c
 copypaste a b c
 a is start of copying array
 b is end of copy array( example a = 2, b = 5, it will copy all patterns from slot 2 to slot 5), if b is not set it will only copy pattern a
 c is select set of interfaces to copy(set is based on how u put addresses, first adresse will be 1), if set to 0 will copy in all interfaces
 if b < 0 it will turn on erase mode
 erase mode : 
 pattern a in c set of interfaces will be erased
 use it before upating pattern to remove leftovers from last pattern





Russiant translation is made by Кетцаль#0802



Настройка:
Поместите базу данных (уровень 2+) в любой адаптер.
Поместите интерфейсы, с которых вы хотите копировать шаблоны, соедините их с адаптером.
Добавьте их адреса и их количество в конфиг 
в слот интерфейса #36 поместите индикаторный шаблон
поставте интерфейсы, В которые вы хотите скопировать 
заполните их случайным паттерном (паттерн должен иметь 1 вход и 1 выход (например, 1 дубовая доска делает 1 гриб)) и поместите индикаторный паттерн в слот 36
индикаторный шаблон - это шаблон, который вы используете для соединения ваших интерфейсов, интерфейсы с одинаковым индикаторным шаблоном будут иметь одинаковые рецепты (индикаторный элемент - это выход шаблона)

примеры вызова программ:
 copypaste a b c
 copypaste a b c
a - начало копируемого массива
b - конец массива копирования (пример a = 2, b = 5, это скопирует все рецепты с 2 до 5 слота), если b не задано, то будет скопирована лишь 1 рецепт "а"
c - выбор набора интерфейсов для копирования (набор зависит от того, как вы расположили адреса, первый адрес будет 1), если установить значение 0, то будут скопированы все интерфейсы. 
если b < 0, включается режим стирания
 режим стирания : 
 все шаблоны начиная с "a" до "с" будут стерты в интерфейсе
 Используйте этот режим перед обновлением шаблонов, чтобы удалить остатки предыдущих записей

--]]



--config
local number = 2 -- number of interfaces
 adresses = {"9c7a","f711"} --addresses of patter source interfaces
local slot = 36 --slot of indicator pattern

-----


local database = component.database
local db = database.address
local ifaceadress = component.me_interface
local mainfaces = {}
local proxies = {}
local interface
local pattern
local input = {}
local output = {}
local inputlength = 0
local outputlength = 0
local item
local maxpattern
local minpattern
local mode 
local placeholderitems = {}

if arguments_as_a_table[3] == nil then

  maxpattern = tonumber(arguments_as_a_table[1])
  minpattern = maxpattern 
  
  mode = tonumber(arguments_as_a_table[2])
else

  minpattern = tonumber(arguments_as_a_table[1])
  maxpattern = tonumber(arguments_as_a_table[2])
  mode = tonumber(arguments_as_a_table[3])
end
if maxpattern < 0 then maxpattern = minpattern end
--getting main interfaces
for i = 1, number do
  
  mainfaces[i] = component.get(adresses[i])
  mainfaces[mainfaces[i]] = 1
  mainfaces[i] = component.proxy(mainfaces[i])
 proxies[i] = {}
 mainfaces[i].storeInterfacePatternOutput(slot,1,db,1)
 item = database.get(1)
 placeholderitems[i] = item.label

  
end




---Sorting all interfaces
for ifaceadress, me_interface in pairs(component.list("me_interface", true)) do
interface = component.proxy(ifaceadress)
if mainfaces[interface.address] ~= 1  then
  interface.storeInterfacePatternOutput(slot,1,db,1)
   item = database.get(1)
   for i = 1, number do
    if item.label == placeholderitems[i] then
    table.insert(proxies[i],component.proxy(ifaceadress))
    
   end
   end

end


end


local function rewrite(miface,array)
for k = minpattern , maxpattern do

  --geting input/output size
    pattern  = miface.getInterfacePattern(k)
    for k=1 , #pattern.inputs do
     if pattern.inputs[k].count == nil then
      break
     end
      inputlength = inputlength + 1
        input[k] = pattern.inputs[k].count     
     
    end
    
      for k=1 , #pattern.outputs do
     
        outputlength = outputlength + 1
         output[k] = pattern.outputs[k].count     
        
      end
     

  --builddatabase from pattern
for p = 1 , inputlength do


  miface.storeInterfacePatternInput(k,p,db,p)
  
end


for p = 1,outputlength do
 miface.storeInterfacePatternOutput(k,p,db,inputlength+p)
end
for i in pairs(array) do
   interface = array[i]
  for b = 1, inputlength do
        
interface.setInterfacePatternInput(k,db,b,input[b],b)
  end
    for i = 1, outputlength do
      interface.setInterfacePatternOutput(k,db,inputlength+i,output[i], i)
    end
  end
  print("pattern ".. k .. " done")
  --clear variables
  inputlength = 0
  outputlength = 0
  input = {}
  output = {}
    end
  print("Complete")
  end


local function earase(miface,array)
for k = minpattern , maxpattern do


  --geting input/output size
    pattern  = miface.getInterfacePattern(k)
    for k=1 , #pattern.inputs do
     if pattern.inputs[k].count == nil then
      break
     end
      inputlength = inputlength + 1
     
    end
    
      for k=1 , #pattern.outputs do
        outputlength = outputlength + 1
        
      end
      
      miface.storeInterfacePatternOutput(slot,1,db,1)
      
     for i in pairs(array) do
      
   interface = array[i]
   interface.setInterfacePatternInput(k,db,1,1,1)
   interface.setInterfacePatternOutput(k,db,1,1,1)

if inputlength > 1 then
  for b = 2, inputlength do
    interface.clearInterfacePatternInput(k, 2)
   
   
  end
end
  if outputlength >  1 then
    for i = 2, outputlength do
      interface.clearInterfacePatternOutput(k, 2)
    end
  end
end

     

  
end
end
if tonumber(arguments_as_a_table[2]) < 0 then
  earase(mainfaces[mode],proxies[mode])
else

  if mode == 0 then
    for i = 1, number do
      rewrite(mainfaces[i],proxies[i])
    end
    
  else
 
      rewrite(mainfaces[mode],proxies[mode])
  end
end
  
