//
//  ViewController.swift
//  DartsTracker
//
//  Created by Sam Toll on 12/22/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player1NameLabel: UILabel!
    
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    
    @IBOutlet weak var playerTurnLabel: UILabel!
    @IBOutlet weak var turnScoreTextField: UITextField!
    
    var turnCount: Int = 1;
    
    // function to execute when submit is pressed
    @IBAction func submitButtonPressed(_ sender: Any) {
        performTurn()
    }
    
    // game players
    var player1: Player = Player();
    var player2: Player = Player();
    
    // function to execute upon view load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // function that executes when view appears, displays first two alerts
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        promptForPlayerNames()
    }
    
    // function that gets the player names from the user
    func promptForPlayerNames() {
        // make sure labels are not hidden upon start
        player2ScoreLabel.isHidden = false
        player2NameLabel.isHidden = false
        // displays alert to get player names
        let alertController = UIAlertController(title: "Enter Player Name(s)", message: nil, preferredStyle: .alert)
        // add text fields to alert
        alertController.addTextField()
        alertController.addTextField()
        
        // add action upon start game pressed
        let startGameAction = UIAlertAction(title: "Start Game", style: .default) { [unowned alertController] _ in
            // get the player name fields presented
            let player1NameField = alertController.textFields![0]
            let player2NameField = alertController.textFields![1]
            
            // see if names were entered, if both names entered...
            if let player1Name = player1NameField.text, player1NameField.text != "", let player2Name = player2NameField.text, player2NameField.text != "" {
                self.player1.name = player1Name;
                self.player2.name = player2Name;
                Player.numPlayers = 2;
            // if both names not entered...
            } else {
                // if player1 name entered, play 1 player game with player1
                if let player1Name = player1NameField.text, player1NameField.text != "" {
                    self.onePlayerGame(name: player1Name)
                // if player2 name entered, play 1 player game with player2
                } else if let player2Name = player2NameField.text, player2NameField.text != "" {
                    self.onePlayerGame(name: player2Name)
                // otherwise prompt again because no players were entered
                } else {
                    self.promptForPlayerNames()
                }
            }
            // set up the labels
            self.setUpLabels()
        }
        
        // when user pressed start game on alert...
        alertController.addAction(startGameAction)
        // show the alert with present()
        present(alertController, animated: true)
    }
    
    // set there to be a one player game
    func onePlayerGame(name: String) {
        // hide player 2 labels and set num players to 1
        player1.name = name;
        player2NameLabel.isHidden = true;
        player2ScoreLabel.isHidden = true;
        Player.numPlayers = 1;
    }
    
    // function to setup beginning labels
    func setUpLabels() {
        player1NameLabel.text = player1.name;
        playerTurnLabel.text = "\(player1.name)'s turn"
        
        if Player.numPlayers == 2 {
            player2NameLabel.text = player2.name;
        }
    }
    
    // function to perform a single turn
    func performTurn() {
        if let turnScore = turnScoreTextField.text, turnScore != "", let turnScoreInt = Int(turnScore) {
            if turnCount % 2 != 0 {
                if checkForValidScore(score: turnScoreInt) == true {
                    player1.score = player1.score - turnScoreInt;
                } else {
                    showBustAlert()
                }
            } else {
                if checkForValidScore(score: turnScoreInt) == true {
                    player2.score = player2.score - turnScoreInt;
                } else {
                    showBustAlert()
                }
            }
            if Player.numPlayers == 2 {
                turnCount = turnCount + 1
            }
        } else {
            displayInvalidInput()
        }
        
        turnScoreTextField.text = ""
        updateLabels()
        checkForWin()
    }
    
    func displayInvalidInput() {
        let alertController = UIAlertController(title: "Invalid Input", message: "You have entered a non-integer for the score. Please enter an integer to count your score!", preferredStyle: .alert)
        // when user pressed okay on first alert...
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        // show the  alert with present()
        present(alertController, animated: true)
    }
    
    func showBustAlert() {
        if turnCount % 2 != 0 {
            let alertController = UIAlertController(title: "\(player1.name) BUST!", message: "Bust, no points deducted. Better luck next time.", preferredStyle: .alert)
            // when user pressed okay on first alert...
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            // show the  alert with present()
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "\(player2.name) BUST!", message: "Bust, no points deducted. Better luck next time.", preferredStyle: .alert)
            // when user pressed okay on first alert...
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            // show the  alert with present()
            present(alertController, animated: true)
        }
    }
    
    // function to check if the score the user entered is valid (if it does not make their score < 0, aka checking for a BUST)
    func checkForValidScore(score: Int) -> Bool {
        if turnCount % 2 == 0 {
            if player2.score - score < 0 {
                return false
            } else {
                return true
            }
        } else {
            if player1.score - score < 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    // function to update all the labels every turn
    func updateLabels() {
        player1ScoreLabel.text = "\(player1.score)"
        player2ScoreLabel.text = "\(player2.score)"
        
        if turnCount % 2 == 0 {
            playerTurnLabel.text = "\(player2.name)'s turn"
        } else {
            playerTurnLabel.text = "\(player1.name)'s turn"
        }
    }
    
    // function to check if a user has one by seeing if their score is 0
    func checkForWin() {
        if player1.score == 0 {
            let alertController = UIAlertController(title: "\(player1.name) Wins!", message: "\(player1.name) has won! Sorry, \(player2.name). You only lost by \(player2.score) points!", preferredStyle: .alert)
            // when user pressed okay on first alert...
            alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action -> Void in
                self.resetGame()
            }))
            // show the  alert with present()
            present(alertController, animated: true)
        } else if player2.score == 0 {
            let alertController = UIAlertController(title: "\(player2.name) Wins!", message: "\(player2.name) has won! Sorry, \(player1.name). You only lost by \(player1.score) points!", preferredStyle: .alert)
            // when user pressed okay on first alert...
            alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action -> Void in
                self.resetGame()
            }))
            // show the  alert with present()
            present(alertController, animated: true)
        }
    }
    
    // function to reset the game
    func resetGame() {
        player1.name = ""
        player2.name = ""
        player1.score = 501;
        player2.score = 501;
        player1ScoreLabel.text = "\(player1.score)";
        player2ScoreLabel.text = "\(player2.score)";
        turnScoreTextField.text = ""
        turnCount = 1;

        promptForPlayerNames()
    }
}
