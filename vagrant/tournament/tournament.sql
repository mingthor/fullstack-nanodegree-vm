-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;

\c tournament

DROP TABLE IF EXISTS player;
CREATE TABLE player (
	id SERIAL PRIMARY KEY,
	name TEXT,
	wins SMALLINT,
	matches SMALLINT
);

DROP TABLE IF EXISTS match;
CREATE TABLE match (
	winner INTEGER REFERENCES player (id),
	loser INTEGER REFERENCES player(id),
	CHECK(winner <> loser),
	PRIMARY KEY (winner, loser)
);

DROP VIEW IF EXISTS standingsView;
CREATE VIEW standingsView AS
SELECT id, name, wins, matches, ROW_NUMBER() OVER (ORDER BY wins DESC) AS ranking FROM player;

-- all possible pairs, assuming no draw possible
DROP VIEW IF EXISTS possiblePairsView;
CREATE VIEW possiblePairsView AS
SELECT player1.id AS id1, player1.name AS name1, player2.id AS id2, player2.name AS name2
FROM player player1 
INNER JOIN player player2 ON player1.wins=player2.wins AND player1.id<player2.id
WHERE (player1.id, player2.id) NOT IN ( 
	SELECT winner, loser from match
	UNION
	SELECT loser, winner from match
)
ORDER BY id1, id2;