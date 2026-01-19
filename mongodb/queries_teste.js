// 1. Jogadores decisivos (clutch)
// Quem faz mais pontos em **jogos vencidos pelo time**
// Quem realmente contribui para vitórias, não só pontua muito.

db.games.aggregate([
  { $unwind: "$stats" },

  {
    $lookup: {
      from: "players",
      localField: "stats.playerId",
      foreignField: "_id",
      as: "player"
    }
  },
  { $unwind: "$player" },

  {
    $match: {
      $expr: {
        $or: [
          {
            $and: [
              { $eq: ["$player.teamId", "$homeTeamId"] },
              { $gt: ["$homeScore", "$awayScore"] }
            ]
          },
          {
            $and: [
              { $eq: ["$player.teamId", "$awayTeamId"] },
              { $gt: ["$awayScore", "$homeScore"] }
            ]
          }
        ]
      }
    }
  },

  {
    $group: {
      _id: "$player.name",
      pointsInWins: { $sum: "$stats.points" }
    }
  },

  { $sort: { pointsInWins: -1 } }
]);



// 2. Dependência de jogador (time “refém”)
// Percentual de pontos do time feitos por um jogador
// Times muito dependentes de uma estrela.

db.games.aggregate([
  { $unwind: "$stats" },

  {
    $lookup: {
      from: "players",
      localField: "stats.playerId",
      foreignField: "_id",
      as: "player"
    }
  },
  { $unwind: "$player" },

  {
    $project: {
      team: "$player.teamId",
      player: "$player.name",
      playerPoints: "$stats.points",
      teamPoints: {
        $cond: [
          { $eq: ["$player.teamId", "$homeTeamId"] },
          "$homeScore",
          "$awayScore"
        ]
      }
    }
  },

  {
    $group: {
      _id: { team: "$team", player: "$player" },
      playerPoints: { $sum: "$playerPoints" },
      teamPoints: { $sum: "$teamPoints" }
    }
  },

  {
    $project: {
      _id: 0,
      team: "$_id.team",
      player: "$_id.player",
      pctOfTeamPoints: {
        $round: [
          { $multiply: [{ $divide: ["$playerPoints", "$teamPoints"] }, 100] },
          1
        ]
      }
    }
  },

  { $sort: { pctOfTeamPoints: -1 } }
]);



// 3. Força do mando de quadra (arena decisiva)
// Aproveitamento do time jogando em casa
// Arenas que realmente fazem diferença.

db.games.aggregate([
  {
    $group: {
      _id: "$homeTeamId",
      homeGames: { $sum: 1 },
      homeWins: {
        $sum: {
          $cond: [{ $gt: ["$homeScore", "$awayScore"] }, 1, 0]
        }
      }
    }
  },

  {
    $project: {
      team: "$_id",
      homeWins: 1,
      homeGames: 1,
      homeWinPct: {
        $round: [
          { $multiply: [{ $divide: ["$homeWins", "$homeGames"] }, 100] },
          1
        ]
      }
    }
  },

  { $sort: { homeWinPct: -1 } }
]);



// 4. Jogadores mais consistentes
// Menor variação de pontos por jogo
// Jogador confiável vs jogador “8 ou 80”.

db.games.aggregate([
  { $unwind: "$stats" },

  {
    $lookup: {
      from: "players",
      localField: "stats.playerId",
      foreignField: "_id",
      as: "player"
    }
  },
  { $unwind: "$player" },

  {
    $group: {
      _id: "$player.name",
      avgPoints: { $avg: "$stats.points" },
      variation: { $stdDevPop: "$stats.points" }
    }
  },

  {
    $project: {
      player: "$_id",
      avgPoints: { $round: ["$avgPoints", 1] },
      consistency: { $round: ["$variation", 2] }
    }
  },

  { $sort: { consistency: 1 } }
]);



// 5. Rivalidade equilibrada
// Jogos decididos por até 5 pontos
// Jogos mais emocionantes.

db.games.aggregate([
  {
    $project: {
      game: "$_id",
      home: "$homeTeamId",
      away: "$awayTeamId",
      homeScore: 1,
      awayScore: 1,
      diff: { $abs: { $subtract: ["$homeScore", "$awayScore"] } }
    }
  },

  { $match: { diff: { $lte: 5 } } },

  { $sort: { diff: 1 } }
]);



// 6. “Carregou o time nas costas”
// Jogador que fez 30+ pontos e o time venceu
// Atuações históricas.

db.games.aggregate([
  { $unwind: "$stats" },

  {
    $lookup: {
      from: "players",
      localField: "stats.playerId",
      foreignField: "_id",
      as: "player"
    }
  },
  { $unwind: "$player" },

  { $match: { "stats.points": { $gte: 30 } } },

  {
    $match: {
      $expr: {
        $or: [
          {
            $and: [
              { $eq: ["$player.teamId", "$homeTeamId"] },
              { $gt: ["$homeScore", "$awayScore"] }
            ]
          },
          {
            $and: [
              { $eq: ["$player.teamId", "$awayTeamId"] },
              { $gt: ["$awayScore", "$homeScore"] }
            ]
          }
        ]
      }
    }
  },

  {
    $project: {
      player: "$player.name",
      game: "$_id",
      points: "$stats.points"
    }
  },

  { $sort: { points: -1 } }
]);



// 7. Eficiência ofensiva (pontos por jogo)
// Time que mais pontua em média
// Melhor ataque da liga.

db.games.aggregate([
  {
    $project: {
      teams: [
        { team: "$homeTeamId", points: "$homeScore" },
        { team: "$awayTeamId", points: "$awayScore" }
      ]
    }
  },

  { $unwind: "$teams" },

  {
    $group: {
      _id: "$teams.team",
      avgPoints: { $avg: "$teams.points" }
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



// 8. Melhor defesa
// Time que menos sofre pontos
// Quem ganha jogo defendendo.

db.games.aggregate([
  {
    $project: {
      conceded: [
        { team: "$homeTeamId", points: "$awayScore" },
        { team: "$awayTeamId", points: "$homeScore" }
      ]
    }
  },

  { $unwind: "$conceded" },

  {
    $group: {
      _id: "$conceded.team",
      avgPointsAgainst: { $avg: "$conceded.points" }
    }
  },

  {
    $project: {
      team: "$_id",
      avgPointsAgainst: { $round: ["$avgPointsAgainst", 1] }
    }
  },

  { $sort: { avgPointsAgainst: 1 } }
]);



// 9. Jogadores “vilões”
// Jogadores que sempre jogam bem fora de casa
// Jogadores que silenciam arenas adversárias.

db.games.aggregate([
  { $unwind: "$stats" },

  {
    $lookup: {
      from: "players",
      localField: "stats.playerId",
      foreignField: "_id",
      as: "player"
    }
  },
  { $unwind: "$player" },

  {
    $match: {
      $expr: { $eq: ["$player.teamId", "$awayTeamId"] }
    }
  },

  {
    $group: {
      _id: "$player.name",
      avgAwayPoints: { $avg: "$stats.points" }
    }
  },

  {
    $project: {
      player: "$_id",
      avgAwayPoints: { $round: ["$avgAwayPoints", 1] }
    }
  },

  { $sort: { avgAwayPoints: -1 } }
]);



// 10. Narrativa de temporada
// Evolução do time jogo a jogo
// Análise temporal (gráfico).

db.games.aggregate([
  { $match: { homeTeamId: "LAL" } },

  {
    $project: {
      date: 1,
      points: "$homeScore"
    }
  },

  { $sort: { date: 1 } }
]);
