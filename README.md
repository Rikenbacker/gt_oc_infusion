# gt_oc_infusion
Как это работает:
В компьютере должен быть 
1. adapter подсоединённый к ME интерфейсу.
2. transposer подсоединённый с четырёх сторон к
а) settings.inputSide к сундуку с ингридентами (ME интерфейс должен выдавать по одному рецепту)
б) settings.altarSide к центральнму пьедесталу алтаря
в) settings.piedestalSide к сундуку из котрого предметы кондуитом разносятся по пьедесталам (разносится должны по сигналу красного камня)
г) settings.outputSide сундук куда перекладывается результат инфузии
3. redstone I/O
a) settings.redstonePiedestalSide сторона откуда выдаётся сигнал на расстановку вещей по пьедесталам
б) settings.redstoneInfusionSide сторона откуда выдаётся сигнал на старт инфузии (должен приниматься на Indusion Claw)

в recipes.json описаны рецепты которые программа умеет обрабатывать.
Программа старается заказать в МЕ те аспекты которых нет в системе. Если рецепта нет и аспектов не хватает, то будет ждать аспекта (ошибка будет на экране)

Скачать можно имея internet card при помощи команд:
```
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/json.lua json.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/ra_gui.lua ra_gui.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/recipes.json recipes.json 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/runic_matrix.lua runic_matrix.lua 
```

Запуск 
```
./runic_matrix.lua 
```
