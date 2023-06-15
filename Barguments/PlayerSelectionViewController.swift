import UIKit
import QuartzCore

class PlayerSelectionViewController: UIViewController {
    
    var player1: String?
    var player2: String?
    var judge: String?
    var currentBargument: String?
    
    var goesFirst: String?
    var goesSecond: String?
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        let customFont = UIFont(name: "CarnivaleeFreakshow", size: 36)
        label.font = customFont
        label.textAlignment = .center
        label.text = "Player Selection"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let player1Label: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let player2Label: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let arrowImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "arrow.down")
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
         btn.setTitle("Next >", for: .normal)
         btn.layer.cornerRadius = 10
         btn.layer.borderWidth = 1 // This will set the border width to 1
         btn.tintColor = .black
         btn.layer.borderColor = UIColor.black.cgColor
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Change these values to your needs
         btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
         return btn
    }()
    
    public lazy var bargumentLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont.italicSystemFont(ofSize: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(player1Label)
        view.addSubview(player2Label)
        view.addSubview(arrowImageView)
        view.addSubview(nextButton)
        view.addSubview(bargumentLabel)
        
        setupConstraints()
        
        bargumentLabel.text = self.currentBargument!
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        spinArrow()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            player1Label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            player1Label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            player2Label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            player2Label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            arrowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 100),  // Set width
            arrowImageView.heightAnchor.constraint(equalToConstant: 100), // Set height
            
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            bargumentLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            bargumentLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            bargumentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bargumentLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
            ])
        
    }

    func setPlayerNames(player1: String, player2: String) {
        player1Label.text = player1
        player2Label.text = player2
    }

    func spinArrow() {
        // Randomly select a player: 0 for Player 1, 1 for Player 2
            let selectedPlayer = Int.random(in: 0...1)

            // Determine the rotation angle based on the selected player
        let finalRotationAngle: CGFloat = selectedPlayer == 0 ? .pi / 2 : 3 * .pi / 2

            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            // Set the animation properties
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = finalRotationAngle + (10 * .pi)
            rotationAnimation.duration = 2
            rotationAnimation.fillMode = .forwards
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // Here's the ease-in-ease-out effect

        // Begin a new transaction
            CATransaction.begin()

            // Set the completion block for the transaction
            CATransaction.setCompletionBlock {
                // Highlight the border of the selected player
                self.nextButton.isHidden = false
                self.highlightPlayerBorder(playerNumber: selectedPlayer + 1)
            }

            // Add the animation to the arrow
            arrowImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")

            // Commit the transaction
            CATransaction.commit()
    }
    
    func highlightPlayerBorder(playerNumber: Int) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.5 // Specify the desired duration of the animation

        if playerNumber == 1 {
            player1Label.layer.add(transition, forKey: nil)
            let goldBeerColor = UIColor(red: 204/255, green: 166/255, blue: 62/255, alpha: 1)
            player1Label.layer.borderWidth = 1
            player1Label.layer.borderColor = goldBeerColor.cgColor
            player1Label.layer.cornerRadius = 10
            goesFirst = player1Label.text
            goesSecond = player2Label.text
            
            player2Label.layer.add(transition, forKey: nil)
            player2Label.layer.borderColor = UIColor.clear.cgColor
        } else {
            player2Label.layer.add(transition, forKey: nil)
            let goldBeerColor = UIColor(red: 204/255, green: 166/255, blue: 62/255, alpha: 1)
            player2Label.layer.borderWidth = 1
            player2Label.layer.borderColor = goldBeerColor.cgColor
            player2Label.layer.cornerRadius = 10
            goesFirst = player2Label.text
            goesSecond = player1Label.text

            player1Label.layer.add(transition, forKey: nil)
            player1Label.layer.borderColor = UIColor.clear.cgColor
        }
    }

    
    // Button action
    @objc func nextButtonTapped() {
        // Handle start button tap here
        let vc = GameViewController()
        vc.setLabels(goesFirst: self.goesFirst!, goesSecond: self.goesSecond!, player1: self.player1!, player2: self.player2!, judge: self.judge!)
        vc.currentTopic = self.currentBargument!
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
