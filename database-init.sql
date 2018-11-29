CREATE TABLE button_click (
  id serial PRIMARY KEY,
  uuid VARCHAR(37),
  button_id VARCHAR(90),
  created_date TIMESTAMP NOT NULL DEFAULT now(),
  clicks integer
);

CREATE TABLE page_load (
  id serial PRIMARY KEY,
  uuid VARCHAR(37),
  user_device_type VARCHAR(40),
  user_agent text,
  created_date TIMESTAMP NOT NULL DEFAULT now(),
  loads integer
);