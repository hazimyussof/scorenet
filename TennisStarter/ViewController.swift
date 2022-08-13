import UIKit
import AVFoundation
import CoreLocation
import EventKit
import EventKitUI

class ViewController: UIViewController, CLLocationManagerDelegate, EKEventEditViewDelegate {
    
    private var game = Game() // Object instance of the Game Class
    private var setPoints = SetPoints() // Object instance of the SetPoints Class.
    private var set = Set() // Object instance of the Set Class.
    private var tieBreaker = TieBreaker() // Object instance of the TieBreaker Class.
    
    private var diff: Int = 0 // This variable is used to count the difference of 2 points for TieBreak server.
    private var P1ServesTieBreak: Bool = false // Condition if P1 is the first server for TieBreak.
    private var P2SerbesTieBreak: Bool = false // Condition if P2 is the first server for TieBreak.
    
    private var noOfGamesPlayed: Int = 0 // This variable is used to count the number of games played in the match.
    private var firstGameRoundPassed: Bool = false // Condition if the firstGameRound 7 has passed.
    private var gameRound: Int = 7 // This variable is used to represent the gameRounds for each new ball requested.
    
    var p1MatchScoreArr = [String]() // This array is used to store the match scores of player 1 of each game for the match history.
    var p2MatchScoreArr = [String]() // This array is used to store the match scores of player 2 of each game for the match history.
    var matchLocationArr = [String]() // This array is used to store the match location of the match for the match history.
    var dateArr = [String]() // This array is used to store the current date of the match for the match history.
    
    var player: AVAudioPlayer?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let eventStore = EKEventStore()
    let date = Date()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p1NameLabel: UILabel!
    @IBOutlet weak var p2NameLabel: UILabel!
    
    @IBOutlet weak var p1PointsLabel: UILabel!
    @IBOutlet weak var p2PointsLabel: UILabel!
    
    @IBOutlet weak var p1GamesLabel: UILabel!
    @IBOutlet weak var p2GamesLabel: UILabel!
    
    @IBOutlet weak var p1SetsLabel: UILabel!
    @IBOutlet weak var p2SetsLabel: UILabel!
    
    @IBOutlet weak var p1PreviousSetsLabel: UILabel!
    @IBOutlet weak var p2PreviousSetsLabel: UILabel!
    
