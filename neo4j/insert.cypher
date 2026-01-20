// -----------------------------------------------------
// 1. ESTRUTURA BASE (Season, Arenas, Teams, Coaches)
// -----------------------------------------------------
MERGE (season:Season {id:'2024', name:'2024-25', year:2024})

MERGE (crypto:Arena {id:'CRYPTO', name:'Crypto.com Arena', city:'Los Angeles'})
MERGE (chase:Arena {id:'CHASE', name:'Chase Center', city:'San Francisco'})
MERGE (tdg:Arena {id:'TDG', name:'TD Garden', city:'Boston'})
MERGE (kaseya:Arena {id:'KASEYA', name:'Kaseya Center', city:'Miami'})
MERGE (ball:Arena {id:'BALL', name:'Ball Arena', city:'Denver'})
MERGE (fiserv:Arena {id:'FISERV', name:'Fiserv Forum', city:'Milwaukee'})
MERGE (foot:Arena {id:'FOOT', name:'Footprint Center', city:'Phoenix'})
MERGE (aac:Arena {id:'AAC', name:'American Airlines Center', city:'Dallas'})

MERGE (lal:Team {id:'LAL', name:'Los Angeles Lakers', city:'Los Angeles', conference:'West', division:'Pacific'})
MERGE (gsw:Team {id:'GSW', name:'Golden State Warriors', city:'San Francisco', conference:'West', division:'Pacific'})
MERGE (bos:Team {id:'BOS', name:'Boston Celtics', city:'Boston', conference:'East', division:'Atlantic'})
MERGE (mia:Team {id:'MIA', name:'Miami Heat', city:'Miami', conference:'East', division:'Southeast'})
MERGE (den:Team {id:'DEN', name:'Denver Nuggets', city:'Denver', conference:'West', division:'Northwest'})
MERGE (mil:Team {id:'MIL', name:'Milwaukee Bucks', city:'Milwaukee', conference:'East', division:'Central'})
MERGE (phx:Team {id:'PHX', name:'Phoenix Suns', city:'Phoenix', conference:'West', division:'Pacific'})
MERGE (dal:Team {id:'DAL', name:'Dallas Mavericks', city:'Dallas', conference:'West', division:'Southwest'})

MERGE (ham:Coach {id:'C1', name:'Darvin Ham'})
MERGE (kerr:Coach {id:'C2', name:'Steve Kerr'})
MERGE (maz:Coach {id:'C3', name:'Joe Mazzulla'})
MERGE (spo:Coach {id:'C4', name:'Erik Spoelstra'})
MERGE (malone:Coach {id:'C5', name:'Michael Malone'})
MERGE (doc:Coach {id:'C6', name:'Doc Rivers'})
MERGE (bud:Coach {id:'C7', name:'Mike Budenholzer'})
MERGE (kidd:Coach {id:'C8', name:'Jason Kidd'})

MERGE (lal)-[:HOME_ARENA]->(crypto)
MERGE (gsw)-[:HOME_ARENA]->(chase)
MERGE (bos)-[:HOME_ARENA]->(tdg)
MERGE (mia)-[:HOME_ARENA]->(kaseya)
MERGE (den)-[:HOME_ARENA]->(ball)
MERGE (mil)-[:HOME_ARENA]->(fiserv)
MERGE (phx)-[:HOME_ARENA]->(foot)
MERGE (dal)-[:HOME_ARENA]->(aac)

MERGE (ham)-[:COACHES {since:2022}]->(lal)
MERGE (kerr)-[:COACHES {since:2014}]->(gsw)
MERGE (maz)-[:COACHES {since:2022}]->(bos)
MERGE (spo)-[:COACHES {since:2008}]->(mia)
MERGE (malone)-[:COACHES {since:2015}]->(den)
MERGE (doc)-[:COACHES {since:2024}]->(mil)
MERGE (bud)-[:COACHES {since:2024}]->(phx)
MERGE (kidd)-[:COACHES {since:2021}]->(dal);

