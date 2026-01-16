// Q1: Team, arena, coach
MATCH (t:Team)-[:HOME_ARENA]->(a:Arena)
MATCH (c:Coach)-[:COACHES]->(t)
RETURN t.id AS team, a.name AS arena, c.name AS coach
ORDER BY team;

// Q2: Total points per player for LAL
MATCH (p:Player)-[:PLAYS_FOR]->(t:Team {id:'LAL'})
MATCH (p)-[pi:PLAYED_IN]->(:Game)
RETURN p.name AS player, sum(pi.points) AS points
ORDER BY points DESC;

// Q3: Games with score and winner
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
RETURN g.id AS game, home.id AS home, h.score AS homeScore,
       away.id AS away, a.score AS awayScore,
       CASE WHEN h.score > a.score THEN home.id ELSE away.id END AS winner
ORDER BY g.date;

// Q4: Top scorer per game
MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
WITH g, p, pi.points AS points
ORDER BY g.id, points DESC
WITH g, collect({player:p.name, points:points})[0] AS top
RETURN g.id AS game, top.player AS player, top.points AS points
ORDER BY game;

// Q5: Average points per player
MATCH (p:Player)-[pi:PLAYED_IN]->(:Game)
RETURN p.name AS player, round(avg(pi.points)*10)/10 AS avgPoints
ORDER BY avgPoints DESC;

// Q6: Head-to-head LAL vs GSW
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team {id:'LAL'})
MATCH (g)-[a:AWAY_TEAM]->(away:Team {id:'GSW'})
RETURN g.id AS game, h.score AS homeScore, a.score AS awayScore;

// Q7: Double-double players
MATCH (p:Player)-[pi:PLAYED_IN]->(:Game)
WHERE pi.points >= 10 AND pi.rebounds >= 10
RETURN DISTINCT p.name AS player
ORDER BY player;

// Q8: Team wins
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WITH home, away, h.score AS hs, a.score AS as
WITH CASE WHEN hs > as THEN home ELSE away END AS winner
RETURN winner.id AS team, count(*) AS wins
ORDER BY wins DESC;

// Q9: Games at TD Garden
MATCH (g:Game)-[:PLAYED_AT]->(a:Arena {id:'TDG'})
MATCH (g)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[aw:AWAY_TEAM]->(away:Team)
RETURN g.id AS game, home.id AS home, h.score AS homeScore,
       away.id AS away, aw.score AS awayScore;

// Q10: Players with 25+ vs LAL
MATCH (g:Game)-[:HOME_TEAM|AWAY_TEAM]->(t:Team {id:'LAL'})
MATCH (p:Player)-[pi:PLAYED_IN]->(g)
WHERE pi.points >= 25 AND NOT (p)-[:PLAYS_FOR]->(t)
RETURN p.name AS player, g.id AS game, pi.points AS points
ORDER BY points DESC;
