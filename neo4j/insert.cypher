// Nodes
MERGE (season:Season {id:'2024', name:'2024-25', year:2024});

MERGE (crypto:Arena {id:'CRYPTO', name:'Crypto.com Arena', city:'Los Angeles'});
MERGE (chase:Arena {id:'CHASE', name:'Chase Center', city:'San Francisco'});
MERGE (tdg:Arena {id:'TDG', name:'TD Garden', city:'Boston'});
MERGE (kaseya:Arena {id:'KASEYA', name:'Kaseya Center', city:'Miami'});

MERGE (lal:Team {id:'LAL', name:'Los Angeles Lakers', city:'Los Angeles', conference:'West', division:'Pacific'});
MERGE (gsw:Team {id:'GSW', name:'Golden State Warriors', city:'San Francisco', conference:'West', division:'Pacific'});
MERGE (bos:Team {id:'BOS', name:'Boston Celtics', city:'Boston', conference:'East', division:'Atlantic'});
MERGE (mia:Team {id:'MIA', name:'Miami Heat', city:'Miami', conference:'East', division:'Southeast'});

MERGE (ham:Coach {id:'C1', name:'Darvin Ham'});
MERGE (kerr:Coach {id:'C2', name:'Steve Kerr'});
MERGE (maz:Coach {id:'C3', name:'Joe Mazzulla'});
MERGE (spo:Coach {id:'C4', name:'Erik Spoelstra'});

MERGE (lebron:Player {id:'P1', name:'LeBron James', position:'SF'});
MERGE (davis:Player {id:'P2', name:'Anthony Davis', position:'C'});
MERGE (russell:Player {id:'P3', name:'D\'Angelo Russell', position:'PG'});
MERGE (curry:Player {id:'P4', name:'Stephen Curry', position:'PG'});
MERGE (klay:Player {id:'P5', name:'Klay Thompson', position:'SG'});
MERGE (dray:Player {id:'P6', name:'Draymond Green', position:'PF'});
MERGE (tatum:Player {id:'P7', name:'Jayson Tatum', position:'SF'});
MERGE (brown:Player {id:'P8', name:'Jaylen Brown', position:'SG'});
MERGE (holiday:Player {id:'P9', name:'Jrue Holiday', position:'PG'});
MERGE (butler:Player {id:'P10', name:'Jimmy Butler', position:'SF'});
MERGE (bam:Player {id:'P11', name:'Bam Adebayo', position:'C'});
MERGE (herro:Player {id:'P12', name:'Tyler Herro', position:'SG'});

// Relationships
MERGE (lal)-[:HOME_ARENA]->(crypto);
MERGE (gsw)-[:HOME_ARENA]->(chase);
MERGE (bos)-[:HOME_ARENA]->(tdg);
MERGE (mia)-[:HOME_ARENA]->(kaseya);

MERGE (ham)-[:COACHES {since:2022}]->(lal);
MERGE (kerr)-[:COACHES {since:2014}]->(gsw);
MERGE (maz)-[:COACHES {since:2022}]->(bos);
MERGE (spo)-[:COACHES {since:2008}]->(mia);

MERGE (lebron)-[:PLAYS_FOR {number:23, since:2018}]->(lal);
MERGE (davis)-[:PLAYS_FOR {number:3, since:2019}]->(lal);
MERGE (russell)-[:PLAYS_FOR {number:1, since:2023}]->(lal);

MERGE (curry)-[:PLAYS_FOR {number:30, since:2009}]->(gsw);
MERGE (klay)-[:PLAYS_FOR {number:11, since:2011}]->(gsw);
MERGE (dray)-[:PLAYS_FOR {number:23, since:2012}]->(gsw);

MERGE (tatum)-[:PLAYS_FOR {number:0, since:2017}]->(bos);
MERGE (brown)-[:PLAYS_FOR {number:7, since:2016}]->(bos);
MERGE (holiday)-[:PLAYS_FOR {number:4, since:2023}]->(bos);

