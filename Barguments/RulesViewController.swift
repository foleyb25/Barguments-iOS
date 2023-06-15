//
//  RulesViewController.swift
//  Barguments
//
//  Created by Brian Foley on 6/14/23.
//

import UIKit

class RulesViewController: UIViewController {
    
    //1. Create a UITextView to hold the rules
    private lazy var rulesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = """
        Welcome to Barguments, the game of wits, fun, and friendly disputes. Here's a step-by-step guide on how to play this thrilling game:

        1. Choosing the Judge and Players:
        Begin by appointing a judge, who will be the scorekeeper for the game. The remaining participants will be divided into two roles, let's call them Player 1 and Player 2 for the ease of understanding.

        2. Setting Up:
        The game consists of three rounds - 'Opening Barguments', 'Rebuttals', and 'Closing Barguments'. Each round comes with its unique set of rules and goals that participants must adhere to. These rounds are intended to present arguments or rather, "barguments," refute your opponent, and finally, make a lasting impression.

        3. Round 1 - Opening Barguments:
        Player 1 starts by choosing a topic they want to 'bargue' for or against. They announce this topic to everyone, and this position must be maintained for the entire game. Player 1 then has 1 minute to deliver the best bargument possible. The judge adjusts the score based on the quality of the bargument and can deduct points for speaking out of turn.

        4. Round 2 - Rebuttals:
        After both players have presented their opening barguments, we move on to rebuttals. Player 1 will be the first to rebut. In this round, each player is given 1 minute and 30 seconds to refute their opponent's claims and strengthen their own position. The judge continues to keep score based on the effectiveness of the rebuttal and can adjust the score accordingly.

        5. Round 3 - Closing Barguments:
        In the final round, each player will have 30 seconds to make a closing bargument. This is the opportunity to wrap up your stance, challenge your opponent's claims one last time, strengthen your bargument, and leave a lasting impression on the judge.

        6. Winner Announcement:
        After the closing barguments, the judge tallies the scores. The player with the highest score is declared the winner of Barguments!

        7. Rules to Remember:
        Remember, the judge can adjust points based on the quality of the barguments, any rules violations, or any other criteria the judge deems necessary. The judge's decisions are final.

        So, gear up and get ready to make your bargument count! Enjoy the thrill of debating and may the best 'barguer' win!
        """
        return textView
    }()
    
    private lazy var closeButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Close", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1 // This will set the border width to 1
            button.tintColor = .black
            button.layer.borderColor = UIColor.black.cgColor
            button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 2. Set up the view
        view.backgroundColor = .systemBackground
        view.addSubview(rulesTextView)
        view.addSubview(closeButton)
               
       // Set up the constraints
       NSLayoutConstraint.activate([
           rulesTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           rulesTextView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -10),
           rulesTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           rulesTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           
           closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
           closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           closeButton.heightAnchor.constraint(equalToConstant: 50),
           closeButton.widthAnchor.constraint(equalTo: view.widthAnchor)
       ])
    }
    
    @objc func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
}
