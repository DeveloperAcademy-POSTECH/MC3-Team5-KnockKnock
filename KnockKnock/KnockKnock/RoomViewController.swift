//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    let letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
        imageView.image = myImage
        return imageView
    }()
    
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    //MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(memoImageView)
        view.addSubview(albumImageView)
        view.addSubview(letterImageView)
        setupLayout()
        
        //메모 사진 터치 가능하도록 설정
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
        
        //앨범 사진 터치 가능하도록 설정
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumViewTapped(_:))))
        
        letterImageView.translatesAutoresizingMaskIntoConstraints = false
        letterImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        letterImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        letterImageView.bottomAnchor.constraint(equalTo: memoImageView.topAnchor).isActive = true
        letterImageView.isUserInteractionEnabled = true
        letterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(letterViewTapped(_:))))
    }
    
    func setupLayout(){
        NSLayoutConstraint.activate([
            //memoImageView layout
            memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //albumIamgeView layout
            albumImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: memoImageView.bottomAnchor, constant: 20)
        ])
    }
    
    //메모 버튼 터치 함수
    @objc func memoViewTapped(_ sender: UITapGestureRecognizer) {
        let memoVC = MainMemoView()
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    
    //앨범 버튼 터치 함수
    @objc func albumViewTapped(_ sender: UITapGestureRecognizer) {
        let albumVC = MainAlbumViewController()
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
    @objc func letterViewTapped(_ sender: UITapGestureRecognizer) {
        let letterVC = MainLetterViewController()
        letterVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        
        self.present(letterVC, animated: true, completion: nil)
    }
    
    
}