MERGE (butler)-[:PLAYS_FOR {number:22, since:2019}]->(mia);
MERGE (bam)-[:PLAYS_FOR {number:13, since:2017}]->(mia);
MERGE (herro)-[:PLAYS_FOR {number:14, since:2019}]->(mia);

// Games
MERGE (g1:Game {id:'G1', date:date('2024-11-01')});
MERGE (g2:Game {id:'G2', date:date('2024-11-03')});
MERGE (g3:Game {id:'G3', date:date('2024-11-05')});
MERGE (g4:Game {id:'G4', date:date('2024-11-07')});

MERGE (g1)-[:IN_SEASON]->(season);
MERGE (g2)-[:IN_SEASON]->(season);
MERGE (g3)-[:IN_SEASON]->(season);
MERGE (g4)-[:IN_SEASON]->(season);

MERGE (g1)-[:PLAYED_AT]->(crypto);
MERGE (g2)-[:PLAYED_AT]->(tdg);
MERGE (g3)-[:PLAYED_AT]->(chase);
MERGE (g4)-[:PLAYED_AT]->(kaseya);

MERGE (g1)-[:HOME_TEAM {score:112}]->(lal);
MERGE (g1)-[:AWAY_TEAM {score:108}]->(gsw);

MERGE (g2)-[:HOME_TEAM {score:118}]->(bos);
MERGE (g2)-[:AWAY_TEAM {score:110}]->(mia);

MERGE (g3)-[:HOME_TEAM {score:121}]->(gsw);
MERGE (g3)-[:AWAY_TEAM {score:125}]->(bos);

MERGE (g4)-[:HOME_TEAM {score:102}]->(mia);
MERGE (g4)-[:AWAY_TEAM {score:99}]->(lal);

// Player stats
MERGE (lebron)-[:PLAYED_IN {points:28, rebounds:7, assists:8, minutes:36}]->(g1);
MERGE (davis)-[:PLAYED_IN {points:24, rebounds:12, assists:3, minutes:35}]->(g1);
MERGE (russell)-[:PLAYED_IN {points:15, rebounds:4, assists:6, minutes:32}]->(g1);
MERGE (curry)-[:PLAYED_IN {points:30, rebounds:5, assists:7, minutes:36}]->(g1);
MERGE (klay)-[:PLAYED_IN {points:18, rebounds:3, assists:2, minutes:34}]->(g1);
MERGE (dray)-[:PLAYED_IN {points:10, rebounds:9, assists:8, minutes:33}]->(g1);

MERGE (tatum)-[:PLAYED_IN {points:32, rebounds:9, assists:5, minutes:37}]->(g2);
MERGE (brown)-[:PLAYED_IN {points:24, rebounds:6, assists:3, minutes:35}]->(g2);
MERGE (holiday)-[:PLAYED_IN {points:14, rebounds:4, assists:8, minutes:33}]->(g2);
MERGE (butler)-[:PLAYED_IN {points:26, rebounds:6, assists:4, minutes:36}]->(g2);
MERGE (bam)-[:PLAYED_IN {points:20, rebounds:11, assists:3, minutes:35}]->(g2);
MERGE (herro)-[:PLAYED_IN {points:18, rebounds:3, assists:4, minutes:34}]->(g2);

MERGE (curry)-[:PLAYED_IN {points:34, rebounds:4, assists:9, minutes:37}]->(g3);
MERGE (klay)-[:PLAYED_IN {points:20, rebounds:3, assists:3, minutes:35}]->(g3);
MERGE (dray)-[:PLAYED_IN {points:12, rebounds:10, assists:7, minutes:34}]->(g3);
MERGE (tatum)-[:PLAYED_IN {points:29, rebounds:8, assists:6, minutes:36}]->(g3);
MERGE (brown)-[:PLAYED_IN {points:22, rebounds:5, assists:2, minutes:35}]->(g3);
MERGE (holiday)-[:PLAYED_IN {points:16, rebounds:3, assists:7, minutes:34}]->(g3);