// -----------------------------------------------------
// 2. JOGADORES E CONTRATOS
// -----------------------------------------------------
MATCH (lal:Team {id:'LAL'}), (gsw:Team {id:'GSW'}), (bos:Team {id:'BOS'}), (mia:Team {id:'MIA'})
MATCH (den:Team {id:'DEN'}), (mil:Team {id:'MIL'}), (phx:Team {id:'PHX'}), (dal:Team {id:'DAL'})

MERGE (lebron:Player {id:'P1', name:'LeBron James', position:'SF'})-[:PLAYS_FOR {number:23}]->(lal)
MERGE (davis:Player {id:'P2', name:'Anthony Davis', position:'C'})-[:PLAYS_FOR {number:3}]->(lal)
MERGE (russell:Player {id:'P3', name:'D\'Angelo Russell', position:'PG'})-[:PLAYS_FOR {number:1}]->(lal)

MERGE (curry:Player {id:'P4', name:'Stephen Curry', position:'PG'})-[:PLAYS_FOR {number:30}]->(gsw)
MERGE (klay:Player {id:'P5', name:'Klay Thompson', position:'SG'})-[:PLAYS_FOR {number:11}]->(gsw)
MERGE (dray:Player {id:'P6', name:'Draymond Green', position:'PF'})-[:PLAYS_FOR {number:23}]->(gsw)

MERGE (tatum:Player {id:'P7', name:'Jayson Tatum', position:'SF'})-[:PLAYS_FOR {number:0}]->(bos)
MERGE (brown:Player {id:'P8', name:'Jaylen Brown', position:'SG'})-[:PLAYS_FOR {number:7}]->(bos)
MERGE (holiday:Player {id:'P9', name:'Jrue Holiday', position:'PG'})-[:PLAYS_FOR {number:4}]->(bos)

MERGE (butler:Player {id:'P10', name:'Jimmy Butler', position:'SF'})-[:PLAYS_FOR {number:22}]->(mia)
MERGE (bam:Player {id:'P11', name:'Bam Adebayo', position:'C'})-[:PLAYS_FOR {number:13}]->(mia)
MERGE (herro:Player {id:'P12', name:'Tyler Herro', position:'SG'})-[:PLAYS_FOR {number:14}]->(mia)

MERGE (jokic:Player {id:'P13', name:'Nikola Jokic', position:'C'})-[:PLAYS_FOR {number:15}]->(den)
MERGE (murray:Player {id:'P14', name:'Jamal Murray', position:'PG'})-[:PLAYS_FOR {number:27}]->(den)

MERGE (giannis:Player {id:'P15', name:'Giannis Antetokounmpo', position:'PF'})-[:PLAYS_FOR {number:34}]->(mil)
MERGE (lillard:Player {id:'P16', name:'Damian Lillard', position:'PG'})-[:PLAYS_FOR {number:0}]->(mil)

MERGE (durant:Player {id:'P17', name:'Kevin Durant', position:'PF'})-[:PLAYS_FOR {number:35}]->(phx)
MERGE (booker:Player {id:'P18', name:'Devin Booker', position:'SG'})-[:PLAYS_FOR {number:1}]->(phx)

MERGE (luka:Player {id:'P19', name:'Luka Doncic', position:'PG'})-[:PLAYS_FOR {number:77}]->(dal)
MERGE (kyrie:Player {id:'P20', name:'Kyrie Irving', position:'SG'})-[:PLAYS_FOR {number:11}]->(dal);

// -----------------------------------------------------
// 3. JOGOS (GAMES) E PLACARES
// -----------------------------------------------------
MATCH (season:Season {id:'2024'})
MATCH (lal:Team {id:'LAL'}), (gsw:Team {id:'GSW'}), (bos:Team {id:'BOS'}), (mia:Team {id:'MIA'})
MATCH (den:Team {id:'DEN'}), (mil:Team {id:'MIL'}), (phx:Team {id:'PHX'}), (dal:Team {id:'DAL'})
MATCH (crypto:Arena {id:'CRYPTO'}), (tdg:Arena {id:'TDG'}), (chase:Arena {id:'CHASE'}), (kaseya:Arena {id:'KASEYA'})
MATCH (ball:Arena {id:'BALL'}), (fiserv:Arena {id:'FISERV'})

