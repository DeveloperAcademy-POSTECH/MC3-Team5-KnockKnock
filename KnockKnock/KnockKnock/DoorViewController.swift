//
//  DoorViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/18.
//

import UIKit

class DoorViewController: UIViewController {
    
    let keychainManager = KeychainManager()
    let doorImageView: UIImageView = {
        let imageView = UIImageView()
        let myImage: UIImage = UIImage(named: "door")!
        imageView.image = myImage
        imageView.contentMode = .scaleAspectFit
        imageView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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
    
    private func doorSetup() {
        view.addSubview(doorImageView)
        NSLayoutConstraint.activate([
            doorImageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant:  -view.bounds.width * 0.15),
            doorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            doorImageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.7),
            doorImageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7)
        ])
    }
    
    // 싱글 탭하면 토스트 팝업 알림
    @objc private func oneTapped() {
        showToast(VC:self, text:"방에 입장하려면 두 번 터치해주세요.")
    }
    
    // 더블 탭하면 DoorViewController dismiss
    @objc private func doubleTapped() {
        UIView.animate(withDuration: 1.5, delay: 0, animations: {
            let layer = self.doorImageView.layer
            var rotationAndPerspectiveTransform = CATransform3DIdentity
            rotationAndPerspectiveTransform.m34 = 1.0 / -500
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -15.0 * .pi / 90.0, 0.0, 0.5, 0.0)
            layer.transform = rotationAndPerspectiveTransform
            self.doorImageView.alpha = 0.2
            self.view.backgroundColor = .white
            
        }, completion: {finished in
            self.doorImageView.alpha = 0.0
            self.modalTransitionStyle = .crossDissolve
                    self.dismiss(animated: true)
        })
    }
}
