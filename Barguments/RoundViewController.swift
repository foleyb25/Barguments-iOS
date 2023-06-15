//
//  RoundOneViewController.swift
//  Barguments
//
//  Created by Brian Foley on 6/13/23.
//

import UIKit
import AVFoundation

struct GameRound {
    let title: String
    let duration: TimeInterval
    let rules: String
    let playerUp: String
}

protocol RoundViewControllerDelegate: AnyObject {
    func roundViewControllerDidFinish(_ controller: RoundViewController, player1Score: Int, player2Score: Int)
    func roundViewControllerDidEndGame(_ controller: RoundViewController)
}

class RoundViewController: UIViewController {
    
    weak var delegate: RoundViewControllerDelegate?

        private let gameRound: GameRound
        private var timer: Timer?
    
        
        init(gameRound: GameRound) {
            self.gameRound = gameRound
            super.init(nibName: nil, bundle: nil)
            
            let minutes = Int(gameRound.duration) / 60
            let seconds = Int(gameRound.duration) % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    var incrementPlayer: AVAudioPlayer?
    var decrementPlayer: AVAudioPlayer?
    
    public var player1Counter: Int = 0
    public var player2Counter: Int = 0
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            let customFont = UIFont(name: "CarnivaleeFreakshow", size: 30)
            label.font = customFont
            label.text = "Round 1 - Opening Barguments"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let playerUpLabel: UILabel = {
            let label = UILabel()
            label.text = "Player Up"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private lazy var settingsButton: UIButton = {
        let btn = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "flag", withConfiguration: configuration)
        btn.setImage(image, for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

        public let player1Label: PaddingLabel = {
            let label = PaddingLabel()
            label.text = "Player 1"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        public let player2Label: PaddingLabel = {
            let label = PaddingLabel()
            label.text = "Player 2"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        public let player1CounterLabel: UILabel = {
            let label = UILabel()
            label.text = "0"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        public let player2CounterLabel: UILabel = {
            let label = UILabel()
            label.text = "0"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private lazy var timerLabel: UILabel = {
            let label = UILabel()
            label.text = "0:00"
            label.font = UIFont.boldSystemFont(ofSize: 40)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let upperLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let upperRightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let lowerLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let lowerRightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let ULplusImageView: UIImageView = {
        //Upper Left Image
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus.circle")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let URplusImageView: UIImageView = {
        // Upper Right Image
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus.circle")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let LLminusImageView: UIImageView = {
        //Lower Left Image
        let iv = UIImageView()
        iv.image = UIImage(systemName: "minus.circle")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let LRminusImageView: UIImageView = {
        //Lower Right Image
        let iv = UIImageView()
        iv.image = UIImage(systemName: "minus.circle")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    public let bargumentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 17) // Adjust size as needed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "plus_FX", ofType: "m4a") {
            do {
                incrementPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                incrementPlayer?.prepareToPlay() // Add this line
            } catch {
                // Handle the error here
            }
        }
        
        if let path = Bundle.main.path(forResource: "minus_FX", ofType: "m4a") {
            do {
                decrementPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                decrementPlayer?.prepareToPlay() // Add this line
            } catch {
                // Handle the error here
            }
        }
        
        highlightPlayerBorder(playerUp: gameRound.playerUp)
        
        // Configure your views here
        // Set the title label to the game round's title
        titleLabel.text = gameRound.title
        playerUpLabel.text = "\(gameRound.playerUp)'s Turn"
        
        view.backgroundColor = .white
        
        // Adding views to the main view
        view.addSubview(titleLabel)
        view.addSubview(playerUpLabel)
        view.addSubview(player1Label)
        view.addSubview(player2Label)
        view.addSubview(player1CounterLabel)
        view.addSubview(player2CounterLabel)
        view.addSubview(timerLabel)
        view.addSubview(bargumentLabel)
        view.addSubview(settingsButton)
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        let ULtap = UITapGestureRecognizer(target: self, action: #selector(handleUpperLeftTap))
        upperLeftView.addGestureRecognizer(ULtap)
        view.addSubview(upperLeftView)
        
        let URtap = UITapGestureRecognizer(target: self, action: #selector(handleUpperRightTap))
        upperRightView.addGestureRecognizer(URtap)
        view.addSubview(upperRightView)
        
        let LLtap = UITapGestureRecognizer(target: self, action: #selector(handleLowerLeftTap))
        lowerLeftView.addGestureRecognizer(LLtap)
        view.addSubview(lowerLeftView)
        
        let LRtap = UITapGestureRecognizer(target: self, action: #selector(handleLowerRightTap))
        lowerRightView.addGestureRecognizer(LRtap)
        view.addSubview(lowerRightView)
        
        upperLeftView.addSubview(ULplusImageView)
        upperRightView.addSubview(URplusImageView)
        lowerLeftView.addSubview(LLminusImageView)
        lowerRightView.addSubview(LRminusImageView)
        
        // Setting up constraints
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            startTimer()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            timer?.invalidate()
            timer = nil
        }

    private func setupConstraints() {
        // Add constraints code here...
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
        playerUpLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        playerUpLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            player1Label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            player1Label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            player2Label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            player2Label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        player1CounterLabel.leftAnchor.constraint(equalTo: player1Label.rightAnchor, constant: 10),
            player1CounterLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        
        player2CounterLabel.rightAnchor.constraint(equalTo: player2Label.leftAnchor, constant: -10),
            player2CounterLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            timerLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            settingsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        settingsButton.bottomAnchor.constraint(equalTo: timerLabel.topAnchor),
        settingsButton.widthAnchor.constraint(equalToConstant: 30),
        settingsButton.heightAnchor.constraint(equalToConstant: 30),
            
            upperLeftView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            upperLeftView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            upperLeftView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            upperLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            
            upperRightView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            upperRightView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            upperRightView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            upperRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        
            lowerLeftView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            lowerLeftView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            lowerLeftView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            lowerLeftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            lowerRightView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            lowerRightView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            lowerRightView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            lowerRightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ULplusImageView.widthAnchor.constraint(equalToConstant: 50),
        ULplusImageView.heightAnchor.constraint(equalToConstant: 50),
        ULplusImageView.centerXAnchor.constraint(equalTo: upperLeftView.centerXAnchor, constant: -40),
        ULplusImageView.centerYAnchor.constraint(equalTo: upperLeftView.centerYAnchor),
            
        URplusImageView.widthAnchor.constraint(equalToConstant: 50),
        URplusImageView.heightAnchor.constraint(equalToConstant: 50),
        URplusImageView.centerXAnchor.constraint(equalTo: upperRightView.centerXAnchor, constant: 40),
        URplusImageView.centerYAnchor.constraint(equalTo: upperRightView.centerYAnchor),
            
        LLminusImageView.widthAnchor.constraint(equalToConstant: 50),
        LLminusImageView.heightAnchor.constraint(equalToConstant: 50),
        LLminusImageView.centerXAnchor.constraint(equalTo: lowerLeftView.centerXAnchor, constant: -40),
        LLminusImageView.centerYAnchor.constraint(equalTo: lowerLeftView.centerYAnchor),
            
        LRminusImageView.widthAnchor.constraint(equalToConstant: 50),
        LRminusImageView.heightAnchor.constraint(equalToConstant: 50),
        LRminusImageView.centerXAnchor.constraint(equalTo: lowerRightView.centerXAnchor, constant: 40),
        LRminusImageView.centerYAnchor.constraint(equalTo: lowerRightView.centerYAnchor),
            
            bargumentLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            bargumentLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            bargumentLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bargumentLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        
        ])
        
    }
    
    private func finishRound() {
        let player1Score = Int(player1CounterLabel.text!) ?? 0
        let player2Score = Int(player2CounterLabel.text!) ?? 0
        dismiss(animated: true) { [weak self] in
            self?.delegate?.roundViewControllerDidFinish(self!, player1Score: player1Score, player2Score: player2Score)
        }
        
        }
    
    func playIncrementSound() {
        if let player = incrementPlayer {
            if player.isPlaying {
                player.stop()
                player.currentTime = 0
            }
            player.play()
        }
    }
    
    func playDecrementSound() {
        if let player = decrementPlayer {
            if player.isPlaying {
                player.stop()
                player.currentTime = 0
            }
            player.play()
        }
    }
    
    private func startTimer() {
        let endTime = Date().addingTimeInterval(gameRound.duration)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            let remainingTime = endTime.timeIntervalSince(Date())
            if remainingTime <= 0 {
                self?.timer?.invalidate()
                self?.timer = nil
                self?.timerLabel.text = "00:00"
                self?.finishRound()
            } else {
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                self?.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }

    
    func highlightPlayerBorder(playerUp: String) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.5 // Specify the desired duration of the animation

        if player1Label.text == playerUp {
            player1Label.layer.add(transition, forKey: nil)
            let goldBeerColor = UIColor(red: 204/255, green: 166/255, blue: 62/255, alpha: 1)
            player1Label.layer.borderWidth = 1
            player1Label.layer.borderColor = goldBeerColor.cgColor
            player1Label.layer.cornerRadius = 10
            
            player2Label.layer.add(transition, forKey: nil)
            player2Label.layer.borderColor = UIColor.clear.cgColor
        } else {
            player2Label.layer.add(transition, forKey: nil)
            let goldBeerColor = UIColor(red: 204/255, green: 166/255, blue: 62/255, alpha: 1)
            player2Label.layer.borderWidth = 1
            player2Label.layer.borderColor = goldBeerColor.cgColor
            player2Label.layer.cornerRadius = 10

            player1Label.layer.add(transition, forKey: nil)
            player1Label.layer.borderColor = UIColor.clear.cgColor
        }
    }

    func setLabels(player1: String, player2: String) {
        self.player1Label.text = player1
        self.player2Label.text = player2
    }
    
    @objc func settingsButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let endGameAction = UIAlertAction(title: "End Game", style: .destructive) { [weak self] _ in
            // Your code here for ending the game
            self?.dismiss(animated: true) {
            // After the dismissal completes, pop to the root of the navigation controller
                self?.delegate?.roundViewControllerDidEndGame(self!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(endGameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc func handleUpperLeftTap() {
        playIncrementSound()
        // Increment the counter
        player1Counter += 1
        // Update the label
        player1CounterLabel.text = String(player1Counter)
    }
    
    @objc func handleUpperRightTap() {
        // Increment the counter
        playIncrementSound()
        player2Counter += 1
        // Update the label
        player2CounterLabel.text = String(player2Counter)
    }
    
    @objc func handleLowerLeftTap() {
        // Increment the counter
        playDecrementSound()
        player1Counter -= 1
        // Update the label
        player1CounterLabel.text = String(player1Counter)
    }
    
    @objc func handleLowerRightTap() {
        // Increment the counter
        playDecrementSound()
        player2Counter -= 1
        // Update the label
        player2CounterLabel.text = String(player2Counter)
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

