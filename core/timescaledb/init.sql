--create user hcrl with superuser password 'hcrl';

-- Users
CREATE TABLE IF NOT EXISTS users (
    id uuid NOT NULL,
    username VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    fname VARCHAR NOT NULL,
    lname VARCHAR NOT NULL,
    role SMALLINT NOT NULL,

    PRIMARY KEY (id),
    UNIQUE (username)
);

-- Location
CREATE TABLE IF NOT EXISTS location (
    location_name VARCHAR NOT NULL,
    PRIMARY KEY (location_name)
);

-- Device
CREATE TABLE IF NOT EXISTS device (
    device_id uuid NOT NULL,
    location_name VARCHAR NOT NULL,
    device_name VARCHAR NOT NULL,
    device_type VARCHAR NOT NULL,
    timezone SMALLINT NOT NULL,
    date_added TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (device_id),
    FOREIGN KEY (location_name) REFERENCES location(location_name) ON DELETE CASCADE
);

-- Element
CREATE TABLE IF NOT EXISTS element (
    device_id uuid NOT NULL,
    element_id VARCHAR NOT NULL,
    element_name VARCHAR NOT NULL,
    unit VARCHAR NOT NULL,
    icon VARCHAR NOT NULL,

    PRIMARY KEY (device_id, element_id),
    FOREIGN KEY (device_id) REFERENCES device(device_id) ON DELETE CASCADE
);

-- Time series
CREATE TABLE IF NOT EXISTS timeseries (
    timestamp TIMESTAMPTZ NOT NULL,
    device_id uuid NOT NULL,
    element_id VARCHAR NOT NULL,
    firmware_version VARCHAR NOT NULL,
    operation_time_since TIMESTAMPTZ NOT NULL,
    value NUMERIC(16, 7) NOT NULL
);

-- Event and Triggers
CREATE TABLE IF NOT EXISTS events (
    event_id uuid NOT NULL,
    device_id uuid NOT NULL,
    element_id VARCHAR NOT NULL,
    event_name VARCHAR NOT NULL,
    status SMALLINT NOT NULL,
    operator VARCHAR NOT NULL,
    comparison_value NUMERIC(16, 7) NOT NULL,
    line_notify_key VARCHAR NOT NULL,
    message VARCHAR NOT NULL,
    date_added TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (event_id),
    FOREIGN KEY (device_id, element_id) REFERENCES element(device_id, element_id) ON DELETE CASCADE
);

-- EMQX users
CREATE TABLE IF NOT EXISTS mqtt_user (
  id SERIAL PRIMARY KEY,
  username CHARACTER VARYING(100),
  password CHARACTER VARYING(100),
  salt CHARACTER VARYING(40),
  is_superuser BOOLEAN,
  UNIQUE (username)
);

-- EMQX ACL
CREATE TABLE mqtt_acl (
  id SERIAL PRIMARY KEY,
  allow INTEGER,
  ipaddr CHARACTER VARYING(60),
  username CHARACTER VARYING(100),
  clientid CHARACTER VARYING(100),
  access  INTEGER,
  topic CHARACTER VARYING(100)
);
CREATE INDEX ipaddr ON mqtt_acl (ipaddr);
CREATE INDEX username ON mqtt_acl (username);
CREATE INDEX clientid ON mqtt_acl (clientid);

SELECT create_hypertable('timeseries', 'timestamp', if_not_exists => TRUE, chunk_time_interval => INTERVAL '6 hours');

CREATE INDEX ON timeseries (device_id, element_id, timestamp DESC);

SELECT add_retention_policy('timeseries', INTERVAL '30 days');


-- EMQX admin 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('admin', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, true),
       ('root', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, true);
       
-- EMQX meta data
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('edge_emqx', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX data persistent 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('edge_emqx1', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX event & trigger 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('edge_emqx2', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX realtime 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('edge_emqx3', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX observer 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('observer', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX rtu simulator 
INSERT INTO mqtt_user (username, password, salt, is_superuser)
VALUES ('rtu1', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false),
       ('rtu2', '20026c441514c1614c884b1a4fb5b4215d5a6462009f9440c7a0812cb12df644', NULL, false);

-- EMQX ACL allow all topics subscription
INSERT INTO mqtt_acl (allow, ipaddr, username, clientid, access, topic) 
VALUES (1, NULL, '$all', NULL, 3, 'iot/#');