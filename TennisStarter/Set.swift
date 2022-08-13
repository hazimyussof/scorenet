class Set {
    
    private var p1SetCount: Int = 0
    private var p2SetCount: Int = 0
    
    /**
     This method will be called when player 1 wins a point and update the state of the instance of Set to reflect the change
     */
    func addPointToPlayer1() { // USED
        p1SetCount += 1
        if p1SetCount == 4 {
            p1SetCount = 0
        }
    }
    
    /**
     This method will be called when player 2 wins a point and update the state of the instance of Set to reflect the change
     */
    func addPointToPlayer2() { // USED
        p2SetCount += 1
        if p2SetCount == 4 {
            p2SetCount = 0
        }
    }
    
    /**
     Returns the score for player 1, this ranges from 0 - 3
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String { // USED
        let score: [String] = ["0","1","2","3"]
        return score[p1SetCount]
    }
    
    /**
     Returns the score for player 2, this ranges from 0 - 3
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String { // USED
        let score: [String] = ["0","1","2","3"]
        return score[p2SetCount]
    }
    
    /**
     Returns true if player 1 has won the Match, false otherwise
     */
    func player1Won() -> Bool { // UNUSED
        var player1WinCondition: Bool = false
        if (p1SetCount == 3) {
            player1WinCondition = true
        } else {
            player1WinCondition = false
        }
        return player1WinCondition
    }
    
    /**
     Returns true if player 1 has won the Match, false otherwise
     */
    func player2Won() -> Bool { // UNUSED
        var player2WinCondition: Bool = false
        if (p2SetCount == 3) {
            player2WinCondition = true
        } else {
            player2WinCondition = false
        }
        return player2WinCondition
    }
    
}
