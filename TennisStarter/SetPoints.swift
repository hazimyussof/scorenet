class SetPoints {
    
    private var p1GamesCount: Int = 0
    private var p2GamesCount: Int = 0
    
    /**
     This method will be called when player 1 wins a point and update the state of the instance of SetPoints  to reflect the change
     */
    func addPointToPlayer1() { // USED
        p1GamesCount += 1
        if p1GamesCount == 8 {
            p1GamesCount = 0
        }
    }
    
    /**
     This method will be called when player 2 wins a point and update the state of the instance of SetPoints to reflect the change
     */
    func addPointToPlayer2() { // USED
        p2GamesCount += 1
        if p2GamesCount == 8 {
            p2GamesCount = 0
        }
    }
    
    /**
     Returns the score for player 1, this ranges from 0 - 7
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String { // USED
        let score: [String] = ["0","1","2","3","4","5","6","7"]
        return score[p1GamesCount]
    }
    
    /**
     Returns the score for player 2, this ranges from 0 - 7
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String { // USED
        let score: [String] = ["0","1","2","3","4","5","6","7"]
        return score[p2GamesCount]
    }
    
    /**
     This method will return a string that shows and updates the previous SetScores with the current SetScores for player 1
     */
    func player1PreviousScore(previousScore: String) -> String { // USED
        let currentScore: String = player1Score()
        let updatedScore: String = "\(previousScore) \(currentScore)"
        return updatedScore
    }
    
    /**
     This method will return a string that shows and updates the previous SetScores with the current SetScores for player 2
     */
    func player2PreviousScore(previousScore: String) -> String { // USED
        let currentScore: String = player2Score()
        let updatedScore: String = "\(previousScore) \(currentScore)"
        return String(updatedScore)
    }
    
    /**
     Returns true if player 1 has won the Set, false otherwise
     */
    func player1Won() -> Bool { // USED
        var player1WinCondition: Bool = false
        if (gamePointsForPlayer1() >= 2 && p1GamesCount == 6) {
            player1WinCondition = true
        } else if (p1GamesCount == 7) {
            player1WinCondition = true
        } else {
            player1WinCondition = false
        }
        return player1WinCondition
    }
    
    /**
     Returns true if player 2 has won the Set, false otherwise
     */
    func player2Won() -> Bool { // USED
        var player2WinCondition: Bool = false
        if (gamePointsForPlayer2() >= 2 && p2GamesCount == 6) {
            player2WinCondition = true
        } else if (p2GamesCount == 7) {
            player2WinCondition = true
        } else {
            player2WinCondition = false
        }
        return player2WinCondition
    }
    
    /**
     Returns true if the SetPoints is finished, false otherwise
     */
    func complete() -> Bool { // USED
        var gameCompleted: Bool = false
        if (player1Won() || player2Won()) {
            gameCompleted = true
        } else {
            gameCompleted = false
        }
        return gameCompleted
    }
    
    /**
     returns the number of points player 1 would need to win to equalise the score, otherwise returns 0
     */
    func gamePointsForPlayer1() -> Int { // USED
        let score: [String] = ["0","1","2","3","4","5","6","7"]
        var pointsNeededForPlayer2: Int
        // Code adapted from Paul Hudson, 2019.
        let player1Points: Int = score.firstIndex { $0 == player1Score()}!
        let player2Points: Int = score.firstIndex { $0 == player2Score()}!
        // End of adapted code.
        if (player1Points >= 3 && player1Points >= player2Points) { // Condition for points that has to be 2 points ahead.
            pointsNeededForPlayer2 = player1Points - player2Points
        } else {
            pointsNeededForPlayer2 = 0
        }
        return pointsNeededForPlayer2
    }
    
    /**
     returns the number of points player 2 would need to win to equalise the score, otherwise returns 0
     */
    func gamePointsForPlayer2() -> Int { // USED
        let score: [String] = ["0","1","2","3","4","5","6","7"]
        var pointsNeededForPlayer1: Int
        // Code adapted from Pual Hudson, 2019.
        let player2Points: Int = score.firstIndex { $0 == player2Score()}!
        let player1Points: Int = score.firstIndex { $0 == player1Score()}!
        // End of adapted code.
        if (player2Points >= 3 && player2Points >= player1Points) { // Condition for points that has to be 2 points ahead.
            pointsNeededForPlayer1 = player2Points - player1Points
        } else {
            pointsNeededForPlayer1 = 0
        }
        return pointsNeededForPlayer1
    }
    
    /**
     returns a boolean condition on whether a Tie-Breaker condition is meet, this is only done for SetPoints of 6 - 6
     */
    func tieBreaker() -> Bool { // USED
        var tieBreakerCondition: Bool = false
        if (p1GamesCount == 6 && p2GamesCount == 6) {
            tieBreakerCondition = true
        } else {
            tieBreakerCondition = false
        }
        return tieBreakerCondition
    }
    
}
