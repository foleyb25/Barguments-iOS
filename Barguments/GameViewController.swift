//
//  GameViewController.swift
//  Barguments
//
//  Created by Brian Foley on 6/13/23.
//

import UIKit

class GameViewController: UIViewController {
    
    public var player1: String = ""
    public var player2: String = ""
    public var judge: String = ""
    public var goesFirst: String = ""
    public var goesSecond: String = ""
    public var currentTopic: String = ""
    private var currentRoundIndex = 0
    public var player1TotalScore: Int = 0
    public var player2TotalScore: Int = 0
    
    var rounds: [GameRound] {
        return [
            GameRound(title: "Round 1 - Opening Barguments", duration: 60, rules: """
            Top of Round 1 - Opening Barguments.

            \(goesFirst) will start this round.

            \(goesFirst) should now choose the bargument they wish to bargue for or against, and announce their choice to everyone. It's important to remember that once chosen, this position must be maintained for the entirety of the game.

            \(goesFirst) will have 1 minute to present the best bargument possible. The judge, \(judge), is the scorekeeper and has the authority to adjust the score based on the quality of the bargument.

            \(judge) may deduct points for speaking out of turn in order to maintain law and order during the barguments. (They may also add points for speaking out of turn if chaos is \(judge)'s thing).

            Start to formulate your bargument now. When ready, the judge will press the play button located below. Good luck, and let's get ready to bargue.
            """, playerUp: goesFirst),
            
            GameRound(title: "Round 1 - Opening Barguments", duration: 60, rules: """
            Bottom of Round 1 - Opening Barguments.

            \(goesSecond) will now give their opposing bargument.

            \(goesSecond) must bargue against the bargument \(goesFirst) made, no matter how strongly they may agree with them.

            \(goesSecond) will be given 1 minute to provide they best bargument possible. The judge is the scorekeeper and can adjust the score based on what he/she thinks is a good (or bad) bargument.

            Once you are ready, the judge will press the play button located below. Good luck, and may the best bargument prevail.
            """, playerUp: goesSecond),

            GameRound(title: "Round 2 - Rebuttal", duration: 90, rules: """
                Top of Round 2 - Rebuttals.

                Now that we've heard the opening barguments, it's time for rebuttals.

                Each player will be given 1 minute and 30 seconds to refute their opponent's claims, evidence, and strengthen their own position. This is your chance to poke holes in your opponent's bargument and further solidify your stance.

                \(goesFirst), you will be the first to rebut. Remember, the judge, \(judge), will continue to keep score based on the effectiveness of your rebuttal.

                Begin formulating your rebuttal now. When you're ready, the judge will press the play button located below. Use this opportunity wisely, every point counts.
                """, playerUp: goesFirst),

            GameRound(title: "Round 2 - Rebuttal", duration: 90, rules: """
                Bottom of Round 2 - Rebuttals.

                We've heard the first round of rebuttals and now, the stage is set for \(goesSecond) to counter-bargue.

                \(goesSecond), it's now your time to shine. You will be given 1 minute and 30 seconds to counter your opponent's barguments, rebut their claims, and bolster your position. This is your opportunity to unravel the barguments of your rival and fortify your stance.

                Do remember, \(judge), the adjudicator, will be marking your performance, so appease them and buy them a drink if that's what it takes.

                Start preparing your counter-bargument now. When you are set, the judge will tap the play button below. Remember, every well-crafted rebuttal can tip the scales in your favor.
                """, playerUp: goesSecond),
            GameRound(title: "Round 3 - Closing Barguments", duration: 30, rules: """
                Top of Round 3 - Closing Barguments.

                We have reached the final stretch. \(goesFirst), it's your turn again.

                Now is the time to wrap up your stance, capture the spirit of your bargument, and captivate the heart and mind of the judge, \(judge). You have 30 seconds to make your closing bargument. Every second counts.

                This is not only your final chance to challenge your opponent's claims but also your opportunity to strengthen your own. Bring out your most persuasive points, emphasize your key barguments, and leave a lasting impression on \(judge).

                \(judge), as always, will be keeping an eye out for any violations and adjusting the score accordingly.

                When you are ready, \(judge) will press the play button. This is your moment, make it count.
                """, playerUp: goesFirst),
            GameRound(title: "Round 3 - Closing Barguments", duration: 30, rules: """
                Bottom of Round 3 - Closing Barguments.

                We have reached the final moment. \(goesSecond), it's your turn now.

                This is your last chance to sway the opinion of the judge, \(judge), and win this game. You have 30 seconds to conclude your bargument, challenge \(goesFirst)'s points and reinforce your stance. Don't hold back, every point matters.

                When you're ready, \(judge) will hit the play button. This is the moment to bring everything together and deliver a compelling closing bargument.
                """, playerUp: goesSecond),
        ]
    }
    
