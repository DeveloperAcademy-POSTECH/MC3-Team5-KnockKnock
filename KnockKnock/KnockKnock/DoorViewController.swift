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
        
        firstCheck()
        doorSetup()
        
        // 뷰 전체에 더블탭 제스처 기능 추가
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            view.addGestureRecognizer(tap)
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
    
    // 앱을 처음사용 하는 것인지 확인 후 기존의 키체인에 비밀번호가 등록되어 있다면 삭제
    private func firstCheck() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "isPasscode") is Bool {
        } else {
            userDefaults.set(true, forKey: "isPasscode")
            if keychainManager.deleteItem(key: "passcode") {
                print("기존의 키체인을 삭제 함")
            }
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
            doorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.width / 10),
            doorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.width / 10),
            doorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 10),
            doorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 10)
        ])
    }
    
    // 더블 탭하면 DoorViewController dismiss
    @objc private func doubleTapped() {
        
        self.dismiss(animated: false)
    }
    

}
