// 1. Jogadores decisivos (clutch)
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



// 2. Dependência de jogador (time “refém”)
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




// 3. Força do mando de quadra (arena decisiva)
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




// 4. Jogadores mais consistentes
// Menor variação de pontos por jogo
// Jogador confiável vs jogador “8 ou 80”.


MATCH (p:Player)-[pi:PLAYED_IN]->(:Game)
WITH p, avg(pi.points) AS avgPts,
     stdev(pi.points) AS variation
RETURN p.name AS player,
       round(avgPts,1) AS avgPoints,
       round(variation,2) AS consistency
ORDER BY consistency ASC;




// 5. Rivalidade equilibrada
// Jogos decididos por até 5 pontos
// Jogos mais emocionantes.

MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WHERE abs(h.score - a.score) <= 5
RETURN g.id AS game, home.id AS home, away.id AS away,
       h.score AS homeScore, a.score AS awayScore
ORDER BY abs(h.score - a.score);




// 6. “Carregou o time nas costas”
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




// 7. Eficiência ofensiva (pontos por jogo)
// Time que mais pontua em média
// Melhor ataque da liga.

MATCH (g:Game)-[h:HOME_TEAM]->(t:Team)
WITH t, h.score AS pts
UNION ALL
MATCH (g:Game)-[a:AWAY_TEAM]->(t:Team)
WITH t, a.score AS pts
RETURN t.id AS team, round(avg(pts),1) AS avgPoints
ORDER BY avgPoints DESC;




// 8. Melhor defesa
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




// 9. Jogadores “vilões”
// Jogadores que sempre jogam bem fora de casa
// Jogadores que silenciam arenas adversárias.

MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
MATCH (g)-[a:AWAY_TEAM]->(t:Team)
WHERE (p)-[:PLAYS_FOR]->(t)
RETURN p.name AS player, round(avg(pi.points),1) AS avgAwayPoints
ORDER BY avgAwayPoints DESC;




// 10. Narrativa de temporada
// Evolução do time jogo a jogo
// Análise temporal (gráfico).

MATCH (g:Game)-[h:HOME_TEAM]->(home:Team {id:'LAL'})
OPTIONAL MATCH (g)-[a:AWAY_TEAM]->(:Team)
RETURN g.date AS date, h.score AS points
ORDER BY date;



