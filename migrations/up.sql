-- Create PostGIS extensions if they don't exist
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- User location data
CREATE TABLE user_location (
  user_id INTEGER PRIMARY KEY,
  location GEOGRAPHY(Point)
);

-- Landmark location data
CREATE TABLE landmark (
  id SERIAL PRIMARY KEY,
  name TEXT,
  type TEXT,
  location GEOGRAPHY(Point)
);

-- SETOF table
CREATE TABLE user_landmarks (
  user_id INTEGER,
  location GEOGRAPHY(Point),
  nearby_landmarks JSON
);

-- function returns a list of landmarks near a user based on the
-- input arguments distance_kms and userid
CREATE FUNCTION search_landmarks_near_user(userid integer, distance_kms integer)
RETURNS SETOF user_landmarks AS $$
  SELECT  A.user_id, A.location,
  (SELECT json_agg(row_to_json(B)) FROM landmark B
    WHERE (
      ST_Distance(
        ST_Transform(B.location::Geometry, 3857),
        ST_Transform(A.location::Geometry, 3857)
      ) /1000) < distance_kms
    ) AS nearby_landmarks
  FROM user_location A where A.user_id = userid
$$ LANGUAGE sql STABLE;