MERGE (g1:Game {id:'G1', date:date('2024-11-01')})-[:IN_SEASON]->(season)
MERGE (g1)-[:PLAYED_AT]->(crypto)
MERGE (g1)-[:HOME_TEAM {score:112}]->(lal)
MERGE (g1)-[:AWAY_TEAM {score:108}]->(gsw)

MERGE (g2:Game {id:'G2', date:date('2024-11-03')})-[:IN_SEASON]->(season)
MERGE (g2)-[:PLAYED_AT]->(tdg)
MERGE (g2)-[:HOME_TEAM {score:118}]->(bos)
MERGE (g2)-[:AWAY_TEAM {score:110}]->(mia)

MERGE (g3:Game {id:'G3', date:date('2024-11-05')})-[:IN_SEASON]->(season)
MERGE (g3)-[:PLAYED_AT]->(chase)
MERGE (g3)-[:HOME_TEAM {score:121}]->(gsw)
MERGE (g3)-[:AWAY_TEAM {score:125}]->(bos)

MERGE (g4:Game {id:'G4', date:date('2024-11-07')})-[:IN_SEASON]->(season)
MERGE (g4)-[:PLAYED_AT]->(kaseya)
MERGE (g4)-[:HOME_TEAM {score:102}]->(mia)
MERGE (g4)-[:AWAY_TEAM {score:99}]->(lal)

MERGE (g5:Game {id:'G5', date:date('2024-11-08')})-[:IN_SEASON]->(season)
MERGE (g5)-[:PLAYED_AT]->(ball)
MERGE (g5)-[:HOME_TEAM {score:120}]->(den)
MERGE (g5)-[:AWAY_TEAM {score:115}]->(phx)

MERGE (g6:Game {id:'G6', date:date('2024-11-10')})-[:IN_SEASON]->(season)
MERGE (g6)-[:PLAYED_AT]->(fiserv)
MERGE (g6)-[:HOME_TEAM {score:110}]->(mil)
MERGE (g6)-[:AWAY_TEAM {score:118}]->(dal)

MERGE (g7:Game {id:'G7', date:date('2024-11-12')})-[:IN_SEASON]->(season)
MERGE (g7)-[:PLAYED_AT]->(crypto)
MERGE (g7)-[:HOME_TEAM {score:108}]->(lal)
MERGE (g7)-[:AWAY_TEAM {score:114}]->(den)

MERGE (g8:Game {id:'G8', date:date('2024-11-14')})-[:IN_SEASON]->(season)
MERGE (g8)-[:PLAYED_AT]->(tdg)
MERGE (g8)-[:HOME_TEAM {score:125}]->(bos)
MERGE (g8)-[:AWAY_TEAM {score:122}]->(mil);

// -----------------------------------------------------
// 4. STATS DOS JOGADORES
// -----------------------------------------------------
MATCH (g1:Game {id:'G1'}), (g2:Game {id:'G2'}), (g3:Game {id:'G3'}), (g4:Game {id:'G4'})
MATCH (g5:Game {id:'G5'}), (g6:Game {id:'G6'}), (g7:Game {id:'G7'}), (g8:Game {id:'G8'})
MATCH (lebron:Player {id:'P1'}), (davis:Player {id:'P2'}), (russell:Player {id:'P3'}), (curry:Player {id:'P4'}), (klay:Player {id:'P5'}), (dray:Player {id:'P6'})
MATCH (tatum:Player {id:'P7'}), (brown:Player {id:'P8'}), (holiday:Player {id:'P9'}), (butler:Player {id:'P10'}), (bam:Player {id:'P11'}), (herro:Player {id:'P12'})
MATCH (jokic:Player {id:'P13'}), (murray:Player {id:'P14'}), (giannis:Player {id:'P15'}), (lillard:Player {id:'P16'}), (durant:Player {id:'P17'}), (booker:Player {id:'P18'}), (luka:Player {id:'P19'}), (kyrie:Player {id:'P20'})

