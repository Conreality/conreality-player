DROP TABLE IF EXISTS user;

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS player;
CREATE TABLE player (
  player_id INTEGER PRIMARY KEY NOT NULL,
  player_nick TEXT NOT NULL,
  player_rank TEXT NULL,
  player_headset BOOLEAN NULL,
  player_heartrate INTEGER NULL,
  player_distance REAL NULL,
  player_avatar BLOB NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS game;
CREATE TABLE game (
  game_id INTEGER PRIMARY KEY NOT NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS message;
CREATE TABLE message (
  message_id INTEGER PRIMARY KEY NOT NULL,
  message_timestamp DATETIME NOT NULL,
  message_seen BOOLEAN NOT NULL,
  message_sender INTEGER NULL,
  message_recipient INTEGER NULL,
  message_text TEXT NULL,
  message_audio BLOB NULL
);