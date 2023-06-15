import UIKit

struct Player {
    let name: String
    let score: Int
}

protocol WinnerSelectionViewControllerDelegate: AnyObject {
    func winnerViewControllerDidEndGame(_ controller: WinnerSelectionViewController)
}

class WinnerSelectionViewController: UIViewController {
    
    weak var delegate: WinnerSelectionViewControllerDelegate?
    
    var winner: Player?
    
    init(player: Player?) {
        super.init(nibName: nil, bundle: nil)

        if let player = player {
            self.winner = player
            winnerNameLabel.text = player.name
            winnerScoreLabel.text = String(player.score)
            titleLabel.text = "Winner"
        } else {
            self.winner = nil
            winnerNameLabel.text = ""
            winnerScoreLabel.text = ""
            titleLabel.text = "Tie"
        }
    }


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 30)
        label.text = "Winner!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
        private let winnerNameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.italicSystemFont(ofSize: 30)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
        private let winnerScoreLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private lazy var endGameButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("End Game", for: .normal)
        btn.addTarget(self, action: #selector(endGameTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1 // This will set the border width to 1
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Change these values to your needs
        btn.layer.borderColor = UIColor.black.cgColor
        btn.backgroundColor = UIColor(red: 204/255, green: 166/255, blue: 62/255, alpha: 1)
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(winnerNameLabel)
        view.addSubview(winnerScoreLabel)
        view.addSubview(endGameButton)
        
        setupConstraints()
    }
    
    
    
    func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            
            winnerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            winnerNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: winnerNameLabel.topAnchor, constant: -50),
            
            winnerScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            winnerScoreLabel.topAnchor.constraint(equalTo: winnerNameLabel.bottomAnchor, constant: 20),
            
            endGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endGameButton.topAnchor.constraint(equalTo: winnerScoreLabel.bottomAnchor, constant: 30)
        ])
    }
    
    @objc func endGameTapped() {
        
        dismiss(animated: true) {
        // After the dismissal completes, pop to the root of the navigation controller
            self.delegate!.winnerViewControllerDidEndGame(self)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
}
