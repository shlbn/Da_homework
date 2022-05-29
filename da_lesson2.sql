--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


-- Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select maker, avg(hd)
from product x
join pc 
on x.model = pc.model
where maker in 
(
select maker
from product x 
join printer p 
on x.model = p.model 
)
group by maker


-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
SELECT name ,"class"
FROM ships
where name != "class"
where launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
SELECT name ,"class"
FROM ships
where launched > 1920 and launched <=1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select count(name), "class"
from ships s 
group by "class"

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select "class", country 
from Classes c 
where numguns >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship
from outcomes 
where battle = 'North Atlantic' and result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--

select ship
from battles b 
join outcomes o2
on o2.battle = b.name
where result = 'sunk' and date in 
(
	select max(date)
	from battles b 
	join outcomes o2
	on o2.battle = b.name
	where result = 'sunk'
	group by result
)

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--

select name, "class" 
from ships b
where "name" in (
	select ship
	from outcomes o
	join battles b
	on o.battle = b.name
	where result = 'sunk'
)


-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select name as ship, s.class
from ships s 
join classes cl
on s.class = cl.class
where bore >= 16 and name in 
(
	select ship
	from outcomes o 
	where result = 'sunk'
)


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--

select class 
from classes c 
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select name,s."class" 
from ships s
join classes c 
on s."class" = c."class"
where country = 'USA'