// Stats G1
MERGE (lebron)-[:PLAYED_IN {points:28, rebounds:7, assists:8}]->(g1)
MERGE (davis)-[:PLAYED_IN {points:24, rebounds:12, assists:3}]->(g1)
MERGE (russell)-[:PLAYED_IN {points:15, rebounds:4, assists:6}]->(g1)
MERGE (curry)-[:PLAYED_IN {points:30, rebounds:5, assists:7}]->(g1)
MERGE (klay)-[:PLAYED_IN {points:18, rebounds:3, assists:2}]->(g1)
MERGE (dray)-[:PLAYED_IN {points:10, rebounds:9, assists:8}]->(g1)

// Stats G2
MERGE (tatum)-[:PLAYED_IN {points:32, rebounds:9, assists:5}]->(g2)
MERGE (brown)-[:PLAYED_IN {points:24, rebounds:6, assists:3}]->(g2)
MERGE (holiday)-[:PLAYED_IN {points:14, rebounds:4, assists:8}]->(g2)
MERGE (butler)-[:PLAYED_IN {points:26, rebounds:6, assists:4}]->(g2)
MERGE (bam)-[:PLAYED_IN {points:20, rebounds:11, assists:3}]->(g2)
MERGE (herro)-[:PLAYED_IN {points:18, rebounds:3, assists:4}]->(g2)

// Stats G3
MERGE (curry)-[:PLAYED_IN {points:34, rebounds:4, assists:9}]->(g3)
MERGE (klay)-[:PLAYED_IN {points:20, rebounds:3, assists:3}]->(g3)
MERGE (dray)-[:PLAYED_IN {points:12, rebounds:10, assists:7}]->(g3)
MERGE (tatum)-[:PLAYED_IN {points:29, rebounds:8, assists:6}]->(g3)
MERGE (brown)-[:PLAYED_IN {points:22, rebounds:5, assists:2}]->(g3)
MERGE (holiday)-[:PLAYED_IN {points:16, rebounds:3, assists:7}]->(g3)

// Stats G4
MERGE (butler)-[:PLAYED_IN {points:27, rebounds:7, assists:5}]->(g4)
MERGE (bam)-[:PLAYED_IN {points:18, rebounds:13, assists:2}]->(g4)
MERGE (herro)-[:PLAYED_IN {points:21, rebounds:4, assists:5}]->(g4)
MERGE (lebron)-[:PLAYED_IN {points:25, rebounds:6, assists:7}]->(g4)
MERGE (davis)-[:PLAYED_IN {points:22, rebounds:14, assists:2}]->(g4)
MERGE (russell)-[:PLAYED_IN {points:13, rebounds:3, assists:8}]->(g4)

// Stats G5
MERGE (jokic)-[:PLAYED_IN {points:35, rebounds:14, assists:10}]->(g5)
MERGE (murray)-[:PLAYED_IN {points:22, rebounds:4, assists:8}]->(g5)
MERGE (durant)-[:PLAYED_IN {points:31, rebounds:7, assists:3}]->(g5)
MERGE (booker)-[:PLAYED_IN {points:28, rebounds:5, assists:6}]->(g5)

// Stats G6
MERGE (giannis)-[:PLAYED_IN {points:30, rebounds:12, assists:5}]->(g6)
MERGE (lillard)-[:PLAYED_IN {points:24, rebounds:3, assists:8}]->(g6)
MERGE (luka)-[:PLAYED_IN {points:38, rebounds:9, assists:11}]->(g6)
MERGE (kyrie)-[:PLAYED_IN {points:26, rebounds:4, assists:5}]->(g6)

// Stats G7
MERGE (lebron)-[:PLAYED_IN {points:26, rebounds:7, assists:7}]->(g7)
MERGE (davis)-[:PLAYED_IN {points:24, rebounds:10, assists:2}]->(g7)
MERGE (jokic)-[:PLAYED_IN {points:29, rebounds:13, assists:8}]->(g7)
MERGE (murray)-[:PLAYED_IN {points:20, rebounds:3, assists:6}]->(g7)

// Stats G8
MERGE (tatum)-[:PLAYED_IN {points:33, rebounds:8, assists:4}]->(g8)
MERGE (brown)-[:PLAYED_IN {points:25, rebounds:6, assists:3}]->(g8)
MERGE (giannis)-[:PLAYED_IN {points:36, rebounds:11, assists:4}]->(g8)
MERGE (lillard)-[:PLAYED_IN {points:21, rebounds:2, assists:9}]->(g8)