MERGE (butler)-[:PLAYED_IN {points:27, rebounds:7, assists:5, minutes:36}]->(g4);
MERGE (bam)-[:PLAYED_IN {points:18, rebounds:13, assists:2, minutes:35}]->(g4);
MERGE (herro)-[:PLAYED_IN {points:21, rebounds:4, assists:5, minutes:34}]->(g4);
MERGE (lebron)-[:PLAYED_IN {points:25, rebounds:6, assists:7, minutes:36}]->(g4);
MERGE (davis)-[:PLAYED_IN {points:22, rebounds:14, assists:2, minutes:35}]->(g4);
MERGE (russell)-[:PLAYED_IN {points:13, rebounds:3, assists:8, minutes:32}]->(g4);

// Novos Times, Arenas, Técnicos e Jogadores
MERGE (ball:Arena {id:'BALL', name:'Ball Arena', city:'Denver'});
MERGE (fiserv:Arena {id:'FISERV', name:'Fiserv Forum', city:'Milwaukee'});
MERGE (foot:Arena {id:'FOOT', name:'Footprint Center', city:'Phoenix'});
MERGE (aac:Arena {id:'AAC', name:'American Airlines Center', city:'Dallas'});

MERGE (den:Team {id:'DEN', name:'Denver Nuggets', city:'Denver', conference:'West', division:'Northwest'});
MERGE (mil:Team {id:'MIL', name:'Milwaukee Bucks', city:'Milwaukee', conference:'East', division:'Central'});
MERGE (phx:Team {id:'PHX', name:'Phoenix Suns', city:'Phoenix', conference:'West', division:'Pacific'});
MERGE (dal:Team {id:'DAL', name:'Dallas Mavericks', city:'Dallas', conference:'West', division:'Southwest'});

MERGE (malone:Coach {id:'C5', name:'Michael Malone'});
MERGE (doc:Coach {id:'C6', name:'Doc Rivers'});
MERGE (bud:Coach {id:'C7', name:'Mike Budenholzer'});
MERGE (kidd:Coach {id:'C8', name:'Jason Kidd'});

MERGE (jokic:Player {id:'P13', name:'Nikola Jokic', position:'C'});
MERGE (murray:Player {id:'P14', name:'Jamal Murray', position:'PG'});
MERGE (giannis:Player {id:'P15', name:'Giannis Antetokounmpo', position:'PF'});
MERGE (lillard:Player {id:'P16', name:'Damian Lillard', position:'PG'});
MERGE (durant:Player {id:'P17', name:'Kevin Durant', position:'PF'});
MERGE (booker:Player {id:'P18', name:'Devin Booker', position:'SG'});
MERGE (luka:Player {id:'P19', name:'Luka Doncic', position:'PG'});
MERGE (kyrie:Player {id:'P20', name:'Kyrie Irving', position:'SG'});

// Relationships: Estrutura dos Times
MERGE (den)-[:HOME_ARENA]->(ball);
MERGE (mil)-[:HOME_ARENA]->(fiserv);
MERGE (phx)-[:HOME_ARENA]->(foot);
MERGE (dal)-[:HOME_ARENA]->(aac);

MERGE (malone)-[:COACHES {since:2015}]->(den);
MERGE (doc)-[:COACHES {since:2024}]->(mil);
MERGE (bud)-[:COACHES {since:2024}]->(phx);
MERGE (kidd)-[:COACHES {since:2021}]->(dal);

MERGE (jokic)-[:PLAYS_FOR {number:15, since:2015}]->(den);
MERGE (murray)-[:PLAYS_FOR {number:27, since:2016}]->(den);
MERGE (giannis)-[:PLAYS_FOR {number:34, since:2013}]->(mil);
MERGE (lillard)-[:PLAYS_FOR {number:0, since:2023}]->(mil);
MERGE (durant)-[:PLAYS_FOR {number:35, since:2023}]->(phx);
MERGE (booker)-[:PLAYS_FOR {number:1, since:2015}]->(phx);
MERGE (luka)-[:PLAYS_FOR {number:77, since:2018}]->(dal);
MERGE (kyrie)-[:PLAYS_FOR {number:11, since:2023}]->(dal);

