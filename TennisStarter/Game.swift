class Game {
    
    /// Don't add more than 2 instance variables in this class. One or Two either Int or String ONLY, must be private.
    /// Any new methods added to the class should be private, (not that you need to add any).
    
    private var p1PointsCount: Int = 0
    private var p2PointsCount: Int = 0
    
    /**
     This method will be called when player 1 wins a point and update the state of the instance of Game to reflect the change
     */
    func addPointToPlayer1() { // USED
        p1PointsCount += 1
        if deuce() == true { // Condition for Deuce, it will set both P1 and P2 back to (40 - 40).
            p1PointsCount = 3
            p2PointsCount = 3
        }
        if p1PointsCount == 5 { // To iterate the score array.
            p1PointsCount = 0
        }
    }
    
    /**
     This method will be called when player 2 wins a point
     */
    func addPointToPlayer2() { // USED
        p2PointsCount += 1
        if deuce() == true { // Conditon for Deuce, it will set both P2 and P1 back to (40 - 40).
            p2PointsCount = 3
            p1PointsCount = 3
        }
        if p2PointsCount == 5 { // To iterate the score array.
            p2PointsCount = 0
        }
    }
    
    /**
     Returns the score for player 1, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String { // USED
        let score: [String] = ["0","15","30","40","A"]
        return score[p1PointsCount]
    }
    
    /**
     Returns the score for player 2, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String { // USED
        let score: [String] = ["0","15","30","40","A"]
        return score[p2PointsCount]
    }
    
    /**
     Returns true if player 1 has won the game, false otherwise
     */
    func player1Won() -> Bool { // USED
        var player1WinCondition: Bool = false
        if (gamePointsForPlayer1() >= 2 && p1PointsCount == 4) { // If P1 has more than 2 points ahead and has Advantage, he won.
            player1WinCondition = true
        } else {
            player1WinCondition = false
        }
        return player1WinCondition
    }
    
    /**
     Returns true if player 2 has won the game, false otherwise
     */
    func player2Won() -> Bool { // USED
        var player2WinCondition: Bool = false
        if (gamePointsForPlayer2() >= 2 && p2PointsCount == 4) { // If P2 has more than 2 points ahead and he has Advantage, he won.
            player2WinCondition = true
        } else {
            player2WinCondition = false
        }
        return player2WinCondition
    }
    
    /**
     Returns true if the game is finished, false otherwise
     */
    func complete() -> Bool { // UNUSED
        var gameCompleted: Bool = false
        if (player1Won() || player2Won()) {
            gameCompleted = true
        } else {
            gameCompleted = false
        }
        return gameCompleted
    }
    
    /**
     If player 1 would win the game if they won the next point, returns the number of points player 2 would need to win to equalise the score, otherwise returns 0
     e.g. if the score is 40:15 to player 1, player 1 would win if they scored the next point, and player 2 would need 2 points in a row to prevent that, so this method should return 2 in that case.
     */
    func gamePointsForPlayer1() -> Int { // USED
        let score: [String] = ["0","15","30","40","A"]
        var pointsNeededForPlayer2: Int
        // Code adapted from Paul Hudson, 2019.
        let player1Points: Int = score.firstIndex { $0 == player1Score()}!
        let player2Points: Int = score.firstIndex { $0 == player2Score()}!
        // End of adapted code.
        if (player1Points >= 3 && player1Points >= player2Points) { // Condition for points that has to be 2 points ahead unless deuce.
            pointsNeededForPlayer2 = player1Points - player2Points
        } else {
            pointsNeededForPlayer2 = 0
        }
        return pointsNeededForPlayer2
    }
    
    /**
     If player 2 would win the game if they won the next point, returns the number of points player 1 would need to win to equalise the score
     */
    func gamePointsForPlayer2() -> Int { // USED
        let score: [String] = ["0","15","30","40","A"]
        var pointsNeededForPlayer1: Int
        // Code adapted from Pual Hudson, 2019.
        let player2Points: Int = score.firstIndex { $0 == player2Score()}!
        let player1Points: Int = score.firstIndex { $0 == player1Score()}!
        // End of adapted code.
        if (player2Points >= 3 && player2Points >= player1Points) { // Condition for points that has to be 2 points ahead unless deuce.
            pointsNeededForPlayer1 = player2Points - player1Points
        } else {
            pointsNeededForPlayer1 = 0
        }
        return pointsNeededForPlayer1
    }
    
    /**
     (New Method Added) This private method returns a condition whether player 1 and player 2 has deuce (40 - 40).
     */
    private func deuce() -> Bool { // USED
        var deuceCondition: Bool = false
        if (p1PointsCount == 4 && p2PointsCount == 4) {
            deuceCondition = true
        } else {
            deuceCondition = false
        }
        return deuceCondition
    }
    
}
