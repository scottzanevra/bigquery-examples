


SELECT
  ST_GeogPoint(longitude, latitude)  AS WKT,
  num_bikes_available
FROM
  `bigquery-public-data.new_york.citibike_stations`
WHERE num_bikes_available > 30


-- Finds Citi Bike stations with > 30 bikes
SELECT
  ST_GeogPoint(longitude, latitude)  AS WKT,
  num_bikes_available
FROM
  `bigquery-public-data.new_york.citibike_stations`
WHERE num_bikes_available > 30


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
FROM `<your_project_id>.<dataset>.<table_name>` a
LEFT JOIN `<your_project_id>.<dataset>.<table_name>` b ON FORMAT_DATETIME('%Y%m%d%H%M', a.`BaseDateTime`) = FORMAT_DATETIME('%Y%m%d%H%M', b.`BaseDateTime`) AND a.`MMSI` != b.`MMSI`
WHERE b.MMSI IS NOT NULL
AND ST_DISTANCE(a.`the_geom`, b.`the_geom`) < 15000
ORDER BY a.`BaseDateTime` ASC;