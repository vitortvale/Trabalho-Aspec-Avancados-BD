const dbName = 'nba';
const nba = db.getSiblingDB(dbName);

nba.teams.drop();
nba.players.drop();
nba.arenas.drop();
nba.games.drop();

nba.arenas.insertMany([
  {_id:'CRYPTO', name:'Crypto.com Arena', city:'Los Angeles'},
  {_id:'CHASE', name:'Chase Center', city:'San Francisco'},
  {_id:'TDG', name:'TD Garden', city:'Boston'},
  {_id:'KASEYA', name:'Kaseya Center', city:'Miami'}
]);

nba.players.insertMany([
  {_id:'P1', name:'LeBron James', position:'SF', teamId:'LAL'},
  {_id:'P2', name:'Anthony Davis', position:'C', teamId:'LAL'},
  {_id:'P3', name:"D'Angelo Russell", position:'PG', teamId:'LAL'},
  {_id:'P4', name:'Stephen Curry', position:'PG', teamId:'GSW'},
  {_id:'P5', name:'Klay Thompson', position:'SG', teamId:'GSW'},
  {_id:'P6', name:'Draymond Green', position:'PF', teamId:'GSW'},
  {_id:'P7', name:'Jayson Tatum', position:'SF', teamId:'BOS'},
  {_id:'P8', name:'Jaylen Brown', position:'SG', teamId:'BOS'},
  {_id:'P9', name:'Jrue Holiday', position:'PG', teamId:'BOS'},
  {_id:'P10', name:'Jimmy Butler', position:'SF', teamId:'MIA'},
  {_id:'P11', name:'Bam Adebayo', position:'C', teamId:'MIA'},
  {_id:'P12', name:'Tyler Herro', position:'SG', teamId:'MIA'}
]);

nba.teams.insertMany([
  {
    _id:'LAL',
    name:'Los Angeles Lakers',
    city:'Los Angeles',
    conference:'West',
    division:'Pacific',
    arenaId:'CRYPTO',
    coach:{id:'C1', name:'Darvin Ham', since:2022},
    roster:[
      {playerId:'P1', name:'LeBron James', position:'SF', number:23, since:2018},
      {playerId:'P2', name:'Anthony Davis', position:'C', number:3, since:2019},
      {playerId:'P3', name:"D'Angelo Russell", position:'PG', number:1, since:2023}
    ]
  },
  {
    _id:'GSW',
    name:'Golden State Warriors',
    city:'San Francisco',
    conference:'West',
    division:'Pacific',
    arenaId:'CHASE',
    coach:{id:'C2', name:'Steve Kerr', since:2014},
    roster:[
      {playerId:'P4', name:'Stephen Curry', position:'PG', number:30, since:2009},
      {playerId:'P5', name:'Klay Thompson', position:'SG', number:11, since:2011},
      {playerId:'P6', name:'Draymond Green', position:'PF', number:23, since:2012}
    ]
  },
  {
    _id:'BOS',
    name:'Boston Celtics',
    city:'Boston',
    conference:'East',
    division:'Atlantic',
    arenaId:'TDG',
    coach:{id:'C3', name:'Joe Mazzulla', since:2022},
    roster:[
      {playerId:'P7', name:'Jayson Tatum', position:'SF', number:0, since:2017},
      {playerId:'P8', name:'Jaylen Brown', position:'SG', number:7, since:2016},
      {playerId:'P9', name:'Jrue Holiday', position:'PG', number:4, since:2023}
    ]
  },
  {
    _id:'MIA',
    name:'Miami Heat',
    city:'Miami',
    conference:'East',
    division:'Southeast',
    arenaId:'KASEYA',
    coach:{id:'C4', name:'Erik Spoelstra', since:2008},
    roster:[
      {playerId:'P10', name:'Jimmy Butler', position:'SF', number:22, since:2019},
      {playerId:'P11', name:'Bam Adebayo', position:'C', number:13, since:2017},
      {playerId:'P12', name:'Tyler Herro', position:'SG', number:14, since:2019}
    ]
  }
]);

