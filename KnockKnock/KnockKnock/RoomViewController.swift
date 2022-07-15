//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.image = myImage
        return imageView
    }()
    
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.image = myImage
        return imageView
    }()
    
    //MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(memoImageView)
        view.addSubview(albumImageView)
        //MARK: - memoImageView layout
        memoImageView.translatesAutoresizingMaskIntoConstraints = false
        memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //메모사진이 터치 가능하도록 함
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
        
        //MARK: - albumIamgeView layout
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: memoImageView.bottomAnchor, constant: 20).isActive = true
        //앨범사진이 터치 가능하도록 함
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumViewTapped(_:))))
        
    }
    
    @objc func memoViewTapped(_ sender: UITapGestureRecognizer) {
        // 객체 인스턴스 생성
        let memoVC = MainMemoView()
        // 푸쉬한다
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    @objc func albumViewTapped(_ sender: UITapGestureRecognizer) {
        // 객체 인스턴스 생성
        let albumVC = MainAlbumViewController()
        // 푸쉬한다
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
}

