Relatorio AABD - NBA (Neo4j + MongoDB)

1) SGBDs escolhidos
- Grafos: Neo4j (Cypher)
- Documentos: MongoDB

2) Tema e aplicacao
Sistema de informacao da NBA para equipes, jogos, resultados, escalacoes, locais e estatisticas.

3) Conjunto de dados (amostra)
Entidades principais: Team, Player, Coach, Arena, Game, Season.
A amostra cobre 4 times, 12 jogadores, 4 jogos e estatisticas por jogo.

4) Modelagem
4.1) Grafo (Neo4j)
- Nodes: Team, Player, Coach, Arena, Game, Season
- Relacionamentos:
  - (Player)-[:PLAYS_FOR {number, since}]->(Team)
  - (Coach)-[:COACHES {since}]->(Team)
  - (Team)-[:HOME_ARENA]->(Arena)
  - (Game)-[:IN_SEASON]->(Season)
  - (Game)-[:PLAYED_AT]->(Arena)
  - (Game)-[:HOME_TEAM {score}]->(Team)
  - (Game)-[:AWAY_TEAM {score}]->(Team)
  - (Player)-[:PLAYED_IN {points, rebounds, assists, minutes}]->(Game)

Diagrama: diagramas/neo4j.mmd

4.2) Documentos (MongoDB)
Colecoes:
- teams: dados do time + coach + roster
- players: dados do jogador
- arenas: dados de arenas
- games: dados de jogos + boxscore (estatisticas por jogador)

Diagrama: diagramas/mongodb.mmd

5) Insercao de dados
- Neo4j: neo4j/insert.cypher
- MongoDB: mongodb/insert.js

6) Consultas (objetivo, comando e resultado esperado)

6.1) Neo4j (10 consultas)
Q1) Listar time, arena e tecnico
Cypher:
MATCH (t:Team)-[:HOME_ARENA]->(a:Arena)
MATCH (c:Coach)-[:COACHES]->(t)
RETURN t.id AS team, a.name AS arena, c.name AS coach
ORDER BY team;
Resultado:
LAL | Crypto.com Arena | Darvin Ham
GSW | Chase Center | Steve Kerr
BOS | TD Garden | Joe Mazzulla
MIA | Kaseya Center | Erik Spoelstra

Q2) Pontos totais por jogador de um time (LAL)
Cypher:
MATCH (p:Player)-[:PLAYS_FOR]->(t:Team {id:'LAL'})
MATCH (p)-[pi:PLAYED_IN]->(g:Game)
RETURN p.name AS player, sum(pi.points) AS points
ORDER BY points DESC;
Resultado:
LeBron James 53
Anthony Davis 46
D'Angelo Russell 28

Q3) Jogos com placar e vencedor
Cypher:
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
RETURN g.id AS game, home.id AS home, h.score AS homeScore,
       away.id AS away, a.score AS awayScore,
       CASE WHEN h.score > a.score THEN home.id ELSE away.id END AS winner
ORDER BY g.date;
Resultado:
G1 LAL 112 GSW 108 LAL
G2 BOS 118 MIA 110 BOS
G3 GSW 121 BOS 125 BOS
G4 MIA 102 LAL 99 MIA

Q4) Maior pontuador de cada jogo
Cypher:
MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
WITH g, p, pi.points AS points
ORDER BY g.id, points DESC
WITH g, collect({player:p.name, points:points})[0] AS top
RETURN g.id AS game, top.player AS player, top.points AS points
ORDER BY game;
Resultado:
G1 Stephen Curry 30
G2 Jayson Tatum 32
G3 Stephen Curry 34
G4 Jimmy Butler 27

Q5) Media de pontos por jogador (temporada)
Cypher:
MATCH (p:Player)-[pi:PLAYED_IN]->(:Game)
RETURN p.name AS player, round(avg(pi.points)*10)/10 AS avgPoints
ORDER BY avgPoints DESC;
Resultado (amostra):
Stephen Curry 32.0
Jayson Tatum 30.5
LeBron James 26.5
Jimmy Butler 26.5
Anthony Davis 23.0

Q6) Confronto direto entre LAL e GSW
Cypher:
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team {id:'LAL'})
MATCH (g)-[a:AWAY_TEAM]->(away:Team {id:'GSW'})
RETURN g.id AS game, h.score AS homeScore, a.score AS awayScore;
Resultado:
G1 112 108

Q7) Jogadores com double-double (>=10 pontos e rebotes)
Cypher:
MATCH (p:Player)-[pi:PLAYED_IN]->(g:Game)
WHERE pi.points >= 10 AND pi.rebounds >= 10
RETURN DISTINCT p.name AS player
ORDER BY player;
Resultado:
Anthony Davis
Bam Adebayo
Draymond Green

Q8) Recorde de vitorias por time
Cypher:
MATCH (g:Game)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[a:AWAY_TEAM]->(away:Team)
WITH home, away, h.score AS hs, a.score AS as
WITH CASE WHEN hs > as THEN home ELSE away END AS winner,
     CASE WHEN hs > as THEN away ELSE home END AS loser
RETURN winner.id AS team, count(*) AS wins
ORDER BY wins DESC;
Resultado:
BOS 2
LAL 1
MIA 1