// Games: Novos Jogos (Misturando times novos e antigos)
MERGE (g5:Game {id:'G5', date:date('2024-11-08')}); // DEN vs PHX
MERGE (g6:Game {id:'G6', date:date('2024-11-10')}); // MIL vs DAL
MERGE (g7:Game {id:'G7', date:date('2024-11-12')}); // LAL vs DEN (Importante: conecta cluster antigo com novo)
MERGE (g8:Game {id:'G8', date:date('2024-11-14')}); // BOS vs MIL (Importante: conecta cluster antigo com novo)

MERGE (g5)-[:IN_SEASON]->(season);
MERGE (g6)-[:IN_SEASON]->(season);
MERGE (g7)-[:IN_SEASON]->(season);
MERGE (g8)-[:IN_SEASON]->(season);

MERGE (g5)-[:PLAYED_AT]->(ball);
MERGE (g6)-[:PLAYED_AT]->(fiserv);
MERGE (g7)-[:PLAYED_AT]->(crypto);
MERGE (g8)-[:PLAYED_AT]->(tdg);

MERGE (g5)-[:HOME_TEAM {score:120}]->(den);
MERGE (g5)-[:AWAY_TEAM {score:115}]->(phx);

MERGE (g6)-[:HOME_TEAM {score:110}]->(mil);
MERGE (g6)-[:AWAY_TEAM {score:118}]->(dal);

MERGE (g7)-[:HOME_TEAM {score:108}]->(lal);
MERGE (g7)-[:AWAY_TEAM {score:114}]->(den);

MERGE (g8)-[:HOME_TEAM {score:125}]->(bos);
MERGE (g8)-[:AWAY_TEAM {score:122}]->(mil);

// Player Stats: Stats dos novos jogos
// G5: Jokic/Murray vs Durant/Booker
MERGE (jokic)-[:PLAYED_IN {points:35, rebounds:14, assists:10, minutes:38}]->(g5);
MERGE (murray)-[:PLAYED_IN {points:22, rebounds:4, assists:8, minutes:36}]->(g5);
MERGE (durant)-[:PLAYED_IN {points:31, rebounds:7, assists:3, minutes:39}]->(g5);
MERGE (booker)-[:PLAYED_IN {points:28, rebounds:5, assists:6, minutes:38}]->(g5);

// G6: Giannis/Lillard vs Luka/Kyrie
MERGE (giannis)-[:PLAYED_IN {points:30, rebounds:12, assists:5, minutes:35}]->(g6);
MERGE (lillard)-[:PLAYED_IN {points:24, rebounds:3, assists:8, minutes:36}]->(g6);
MERGE (luka)-[:PLAYED_IN {points:38, rebounds:9, assists:11, minutes:40}]->(g6);
MERGE (kyrie)-[:PLAYED_IN {points:26, rebounds:4, assists:5, minutes:37}]->(g6);

// G7: LeBron/Davis vs Jokic/Murray (Conectando os grafos)
MERGE (lebron)-[:PLAYED_IN {points:26, rebounds:7, assists:7, minutes:35}]->(g7);
MERGE (davis)-[:PLAYED_IN {points:24, rebounds:10, assists:2, minutes:36}]->(g7);
MERGE (jokic)-[:PLAYED_IN {points:29, rebounds:13, assists:8, minutes:37}]->(g7);
MERGE (murray)-[:PLAYED_IN {points:20, rebounds:3, assists:6, minutes:34}]->(g7);

// G8: Tatum/Brown vs Giannis/Lillard (Conectando os grafos)
MERGE (tatum)-[:PLAYED_IN {points:33, rebounds:8, assists:4, minutes:38}]->(g8);
MERGE (brown)-[:PLAYED_IN {points:25, rebounds:6, assists:3, minutes:36}]->(g8);
MERGE (giannis)-[:PLAYED_IN {points:36, rebounds:11, assists:4, minutes:37}]->(g8);
MERGE (lillard)-[:PLAYED_IN {points:21, rebounds:2, assists:9, minutes:35}]->(g8);