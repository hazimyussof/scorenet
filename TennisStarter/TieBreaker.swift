class TieBreaker {
    
    private var p1Score: Int = 0
    private var p2Score: Int = 0
    
    /**
     This method will be called when player 1 wins a point in a Tie-Break and update the state of the instance of Game to reflect the change
     */
    func addPointToPlayer1() { // USED
        p1Score += 1
    }
    
    /**
     This method will be called when player 2 wins a point in a Tie-Break and update the state of the instance of Game to reflect the change
     */
    func addPointToPlayer2() { // USED
        p2Score += 1
    }
    
    /**
     Returns the score for player 1, this has unlimited range until a winning condition is met
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String { // USED
        return String(p1Score)
    }
    
    /**
     Returns the score for player 2, this has unlimited range until a winning condition is met
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String { // USED
        return String(p2Score)
    }
    
    /**
     Returns true if player 1 has won the Tie-Break, false otherwise
     */
    func player1Won() -> Bool { // USED
        var player1WinCondition: Bool = false
        if (gamePointsForPlayer1() >= 2 && p1Score == 7) {
            player1WinCondition = true
        }
        else if (gamePointsForPlayer1() >= 2 && p1Score >= 7) {
            player1WinCondition = true
        }
        else {
            player1WinCondition = false
        }
        return player1WinCondition
    }
    
    /**
     Returns true if player 1 has won the Tie-Break, false otherwise
     */
    func player2Won() -> Bool { // USED
        var player2WinCondition: Bool = false
        if (gamePointsForPlayer2() >= 2 && p2Score == 7) {
            player2WinCondition = true
        }
        else if (gamePointsForPlayer2() >= 2 && p2Score >= 7) {
            player2WinCondition = true
        }
        else {
            player2WinCondition = false
        }
        return player2WinCondition
    }
    
    /**
     returns the number of points player 1 would need to win to equalise the score, otherwise returns 0
     */
    func gamePointsForPlayer1() -> Int { // USED
        var pointsNeededForPlayer2: Int
        if (p1Score >= 3 && p1Score >= p2Score) { // Condition for points that has to be 2 points ahead.
            pointsNeededForPlayer2 = p1Score - p2Score
        } else {
            pointsNeededForPlayer2 = 0
        }
        return pointsNeededForPlayer2
    }
    
    /**
     returns the number of points player 2 would need to win to equalise the score, otherwise returns 0
     */
    func gamePointsForPlayer2() -> Int { // USED
        var pointsNeededForPlayer1: Int
        if (p2Score >= 3 && p2Score >= p1Score) { // Condition for points that has to be 2 points ahead.
            pointsNeededForPlayer1 = p2Score - p1Score
        } else {
            pointsNeededForPlayer1 = 0
        }
        return pointsNeededForPlayer1
    }
    
}