nba.games.insertMany([
  {
    _id:'G1',
    date: ISODate('2024-11-01T00:00:00Z'),
    season:'2024-25',
    arenaId:'CRYPTO',
    home:{teamId:'LAL', score:112},
    away:{teamId:'GSW', score:108},
    boxscore:[
      {playerId:'P1', teamId:'LAL', points:28, rebounds:7, assists:8, minutes:36},
      {playerId:'P2', teamId:'LAL', points:24, rebounds:12, assists:3, minutes:35},
      {playerId:'P3', teamId:'LAL', points:15, rebounds:4, assists:6, minutes:32},
      {playerId:'P4', teamId:'GSW', points:30, rebounds:5, assists:7, minutes:36},
      {playerId:'P5', teamId:'GSW', points:18, rebounds:3, assists:2, minutes:34},
      {playerId:'P6', teamId:'GSW', points:10, rebounds:9, assists:8, minutes:33}
    ]
  },
  {
    _id:'G2',
    date: ISODate('2024-11-03T00:00:00Z'),
    season:'2024-25',
    arenaId:'TDG',
    home:{teamId:'BOS', score:118},
    away:{teamId:'MIA', score:110},
    boxscore:[
      {playerId:'P7', teamId:'BOS', points:32, rebounds:9, assists:5, minutes:37},
      {playerId:'P8', teamId:'BOS', points:24, rebounds:6, assists:3, minutes:35},
      {playerId:'P9', teamId:'BOS', points:14, rebounds:4, assists:8, minutes:33},
      {playerId:'P10', teamId:'MIA', points:26, rebounds:6, assists:4, minutes:36},
      {playerId:'P11', teamId:'MIA', points:20, rebounds:11, assists:3, minutes:35},
      {playerId:'P12', teamId:'MIA', points:18, rebounds:3, assists:4, minutes:34}
    ]
  },
  {
    _id:'G3',
    date: ISODate('2024-11-05T00:00:00Z'),
    season:'2024-25',
    arenaId:'CHASE',
    home:{teamId:'GSW', score:121},
    away:{teamId:'BOS', score:125},
    boxscore:[
      {playerId:'P4', teamId:'GSW', points:34, rebounds:4, assists:9, minutes:37},
      {playerId:'P5', teamId:'GSW', points:20, rebounds:3, assists:3, minutes:35},
      {playerId:'P6', teamId:'GSW', points:12, rebounds:10, assists:7, minutes:34},
      {playerId:'P7', teamId:'BOS', points:29, rebounds:8, assists:6, minutes:36},
      {playerId:'P8', teamId:'BOS', points:22, rebounds:5, assists:2, minutes:35},
      {playerId:'P9', teamId:'BOS', points:16, rebounds:3, assists:7, minutes:34}
    ]
  },
  {
    _id:'G4',
    date: ISODate('2024-11-07T00:00:00Z'),
    season:'2024-25',
    arenaId:'KASEYA',
    home:{teamId:'MIA', score:102},
    away:{teamId:'LAL', score:99},
    boxscore:[
      {playerId:'P10', teamId:'MIA', points:27, rebounds:7, assists:5, minutes:36},
      {playerId:'P11', teamId:'MIA', points:18, rebounds:13, assists:2, minutes:35},
      {playerId:'P12', teamId:'MIA', points:21, rebounds:4, assists:5, minutes:34},
      {playerId:'P1', teamId:'LAL', points:25, rebounds:6, assists:7, minutes:36},
      {playerId:'P2', teamId:'LAL', points:22, rebounds:14, assists:2, minutes:35},
      {playerId:'P3', teamId:'LAL', points:13, rebounds:3, assists:8, minutes:32}
    ]
  }
]);
