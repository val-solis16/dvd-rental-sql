--1.Muestre todas las películas disponibles que son catalogadas con rating de ‘PG’ o ‘PG-13’, además que su duración de renta se encuentra entre 5 a 6, y su tamaño (largo) es mayor a 180.
SELECT 
	title,
	description,
	rating,
	rental_duration,
	length 
FROM film
WHERE rating IN ('PG','PG-13')
      AND rental_duration IN (5,6)
	  AND length > 180;

--CONCLUSIÓN: La consulta muestra 7 registros de las películas en el que su rating es ‘PG o PG-13’, lo cual quiere decir que son muy pocas las películas que tienen esta restricción parental, ya que el total de películas en la base de datos corresponde a 1000 títulos y solo 7 registros fueron encontrados (0.7%), además su duración de renta es de ‘5 a 6 días’ y el tamaño es superior a ‘180’. 

--2.Muestre un listado de todos los clientes con su Nombre, Apellido y correo electrónico, que rentaron videos pero deben cumplir con: El Apellido es ‘Simpson’, el inventory_id es 2580 o bien, 596, y la tienda donde se rentó es la 1. 
SELECT
    c.first_name,
    c.last_name,
    c.email,
	i.inventory_id,
    i.store_id 
FROM
    customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE c.last_name = 'Simpson'
    AND i.inventory_id IN (2580)
    AND i.store_id = 1;

--CONCLUSIÓN: La consulta realizada de todos los clientes (Nombre-Apellido y correo) que rentaron videos cuyo apellido es ‘Simpson’, el inventory_id es ‘2580’ y la tienda es la ‘1’, solo mostró un resultado, el cual corresponde a Ellen Simpson.

--3.Muestre un listado de todas las películas en habla ‘English’ y cuyo título de la película contenga ‘Egg’ en algún lado. 
SELECT 
	f.title,
	l.name
FROM film f 
INNER JOIN language l ON f.language_id = l.language_id
WHERE l.name = 'English'
	AND f.title LIKE '%Egg%';

--CONCLUSIÓN: Se realizó la consulta correspondiente a todas las películas de habla ‘English’ y que dentro del nombre del título estuviera presente la palabra ‘Egg’. Se obtuvo como resultado 3 registros: African Egg - Egg Igby - Racer Egg, todas en habla ‘English’. 
	
--4.Muestre las películas cuyo actor tiene como nombre ‘Penelope’ , la película tiene como tasa de renta 0.99 y un tamaño (length) de 175. 
SELECT 
	f.title,
	f.rental_rate,
	f.length,
	a.first_name,
	a.last_name
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = 'Penelope'
	AND f.rental_rate = 0.99
	AND f.length = 175;

--CONCLUSIÓN: La consulta de las películas cuyo nombre del actor(a) es ‘Penelope’, la tasa de renta corresponde a ‘0.99’ y el tamaño a ‘175’, solo muestra un registro de la película ‘Splash Gump’ , en donde la actriz es Penelope Guiness. 

--5.Muestre un listado de todos los países en donde se tiene presencia la empresa de Alquiler de Videos. En el mismo listado debe aparecer la cantidad de clientes en dicho país, y las ventas totales realizadas hasta el momento. 
SELECT
	cn.country, 
	COUNT (c.customer_id) AS cant_clientes,
    SUM (p.amount) AS ventas_totales
FROM country cn 
INNER JOIN city ct ON cn.country_id = ct.country_id
INNER JOIN address a ON ct.city_id = a.city_id
INNER JOIN customer c ON a.address_id = c.address_id
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY cn.country
ORDER BY ventas_totales DESC;

--CONCLUSIÓN: La consulta realizada sobre los ‘países’ en donde se encuentra presente el alquiler de videos, la ‘cantidad de clientes’ y ‘ventas totales’ por país mostró un total de 108 registros. Estos ordenados de manera descendente en donde la India y China dominan las ventas totales (6034.78 y 5251.03) y la cantidad de clientes (1422 y 1297), seguidos de otros paises como Estados Unidos, Mexico y Brasil. 

--6.Muestre la cantidad de películas se encuentran en la categoría de “Action”, “Comedy” o “Family”. Imprima ACCION, COMEDIA o FAMILIAR y la cantidad de películas.
SELECT
    CASE
        WHEN LOWER(cat.name) = 'action' THEN 'ACCION'
        WHEN LOWER(cat.name) = 'comedy' THEN 'COMEDIA'
        WHEN LOWER(cat.name) = 'family' THEN 'FAMILIAR'
		END cat_esp,
    COUNT(f.film_id) AS cant_peliculas
