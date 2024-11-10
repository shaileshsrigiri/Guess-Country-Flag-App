//
//  ViewController.swift
//  ProjectApp2
//
//  Created by Shailesh Srigiri on 11/9/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet weak var playerInfoLabel: UILabel!
    @IBOutlet weak var guessLabel: UILabel!
    
    var countries = [String]()
    var score = 0 {
        didSet {
            updatePlayerInfoLabel()
        }
    }
    var correctAnswer = 0
    var questionsAsked = 0
    let totalQuestions = 10
    var playerName: String = ""
    var highScores: [(name: String, score: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        setupNavigationBar()
        promptForPlayerName()
    }
    
    func promptForPlayerName() {
        let ac = UIAlertController(title: "Enter Player Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Start Game", style: .default) { [weak self, weak ac] _ in
            guard let playerName = ac?.textFields?[0].text, !playerName.isEmpty else { return }
            self?.playerName = playerName
            self?.score = 0
            self?.questionsAsked = 0
            self?.playerInfoLabel.text = "Player: \(playerName) | Score: 0"
            self?.askQuestions()
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func askQuestions(action: UIAlertAction! = nil) {
        if questionsAsked == totalQuestions {
            showFinalScore()
            return
        }
        
        questionsAsked += 1
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderColor = UIColor.black.cgColor
        
        guessLabel.text = "Which flag belongs to \(countries[correctAnswer].uppercased())?"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag])"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
        present(ac, animated: true)
    }
    
    func showFinalScore() {
        highScores.append((name: playerName, score: score))
        highScores.sort { $0.score > $1.score }
        
        // Display an alert to inform the player about their final score
        let alertController = UIAlertController(
            title: "Game Over",
            message: "You've answered 10 questions. Your final score is \(score).",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.restartGame()
        }))
        alertController.addAction(UIAlertAction(title: "New Player", style: .default, handler: { [weak self] _ in
            self?.resetForNewPlayer()
        }))
        present(alertController, animated: true)
    }


    
    func restartGame() {
        score = 0
        questionsAsked = 0
        askQuestions()
    }
    
    func resetForNewPlayer() {
        score = 0
        questionsAsked = 0
        promptForPlayerName()
    }
    
    func setupNavigationBar() {
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.title = "Flag Quiz"
    }

    @objc func showMenu() {
        let menu = UIAlertController(title: "Menu", message: "Choose an action", preferredStyle: .actionSheet)
        
        menu.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.restartGame()
        }))
        
        menu.addAction(UIAlertAction(title: "New Player", style: .default, handler: { [weak self] _ in
            self?.resetForNewPlayer()
        }))
        
        menu.addAction(UIAlertAction(title: "High Scores", style: .default, handler: { [weak self] _ in
            self?.showHighScoresTapped()
        }))
        
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(menu, animated: true, completion: nil)
    }

    
    @objc func restartGameTapped() {
        restartGame()
    }
    
    @objc func newPlayerTapped() {
        resetForNewPlayer()
    }
    
    @objc func showHighScoresTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let highScoresVC = storyboard.instantiateViewController(withIdentifier: "HighScoresViewController") as? HighScoresViewController {
            highScoresVC.highScores = highScores
            navigationController?.pushViewController(highScoresVC, animated: true)
        }
    }
    
    func updatePlayerInfoLabel() {
        playerInfoLabel.text = "Player: \(playerName) | Score: \(score)"
    }
}