    private let topGameStatusBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var player1Status: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(player1) - \(player1TotalScore)"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var player2Status: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(player2) - \(player2TotalScore)"
        label.textAlignment = .center
        return label
    }()
    
    private let rulesTextView: UITextView = {
            let textView = UITextView()
            textView.isEditable = false
            textView.isScrollEnabled = true
            textView.font = UIFont.systemFont(ofSize: 17)
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        }()
    
    private let startButton: UIButton = {
        let btn = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "play", withConfiguration: configuration)
        btn.setImage(image, for: .normal)
         btn.tintColor = .label
         return btn
    }()
    
    private let settingsButton: UIButton = {
        let btn = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "flag", withConfiguration: configuration)
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let zoomOutButton: UIButton = {
       let btn = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "minus.magnifyingglass", withConfiguration: configuration)
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let zoomInButton: UIButton = {
       let btn = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.magnifyingglass", withConfiguration: configuration)
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private lazy var bottomButtonBar: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [settingsButton, zoomOutButton, zoomInButton, startButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(topGameStatusBarView)
        topGameStatusBarView.addSubview(player1Status)
        topGameStatusBarView.addSubview(player2Status)
        view.addSubview(startButton)
        view.addSubview(settingsButton)
        view.addSubview(bottomButtonBar)
        view.addSubview(rulesTextView)
        bottomButtonBar.addSubview(startButton)
        bottomButtonBar.addSubview(settingsButton)
        bottomButtonBar.addSubview(zoomOutButton)
        bottomButtonBar.addSubview(zoomInButton)
        
        startButton.addTarget(self, action: #selector(startNextRound), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)


        // Call this to set the rules for the first round.
        updateRules()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            bottomButtonBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), // Padding to the left side of the screen
            bottomButtonBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4), // Padding to the right side of the screen
            bottomButtonBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10), // Padding to the bottom of the screen
            bottomButtonBar.heightAnchor.constraint(equalToConstant: 40),
            
            topGameStatusBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topGameStatusBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topGameStatusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topGameStatusBarView.heightAnchor.constraint(equalToConstant: 40),
            
            player1Status.topAnchor.constraint(equalTo: topGameStatusBarView.topAnchor),
            player1Status.bottomAnchor.constraint(equalTo: topGameStatusBarView.bottomAnchor),  // Add this line
            player1Status.widthAnchor.constraint(equalTo: topGameStatusBarView.widthAnchor, multiplier: 0.5),
            player1Status.leftAnchor.constraint(equalTo: topGameStatusBarView.leftAnchor),

            player2Status.topAnchor.constraint(equalTo: topGameStatusBarView.topAnchor),
            player2Status.bottomAnchor.constraint(equalTo: topGameStatusBarView.bottomAnchor),  // Add this line
            player2Status.widthAnchor.constraint(equalTo: topGameStatusBarView.widthAnchor, multiplier: 0.5),
            player2Status.rightAnchor.constraint(equalTo: topGameStatusBarView.rightAnchor),
            
            rulesTextView.topAnchor.constraint(equalTo: topGameStatusBarView.bottomAnchor, constant: 10),
            rulesTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            rulesTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
          rulesTextView.bottomAnchor.constraint(equalTo: bottomButtonBar.topAnchor, constant: -10),

        ])
        
    }
    
    private func updateRules() {
            if currentRoundIndex < rounds.count {
                rulesTextView.text = rounds[currentRoundIndex].rules
            } else {
                // Game is over, perhaps set the text to a final message.
                startNextRound()
            }
        }
    
    @objc func zoomInButtonTapped() {
        let currentFontSize = rulesTextView.font?.pointSize ?? 17.0  // assuming default size is 17 if not set
            if currentFontSize < 26 {
                let newFontSize = currentFontSize + 1.0 // or any value you want to increase by
                rulesTextView.font = UIFont.systemFont(ofSize: newFontSize)
            }
    }
    
    @objc func zoomOutButtonTapped() {
        let currentFontSize = rulesTextView.font?.pointSize ?? 17.0  // assuming default size is 17 if not set
        if currentFontSize > 8 {
            let newFontSize = currentFontSize - 1.0 // or any value you want to increase by
            rulesTextView.font = UIFont.systemFont(ofSize: newFontSize)
        }
    }
    
    @objc func startNextRound() {
        rulesTextView.text = ""
        if currentRoundIndex < rounds.count {
            let roundViewController = RoundViewController(gameRound: rounds[currentRoundIndex])
            roundViewController.delegate = self
            roundViewController.player1Label.text = self.player1
            roundViewController.player2Label.text = self.player2
//            roundViewController.player1CounterLabel.text = String(player1Score)
//            roundViewController.player2CounterLabel.text = String(player2Score)
//            roundViewController.player1Counter = player1Score
//            roundViewController.player2Counter = player2Score
            
            roundViewController.bargumentLabel.text = self.currentTopic
            present(roundViewController, animated: true)
            currentRoundIndex += 1
        } else {
            
            //handleTie:
            if (self.player1TotalScore == self.player2TotalScore) {
                let winnerSelectionVC = WinnerSelectionViewController(player: nil)
                winnerSelectionVC.delegate = self
                present(winnerSelectionVC, animated: true)
                return
            }
            // Game is over, push on final decision controller
            let winner = (self.player1TotalScore > self.player2TotalScore) ? Player(name: self.player1, score: player1TotalScore) : Player(name: self.player2, score: player2TotalScore)

            let winnerSelectionVC = WinnerSelectionViewController(player: winner)
            winnerSelectionVC.delegate = self
            present(winnerSelectionVC, animated: true)
        }
    }
    
    public func setLabels(goesFirst: String, goesSecond: String, player1: String, player2: String, judge: String) {
        self.goesFirst = goesFirst
        self.goesSecond = goesSecond
        self.player1 = player1
        self.player2 = player2
        self.judge = judge
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    @objc func settingsButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let endGameAction = UIAlertAction(title: "End Game", style: .destructive) { [weak self] _ in
            // Your code here for ending the game
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(endGameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension GameViewController: RoundViewControllerDelegate, WinnerSelectionViewControllerDelegate {
    func roundViewControllerDidFinish(_ controller: RoundViewController, player1Score: Int, player2Score: Int) {
            self.player1TotalScore += player1Score
            self.player2TotalScore += player2Score
            self.player1Status.text = "\(player1):  \(player1TotalScore)"
            self.player2Status.text = "\(player2):  \(player2TotalScore)"
            self.updateRules()
    }
    
    func roundViewControllerDidEndGame(_ controller: RoundViewController) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    
    func winnerViewControllerDidEndGame(_ controller: WinnerSelectionViewController) {
            self.navigationController?.popToRootViewController(animated: true)
    }
}
