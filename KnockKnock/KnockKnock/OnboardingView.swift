//
//  OnboardingViewController.swift
//  KnockKnock
//
//  Created by hurdasol on 2022/07/28.
//

import UIKit

class OnboardingController: UIPageViewController {
    let keychainManager = KeychainManager()
    let doorView = DoorViewController()
    var pages = [UIViewController]()

    // external controls
    let pageControl = UIPageControl()
    let initialPage = 0

    let goToRoomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .init(red: 128/255, green: 159/255, blue: 174/255, alpha: 1)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        
        button.setTitle("방에 입장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToRoomButtonTapped), for: .touchUpInside)
       
        return button
    }()
    
    // animations
    var pageControlBottomAnchor: NSLayoutConstraint?
    var buttonWidth: NSLayoutConstraint?
    var buttonHeight: NSLayoutConstraint?
    var buttonBottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "oldUser") is Bool {
            
        } else {
            // 앱을 처음사용 하는 것인지 확인 후 기존의 키체인에 비밀번호가 등록되어 있다면 삭제
            if
                
                keychainManager.deleteItem(key: "passcode") {
                print("기존의 키체인을 삭제 함")
            }
            doorView.modalPresentationStyle = .overFullScreen
            present(doorView, animated: false)
        }
    }
}

extension OnboardingController {
    
    func setup() {
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

        goToRoomButton.addTarget(self, action: #selector(goToRoomButtonTapped), for: .touchUpInside)
        let page1 = OnboardingViewController(imageName: "album",
                                             titleText: "앨범",
                                             subtitleText: "사진을 저장하여\n사랑하는 고인과의\n추억을 꺼내보세요")
        let page2 = OnboardingViewController(imageName: "frame",
                                             titleText: "액자",
                                             subtitleText: "고인의 사진을 꽂아서\n고인의 방을 꾸며주세요")
        let page3 = OnboardingViewController(imageName: "memo",
                                             titleText: "다이어리",
                                             subtitleText: "당신의 일상을 사진과 함께\n기록하고 마음을 돌아보세요")
        let page4 = OnboardingViewController(imageName: "letter", titleText: "편지", subtitleText:"마음속에 있던 이야기를\n편지에 자유롭게 기록하고\n하늘에 날려버리세요.")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .systemGray2
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
        goToRoomButton.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func layout() {
        view.addSubview(pageControl)
        view.addSubview(goToRoomButton)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToRoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // for animations
        pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)

        pageControlBottomAnchor?.isActive = true
        buttonWidth = goToRoomButton.widthAnchor.constraint(equalToConstant: 340)
        buttonWidth?.isActive = true
        buttonHeight = goToRoomButton.heightAnchor.constraint(equalToConstant: 54)
        buttonHeight?.isActive = true
        buttonBottom = goToRoomButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        buttonBottom?.isActive = true
    }
}

// MARK: - DataSource

extension OnboardingController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return nil
        }
    }
}

// MARK: - Delegates

extension OnboardingController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        
        if currentIndex == pages.count - 1 {
//            goToRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
            buttonBottom?.constant = -120
        }
        
        //최신 애니메이션 적용
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Actions

extension OnboardingController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func goToRoomButtonTapped() {
        UserDefaults.standard.set(true, forKey: "oldUser")
        
        dismiss(animated: false)
        
    }

}

// MARK: - Extensions

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
    
}
