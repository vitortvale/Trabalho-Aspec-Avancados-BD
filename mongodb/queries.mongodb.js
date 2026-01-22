/**
 * ARQUIVO MESTRE: 20 CONSULTAS MONGODB (AGGREGATION FRAMEWORK)
 * Conversão de Cypher para MongoDB
 */

// -----------------------------------------------------------------------------
// Q1: Team, arena, coach
// Estratégia: Começar em 'teams', buscar dados da arena ('arenas') e projetar o técnico embutido.
// -----------------------------------------------------------------------------
db.teams.aggregate([
  {
    $lookup: {
      from: "arenas",
      localField: "arena_id",
      foreignField: "_id",
      as: "arena_info"
    }
  },
  { $unwind: "$arena_info" },
  {
    $project: {
      _id: 0,
      team: "$_id",
      arena: "$arena_info.name",
      coach: "$coach.name"
    }
  },
  { $sort: { team: 1 } }
]);

// -----------------------------------------------------------------------------
// Q2: Total points per player for LAL
// Estratégia: Filtrar jogos, desenrolar stats, buscar info do player, filtrar time LAL, agrupar.
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  { $match: { "p.team_id": "LAL" } },
  {
    $group: {
      _id: "$p.name",
      points: { $sum: "$player_stats.points" }
    }
  },
  { $sort: { points: -1 } }
]);

// -----------------------------------------------------------------------------
// Q3: Games with score and winner
// Estratégia: Projetar campos e usar $cond para decidir o vencedor linha a linha.
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $project: {
      game: "$_id",
      home: "$home_team.team_id",
      homeScore: "$home_team.score",
      away: "$away_team.team_id",
      awayScore: "$away_team.score",
      winner: {
        $cond: {
          if: { $gt: ["$home_team.score", "$away_team.score"] },
          then: "$home_team.team_id",
          else: "$away_team.team_id"
        }
      },
    }
  },
  { $sort: { date: 1 } }
]);

// -----------------------------------------------------------------------------
// Q4: Top scorer per game
// Estratégia: Desenrolar stats, ordenar por pontos (DESC), agrupar por jogo pegando o $first.
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  { $sort: { "player_stats.points": -1 } },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $group: {
      _id: "$_id",
      top_player: { $first: "$p.name" },
      top_points: { $first: "$player_stats.points" }
    }
  },
  { $sort: { _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q5: Average points per player
// Estratégia: Desenrolar tudo, agrupar por nome do jogador e tirar média.
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $group: {
      _id: "$p.name",
      avgPoints: { $avg: "$player_stats.points" }
    }
  },
  {
    $project: {
      player: "$_id",
      avgPoints: { $round: ["$avgPoints", 1] }
    }
  },
  { $sort: { avgPoints: -1, player: 1 } }
]);

// -----------------------------------------------------------------------------
// Q6: Head-to-head LAL vs GSW
// Estratégia: Match exato nos campos aninhados home_team e away_team.
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $match: {
      "home_team.team_id": "LAL",
      "away_team.team_id": "GSW"
    }
  },
  {
    $project: {
      game: "$_id",
      homeScore: "$home_team.score",
      awayScore: "$away_team.score"
    }
  }
]);

// -----------------------------------------------------------------------------
// Q7: Double-double players (10+ Pts, 10+ Reb)
// Estratégia: Filtrar stats no unwind e usar $addToSet ou distinct.
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $match: {
      "player_stats.points": { $gte: 10 },
      "player_stats.rebounds": { $gte: 10 }
    }
  },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $group: {
      _id: "$p.name"
    }
  },
  { $sort: { _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q8: Team wins (Total)
// Estratégia: Calcular vencedor por jogo, depois agrupar e contar.
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $project: {
      winner: {
        $cond: [
          { $gt: ["$home_team.score", "$away_team.score"] },
          "$home_team.team_id",
          "$away_team.team_id"
        ]
      }
    }
  },
  {
    $group: {
      _id: "$winner",
      wins: { $sum: 1 }
    }
  },
  { $sort: { wins: -1 , _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q9: Games at TD Garden
// Estratégia: Busca direta pelo ID da arena.
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $match: { arena_id: "TDG" } },
  {
    $project: {
      game: "$_id",
      home: "$home_team.team_id",
      homeScore: "$home_team.score",
      away: "$away_team.team_id",
      awayScore: "$away_team.score"
    }
  }
]);

