//
//  DoorViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/18.
//

import UIKit

class DoorViewController: UIViewController {
    
    let keychainManager = KeychainManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "doorBackground")
        
        
        doorSetup()
        
        // 뷰 전체에 싱글탭 제스처 기능 추가
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapped))
        oneTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(oneTap)
        
        // 뷰 전체에 더블탭 제스처 기능 추가
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            view.addGestureRecognizer(tap)
        
        //더블탭을 할 시 싱글탭 무시
        oneTap.require(toFail: tap)
    }
    
    // 비밀번호창 띄우기
    override func viewDidAppear(_ animated: Bool) {
        let isPasscodeView = keychainManager.getItem(key: "passcode") == nil ? false : true
        if isPasscodeView {
            let PasscodeVC = PasscodeViewController()
            PasscodeVC.modalPresentationStyle = .overFullScreen
            present(PasscodeVC, animated: true)
        }
    }
    
    private func doorSetup() {
        let doorImageView: UIImageView = {
            let imageView = UIImageView()
            let myImage: UIImage = UIImage(named: "door")!
            imageView.image = myImage
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        view.addSubview(doorImageView)
    
        NSLayoutConstraint.activate([
            doorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.width / 6.3),
            doorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.width / 6.3),
            doorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 6.3),
            doorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 6.3)
        ])
    }
    
    // 싱글 탭하면 토스트 팝업 알림
    @objc private func oneTapped() {
        showToast(VC:self, text:"방에 입장하려면 두 번 터치해주세요.")
    }
    
    // 더블 탭하면 DoorViewController dismiss
    @objc private func doubleTapped() {
        self.dismiss(animated: false)
    }
}
