// Use in mongosh with `use nba`

// Q1: Teams with arena name
// db.teams.aggregate([
//   {$lookup:{from:'arenas', localField:'arenaId', foreignField:'_id', as:'arena'}},
//   {$unwind:'$arena'},
//   {$project:{_id:0, team:'$_id', arena:'$arena.name'}}
// ])

// Q2: Team roster (BOS)
// db.teams.find({_id:'BOS'},{_id:0,name:1,coach:1,roster:1})

// Q3: Games with winner
// db.games.aggregate([
//   {$project:{_id:1, home:'$home.teamId', away:'$away.teamId',
//     homeScore:'$home.score', awayScore:'$away.score',
//     winner:{ $cond:[{$gt:['$home.score','$away.score']},'$home.teamId','$away.teamId']}
//   }}
// ])

// Q4: Average points per player
// db.games.aggregate([
//   {$unwind:'$boxscore'},
//   {$group:{_id:'$boxscore.playerId', avgPoints:{$avg:'$boxscore.points'}}},
//   {$lookup:{from:'players', localField:'_id', foreignField:'_id', as:'player'}},
//   {$unwind:'$player'},
//   {$project:{_id:0, player:'$player.name', avgPoints:{$round:['$avgPoints',1]}}},
//   {$sort:{avgPoints:-1}}
// ])

// Q5: Top scorer per game
// db.games.aggregate([
//   {$unwind:'$boxscore'},
//   {$sort:{'_id':1,'boxscore.points':-1}},
//   {$group:{_id:'$_id', top:{$first:'$boxscore'}}},
//   {$lookup:{from:'players', localField:'top.playerId', foreignField:'_id', as:'player'}},
//   {$unwind:'$player'},
//   {$project:{_id:1, player:'$player.name', points:'$top.points'}}
// ])

// Q6: Team wins
// db.games.aggregate([
//   {$project:{winner:{ $cond:[{$gt:['$home.score','$away.score']},'$home.teamId','$away.teamId']}}},
//   {$group:{_id:'$winner', wins:{$sum:1}}},
//   {$sort:{wins:-1}}
// ])

// Q7: Double-double players
// db.games.aggregate([
//   {$unwind:'$boxscore'},
//   {$match:{'boxscore.points':{$gte:10},'boxscore.rebounds':{$gte:10}}},
//   {$group:{_id:'$boxscore.playerId'}},
//   {$lookup:{from:'players', localField:'_id', foreignField:'_id', as:'player'}},
//   {$unwind:'$player'},
//   {$project:{_id:0, player:'$player.name'}}
// ])

// Q8: Head-to-head LAL x GSW
// db.games.find({$or:[
//   {home:{teamId:'LAL'}, away:{teamId:'GSW'}},
//   {home:{teamId:'GSW'}, away:{teamId:'LAL'}}
// ]},{_id:1,home:1,away:1})

// Q9: Games at TD Garden
// db.games.find({arenaId:'TDG'},{_id:1,home:1,away:1,date:1})

// Q10: 25+ points against LAL
// db.games.aggregate([
//   {$match:{$or:[{'home.teamId':'LAL'},{'away.teamId':'LAL'}]}},
//   {$unwind:'$boxscore'},
//   {$match:{'boxscore.points':{$gte:25}}},
//   {$lookup:{from:'players', localField:'boxscore.playerId', foreignField:'_id', as:'player'}},
//   {$unwind:'$player'},
//   {$project:{_id:0, player:'$player.name', game:'$_id', points:'$boxscore.points'}}
// ])