// -----------------------------------------------------------------------------
// Q10: Players with 25+ vs LAL
// Estratégia: Filtrar jogos onde LAL jogou (casa ou fora), filtrar stats > 25, remover jogadores do LAL.
// -----------------------------------------------------------------------------
db.games.aggregate([
  // 1. Jogos envolvendo LAL
  {
    $match: {
      $or: [
        { "home_team.team_id": "LAL" },
        { "away_team.team_id": "LAL" }
      ]
    }
  },
  { $unwind: "$player_stats" },
  // 2. Pontuação alta
  { $match: { "player_stats.points": { $gte: 25 } } },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  // 3. Garantir que não é jogador do LAL
  { $match: { "p.team_id": { $ne: "LAL" } } },
  {
    $project: {
      player: "$p.name",
      game: "$_id",
      points: "$player_stats.points"
    }
  },
  { $sort: { points: -1 } }
]);

// -----------------------------------------------------------------------------
// Q11: Jogadores decisivos (Clutch - Pontos em vitórias)
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $addFields: {
      team_won: {
        $or: [
          { $and: [{ $eq: ["$p.team_id", "$home_team.team_id"] }, { $gt: ["$home_team.score", "$away_team.score"] }] },
          { $and: [{ $eq: ["$p.team_id", "$away_team.team_id"] }, { $gt: ["$away_team.score", "$home_team.score"] }] }
        ]
      }
    }
  },
  { $match: { team_won: true } },
  {
    $group: {
      _id: "$p.name",
      pointsInWins: { $sum: "$player_stats.points" }
    }
  },
  { $sort: { pointsInWins: -1 } }
]);

// -----------------------------------------------------------------------------
// Q12: Dependência de jogador (% dos pontos do time)
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $addFields: {
      team_score: {
        $cond: [
          { $eq: ["$p.team_id", "$home_team.team_id"] },
          "$home_team.score",
          "$away_team.score"
        ]
      }
    }
  },
  {
    $group: {
      _id: { team: "$p.team_id", player: "$p.name" },
      pPoints: { $sum: "$player_stats.points" },
      tPoints: { $sum: "$team_score" }
    }
  },
  {
    $project: {
      _id: 0,
      team: "$_id.team",
      player: "$_id.player",
      pct: { $round: [{ $multiply: [{ $divide: ["$pPoints", "$tPoints"] }, 100] }, 1] }
    }
  },
  { $sort: { pct: -1 } }
]);

// -----------------------------------------------------------------------------
// Q13: Força do mando de quadra
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $group: {
      _id: "$home_team.team_id",
      totalGames: { $sum: 1 },
      wins: {
        $sum: { $cond: [{ $gt: ["$home_team.score", "$away_team.score"] }, 1, 0] }
      }
    }
  },
  {
    $project: {
      team: "$_id",
      homeWins: "$wins",
      homeGames: "$totalGames",
      pct: { $round: [{ $multiply: [{ $divide: ["$wins", "$totalGames"] }, 100] }, 1] }
    }
  },
  { $sort: { pct: -1, _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q14: Consistência (Desvio Padrão)
// -----------------------------------------------------------------------------
// db.games.aggregate([
//   { $unwind: "$player_stats" },
//   {
//     $lookup: {
//       from: "players",
//       localField: "player_stats.player_id",
//       foreignField: "_id",
//       as: "p"
//     }
//   },
//   { $unwind: "$p" },
//   {
//     $group: {
//       _id: "$p.name",
//       avg: { $avg: "$player_stats.points" },
//       stdDev: { $stdDevPop: "$player_stats.points" }
//     }
//   },
//   {
//     $project: {
//       player: "$_id",
//       avgPoints: { $round: ["$avg", 1] },
//       consistency: { $round: ["$stdDev", 2] }
//     }
//   },
//   { $sort: { consistency: 1 , _id: 1 } }
// ]);

db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $group: {
      _id: "$p.name",
      avg: { $avg: "$player_stats.points" },
      stdDev: { $stdDevSamp: "$player_stats.points" }
    }
  },
  {
    $project: {
      _id: 0,
      player: "$_id",
      avgPoints: { $round: ["$avg", 1] },
      consistency: { $round: ["$stdDev", 2] }
    }
  },
  { $sort: { consistency: 1, player: 1 } }
]);