    @IBOutlet weak var matchLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let p1ScoreUserDefaults = UserDefaults.standard.object(forKey: "p1Score") as? [String] { p1MatchScoreArr = p1ScoreUserDefaults }
        if let p2ScoreUserDefaults = UserDefaults.standard.object(forKey: "p2Score") as? [String] { p2MatchScoreArr = p2ScoreUserDefaults }
        if let matchLocationUserDefaults = UserDefaults.standard.object(forKey: "matchLocation") as? [String] { matchLocationArr = matchLocationUserDefaults }
        if let dateUserDefaults = UserDefaults.standard.object(forKey: "date") as? [String] { dateArr = dateUserDefaults }
        tableView.allowsSelection = false
        dateFormatter.dateFormat = "yyyy-MM-dd"
        locationManager.requestWhenInUseAuthorization() // Location is used only when the app is opened.
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        randomSelectServer()
    }
    
    /********Methods*********/
    @IBAction func p1AddPointPressed(_ sender: UIButton) {
        game.addPointToPlayer1()
        p1PointsLabel.text = game.player1Score()
        player1GamePointsCondition()
        previousSetScoreUpdate()
        player1SetPointsCondition()
        playerScoreAdvantage()
    }
    
    @IBAction func p2AddPointPressed(_ sender: UIButton) {
        game.addPointToPlayer2()
        p2PointsLabel.text = game.player2Score()
        player2GamePointsCondition()
        previousSetScoreUpdate()
        player2SetPointsCondition()
        playerScoreAdvantage()
    }
    
    @IBAction func restartPressed(_ sender: AnyObject) {
        // Recall object instances to reset the score counts.
        game = Game()
        setPoints = SetPoints()
        set = Set()
        tieBreaker = TieBreaker()
        // Reseting the default values and conditions.
        diff = 0
        P1ServesTieBreak = false
        P2SerbesTieBreak = false
        noOfGamesPlayed = 0
        firstGameRoundPassed = false
        gameRound = 7
        // Reseting the lables back to - .
        p1PointsLabel.text = "-"
        p2PointsLabel.text = "-"
        p1GamesLabel.text = "-"
        p2GamesLabel.text = "-"
        p1SetsLabel.text = "-"
        p2SetsLabel.text = "-"
        p1PreviousSetsLabel.text = "-"
        p2PreviousSetsLabel.text = "-"
        // Reseting the textColor of lables back to black.
        p1PointsLabel.textColor = UIColor.black
        p2PointsLabel.textColor = UIColor.black
        p1GamesLabel.textColor = UIColor.black
        p2GamesLabel.textColor = UIColor.black
        p1SetsLabel.textColor = UIColor.black
        p2SetsLabel.textColor = UIColor.black
        // Enable buttons for P1 and P2.
        p1Button.isEnabled = true
        p2Button.isEnabled = true
        // Upon clicking the restart button, it will additionally change the server.
        changeServer()
    }
    
    @IBAction func eventPressed(_ sender: Any) {
        // Code adapted from Aryaa SK Coding, 2021.
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Authorised")
                    presentEventVC()
                }
            }
            print("Not determined")
        case .authorized:
            print("Authorised")
            presentEventVC()
        default:
            break
        }
        func presentEventVC() {
            DispatchQueue.main.async {
                let eventVC = EKEventEditViewController()
                eventVC.editViewDelegate = self
                eventVC.eventStore = EKEventStore()
                
                let event = EKEvent(eventStore: eventVC.eventStore)
                event.title = "Tennis Match"
                event.startDate = Date()
                
                eventVC.event = event
                
                self.present(eventVC, animated: true, completion: nil)
            }
        }
        // End of adapted code.
    }
    
    @IBAction func clearHistoryPressed(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "p1Score")
        UserDefaults.standard.removeObject(forKey: "p2Score")
        UserDefaults.standard.removeObject(forKey: "matchLocation")
        UserDefaults.standard.removeObject(forKey: "date")
        p1MatchScoreArr.removeAll()
        p2MatchScoreArr.removeAll()
        matchLocationArr.removeAll()
        dateArr.removeAll()
        tableView.reloadData()
    }
    
    // METHODS:
    func addHistory() { /// this method adds player score, match location and date information into a TableView to save match history.
        self.p1MatchScoreArr.insert(p1PreviousSetsLabel.text!, at: 0)
        UserDefaults.standard.set(p1MatchScoreArr, forKey: "p1Score")
        self.p2MatchScoreArr.insert(p2PreviousSetsLabel.text!, at: 0)
        UserDefaults.standard.set(p2MatchScoreArr, forKey: "p2Score")
        self.matchLocationArr.insert(matchLocation.text!, at: 0)
        UserDefaults.standard.set(matchLocationArr, forKey: "matchLocation")
        self.dateArr.insert(dateFormatter.string(from: date), at: 0)
        UserDefaults.standard.set(dateArr, forKey: "date")
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        tableView.endUpdates()
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) { /// This method is used to allow the ability to dismiss the eventViewController.
        controller.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { /// This method is used to retrieve the location address of the user using reverse Geocoding from the coordinates retrieved by the user's GPS from the phone.
        if let location = locations.first {
            print("Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
            // Code adapted from Himanshu Moradiya, 2016.
            let loc: CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            geocoder.reverseGeocodeLocation(loc, completionHandler:
                                                {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString: String = ""
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
                    self.matchLocation.text = addressString
                }
            })
            // End of adapted code.
        }
    }
    
    private func newBallsRequest() { /// This method will first play text-to-speach when the total games reaches 7, then for every 9th game afterward.
        noOfGamesPlayed += 1
        if (firstGameRoundPassed == true) {
            gameRound = 9
            if (noOfGamesPlayed == gameRound) {
                noOfGamesPlayed = 0
                playTextToSpeach()
            }
        } else {
            if (noOfGamesPlayed == gameRound) {
                firstGameRoundPassed = true
                noOfGamesPlayed = 0
                playTextToSpeach()
            }
        }
    }
    
    private func playerScoreAdvantage() { /// This method is visually indicates whether P1 or P2 has 1 or more points in either GamePoint, SetPoint or Matchpoint, lable will be green.
        let p1GamePointsScore: Int = Int(game.player1Score()) ?? 0
        let p2GamePointsScore: Int = Int(game.player2Score()) ?? 0
        let p1SetPointsScore: Int = Int(setPoints.player1Score()) ?? 0
        let p2SetPointsScore: Int = Int(setPoints.player2Score()) ?? 0
        let p1SetScore: Int = Int(set.player1Score()) ?? 0
        let p2SetScore: Int = Int(set.player2Score()) ?? 0
        let p1TieBreakScore: Int = Int(tieBreaker.player1Score()) ?? 0
        let p2TieBreakScore: Int = Int(tieBreaker.player2Score()) ?? 0
        // Score Advantage for GamePoints:
        if (game.player1Score() == "A") {
            p1PointsLabel.textColor = UIColor.green
            p2PointsLabel.textColor = UIColor.black
        } else if (game.player2Score() == "A") {
            p2PointsLabel.textColor = UIColor.green
            p1PointsLabel.textColor = UIColor.black
        } else {
            if (p1GamePointsScore > p2GamePointsScore) {
                p1PointsLabel.textColor = UIColor.green
                p2PointsLabel.textColor = UIColor.black
            } else if (p2GamePointsScore > p1GamePointsScore) {
                p2PointsLabel.textColor = UIColor.green
                p1PointsLabel.textColor = UIColor.black
            } else if (game.gamePointsForPlayer2() == 0 && game.gamePointsForPlayer1() == 0) {
                p2PointsLabel.textColor = UIColor.black
                p1PointsLabel.textColor = UIColor.black
            }
        }
        // Score Advantage for TieBreaak:
        if (p1TieBreakScore > p2TieBreakScore) {
            p1PointsLabel.textColor = UIColor.green
            p2PointsLabel.textColor = UIColor.black
        } else if (p2TieBreakScore > p1TieBreakScore) {
            p2SetsLabel.textColor = UIColor.green
            p1SetsLabel.textColor = UIColor.black
        } else {
            p1SetsLabel.textColor = UIColor.black
            p2SetsLabel.textColor = UIColor.black
        }
        // Score Advantage for SetPoints:
        if (p1SetPointsScore > p2SetPointsScore) {
            p1GamesLabel.textColor = UIColor.green
            p2GamesLabel.textColor = UIColor.black
        } else if (p2SetPointsScore > p1SetPointsScore) {
            p2GamesLabel.textColor = UIColor.green
            p1GamesLabel.textColor = UIColor.black
        } else {
            p1GamesLabel.textColor = UIColor.black
            p2GamesLabel.textColor = UIColor.black
        }
        // Score Advantage for MatchPoints:
        if (p1SetScore > p2SetScore) {
            p1SetsLabel.textColor = UIColor.green
            p2SetsLabel.textColor = UIColor.black
        } else if (p2SetScore > p1SetScore) {
            p2SetsLabel.textColor = UIColor.green
            p1SetsLabel.textColor = UIColor.black
        } else {
            p1SetsLabel.textColor = UIColor.black
            p2SetsLabel.textColor = UIColor.black
        }
    }
    
    private func randomSelectServer() -> () { /// This method randomly select either P1 or P2 to be the server.
        // Code adapted from Mat Koffman, 2015.
        let randomFunc = [self.p1Server, self.p2Server]
        let randomResult = Int(arc4random_uniform(UInt32(randomFunc.count)))
        return randomFunc[randomResult]()
        // End of adapted code.
    }
    
    /// These method changes the P1 and P2 textColor to purple to visualise the servers.
    private func p1Server() {
        p1NameLabel.textColor = UIColor.purple
    }
    private func p2Server() {
        p2NameLabel.textColor = UIColor.purple
    }
    
    private func changeTieBreakServer() { /// This method is used to change the server for every 2 points played in a TieBreak.
        diff += 1
        diff % 2 == 0 ? changeServer() : nil
    }
    
    private func firstServerForTiebreak() { /// This method is used to determine who is the first palyer who serves the beggining of a TieBreak.
        if (p1NameLabel.textColor == UIColor.purple) {
            P1ServesTieBreak = true
        } else if (p2NameLabel.textColor == UIColor.purple) {
            P2SerbesTieBreak = true
        }
    }
    
    private func changeServerAfterTieBreak() { /// This method is used to change the server after a TieBreak game has ended. Opposite player who serves the first TieBreak.
        if (P1ServesTieBreak == true) {
            p2NameLabel.textColor = UIColor.purple
            p1NameLabel.textColor = UIColor.black
        } else if (P2SerbesTieBreak == true) {
            p1NameLabel.textColor = UIColor.purple
            p2NameLabel.textColor = UIColor.black
        }
    }
    
    private func changeServer() { /// This method is for changing the servers between the players by changing the name lable text colour to purple.
        playSound()
        if (p1NameLabel.textColor == UIColor.purple) {
            p2NameLabel.textColor = UIColor.purple
            p1NameLabel.textColor = UIColor.black
        }
        else if (p2NameLabel.textColor == UIColor.purple) {
            p1NameLabel.textColor = UIColor.purple
            p2NameLabel.textColor = UIColor.black
        }
    }
    
    private func playSound() { /// This method will play the Sound.wav, it will be used for every change in servers.
        // Code adapted from Devapploper, 2015.
        guard let url = Bundle.main.url(forResource: "Sound", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        // End of adapted code.
    }
    
    private func playTextToSpeach() { /// This method will play text-to-speech, it will be used for every 7th game and 9th game.
        let synthesizer = AVSpeechSynthesizer()
        let text: String = "New balls please"
        let speech = AVSpeechUtterance(string: text)
        synthesizer.speak(speech)
    }
    
    private func showWinnerAlert(player: String) { /// This method is for showing the winner of the game using an alert.
        let alert = UIAlertController(title: "Game Ended", message: "\(player) won the match.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            print("Dismiss button tapped.")
        }))
        present(alert, animated: true)
    }
    
    private func player1GamePointsCondition() { /// This method contains the logic for GamePoints to reflect the SetPoints of Player 1.
        if (setPoints.tieBreaker()) {
            if (tieBreaker.player1Score() == "0" && tieBreaker.player2Score() == "0") {
                firstServerForTiebreak()
            }
            player1TieBreakerPointsCondition()
        } else {
            if (game.player1Won()) { // Point winning condition for P1 that has 2 points ahead.
                changeServer()
                setPoints.addPointToPlayer1()
                p1GamesLabel.text = setPoints.player1Score()
                p2GamesLabel.text = setPoints.player2Score()
                game = Game() // Resets the instance of scores in points.
                p2PointsLabel.text = game.player2Score() // Resets the lables for P2.
                p1PointsLabel.text = game.player1Score() // Resets the lables for P1.
                newBallsRequest()
            } else { // Point winning condition for P1 that has less than 2 points ahead.
                if (p1PointsLabel.text == "40" && p2PointsLabel.text == "A") { // Condition to update both lables if P2 won P1's Advantage.
                    p1PointsLabel.text = game.player1Score()
                    p2PointsLabel.text = game.player2Score()
                }
                else if (p1PointsLabel.text == "0") { // Condition to only update games after P2 wins 4 points.
                    changeServer()
                    setPoints.addPointToPlayer1()
                    p1GamesLabel.text = setPoints.player1Score()
                    game = Game() // Resets the instance of scores in points.
                    p2PointsLabel.text = game.player2Score() // Resets the lables for P1, P2 is already reset since he won.
                    newBallsRequest()
                }
            }
        }
    }
    
    private func player2GamePointsCondition() { /// This method contains the logic for GamePoints to reflect the SetPoints of Player 2.
        if (setPoints.tieBreaker()) {
            if (tieBreaker.player2Score() == "0" && tieBreaker.player1Score() == "0") {
                firstServerForTiebreak()
            }
            player2TieBreakerPointsCondition()
        } else {
            if (game.player2Won()) { // Point winning condition for P2 that has 2 points ahead.
                changeServer()
                setPoints.addPointToPlayer2()
                p2GamesLabel.text = setPoints.player2Score()
                p1GamesLabel.text = setPoints.player1Score()
                game = Game() // Resets the instance of scores in points.
                p1PointsLabel.text = game.player1Score() // Resets the lables for P1.
                p2PointsLabel.text = game.player2Score() // Resets the lables for P2.
                newBallsRequest()
            } else { // Point winning condition for P2 that has less than 2 points ahead.
                if (p2PointsLabel.text == "40" && p1PointsLabel.text == "A") { // Condition to update both lables if P2 won P1's Advantage.
                    p2PointsLabel.text = game.player2Score()
                    p1PointsLabel.text = game.player1Score()
                }
                else if (p2PointsLabel.text == "0") { // Condition to only update games after P2 wins 4 points.
                    changeServer()
                    setPoints.addPointToPlayer2()
                    p2GamesLabel.text = setPoints.player2Score()
                    game = Game() // Resets the instance of scores in points.
                    p1PointsLabel.text = game.player1Score() // Resets the lables for P1, P2 is already reset since he won.
                    newBallsRequest()
                }
            }
        }
    }
    
    private func player1SetPointsCondition() { /// This method contains the logic for SetPoints to reflect the Match of Player 1.
        if (setPoints.player1Won()) {
            if (p1SetsLabel.text == "2") { // This condition is used instead of set.Player1Won to perserve the set and setPoint scores.
                set.addPointToPlayer1()
                p1SetsLabel.text = set.player1Score()
                p1Button.isEnabled = false
                p2Button.isEnabled = false
                showWinnerAlert(player: p1NameLabel.text!)
                addHistory()
            } else {
                set.addPointToPlayer1()
                p1SetsLabel.text = set.player1Score()
                p2SetsLabel.text = set.player2Score()
                game = Game()
                p1PointsLabel.text = game.player1Score()
                p2PointsLabel.text = game.player2Score()
                setPoints = SetPoints()
                p1GamesLabel.text = setPoints.player1Score()
                p2GamesLabel.text = setPoints.player2Score()
            }
        }
    }
    
    private func player2SetPointsCondition() { /// This method contains the logic for SetPoints to reflect the Match of Player 2.
        if (setPoints.player2Won()) {
            if (p2SetsLabel.text == "2") { // this condition is used instead of set.Player2Won to conserve the set and setPoint scores.
                set.addPointToPlayer2()
                p2SetsLabel.text = set.player2Score()
                p2Button.isEnabled = false
                p1Button.isEnabled = false
                showWinnerAlert(player: p2NameLabel.text!)
                addHistory()
            } else {
                set.addPointToPlayer2()
                p2SetsLabel.text = set.player2Score()
                p1SetsLabel.text = set.player1Score()
                game = Game()
                p2PointsLabel.text = game.player2Score()
                p1PointsLabel.text = game.player1Score()
                setPoints = SetPoints()
                p2GamesLabel.text = setPoints.player2Score()
                p1GamesLabel.text = setPoints.player1Score()
            }
        }
    }
    
    private func previousSetScoreUpdate() { /// This method contains the logic for showing and updating the Previous SetPoints of each Set.
        if (setPoints.complete()) {
            if (p1PreviousSetsLabel.text == "-" && p2PreviousSetsLabel.text == "-") {
                p1PreviousSetsLabel.text = ""
                p2PreviousSetsLabel.text = ""
            }
            p1PreviousSetsLabel.text = setPoints.player1PreviousScore(previousScore: p1PreviousSetsLabel.text!)
            p2PreviousSetsLabel.text = setPoints.player2PreviousScore(previousScore: p2PreviousSetsLabel.text!)
        }
    }
    
    private func player1TieBreakerPointsCondition() { /// This method contains the logic of Tie-Breaks for Player 1.
        changeTieBreakServer()
        tieBreaker.addPointToPlayer1()
        p1PointsLabel.text = tieBreaker.player1Score()
        p2PointsLabel.text = tieBreaker.player2Score()
        if (tieBreaker.player1Won()) {
            playSound()
            changeServerAfterTieBreak()
            setPoints.addPointToPlayer1()
            p1GamesLabel.text = setPoints.player1Score()
            p2GamesLabel.text = setPoints.player2Score()
            tieBreaker = TieBreaker() // Resets the instance of scores in points.
            p2PointsLabel.text = tieBreaker.player2Score() // Resets the lables for P2.
            p1PointsLabel.text = tieBreaker.player1Score() // Resets the lables for P1.
            newBallsRequest()
        }
    }
    
    private func player2TieBreakerPointsCondition() { /// This method contains the logic of Tie-breaks for Player 2.
        changeTieBreakServer()
        tieBreaker.addPointToPlayer2()
        p2PointsLabel.text = tieBreaker.player2Score()
        p1PointsLabel.text = tieBreaker.player1Score()
        if (tieBreaker.player2Won()) {
            playSound()
            changeServerAfterTieBreak()
            setPoints.addPointToPlayer2()
            p2GamesLabel.text = setPoints.player2Score()
            p1GamesLabel.text = setPoints.player1Score()
            tieBreaker = TieBreaker() // Resets the instance of scores in points.
            p1PointsLabel.text = tieBreaker.player1Score() // Resets the lables for P1.
            p2PointsLabel.text = tieBreaker.player2Score() // Resets the lables for P2.
            newBallsRequest()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource { /// TableView delegate and dataSource extension for the ViewController.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return p1MatchScoreArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewCell", for: indexPath) as? EditTableViewCell else {
            return UITableViewCell()}
        cell.p1Score.text = p1MatchScoreArr[indexPath.row]
        cell.p2Score.text = p2MatchScoreArr[indexPath.row]
        cell.matchLocation.text = matchLocationArr[indexPath.row]
        cell.date.text = dateArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

class EditTableViewCell: UITableViewCell { /// UITableViewCell Class for the Match Hitory.
    
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    @IBOutlet weak var matchLocation: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

