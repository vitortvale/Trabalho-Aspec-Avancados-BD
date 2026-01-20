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

// Q11: Jogadores decisivos (clutch)
// Quem faz mais pontos em **jogos vencidos pelo time**
// Quem realmente contribui para vitórias, não só pontua muito.


MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
MATCH (p)-[:PLAYS_FOR]->(t:Team)
MATCH (g)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WHERE (t = home AND h.score > a.score)
   OR (t = away AND a.score > h.score)
RETURN p.name AS player, sum(pi.points) AS pointsInWins
ORDER BY pointsInWins DESC;



// Q12: Dependência de jogador (time “refém”)
// Percentual de pontos do time feitos por um jogador
// Times muito dependentes de uma estrela.

MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
MATCH (p)-[:PLAYS_FOR]->(t:Team)
MATCH (g)-[ht:HOME_TEAM]->(home:Team)
MATCH (g)-[at:AWAY_TEAM]->(away:Team)
WITH t, p,
     sum(pi.points) AS playerPoints,
     sum(CASE 
           WHEN t = home THEN ht.score
           WHEN t = away THEN at.score
         END) AS teamPoints
RETURN t.id AS team, p.name AS player,
       round(100.0 * playerPoints / teamPoints, 1) AS pctOfTeamPoints
ORDER BY pctOfTeamPoints DESC;




// Q13: Força do mando de quadra (arena decisiva)
// Aproveitamento do time jogando em casa
// Arenas que realmente fazem diferença.

MATCH (g:Game)-[h:HOME_TEAM]->(t:Team)
MATCH (g)-[a:AWAY_TEAM]->(:Team)
WITH t,
     sum(CASE WHEN h.score > a.score THEN 1 ELSE 0 END) AS wins,
     count(*) AS games
RETURN t.id AS team,
       wins AS homeWins,
       games AS homeGames,
       round(100.0 * wins / games, 1) AS homeWinPct
ORDER BY homeWinPct DESC;




// Q14: Jogadores mais consistentes
// Menor variação de pontos por jogo
// Jogador confiável vs jogador “8 ou 80”.


MATCH (p:Player)-[pi:PLAYED_IN]->(:Game)
WITH p, avg(pi.points) AS avgPts,
     stdev(pi.points) AS variation
RETURN p.name AS player,
       round(avgPts,1) AS avgPoints,
       round(variation,2) AS consistency
ORDER BY consistency ASC;




// Q15: Rivalidade equilibrada
// Jogos decididos por até 5 pontos
// Jogos mais emocionantes.

MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WHERE abs(h.score - a.score) <= 5
RETURN g.id AS game, home.id AS home, away.id AS away,
       h.score AS homeScore, a.score AS awayScore
ORDER BY abs(h.score - a.score);




// Q16: “Carregou o time nas costas”
// Jogador que fez 30+ pontos e o time venceu
// Atuações históricas.

MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
MATCH (p)-[:PLAYS_FOR]->(t:Team)
MATCH (g)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WHERE pi.points >= 30
  AND ((t = home AND h.score > a.score)
    OR (t = away AND a.score > h.score))
RETURN p.name AS player, g.id AS game, pi.points AS points
ORDER BY points DESC;




// Q17: Eficiência ofensiva (pontos por jogo)
// Time que mais pontua em média
// Melhor ataque da liga.
MATCH (g:Game)-[r:HOME_TEAM|AWAY_TEAM]->(t:Team)
RETURN t.id AS team, round(avg(r.score), 1) AS avgPoints
ORDER BY avgPoints DESC;




// Q18: Melhor defesa
// Time que menos sofre pontos
// Quem ganha jogo defendendo.

MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WITH home AS team, a.score AS conceded
UNION ALL
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WITH away AS team, h.score AS conceded
RETURN team.id AS team, round(avg(conceded),1) AS avgPointsAgainst
ORDER BY avgPointsAgainst ASC;




// Q19: Jogadores “vilões”
// Jogadores que sempre jogam bem fora de casa
// Jogadores que silenciam arenas adversárias.

MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
MATCH (g)-[a:AWAY_TEAM]->(t:Team)
WHERE (p)-[:PLAYS_FOR]->(t)
RETURN p.name AS player, round(avg(pi.points),1) AS avgAwayPoints
ORDER BY avgAwayPoints DESC;




// Q20: Narrativa de temporada
// Evolução do time jogo a jogo
// Análise temporal (gráfico).

MATCH (g:Game)-[h:HOME_TEAM]->(home:Team {id:'LAL'})
OPTIONAL MATCH (g)-[a:AWAY_TEAM]->(:Team)
RETURN g.date AS date, h.score AS points
ORDER BY date;



