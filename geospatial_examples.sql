/* AIS Data from MarineCadastre.gov */
-- Create a table that contains the Vessel data within the Seattle area
CREATE OR REPLACE TABLE `table-explorer.ais_demo.ais_seattle_2021` AS
(SELECT
  MMSI,
  BaseDateTime,
  SOG,
  VesselName,
  CallSign,
  ST_GEOGPOINT(LON, LAT) AS the_geom,
  Heading
FROM
  `table-explorer.ais_demo.test3`
WHERE
  VesselName LIKE '%CMA%'
  AND ST_CONTAINS(ST_GEOGFROMTEXT('POLYGON((-125.851549 48.884916, -122.324938 48.982349, -121.314196 47.061110, -126.774401 46.929977, -125.851549 48.884916))'), ST_GEOGPOINT(LON, LAT)));

-- Find the names of the ships that were outside Chad's window in December 2021
SELECT
  VesselName,
  DATE_DIFF(MAX(`BaseDateTime`), MIN(`BaseDateTime`), DAY) AS days_in_area,
  MIN(`BaseDateTime`) AS arrived,
  MAX(`BaseDateTime`) AS departed
FROM `table-explorer.ais_demo.ais_seattle_2021`
GROUP BY 1;

-- Measure the distance between ships for different time periods
CREATE OR REPLACE TABLE `table-explorer.ais_demo.ais_seattle_2021_compare` AS
SELECT
  a.*,
  LAST_DAY(CAST(a.BaseDateTime AS DATETIME), WEEK) AS week_end,
  b.VesselName AS comparison_vessel,
  ST_DISTANCE(a.`the_geom`, b.`the_geom`) AS distance_meters,
  ST_AZIMUTH(a.`the_geom`, b.`the_geom`) AS azimuth,
  ST_MAKELINE(a.`the_geom`, b.`the_geom`) AS distance_line,
  FORMAT_DATETIME('%Y%m%d%H%M', a.`BaseDateTime`) AS compare_time,
  CASE
    WHEN a.Heading BETWEEN 45 AND 134 THEN 'East'
    WHEN a.Heading BETWEEN 135 AND 224 THEN 'South'
    WHEN a.Heading BETWEEN 225 AND 314 THEN 'West'
    ELSE 'North' END AS vessel_direction,
  CASE
    WHEN b.Heading BETWEEN 45 AND 134 THEN 'East'
    WHEN b.Heading BETWEEN 135 AND 224 THEN 'South'
    WHEN b.Heading BETWEEN 225 AND 314 THEN 'West'
    ELSE 'North' END AS comparison_vessel_direction,
  CASE
    WHEN ABS(a.Heading - b.Heading) <= 45 THEN 'Convergent'
    ELSE 'Divergent' END AS direction_comparison
FROM `table-explorer.ais_demo.ais_seattle_2021` a
LEFT JOIN `table-explorer.ais_demo.ais_seattle_2021` b ON FORMAT_DATETIME('%Y%m%d%H%M', a.`BaseDateTime`) = FORMAT_DATETIME('%Y%m%d%H%M', b.`BaseDateTime`) AND a.`MMSI` != b.`MMSI`
WHERE b.MMSI IS NOT NULL
ORDER BY a.`BaseDateTime` ASC;

-- Analyze the distance between ships
SELECT
  a.*,
  LAST_DAY(CAST(a.BaseDateTime AS DATETIME), WEEK) AS week_end,
  b.VesselName AS comparison_vessel,
  ST_DISTANCE(a.`the_geom`, b.`the_geom`) AS distance_meters,
  ST_AZIMUTH(a.`the_geom`, b.`the_geom`) AS azimuth,
  ST_MAKELINE(a.`the_geom`, b.`the_geom`) AS distance_line,
  FORMAT_DATETIME('%Y%m%d%H%M', a.`BaseDateTime`) AS compare_time,
  CASE
    WHEN a.Heading BETWEEN 45 AND 134 THEN 'East'
    WHEN a.Heading BETWEEN 135 AND 224 THEN 'South'
    WHEN a.Heading BETWEEN 225 AND 314 THEN 'West'
    ELSE 'North' END AS vessel_direction,
  CASE
    WHEN b.Heading BETWEEN 45 AND 134 THEN 'East'
    WHEN b.Heading BETWEEN 135 AND 224 THEN 'South'
    WHEN b.Heading BETWEEN 225 AND 314 THEN 'West'
    ELSE 'North' END AS comparison_vessel_direction,
  CASE
    WHEN ABS(a.Heading - b.Heading) <= 45 THEN 'Convergent'
    ELSE 'Divergent' END AS direction_comparison
FROM `table-explorer.ais_demo.ais_seattle_2021` a
LEFT JOIN `table-explorer.ais_demo.ais_seattle_2021` b ON FORMAT_DATETIME('%Y%m%d%H%M', a.`BaseDateTime`) = FORMAT_DATETIME('%Y%m%d%H%M', b.`BaseDateTime`) AND a.`MMSI` != b.`MMSI`
WHERE b.MMSI IS NOT NULL
AND ST_DISTANCE(a.`the_geom`, b.`the_geom`) < 15000
ORDER BY a.`BaseDateTime` ASC;