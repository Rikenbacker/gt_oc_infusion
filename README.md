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
 Все параметры из settings настраиваемые прямо в коде.
## Рецепты recipes.json
Рецепты в поставке конечно же не полные и требуют ручного заполнения под себя. Пример рецепта:
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
Внешний вид алтаря:
![alt text](https://github.com/Rikenbacker/gt_oc_infusion/blob/main/.readme.img/2022-11-21_20-59-49.png?raw=true)
Основные элементы на скриншоте:
1. Infusion Claw с палочкой внутри прямо над рунической матрицей (он же стартер)
2. Блок Gregtech с Redstone Receiver (External) cover направленный прямо на стартер. Соединён с Transmiter из п. 9
3. Infusion Provider соединённый с МЕ сетью хранящий аспекты и рецепты с их созданием.  
Вид алтаря без стабилизации и украшений
![alt text](https://github.com/Rikenbacker/gt_oc_infusion/blob/main/.readme.img/2022-11-21_21-11-21.png?raw=true)
4. Как видно все пьедесталы за исключением центрального соеденены кондуитами раздающими предметы по сигналу красного камня.
![alt text](https://github.com/Rikenbacker/gt_oc_infusion/blob/main/.readme.img/2022-11-21_21-11-58.png?raw=true)
5. МЕ интерфейс с рецептами к которому подключенё п.6
6. Адаптер компьютера. Обязательно должен быть направлен на единственный в данной компьютерной (не МЕ!) сети.
![alt text](https://github.com/Rikenbacker/gt_oc_infusion/blob/main/.readme.img/2022-11-21_21-12-49.png?raw=true)
7. Redstone I/O. Блок компьютерной сети выдающий сигналы красного камня. Должен быть единственный в компьютерной сети. Имеет две активные стороны: settings.redstonePiedestalSide и settings.redstoneInfusionSide. Описаны выше.
8. Кондуит забирающий предметы из сундука раздатчика на пьедесталы. Работает по сигналу красного камня.
9. Блок Gregtech Redstone Transmitter (External) cover направленный прямо на п.7. Соединён и Receiver из п. 3
![alt text](https://github.com/Rikenbacker/gt_oc_infusion/blob/main/.readme.img/2022-11-21_21-13-35.png?raw=true)
10. Transposer (в центра). Должен быть единственным в сетию Имеет 4 активные стороны: settings.inputSide, settings.altarSide, settings.piedestalSide, settings.outputSide. На скриншоте он соединён с сундуками и пьедесталом не напрямую а через Transvector Interface из-за моей особенности стабилизации алтаря, вы вольны делать как вам удобно.
11. Центральный пьедестал алтаря (сверху). Тут наверное кроме как через трансвектор и не соеденить
12. Сундук раздатчик (слева) на остальные пьедесталы.
13. Сундук куда приходят предметы из МЕ интерфейса (справа).
14. Сундук куда падает результат инфузии (снизу). Отсюда предмет кондуитом вытаскивается обратно в МЕ интерфейс.
## Пример работы
coming soon
## Известные проблемы
1. Палочка в стартере инфузии не заряжается и за её зарядосм никто не следит. Я не придумал как это сделать не уродуя внешний вид алтаря. В качестве решения предлагаю запихать внутрь палочку на 1000 вис.

