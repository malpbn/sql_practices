-- SELECT * FROM championsleague.mainstats;

-- -- SELECT pjname, position, team FROM championsleague.mainstats
-- -- WHERE COALESCE(pjname, 'No name') = 'Bukayo Saka';

-- -- INSERT INTO championsleague.mainstats (pjname, position, team, matchs_played, goals, assists, minutes)
-- -- VALUES (NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- SELECT COALESCE(pjname, 'No name') FROM championsleague.mainstats;

-- UPDATE championsleague.mainstats 
-- SET pjname = 'William Saliba', position = 'Defender', team = 'Arsenal FC', matchs_played = 2, goals = 0, assists = 0, minutes = 180
-- WHERE pjcode = 2003;

-- UPDATE championsleague.mainstats 
-- SET matchs_played = 2
-- WHERE team = 'Arsenal FC';

-- UPDATE championsleague.mainstats 
-- SET assists = 2
-- WHERE pjcode = 2000;

-- SELECT (a.goals + b.assists) AS goals_and_assists FROM championsleague.mainstats AS a, championsleague.mainstats AS b
-- WHERE a.pjcode = b.pjcode;

-- ALTER TABLE championsleague.mainstats
-- ADD goals_and_assists INT;

-- UPDATE championsleague.mainstats AS a
-- JOIN (
--     SELECT a.pjcode, (a.goals + b.assists) AS goals_and_assists
--     FROM championsleague.mainstats AS a
--     JOIN championsleague.mainstats AS b ON a.pjcode = b.pjcode
-- ) AS c
-- ON a.pjcode = c.pjcode
-- SET a.goals_and_assists = c.goals_and_assists;

-- CREATE TABLE championsleague.teamstats (
-- 	teamID INT AUTO_INCREMENT PRIMARY KEY,
--     team VARCHAR(255),
--     goals BIGINT,
--     assists BIGINT,
--     goals_and_assists INT,
--     games_played INT,
--     clean_sheets INT) auto_increment = 3000;
--     
-- INSERT INTO championsleague.teamstats (team) 
-- SELECT team FROM championsleague.mainstats
-- 				WHERE team = 'Arsenal FC'
--                 LIMIT 1;

-- UPDATE championsleague.teamstats
-- SET goals = (SELECT SUM(goals) FROM championsleague.mainstats
-- 				WHERE team = 'Arsenal FC')
-- WHERE teamID = 3000;

-- UPDATE championsleague.teamstats
-- SET goals_and_assists = (SELECT SUM(goals_and_assists) FROM championsleague.mainstats
-- 			WHERE team = 'Arsenal FC')
-- WHERE teamID = 3000;

UPDATE championsleague.teamstats
SET games_played = 2, clean_sheets = 1
WHERE teamID = 3000;

SELECT * FROM championsleague.teamstats;

SELECT DATEDIFF(day, '2023-10-10', '2023-11-10') FROM championsleague.mainstats;
