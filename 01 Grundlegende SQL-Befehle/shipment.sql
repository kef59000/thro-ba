-- 01) Zeige alle Plants an
SELECT *
FROM plant;


-- 02) Zeige alle K-Namen, K-Strasse, K-PLZ, K-Ort
SELECT Kname, Kstrasse, KPlz, Kort
FROM customer;


-- 03 Zeige alle Outlet-Kunden an
SELECT Kname, Kstrasse, KPlz, Kort
FROM customer
WHERE Kart = 'Outlet';


-- 04) Sortiere Abfrage_03 nach PLZ
SELECT *
FROM (
	SELECT Kname, Kstrasse, KPlz, Kort
	FROM customer
	WHERE Kart = 'Outlet')
ORDER BY KPlz ASC;


-- 05) Wie viele Tonnen FMCG wurde distribuiert?
SELECT sum(GWkg)/1000 AS Tonnen
FROM shipment;


-- 06) Wie viele Tonnen FMCG wurde von den einzelnen Plants ausgeliefert?
SELECT Plant, sum(GWkg)/1000 AS Tonnen
FROM shipment
GROUP BY Plant;


-- 07 Was war das minimale, durchschnittliche und maximale Sendungsgewicht pro Plant und Tarifgruppe?
SELECT Plant, TT2, min(Pallets) AS MinPal, avg(Pallets) AS AvgPal, max(Pallets) AS MaxPal 
FROM shipment
GROUP BY Plant, TT2;


-- 08) An welchen Tagen wurde ausgeliefert
SELECT Distinct Delivery_day
FROM shipment;


-- 09) An wie vielen Tagen wurde ausgeliefert
SELECT count(*) As Anzahl
FROM (
	SELECT Distinct Delivery_day
	FROM shipment);


-- 10) In welche PLZ wurden die einzelnen Sendungen geliefert
SELECT shipment.Shp_no, customer.KPlz
FROM shipment
INNER JOIN customer
ON shipment."Ship-to2" = customer.ID;


-- 11) Wie viele Tonnen FMCG wurden in die einzelnen PLZ geliefert
SELECT customer.KPlz, sum(shipment.GWkg) As Sum_KG
FROM shipment
INNER JOIN customer
ON shipment."Ship-to2" = customer.ID
GROUP BY customer.KPlz;


-- 12) Wie viele Tonnen FMCG wurden von welcher PLZ in welche PLZ geliefert
SELECT plant.PPlz, customer.KPlz, sum(shipment.GWkg) As Sum_KG
FROM plant
INNER JOIN (
	shipment
	INNER JOIN customer
	ON shipment."Ship-to2" = customer.ID)
ON plant.ID = shipment.Plant
GROUP BY plant.PPlz, customer.KPlz;


-- 13) Wie viel KG FMCG wurden an den Kunden 10099192 an den einzelnen Tagen geliefert?
SELECT Tab_1.Delivery_day, Tab_2.Gewicht
FROM (
	SELECT Distinct Delivery_day
	FROM shipment) as Tab_1
LEFT JOIN (
	SELECT Delivery_day, sum(GWkg) As Gewicht
	FROM shipment
	WHERE "Ship-to2" = 10099192
	GROUP BY Delivery_day) as Tab_2
ON Tab_1.Delivery_day = Tab_2.Delivery_day
ORDER BY Tab_1.Delivery_day;