FROM
    film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category cat ON fc.category_id = cat.category_id
WHERE LOWER(cat.name) IN ('action', 'comedy', 'family')
GROUP BY
    cat_esp 
ORDER BY
    cat_esp; 

--CONCLUSIÓN: La consulta anterior muestra 3 registros, los cuales corresponden a la cantidad de películas que se encuentran presentes en las categorías de ‘ACCION’-‘COMEDIA’-‘FAMILIAR’, siendo la categoría FAMILIAR la que predomina con 69 títulos, seguido de ACCION con 64 y COMEDIA con 58 títulos. 

--7.Muestre cuantas clientes tiene por primer nombre ‘Grace’, además cuantas actrices tiene como primer nombre ‘Susan’ y cuantos empleados (staff) tienen como primer nombre ‘Mike’. Todo tiene que aparecer en una sola sentencia.
SELECT 'Grace' AS first_name, COUNT(*), 'Cliente' AS descripcion FROM customer WHERE first_name = 'Grace'
UNION
SELECT 'Susan' AS first_name, COUNT(*), 'Actrices' AS descripcion FROM actor WHERE first_name = 'Susan'
UNION
SELECT 'Mike' AS first_name, COUNT(*), 'Staff' AS descripcion FROM staff WHERE first_name = 'Mike';

--CONCLUSIÓN: Se realizó la consulta correspondiente a la cantidad de clientes que tienen como primer nombre ‘Grace’, la cantidad de actrices que tienen como primer nombre ‘Susan’ y la cantidad de empleados con el nombre ‘Mike’. Esta consulta muestra una cliente con el nombre ‘Grace’, dos actrices con el nombre ‘Susan’ y un empleado con el nombre ‘Mike’. 

-- 8.Muestre un listado de todas las películas que han sido alquiladas entre las fechas 25 de mayo del 2005 al 26 de mayo del 2005. De este listado, mostrar el número de boleta de alquiler, la fecha de alquiler, el nombre y apellido de la persona empleada que lo alquiló, el titulo y la descripción de la película. 
SELECT 
	r.rental_id,
	r.rental_date,
	s.first_name,
	s.last_name,
	f.title, 
	f.description
FROM rental r
INNER JOIN staff s ON r.staff_id = s.staff_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
WHERE r.rental_date BETWEEN '2005-05-25' AND '2005-05-26';

--CONCLUSIÓN: Esta consulta muestra 137 registros, los cuales corresponden a las películas que fueron alquiladas en el ‘período del 25 al 26 de mayo del 2005’, estos registros conforman el 13.7% del total de películas en la base de datos (1000). Así mismo se muestra el ‘número de la boleta de alquiler’, ‘nombre y apellido del empleado que alquiló el título’, el ‘nombre del título’ y su ‘descripción’. 

--9.  Muestre todas las películas en donde posee características especiales como escenas borradas o Detrás de las escenas.
SELECT  
    title,  
    description,  
    special_features 
FROM film 
WHERE (special_features::text) LIKE '%Deleted Scenes%' OR (special_features::text) LIKE '%Behind The 
Scenes%';

--CONCLUSIÓN: La consulta anterior refleja las películas que contienen características especiales como ‘escenas eliminadas o detrás de escenas’, y como se puede observar, el resultado muestra un total de 503 registros, lo cual significa que un 50.3% del total de los títulos en la base de datos, contienen este tipo de características especiales. 

--10. Muestre todas los clientes que compraron en la tienda 1, y muestre el Nombre, Apellido del cliente, y la última fecha en que alquiló algo en esa tienda. 
SELECT  
c.first_name, 
c.last_name,  
MAX(r.rental_date) AS ultima_fecha 
FROM rental r 
INNER JOIN customer c ON r.customer_id = c.customer_id 
INNER JOIN store s ON c.store_id = s.store_id 
WHERE s.store_id = 1 
GROUP BY c.first_name, c.last_name; 

--CONCLUSIÓN: La última consulta muestra el ‘nombre y apellido de los clientes que realizaron una compra de alquiler de video en la tienda 1’, así como la ‘última fecha en la que alquiló un título en esa tienda específicamente’. El resultado corresponde a 326 registros que cumplen con los criterios anteriormente mencionados. 