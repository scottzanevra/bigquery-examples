SELECT max(create_time.timestamp) as max_timestamp FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`

SELECT max(finding_id) as max_container_version FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`

SELECT location.content_locations as location_content FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`, UNNEST(location.content_locations) AS locations


SELECT
  max(loc.container_version) as max_container_version
FROM
  `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`,
  UNNEST(location.content_locations) as loc

-- Select the count of each infoType by day
SELECT info_type.name, COUNT(DISTINCT loc.container_name) AS count, loc.container_version
FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`,
UNNEST(location.content_locations) as loc
WHERE loc.container_version = "1663299868269"
GROUP BY info_type.name, loc.container_version
ORDER BY count DESC;

-- Select the count of each infoType by day
SELECT info_type.name, cast(TIMESTAMP_SECONDS(create_time.seconds) as date) as day,
COUNT(locations.container_name) AS count
FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`,
UNNEST(location.content_locations) AS locations
GROUP BY info_type.name, day
ORDER BY count DESC;

-- Selects the count of each infoType in each container
SELECT info_type.name, locations.container_name,
COUNT(locations.container_name) AS count
FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`,
UNNEST(location.content_locations) AS locations
GROUP BY locations.container_name, info_type.name
ORDER BY count DESC;

-- Selects the count of each infoType
SELECT info_type.name, COUNT(info_type.name) AS count
FROM `dataplex-demo-342803.data_dlp_output.san_francisco_311_service_requests`


-- Selects the finding types found for each column of a table
SELECT
  table_counts.field_name,
  STRING_AGG( CONCAT(" ",table_counts.name," [count: ",CAST(table_counts.count_total AS String),"]")
  ORDER BY
    table_counts.count_total DESC) AS infoTypes
FROM (
  SELECT
    locations.record_location.field_id.name AS field_name,
    info_type.name,
    COUNT(*) AS count_total
  FROM
    [PROJECT_ID].[DATASET].[TABLE_ID],
    UNNEST(location.content_locations) AS locations
  WHERE
    (likelihood = 'LIKELY'
      OR likelihood = 'VERY_LIKELY'
      OR likelihood = 'POSSIBLE')
  GROUP BY
    locations.record_location.field_id.name,
    info_type.name
  HAVING
    count_total>200 ) AS table_counts
GROUP BY
  table_counts.field_name
ORDER BY
  table_counts.field_name

