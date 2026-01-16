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
