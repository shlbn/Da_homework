--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов 
-- (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

SELECT *
FROM product p
JOIN laptop l
ON p.model = l.model


SELECT *
FROM 
) 
sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет 
-- процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
select maker, (count(type) * 100)  / (select count(type) from product)  as percent
from product
group by maker

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

select *
from distribution_by_type


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships s 
where name like '% %'

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select ship
from outcomes o
left join ships s
on s.name= o.ship
where class is null and o.ship like 'S%'



--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
-- и три самых дорогих (через оконные функции). Вывести model

select *
from product p
join printer pr
on p.model = pr.model
where  (p.type = 'Printer' and price > ( select avg(price) from printer ) ) or p.model  like '1%'
