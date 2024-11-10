//
//  HighScoresViewController.swift
//  ProjectApp2
//
//  Created by Shailesh Srigiri on 11/10/24.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var highScoresTableView: UITableView!
    var highScores: [(name: String, score: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        highScoresTableView.dataSource = self
        highScoresTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HighScoreCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath)
        let highScore = highScores[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(highScore.name): \(highScore.score)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = .darkGray
        return cell
    }
}
