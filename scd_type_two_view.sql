

-- 1) Create table
-- This table is created without partition expiry clause. It is important as the source data is provided in a delta manner.
-- If any partition is expired and deleted, the table will miss data and will not be complete.

CREATE OR REPLACE TABLE
  `data-producer-one.test_scd.customer_type_2`
  (
    CustomerID STRING,
    CustomerNO STRING,
    Name STRING,
    BUSINESS_DATE DATE,
    DeltaType BYTEINT
  )
PARTITION BY
  BUSINESS_DATE;

-- 2) Insert records
-- After the table is created, use the following scripts to insert records directly:

-- 0 - New records
-- 1 - Update records
-- 2 - Delete records

# New Records
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('001')),'001','Raymond', DATE'2021-10-01',0);
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('002')),'002','Rob', DATE'2021-10-01',0);
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('003')),'003','Fiona', DATE'2021-10-01',0);
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('004')),'004','Kelly', DATE'2021-10-03',0);

# Update Existing Record
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('001')),'001','Ray', DATE'2021-10-02',1);

# Delete Existing Record
INSERT INTO `test_scd.customer_type_2` values(TO_HEX(MD5('003')),'003','Fiona', DATE'2021-10-03',2);


-- Implement virtual view
-- Now we can create a view to implement the virtual SCD type 2 table.
CREATE OR REPLACE VIEW
  test_scd.vw_dim_customer AS
SELECT
  CustomerID,
  CustomerNO,
  Name,
  CASE
    WHEN DeltaType = 2 THEN 1
  ELSE
  0
END
  AS IsDeleted,
  BUSINESS_DATE AS StartDate,
  COALESCE(LEAD(BUSINESS_DATE) OVER (PARTITION BY CustomerID ORDER BY BUSINESS_DATE) - 1, DATE'9999-12-31') AS EndDate
FROM
  `test_scd.customer_type_2`;


-- Query the virtualized SCD 2 table (view)
SELECT * FROM test_scd.vw_dim_customer ORDER BY CustomerNO, StartDate;


-- To query the latest data, use this filter: EndDate=DATE'9999-12-31'.
-- You can also use the typical BETWEEN AND clause to query as-was data.

SELECT * FROM test_scd.vw_dim_customer WHERE EndDate=DATE'9999-12-31' AND IsDeleted !=1


-- Helper Script when stuff is broken
DELETE `test_scd.customer_type_2`
WHERE CustomerID = TO_HEX(MD5('001'))

DROP TABLE test_scd.customer_type_2


