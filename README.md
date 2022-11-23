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
 - settings.redstoneInfusionSide сторона откуда выдаётся сигнал на старт инфузии (должен приниматься на Infusion Claw)  
 Все параметры из settings настраиваемые прямо в коде.
## Рецепты recipes.json
Рецепты в поставке конечно же не полные и требуют ручного заполнения под себя. Пример рецепта:
```json
[
  { 
    "name": "Ichor",
    "input": [{"name": "minecraft:nether_star/0", "size": 1},{"name": "gregtech:gt.metaitem.02/29500", "size": 1},{"name": "ThaumicTinkerer:kamiResource/6", "size": 1},{"name": "minecraft:ender_eye/0", "size": 1},{"name": "ThaumicTinkerer:kamiResource/7", "size": 1}],
    "aspects": [{"name": "gaseousspiritusessentia", "size": 64},{"name": "gaseoushumanusessentia", "size": 32},{"name": "gaseousluxessentia", "size": 32},{"name": "gaseousalienisessentia", "size": 16},{"name": "gaseousordoessentia", "size": 16}]
  },
  {
    "name": "Block of Ichorium",
    "input": [{"name": "dreamcraft:tile.Mytryl/0", "size": 1},{"name": "gregtech:gt.metaitem.01/11978", "size": 2},{"name": "AWWayofTime:bloodMagicBaseItems/28", "size": 1},{"name": "ThaumicTinkerer:kamiResource/0", "size": 2},{"name": "AWWayofTime:standardBindingAgent/0", "size": 1},{"name": "AWWayofTime:bloodMagicBaseItems/29", "size": 1},{"name": "AWWayofTime:bloodMagicBaseAlchemyItems/4", "size": 1}],
    "aspects": [{"name": "gaseousvictusessentia", "size": 64},{"name": "gaseousfamesessentia", "size": 48},{"name": "gaseouspraecantatioessentia", "size": 32},{"name": "gaseousinfernusessentia", "size": 24},{"name": "gaseousalienisessentia", "size": 16},{"name": "gaseoussuperbiaessentia", "size": 16},{"name": "gaseousterraessentia", "size": 8}]
  }
]
```
 - name - используется только для отображения на экране
 - input.name - имя предмета, в формате name/damage, используется для сверки предметов в рецепете
 - aspects.name - имя аспекта, см. файл essentia.json, используется для сверки аспектов по рецепту и для заказа
## Описание эссенций essenti.json
Описание должно быть полным сразу из поставки. Но может редактироваться с целью перевода
```json
{
  "gaseousterraessentia": {"label": "Terra", "aspect": "terra"},
  "gaseousordoessentia": {"label": "Ordo", "aspect": "ordo"}
}
```
 - идентификатор - Идентификатор эссенции (name в МЕ). Думаю очевидно для чего оно нужно
 - идентификатор.label - Отображаемое имя эссенции. Используется только для отображения на экране, можно писать что угодно
 - идентификатор.aspect - имя аспекта для поиска рецепта в МЕ. Не стоит редактировать, по нему идёт поиск рецепта
## Установка программы:
Для установки программы необходимо скачать на компьютер файлы: json.lua, ra_gui.lua, recipes.json, runic_matrix.lua 
Скачать можно имея internet card при помощи команд:
```bash
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/json.lua json.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/ra_gui.lua ra_gui.lua 
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/recipes.json recipes.json
wget https://raw.githubusercontent.com/Rikenbacker/gt_oc_infusion/main/essentia.json essentia.json
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
10. Transposer (в центре). Должен быть единственным в сетию Имеет 4 активные стороны: settings.inputSide, settings.altarSide, settings.piedestalSide, settings.outputSide. На скриншоте он соединён с сундуками и пьедесталом не напрямую а через Transvector Interface из-за моей особенности стабилизации алтаря, вы вольны делать как вам удобно.
11. Центральный пьедестал алтаря (сверху). Тут наверное кроме как через трансвектор и не соеденить
12. Сундук раздатчик (слева) на остальные пьедесталы.
13. Сундук куда приходят предметы из МЕ интерфейса (справа).
14. Сундук куда падает результат инфузии (снизу). Отсюда предмет кондуитом вытаскивается обратно в МЕ интерфейс.
## Пример работы
coming soon
## Известные проблемы
1. Палочка в стартере инфузии не заряжается и за её зарядосм никто не следит. Я не придумал как это сделать не уродуя внешний вид алтаря. В качестве решения предлагаю запихать внутрь палочку на 1000 вис и забыть о ней на 600 инфузий.

