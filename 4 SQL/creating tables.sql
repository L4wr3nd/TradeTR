#CREATING DATABASE AND TABLES (2021 EXPORT, 2021 IMPORT, %Y/Y export or import change) AND IMPORTING DATA TO TABLES
CREATE DATABASE Export_Import;
use Export_Import;

CREATE TABLE 80export (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  E_Total DECIMAL(20, 3)
);
#DROP TABLE 80Export;
SELECT * FROM 80export;
#imported 80export.csv data
#data verification below
select avg(E_Total), count(E_Total), sum(E_Total) from 80export;

CREATE TABLE export (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  E_Total DECIMAL(20, 3)
);
#DROP TABLE export;
SELECT * FROM export;
#imported export.csv data
#data verification below
select avg(E_Total), count(E_Total), sum(E_Total) from export;


CREATE TABLE 80import (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  I_Total DECIMAL(20, 3)
);
#DROP TABLE 80import;
SELECT * FROM 80import;
#imported 80import.csv data
#data verification below
select avg(I_Total), count(I_Total), sum(I_Total) from 80import;

CREATE TABLE import (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  I_Total DECIMAL(20, 3)
);
#DROP TABLE import;
SELECT * FROM import;
#imported import.csv data
#data verification below
select avg(I_Total), count(I_Total), sum(I_Total) from import;

CREATE TABLE export_change (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  13_14 DECIMAL(20, 3),
  14_15 DECIMAL(20, 3),
  15_16 DECIMAL(20, 3),
  16_17 DECIMAL(20, 3),
  17_18 DECIMAL(20, 3),
  18_19 DECIMAL(20, 3),
  19_20 DECIMAL(20, 3),
  20_21 DECIMAL(20, 3)
);
#DROP TABLE export_change;
select * from export_change;
#imported export_change.csv data

CREATE TABLE import_change (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  13_14 DECIMAL(20, 3),
  14_15 DECIMAL(20, 3),
  15_16 DECIMAL(20, 3),
  16_17 DECIMAL(20, 3),
  17_18 DECIMAL(20, 3),
  18_19 DECIMAL(20, 3),
  19_20 DECIMAL(20, 3),
  20_21 DECIMAL(20, 3)
);
#DROP TABLE import_change;
select * from import_change;
#imported import_change.csv data

#created export_change, import_change tables don't include records with null values; I checked below that no bigger exporters/importers were missed
select e.*, ec.*
from export e
left join export_change ec
on e.ID_Code = ec.ID_Code
order by ec.ID_Code asc, e.E_Total desc;

select i.*, ic.*
from import i
left join import_change ic
on i.ID_Code = ic.ID_Code
order by ic.ID_Code asc, i.I_Total desc;

create table countries_list (
	ID_Code int primary key,
    country varchar(255)
);
#DROP TABLE countries_list;
select * from countries_list;
#imported EI_countries_list.csv data

CREATE TABLE total_export (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  E_Year INT,
  E_Total DECIMAL(20, 3)
);
#DROP TABLE total_export;
SELECT * FROM total_export;
#imported export_all_countries.csv data
#data verification below
select avg(E_Total), count(E_Total), sum(E_Total) from total_export;

CREATE TABLE total_import (
  ID_Code INT PRIMARY KEY,
  Country VARCHAR(255),
  I_Year INT,
  I_Total DECIMAL(20, 3)
);
#DROP TABLE total_import;
SELECT * FROM total_import;
#imported import_all_countries.csv data
#data verification below
select avg(I_Total), count(I_Total), sum(I_Total) from total_import;

select * from total_export;
select * from total_import;


#WORKING WITH TABLES (JOINS, UNION) AND CREATING FINAL DATA FILES
select me.*, IFNULL(i.I_Total, 0) as I_Total
from 80export me
left join import i
on me.ID_Code = i.ID_Code
#order by me.E_Total desc, i.I_Total desc;
union
select mi.ID_Code, mi.Country, IFNULL(e.E_Total, 0) as E_Total, mi.I_Total
from 80import mi
left join export e
on mi.ID_Code = e.ID_Code
order by ID_Code asc;

select c.*, e.E_Year, (e.E_Total/i.I_Total) as 'E/I', e.E_Total, i.I_Total
from countries_list c
left join total_export e
on c.ID_Code = e.ID_Code
left join total_import i
on e.ID_Code = i.ID_Code
and e.E_Year = i.I_Year;
#exported csv file was filled with Confidential Country data

select e.*, i.*
from countries_list c
left join export_change e
on c.ID_Code = e.ID_Code
left join import_change i
on c.ID_Code = i.ID_Code;
#ultimately records from the query above were not used

select e.ID_Code, e.Country, IFNULL(e.E_Year, i.I_Year) as Year, E_Total, IFNULL(i.I_Total, 0) as I_Total
from total_export e
left join total_import i
on e.ID_Code = i.ID_Code
and e.Country = i.Country
and e.E_Year = i.I_Year
where e.E_total != 0 and i.I_Total != 0
union
select i.ID_Code, i.Country, IFNULL(e.E_Year, i.I_Year), IFNULL(e.E_Total, 0), i.I_Total
from total_export e
right join total_import i
on e.ID_Code = i.ID_Code
and e.Country = i.Country
and e.E_Year = i.I_Year
where e.E_total != 0 and i.I_Total != 0;
#ultimately records from the query above were not used