Q9) Jogos em uma arena (TD Garden)
Cypher:
MATCH (g:Game)-[:PLAYED_AT]->(a:Arena {id:'TDG'})
MATCH (g)-[h:HOME_TEAM]->(home:Team)
MATCH (g)-[aw:AWAY_TEAM]->(away:Team)
RETURN g.id AS game, home.id AS home, h.score AS homeScore,
       away.id AS away, aw.score AS awayScore;
Resultado:
G2 BOS 118 MIA 110

Q10) Jogadores que fizeram 25+ contra o LAL
Cypher:
MATCH (g:Game)-[:HOME_TEAM|AWAY_TEAM]->(t:Team {id:'LAL'})
MATCH (p:Player)-[pi:PLAYED_IN]->(g)
WHERE pi.points >= 25 AND NOT (p)-[:PLAYS_FOR]->(t)
RETURN p.name AS player, g.id AS game, pi.points AS points
ORDER BY points DESC;
Resultado:
Jimmy Butler G4 27

6.2) MongoDB (10 consultas)
Q1) Times com nome da arena
Mongo:
 db.teams.aggregate([
  {$lookup:{from:'arenas', localField:'arenaId', foreignField:'_id', as:'arena'}},
  {$unwind:'$arena'},
  {$project:{_id:0, team:'$_id', arena:'$arena.name'}}
 ])
Resultado:
LAL Crypto.com Arena
GSW Chase Center
BOS TD Garden
MIA Kaseya Center

Q2) Roster de um time (BOS)
Mongo:
 db.teams.find({_id:'BOS'},{_id:0,name:1,coach:1,roster:1})
Resultado: roster do BOS com tecnico

Q3) Jogos com vencedor calculado
Mongo:
 db.games.aggregate([
  {$project:{_id:1, home:'$home.teamId', away:'$away.teamId',
    homeScore:'$home.score', awayScore:'$away.score',
    winner:{ $cond:[{$gt:['$home.score','$away.score']},'$home.teamId','$away.teamId']}
  }}
 ])
Resultado: G1 LAL, G2 BOS, G3 BOS, G4 MIA

Q4) Media de pontos por jogador
Mongo:
 db.games.aggregate([
  {$unwind:'$boxscore'},
  {$group:{_id:'$boxscore.playerId', avgPoints:{$avg:'$boxscore.points'}}},
  {$lookup:{from:'players', localField:'_id', foreignField:'_id', as:'player'}},
  {$unwind:'$player'},
  {$project:{_id:0, player:'$player.name', avgPoints:{$round:['$avgPoints',1]}}},
  {$sort:{avgPoints:-1}}
 ])
Resultado (amostra): Stephen Curry 32, Jayson Tatum 30.5, LeBron James 26.5

Q5) Top scorer por jogo
Mongo:
 db.games.aggregate([
  {$unwind:'$boxscore'},
  {$sort:{'_id':1,'boxscore.points':-1}},
  {$group:{_id:'$_id', top:{$first:'$boxscore'}}},
  {$lookup:{from:'players', localField:'top.playerId', foreignField:'_id', as:'player'}},
  {$unwind:'$player'},
  {$project:{_id:1, player:'$player.name', points:'$top.points'}}
 ])
Resultado: G1 Curry 30, G2 Tatum 32, G3 Curry 34, G4 Butler 27

Q6) Recorde de vitorias por time
Mongo:
 db.games.aggregate([
  {$project:{winner:{ $cond:[{$gt:['$home.score','$away.score']},'$home.teamId','$away.teamId']}}},
  {$group:{_id:'$winner', wins:{$sum:1}}},
  {$sort:{wins:-1}}
 ])
Resultado: BOS 2, LAL 1, MIA 1

Q7) Double-double (>=10 pts e rebotes)
Mongo:
 db.games.aggregate([
  {$unwind:'$boxscore'},
  {$match:{'boxscore.points':{$gte:10},'boxscore.rebounds':{$gte:10}}},
  {$group:{_id:'$boxscore.playerId'}},
  {$lookup:{from:'players', localField:'_id', foreignField:'_id', as:'player'}},
  {$unwind:'$player'},
  {$project:{_id:0, player:'$player.name'}}
 ])
Resultado: Anthony Davis, Bam Adebayo, Draymond Green

Q8) Confrontos LAL x GSW
Mongo:
 db.games.find({$or:[
  {home:{teamId:'LAL'}, away:{teamId:'GSW'}},
  {home:{teamId:'GSW'}, away:{teamId:'LAL'}}
 ]},{_id:1,home:1,away:1})
Resultado: G1 LAL 112 x 108 GSW

Q9) Jogos por arena (TD Garden)
Mongo:
 db.games.find({arenaId:'TDG'},{_id:1,home:1,away:1,date:1})
Resultado: G2

Q10) Jogadores 25+ pontos contra LAL
Mongo:
 db.games.aggregate([
  {$match:{$or:[{'home.teamId':'LAL'},{'away.teamId':'LAL'}]}},
  {$unwind:'$boxscore'},
  {$match:{'boxscore.points':{$gte:25}}},
  {$lookup:{from:'players', localField:'boxscore.playerId', foreignField:'_id', as:'player'}},
  {$unwind:'$player'},
  {$project:{_id:0, player:'$player.name', game:'$_id', points:'$boxscore.points'}}
 ])
Resultado: Jimmy Butler G4 27

7) Dumps
- MongoDB: mongodump --db nba --out ./mongodb_dump
- Neo4j: neo4j-admin dump --database=neo4j --to=./neo4j_dump.dump

