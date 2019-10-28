--
-- CREATE USER
--
CREATE USER IF NOT EXISTS dev_master WITH PASSWORD 'dev_master_pass' SUPERUSER;

--
-- CREATE DEV KEYSPACE AND TABLES
--
CREATE KEYSPACE IF NOT EXISTS hearthstone WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};


