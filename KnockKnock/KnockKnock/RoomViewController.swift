//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.image = myImage
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(memoImageView)
        
        memoImageView.translatesAutoresizingMaskIntoConstraints = false
        memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // MARK: 메모사진이 터치 가능하도록 함
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
    }
    
    @objc func memoViewTapped(_ sender: UITapGestureRecognizer) {
        // 객체 인스턴스 생성
        let memoVC = MainMemoView()
        // 푸쉬한다
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    
}

