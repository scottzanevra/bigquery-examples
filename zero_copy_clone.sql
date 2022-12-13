
'''
A table clone is a lightweight, writeable copy of another table (called the base table).
You are only charged for storage of data in the table clone that differs from the base table,
so initially there is no storage cost for a table clone.
'''

CREATE TABLE
project.cloned_datasets.cloned_austin_311_service_requests
CLONE project.cities_311.austin_311_service_requests;