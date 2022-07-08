use db_country;

-- 1. Selezionare tutte le nazioni il cui nome inizia con la P e la cui area è maggiore di 1000 kmq 
SELECT name, area
from countries c 
where name like 'P%' AND area > 1000
order by area desc;

-- 2. Selezionare le nazioni il cui national day è avvenuto più di 100 anni fa
SELECT name, national_day
from countries c 
where timestampdiff(year, national_day, CURDATE()) > 100;

-- 3. Selezionare il nome delle regioni del continente europeo, in ordine alfabetico 
select r.name
from regions r join continents c 
on c.continent_id = r.continent_id 
where LOWER(c.name) like 'europe';  

-- 4. Contare quante lingue sono parlate in Italia 
select c.name as nazione, count(l.language_id) as numero_lingue_parlate
from countries c join country_languages cl 
on c.country_id = cl.country_id 
join languages l 
on l.language_id = cl.language_id 
where LOWER(c.name) like 'italy'
group by c.name;

-- 5. Selezionare quali nazioni non hanno un national day 
select name as nazioni_senza_national_day
from countries c 
where national_day is NULL;

-- 6. Per ogni nazione selezionare il nome, la regione e il continente 
select c.name as nazione, r.name as regione, c.name as continente
from countries c join regions r 
on c.region_id = r.region_id 
join continents c2 
on c2.continent_id = r.continent_id 
group by nazione, regione, continente
order by nazione asc;

-- 7. Modificare la nazione Italy, inserendo come national day il 2  giugno 1946 
UPDATE countries set national_day = '1946-06-02'
where LOWER(name) like 'italy'; 

-- 8. Per ogni regione mostrare il valore dell'area totale 
select r.name as regione, SUM(c.area) as area_totale 
from regions r join countries c 
on r.region_id = c.region_id 
group by regione
order by area_totale desc;

-- 9. Selezionare le lingue ufficiali dell'Albania 
select l.`language` as lingue_ufficiali_albania
from countries c join country_languages cl 
on c.country_id = cl.country_id 
join languages l 
on l.language_id = cl.language_id 
where LOWER(c.name) like 'albania' and cl.official is true; 

-- 10. Selezionare il Gross domestic product (GDP) medio dello United Kingdom tra il 2000 e il 2010 
select c.name as nazione, AVG(cs.gdp) as media_gdp_2000_2010
from countries c join country_stats cs 
on cs.country_id = c.country_id 
where LOWER(c.name) like 'united kingdom' and cs.`year` >= 2000 and cs.`year` <= 2010
group by nazione;

-- 11. Selezionare tutte le nazioni in cui si parla hindi, ordinate dalla più estesa alla meno estesa 
SELECT c.name as nazioni_con_lingua_hindi, c.area
from countries c join country_languages cl 
on c.country_id = cl.country_id 
join languages l 
on l.language_id = cl.language_id 
where lower(l.`language`) like 'hindi'
order by c.area desc;

-- 12. Per ogni continente, selezionare il numero di nazioni con area superiore ai 10.000 kmq ordinando i risultati a partire 
--     dal continente che ne ha di più 

SELECT c.name as continente, count(c2.country_id) as numero_nazioni_con_area_over_10k
from continents c join regions r 
on c.continent_id = r.continent_id 
join countries c2 
on c2.region_id = r.region_id 
where c2.area > 10000
group by continente
order by numero_nazioni_con_area_over_10k desc;

