# gt_oc_infusion
## Описание
Программа для OpenComputers для сопровождения заказов МЕ для алтаря инфузии Thaumcraft.
При поступлении предметов на вход алтаря программа проверяет есть ли рецепт по этим предметам, проверяет наличие аспектов в МЕ (если их нет, но есть рецепт то закажет) и, после того как аспекты будут в системе, раскидает предметы по пьедесталам и стартанёт инфузию, после чего результат вернёт в МЕ.
## Устройство системы:
В компьютере должен быть 
 - adapter подсоединённый к ME интерфейсу.
 - transposer подсоединённый с четырёх сторон к
 - settings.inputSide к сундуку с ингридентами (ME интерфейс должен выдавать по одному рецепту)
 - settings.altarSide к центральнму пьедесталу алтаря
 - settings.piedestalSide к сундуку из котрого предметы кондуитом разносятся по пьедесталам (разносится должны по сигналу красного камня)
 - settings.outputSide сундук куда перекладывается результат инфузии
 - redstone I/O
 - settings.redstonePiedestalSide сторона откуда выдаётся сигнал на расстановку вещей по пьедесталам
 - settings.redstoneInfusionSide сторона откуда выдаётся сигнал на старт инфузии (должен приниматься на Indusion Claw)
## Рецепты recipes.json
```json
[
  { 
    "name": "Master Ritual Stone",
    "input": [{"name": "Ritual Stone", "size": 1},{"name": "Terrae", "size": 2},{"name": "Obsidian", "size": 4},{"name": "Reinforced Blood Stone", "size": 4}],
    "aspects": [{"name": "Terra", "size": 36},{"name": "Ignis", "size": 24},{"name": "Tenebrae", "size": 16},{"name": "Praecantatio", "size": 16},{"name": "Aer", "size": 8},{"name": "Cognitio", "size": 8}]
  },
  { 
    "name": "Crystal Cluster",
    "input": [{"name": "Etherial Blood Stone", "size": 1},{"name": "Life Shard", "size": 5},{"name": "Soul Shard", "size": 5}],
    "aspects": [{"name": "Potentia", "size": 72},{"name": "Victus", "size": 64},{"name": "Spiritus", "size": 64},{"name": "Praecantatio", "size": 32},{"name": "Tenebrae", "size": 32},{"name": "Alienis", "size": 16},{"name": "Cognitio", "size": 16}]
  }
]
```
 - name - используется только для отображения на экране
 - input.name - имя предмета, такое же как в NEI, используется для сверки предметов в рецепете
 - aspects.name - имя аспекта, такое же как в NEI, используется для сверки аспектов по рецепту
## Установка программы:
Для установки программы необходимо скачать на компьютер файлы: json.lua, ra_gui.lua, recipes.json, runic_matrix.lua 
Скачать можно имея internet card при помощи команд:
```bash
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/json.lua json.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/ra_gui.lua ra_gui.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/recipes.json recipes.json 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/runic_matrix.lua runic_matrix.lua 
```
либо вручную.
## Запуск 
```
./runic_matrix.lua 
```
## Обустройство алтаря и требования к железу.
coming soon
## Пример работы
coming soon
