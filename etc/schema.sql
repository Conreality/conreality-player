DROP TABLE IF EXISTS user;

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS team;
CREATE TABLE team (
  player_id INTEGER PRIMARY KEY NOT NULL,
  player_nick TEXT NOT NULL,
  player_rank TEXT NULL,
  player_headset INTEGER NULL,
  player_heartrate INTEGER NULL,
  player_distance REAL NULL,
  player_avatar BLOB NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS mission;
CREATE TABLE mission (
  game_id INTEGER PRIMARY KEY NOT NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS chat;
