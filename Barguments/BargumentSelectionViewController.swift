import UIKit

class BargumentSelectionViewController: UIViewController {
    
    var player1: String?
    var player2: String?
    var judge: String?
    var currentBargument: String?
    
    private var hasInitialScrollPositionBeenSet = false

    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bargument Selection"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "CarnivaleeFreakshow", size: 36)
        lbl.font = customFont
        return lbl
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next >", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1 // This will set the border width to 1
        btn.tintColor = .label  // use dynamic system color
        btn.layer.borderColor = UIColor.label.cgColor  // use dynamic system color
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Change these values to your needs
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()
    
    private lazy var randomizeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Randomize", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1 // This will set the border width to 1
        btn.tintColor = .label  // use dynamic system color
        btn.layer.borderColor = UIColor.label.cgColor  // use dynamic system color
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Change these values to your needs
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = BargumentCollectionViewLayout()

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isHidden = true
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BargumentCollectionViewCell.self, forCellWithReuseIdentifier: BargumentCollectionViewCell.identifier)
        cv.dataSource = self
        cv.delegate = self

        return cv
    }()

    
    var barguments = Barguments.list.shuffled()
    var currentBargumentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(nextButton)
        view.addSubview(randomizeButton)
        
        nextButton.addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside)
        randomizeButton.addTarget(self, action: #selector(randomizeTapped), for: .touchUpInside)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
           collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            randomizeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            randomizeButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor)
           
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Initial scroll position only needs to be set once,
        // so we check if it's already been done.
        guard !hasInitialScrollPositionBeenSet else { return }
        
        if let centerCellPath = self.collectionView.centerCellIndex {
            self.collectionView.scrollToItem(at: centerCellPath, at: .centeredHorizontally, animated: false)
        }
        
        hasInitialScrollPositionBeenSet = true
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            // Show the collection view once the transition is complete
            self.collectionView.isHidden = false
            self.nextButton.isHidden = false
            self.randomizeButton.isHidden = false
        }

        coordinator.animate(alongsideTransition: { (context) in
            // Nothing needed here.
        }, completion: { (context) in
            if let indexPath = self.collectionView.centerCellIndex {
                // Recenter on the cell
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        })
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    @objc func randomizeTapped() {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        // Guard against empty collection views
        guard numberOfItems > 0 else { return }
        
        let randomIndex = Int(arc4random_uniform(UInt32(numberOfItems)))
        let randomIndexPath = IndexPath(item: randomIndex, section: 0)
        
        collectionView.scrollToItem(at: randomIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    // Button action
    @objc func letsGoButtonTapped() {
        let visibleItems = self.collectionView.indexPathsForVisibleItems
        let currentItem = visibleItems.first
        
        // Handle start button tap here
        let vc = PlayerSelectionViewController()
        vc.player1 = self.player1
        vc.player2 = self.player2
        vc.judge = self.judge
        if let currentItem = currentItem {
            vc.currentBargument = barguments[currentItem.row]
        }
        vc.setPlayerNames(player1: self.player1!, player2: self.player2!)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BargumentSelectionViewController: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, BargumentCollectionViewCellDelegate {
    
    func didTapLeftButton(inCell cell: BargumentCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let newIndexPath = IndexPath(item: max(0, indexPath.item - 1), section: indexPath.section)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }

    func didTapRightButton(inCell cell: BargumentCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let newIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barguments.count // Large number to simulate infinity
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BargumentCollectionViewCell.identifier, for: indexPath) as! BargumentCollectionViewCell
        cell.delegate = self
        let bargument = barguments[indexPath.row % barguments.count]
        let color = UIColor(red: .random(in: 0.7...1), green: .random(in: 0.7...1), blue: .random(in: 0.7...1), alpha: 1)
        cell.configure(with: bargument, color: color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return collectionView.frame.size.width / 2
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let middle = (barguments.count) / 2
            collectionView.scrollToItem(at: IndexPath(item: middle, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
}

extension UICollectionView {
    var centerCellIndex: IndexPath? {
        let centerPoint = CGPoint(x: bounds.midX + contentOffset.x, y: bounds.midY + contentOffset.y)
        return indexPathForItem(at: centerPoint)
    }
}

