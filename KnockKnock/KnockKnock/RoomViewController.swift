//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    // DoorViewController 실행 되었는지 확인
    var isDoorView: Bool = true
    let doorViewController = DoorViewController()
    let keychainManager = KeychainManager()
    
    let navigationBarAppearance = UINavigationBarAppearance()
    
    // 배경화면
    let roomImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "roomImage")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 셋팅 버튼 ImageView
    let settingImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(systemName: "gearshape.fill")!
        imageView.tintColor = UIColor(named: "iconColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 메모 버튼 ImageView
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 앨범 버튼 ImageView
    let albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "album")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 액자 버튼 ImageView
    let frameImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "frame")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 액자 사진 버튼 ImageView
    let frameHasImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        CoreDataManager.shared.readFrameCoreData()
        if let image = CoreDataManager.shared.frameImage?.last, let frameImageData = image.value(forKey: "image") as? Data {
            imageView.image = UIImage(data: frameImageData)
        }
        return imageView
    }()
    
    // 편지 버튼 ImageView
    var letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageInput()
        // 네비게이션 뷰 삭제
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // 다시 등장
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarAppearance.backgroundColor = UIColor(named: "navigationColor")
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        

        view.backgroundColor = .systemBackground

        view.addSubview(roomImageView)
        view.addSubview(frameImageView)
        view.addSubview(memoImageView)
        view.addSubview(albumImageView)
        view.addSubview(letterImageView)
        view.addSubview(frameHasImageView)
        view.addSubview(settingImageView)
        
        // 처음에 기본 이미지 추가
        if CoreDataManager.shared.frameImage?.count == 0 {
            CoreDataManager.shared.saveFrameCoreData(image: UIImage(named: "frame person")!.pngData()!)
            CoreDataManager.shared.readFrameCoreData()
        }
        
        setupLayout()
        imageInput()
        

        // 배경화면 크기 AspectFill로 맞춤
        roomImageView.layer.masksToBounds = true
        roomImageView.contentMode = .scaleAspectFill
        
        // 셋팅 사진 터치 가능하도록 설정
        settingImageView.isUserInteractionEnabled = true
        settingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingViewTapped(_:))))

        // 메모 사진 터치 가능하도록 설정
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
        
        // 앨범 사진 터치 가능하도록 설정
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumViewTapped(_:))))
        
        // 액자 사진 터치 가능하도록 설정
        frameImageView.isUserInteractionEnabled = true
        frameImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frameViewTapped(_:))))
        frameHasImageView.isUserInteractionEnabled = true
        frameHasImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frameViewTapped(_:))))
        
        // 편지 사진 터치 가능하도록 설정
        letterImageView.isUserInteractionEnabled = true
        letterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(letterViewTapped(_:))))
        
        // 모달 닫히는 것 감지하여 토스트 수행
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .rotateBack, object: nil)
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

            roomImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            roomImageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            
            // memoImageView layout
            memoImageView.widthAnchor.constraint(equalToConstant: 124),
            memoImageView.heightAnchor.constraint(equalToConstant: 79),
            memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            
            // albumImageView layout
            albumImageView.widthAnchor.constraint(equalToConstant: 73),
            albumImageView.heightAnchor.constraint(equalToConstant: 92),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:  -115),
            albumImageView.bottomAnchor.constraint(equalTo: memoImageView.topAnchor, constant: -120),
            
            // frameImageView layout
            frameImageView.widthAnchor.constraint(equalToConstant: 68),
            frameImageView.heightAnchor.constraint(equalToConstant: 100),
            frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            frameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // frameHasImageView layout
            frameHasImageView.widthAnchor.constraint(equalToConstant: 53),
            frameHasImageView.heightAnchor.constraint(equalToConstant: 85),
            frameHasImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            frameHasImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // letterImageView layout
            letterImageView.widthAnchor.constraint(equalToConstant: 77),
            letterImageView.heightAnchor.constraint(equalToConstant: 66),
            letterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            letterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 4),
            
            // settingImageView layout
            settingImageView.widthAnchor.constraint(equalToConstant: 30),
            settingImageView.heightAnchor.constraint(equalToConstant: 30),
            settingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 15),
            settingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 15)
        ])
    }
    
    // CoreData를 읽어와서 이미지를 전달하는 함수
    func imageInput(){
        CoreDataManager.shared.readFrameCoreData()
        if let image = CoreDataManager.shared.frameImage?.last {
            if let frameImageData = image.value(forKey: "image") as? Data {
                frameHasImageView.image = UIImage(data: frameImageData)
            }
        }
    }


    // 토스트 알림 함수
    @objc func rotate(_ sender: UITapGestureRecognizer) {
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
            toastLabel.text = "편지가 하늘에 잘 전달되었어요"
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            UIView.animate(withDuration: 2.0, delay: 1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        if letterCloseCheck {
            showToast()
            letterCloseCheck = false
        }
    }
    
    // 메모 버튼 터치 함수
    @objc func settingViewTapped(_ sender: UITapGestureRecognizer) {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // 메모 버튼 터치 함수
    @objc func memoViewTapped(_ sender: UITapGestureRecognizer) {
        let memoVC = MainMemoView()
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    
    // 앨범 버튼 터치 함수
    @objc func albumViewTapped(_ sender: UITapGestureRecognizer) {
        let albumVC = MainAlbumViewController()
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
    // 액자 버튼 터치 함수
    @objc func frameViewTapped(_ sender: UITapGestureRecognizer) {
        let frameVC = MainFrameViewController()
        self.navigationController?.pushViewController(frameVC, animated: true)
    }
    
    // 편지 버튼 터치 함수
    @objc func letterViewTapped(_ sender: UITapGestureRecognizer) {
        let letterVC = MainLetterViewController()
        letterVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        
        self.present(letterVC, animated: true, completion: nil)
    }
}

// 감지하는 기능 추가
extension Notification.Name {
    static let rotateBack = Notification.Name("rotateBack")
}

