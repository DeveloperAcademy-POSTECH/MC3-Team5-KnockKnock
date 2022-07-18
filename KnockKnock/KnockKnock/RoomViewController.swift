//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    // DoorViewController실행 되었는지 확인
    var isDoorView: Bool = true
    let doorViewController = DoorViewController()
    
    //메모 버튼 ImageView
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    
    //액자 버튼 ImageView
    let frameImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    //편지 버튼 ImageView
    let letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
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
        view.addSubview(frameImageView)
        view.addSubview(letterImageView)
        setupLayout()
        
        //메모 사진 터치 가능하도록 설정
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
        
        //앨범 사진 터치 가능하도록 설정
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumViewTapped(_:))))
        
        //액자 사진 터치 가능하도록 설정
        frameImageView.isUserInteractionEnabled = true
        frameImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frameViewTapped(_:))))
        
        //편지 사진 터치 가능하도록 설정
        letterImageView.isUserInteractionEnabled = true
        letterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(letterViewTapped(_:))))
    }
    
    // DoorViewController를 띄우고 한번이라도 실행되었다면 다음부턴 안띄움
    override func viewDidAppear(_ animated: Bool) {
        let doorViewController = DoorViewController()
        doorViewController.modalPresentationStyle = .overFullScreen
        
        if isDoorView {
            present(doorViewController, animated: false, completion: nil)
            isDoorView = false
        }
        
    }
    
    func setupLayout(){
        NSLayoutConstraint.activate([
            //memoImageView layout
            memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //albumImageView layout
            albumImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: memoImageView.bottomAnchor, constant: 20),
            
            //frameImageView layout
            frameImageView.widthAnchor.constraint(equalToConstant: 100),
            frameImageView.heightAnchor.constraint(equalToConstant: 100),
            frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:100),
            
            //letterImageView layout
            letterImageView.widthAnchor.constraint(equalToConstant: 100),
            letterImageView.heightAnchor.constraint(equalToConstant: 100),
            letterImageView.bottomAnchor.constraint(equalTo: memoImageView.topAnchor)
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
    
    //액자 버튼 터치 함수
    @objc func frameViewTapped(_ sender: UITapGestureRecognizer) {
        let frameVC = MainFrameViewController()
        self.navigationController?.pushViewController(frameVC, animated: true)
    }
    
    //편지 버튼 터치 함수
    @objc func letterViewTapped(_ sender: UITapGestureRecognizer) {
        let letterVC = MainLetterViewController()
        letterVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        
        self.present(letterVC, animated: true, completion: nil)
    }
}

