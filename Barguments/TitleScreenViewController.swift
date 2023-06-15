//
//  ViewController.swift
//  Barguments
//
//  Created by Brian Foley on 6/11/23.
//
import UIKit

class TitleScreenViewController: UIViewController {
    // UI Elements
    var titleLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: "CarnivaleeFreakshow", size: 36)
        label.font = customFont
        label.text = "Barguments"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView(frame: UIScreen.main.bounds)
        iv.image = UIImage(named: "portrait_bg")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let overlayView: UIView = {
        let overlay = UIView(frame: UIScreen.main.bounds)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return overlay
    }()
    
    private var player1TextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Player1"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var player2TextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Player2"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var judgeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Judge"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var startButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("Start", for: .normal)
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Change these values to your needs
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1 // This will set the border width to 1
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var rulesButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("How To Play", for: .normal)
        btn.addTarget(self, action: #selector(presentRules), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Change these values to your needs
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1 // This will set the border width to 1
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add tap gesture recognizer to the view
       let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tap)

        // Add elements to the view
        view.addSubview(backgroundImage)
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(player1TextField)
        view.addSubview(player2TextField)
        view.addSubview(judgeTextField)
        view.addSubview(startButton)
        view.addSubview(rulesButton)

        // Apply constraints
        NSLayoutConstraint.activate([
            
          backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
          backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
          backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            // titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // player1TextField
            player1TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            player1TextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            player1TextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            player1TextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // player2TextField
            player2TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            player2TextField.topAnchor.constraint(equalTo: player1TextField.bottomAnchor, constant: 20),
            player2TextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            player2TextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // judgeTextField
            judgeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            judgeTextField.topAnchor.constraint(equalTo: player2TextField.bottomAnchor, constant: 20),
            judgeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            judgeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // startButton
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: judgeTextField.bottomAnchor, constant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            
            rulesButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            rulesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    // Button action
    @objc func startButtonTapped() {
        guard let player1 = player1TextField.text, !player1.isEmpty, player1.count >= 3, player1.count <= 12 else {
            showAlert(title: "Invalid Input", message: "Player 1 name should be between 3 and 12 characters and cannot be empty")
                return
            }
            
            guard let player2 = player2TextField.text, !player2.isEmpty, player2.count >= 3, player2.count <= 12 else {
                print("Player 2 name should be between 3 and 12 characters")
                showAlert(title: "Invalid Input", message: "Player 2 name should be between 3 and 15 characters and cannot be empty")
                return
            }
            
            guard player1 != player2 else {
                print("Player 1 and Player 2 names cannot be the same")
                showAlert(title: "Invalid Input", message: "Player 1 and Player 2 names cannot be the same")
                return
            }

            guard let judge = judgeTextField.text, !judge.isEmpty, judge.count >= 3, judge.count <= 12 else {
                print("Judge name should be between 3 and 12 characters")
                showAlert(title: "Invalid Input", message: "Judge name should be between 3 and 15 characters and cannot be empty")
                return
            }
            
            guard player1 != judge, player2 != judge else {
                print("Judge cannot be one of the players")
                showAlert(title: "Invalid Input", message: "Judge cannot be one of the players names")
                return
            }
        // Handle start button tap here
        let vc = BargumentSelectionViewController()
        vc.player1 = player1TextField.text
        vc.player2 = player2TextField.text
        vc.judge = judgeTextField.text
        player1TextField.text = ""
        player2TextField.text = ""
        judgeTextField.text = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentRules() {
        let rulesVC = RulesViewController()
        self.present(rulesVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

