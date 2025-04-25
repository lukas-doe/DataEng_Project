-- Kafka Source Table
CREATE TABLE temperature_data (
  sensor_id STRING,
  temperature DOUBLE,
  timestamp_str STRING,
  ts AS TO_TIMESTAMP(timestamp_str, 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS'),
  WATERMARK FOR ts AS ts - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kafka',
  'topic' = 'temperature-data',
  'properties.bootstrap.servers' = 'kafka:29092',
  'properties.group.id' = 'flink-sql-consumer',
  'scan.startup.mode' = 'earliest-offset',
  'format' = 'json',
  'json.timestamp-format.standard' = 'ISO-8601'
);

-- PostgreSQL Sink Table
CREATE TABLE postgres_temperature_data (
  sensor_id STRING,
  temperature DOUBLE,
  ts TIMESTAMP(3)
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:postgresql://postgres:5432/flinkdb',
  'table-name' = 'postgres_temperature_data',
  'username' = 'flinkuser',
  'password' = 'flinkpassword',
  'driver' = 'org.postgresql.Driver'
);

CREATE TABLE postgres_temperature_data_filtered (
  sensor_id STRING,
  temperature DOUBLE,
  ts TIMESTAMP(3)
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:postgresql://postgres:5432/flinkdb',
  'table-name' = 'postgres_temperature_data_filtered',
  'username' = 'flinkuser',
  'password' = 'flinkpassword',
  'driver' = 'org.postgresql.Driver'
);

-- Insert Statement
INSERT INTO postgres_temperature_data
SELECT sensor_id, temperature, ts
FROM temperature_data;

INSERT INTO postgres_temperature_data_filtered
SELECT sensor_id, temperature, ts
FROM temperature_data
WHERE temperature > 30;