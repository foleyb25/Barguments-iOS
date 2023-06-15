//
//  BargumentCollectionViewCell.swift
//  Barguments
//
//  Created by Brian Foley on 6/12/23.
//

import UIKit

protocol BargumentCollectionViewCellDelegate: AnyObject {
    func didTapLeftButton(inCell cell: BargumentCollectionViewCell)
    func didTapRightButton(inCell cell: BargumentCollectionViewCell)
}

class BargumentCollectionViewCell: UICollectionViewCell {
    static let identifier = "BargumentCell"
    
    weak var delegate: BargumentCollectionViewCellDelegate?
    
    public let bargumentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
        public let bargumentLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let leftButton: UIButton = {
           let button = UIButton()
           button.setTitle("<", for: .normal)
           button.setTitleColor(.black, for: .normal) // Change this to your desired color
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()

       private let rightButton: UIButton = {
           let button = UIButton()
           button.setTitle(">", for: .normal)
           button.setTitleColor(.black, for: .normal) // Change this to your desired color
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            leftButton.addTarget(self, action: #selector(handleLeftButtonTap), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(handleRightButtonTap), for: .touchUpInside)

            
            contentView.addSubview(bargumentView)
            bargumentView.addSubview(bargumentLabel)
            contentView.addSubview(rightButton)
            contentView.addSubview(leftButton)
            NSLayoutConstraint.activate([
                bargumentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                bargumentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                bargumentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
                bargumentView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                
                bargumentLabel.centerXAnchor.constraint(equalTo: bargumentView.centerXAnchor),
                bargumentLabel.centerYAnchor.constraint(equalTo: bargumentView.centerYAnchor),
                bargumentLabel.widthAnchor.constraint(equalTo: bargumentView.widthAnchor, constant: -10),
                bargumentLabel.heightAnchor.constraint(equalTo: bargumentView.heightAnchor, constant: -10),
                
                leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                leftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startBouncingAnimation(button: leftButton, direction: 0)
        startBouncingAnimation(button: rightButton, direction: 1)
    }
    
    func setButtonVisibility(isVisible: Bool) {
        self.leftButton.isHidden = !isVisible
        self.rightButton.isHidden = !isVisible
    }
        
    func configure(with bargument: String, color: UIColor)  {
            bargumentLabel.text = bargument
            bargumentView.backgroundColor = color
        }
    
    func startBouncingAnimation(button: UIButton, direction: Int) {
        //Int 0 = left Int 1 = right
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.75
            animation.fromValue = 0
        animation.toValue = (direction == 0) ? -10 : 10
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            button.layer.add(animation, forKey: "bouncing")
    }
    
    @objc private func handleLeftButtonTap() {
       delegate?.didTapLeftButton(inCell: self)
   }
       
   @objc private func handleRightButtonTap() {
       delegate?.didTapRightButton(inCell: self)
   }
    
    }