// -----------------------------------------------------------------------------
// Q15: Rivalidade equilibrada (Diferença <= 5)
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $addFields: {
      diff: { $abs: { $subtract: ["$home_team.score", "$away_team.score"] } }
    }
  },
  { $match: { diff: { $lte: 5 } } },
  {
    $project: {
      game: "$_id",
      home: "$home_team.team_id",
      away: "$away_team.team_id",
      hScore: "$home_team.score",
      aScore: "$away_team.score",
      diff: 1
    }
  },
  { $sort: { diff: 1, _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q16: Carregou o time (30+ pts e vitória)
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  { $match: { "player_stats.points": { $gte: 30 } } },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  {
    $addFields: {
      won: {
        $or: [
          { $and: [{ $eq: ["$p.team_id", "$home_team.team_id"] }, { $gt: ["$home_team.score", "$away_team.score"] }] },
          { $and: [{ $eq: ["$p.team_id", "$away_team.team_id"] }, { $gt: ["$away_team.score", "$home_team.score"] }] }
        ]
      }
    }
  },
  { $match: { won: true } },
  {
    $project: {
      player: "$p.name",
      game: "$_id",
      points: "$player_stats.points"
    }
  },
  { $sort: { points: -1 } }
]);

// -----------------------------------------------------------------------------
// Q17: Eficiência ofensiva (Melhor ataque)
// Estratégia: Criar array com home e away, desenrolar e calcular média global.
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $project: {
      teams: [
        { id: "$home_team.team_id", score: "$home_team.score" },
        { id: "$away_team.team_id", score: "$away_team.score" }
      ]
    }
  },
  { $unwind: "$teams" },
  {
    $group: {
      _id: "$teams.id",
      avgPoints: { $avg: "$teams.score" }
    }
  },
  {
    $project: {
      team: "$_id",
      avgPoints: { $round: ["$avgPoints", 1] }
    }
  },
  { $sort: { avgPoints: -1 } }
]);

// -----------------------------------------------------------------------------
// Q18: Melhor defesa (Pontos sofridos)
// Estratégia: Inverter a lógica do Q17. Se sou Home, o 'conceded' é Away Score.
// -----------------------------------------------------------------------------
db.games.aggregate([
  {
    $project: {
      performances: [
        { team: "$home_team.team_id", conceded: "$away_team.score" },
        { team: "$away_team.team_id", conceded: "$home_team.score" }
      ]
    }
  },
  { $unwind: "$performances" },
  {
    $group: {
      _id: "$performances.team",
      avgConceded: { $avg: "$performances.conceded" }
    }
  },
  {
    $project: {
      team: "$_id",
      avgPointsAgainst: { $round: ["$avgConceded", 1] }
    }
  },
  { $sort: { avgPointsAgainst: 1 } }
]);

// -----------------------------------------------------------------------------
// Q19: Jogadores Vilões (Média fora de casa)
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $unwind: "$player_stats" },
  {
    $lookup: {
      from: "players",
      localField: "player_stats.player_id",
      foreignField: "_id",
      as: "p"
    }
  },
  { $unwind: "$p" },
  // Filtro: Jogador pertence ao time VISITANTE
  { $match: { $expr: { $eq: ["$p.team_id", "$away_team.team_id"] } } },
  {
    $group: {
      _id: "$p.name",
      avgAwayPoints: { $avg: "$player_stats.points" }
    }
  },
  { $sort: { avgAwayPoints: -1, _id: 1 } }
]);

// -----------------------------------------------------------------------------
// Q20: Narrativa de temporada (Lakers Home Games)
// -----------------------------------------------------------------------------
db.games.aggregate([
  { $match: { "home_team.team_id": "LAL" } },
  {
    $project: {
      date: 1,
      points: "$home_team.score",
      opponent: "$away_team.team_id"
    }
  },
  { $sort: { date: 1 } }
]);