--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). 
--Вывести: model, maker, type

select model, maker, type
from product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case	
	when price > (select avg(price) from printer ) then 1
	else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select ship
from outcomes o 
join ships s 
on s.name = o.ship 
where class is null

select name
from ships s 
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.


select distinct battle
from 
(
select *,
case 
	when year_battle = launched then 1
	else 0
end flag
from 
(
	select ship, o.battle , date_part('year', date) as year_battle, launched
	from outcomes o 
	join battles b
	on o.battle = b.name
	join ships s 
	on s.name = o.ship
) a
) a2
where flag = 0


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle 
from  outcomes o  
where ship in (select name from ships where class ='Kongo')

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. 
-- Во view три колонки: model, price, flag

create view all_products_flag_300 as
select *, 
case
	when price > 300 then 1
	else 0
end flag
from 
(
select model, price
from pc 
	union all
select model, price
from printer 
	union all
select model, price
from laptop
) a


--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
select *, 
case
	when price > avg(price) over (partition by model) then 1
	else 0
end flag
from 
(
select model, price
from pc 
	union all
select model, price
from printer 
	union all
select model, price
from laptop
) a

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select p.model
from printer p 
join product p2 
on p.model = p2.model
where maker = 'A' and price > (
	select avg(price)
	from printer p 
	join product p2 
	on p.model = p2.model
	where maker = 'D' or maker = 'C'
)

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select p.model
from printer p 
join product p2 
on p.model = p2.model
where maker = 'A' and price > (
	select avg(price)
	from printer p 
	join product p2 
	on p.model = p2.model
	where maker = 'D' or maker = 'C'
)

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select avg(price)
from product p
join (
	select model, price
	from printer p 
		union all
	select model, price 
	from laptop
		union all
	select model, price 
	from pc 
) a
on p.model = a.model 
where maker= 'A'

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(model) 
from product
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)



--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
select code, p.model, color, p.type, price
from printer p
join product pr
on p.model = pr.model
where maker != 'D'

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, p.model, color, p.type, price, maker 
from printer_updated p
join product pr
on p.model = pr.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
-- Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

select total,
case 
	when a2.class is not null then a2.class -
	else 0
end flag
from (
select class, count(ship) as total
from (
select ship, class
from outcomes o
left join ships s
on o.ship = s.name
where result = 'sunk'
) a
group by class
) a2

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)



--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
