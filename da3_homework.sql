--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.


select class, count(name)
from outcomes o
join ships s 
on s.name = o.ship
where result = 'sunk'
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select distinct c.class, min(launched)
from classes c
join ships s 
on c.class = s.class
group by c.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select class, count(name)
from ships
where class in 
(
	select class
	from outcomes o
	join ships s 
	on s.name = o.ship
	where result = 'sunk'
)
group by class
having count(name) > 2


--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий 
--среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

select o.ship
from outcomes o 
join ships s 
on o.ship = s.name
where class in 
(
	select class 
	from (
	select *,
	row_number() over (partition by displacement  order by numguns asc) as rn
	from classes c 
	) a
	where rn = 1
)




--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM
--и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

select MAKER 
from product 
where model in 
(
select model 
from (
	select model, max(speed)
	from pc
	where ram = (select min(ram) from pc) 
	group by model
) as ddt
) and maker in (
select maker
from product p 
join printer pr
on p.model = pr.model
)

