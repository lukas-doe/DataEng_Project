CREATE TABLE IF NOT EXISTS postgres_temperature_data (
    sensor_id TEXT,
    temperature DOUBLE PRECISION,
    ts TIMESTAMP
);

CREATE TABLE IF NOT EXISTS postgres_temperature_data_filtered (
    sensor_id TEXT,
    temperature DOUBLE PRECISION,
    ts TIMESTAMP
);