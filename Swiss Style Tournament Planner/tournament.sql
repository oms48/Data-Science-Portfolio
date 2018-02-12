
-- The database schema for multiple Swiss-style tournament.

-- to reset database during testing
DROP DATABASE IF EXISTS tournament;
-- create and connect to the database using psql commands
CREATE DATABASE tournament;
\c tournament;


DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Matches;
DROP VIEW IF EXISTS Standings;

-- create the tables necessary to support multiple Swiss-style tournaments

-- table holds player info
CREATE TABLE Player(
        PlayerID serial PRIMARY KEY,
        PlayerName varchar(50) NOT NULL
);

-- table holds match info
CREATE TABLE Matches(
        MatchID serial PRIMARY KEY,
        Winner integer NOT NULL REFERENCES Player (PlayerID),
        Loser integer NOT NULL REFERENCES Player (PlayerID)
);


-- view to calculate tournament standings
CREATE VIEW Standings AS
        SELECT Player.PlayerID, Player.PlayerName,
        (SELECT count(*) FROM Matches
        WHERE Matches.Winner = Player.PlayerID) AS NumberOfWins,
        (SELECT count(*) FROM Matches
        WHERE Matches.Winner = Player.PlayerID OR
        Matches.Loser = Player.PlayerID) AS NumberOfMatches
        FROM Player LEFT JOIN Matches
        ON Player.PlayerID = Matches.Winner OR Player.PlayerID = Matches.Loser
        GROUP BY Player.PlayerID
        ORDER BY NumberOfWins DESC
;



