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
    // 싱글 탭하면 토스트 팝업 알림
    @objc private func oneTapped() {
        self.showToast()
    }
    // 더블 탭하면 DoorViewController dismiss
    @objc private func doubleTapped() {
        self.dismiss(animated: false)
    }
    
    func showToast(font: UIFont = UIFont.systemFont(ofSize: 16.0)) {
        let toastLabel = UILabel()
        self.view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        toastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = "방에 입장하려면 두 번 터치해주세요."
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
