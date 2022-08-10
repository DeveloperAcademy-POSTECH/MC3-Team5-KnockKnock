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
    
    // 배경음악 재생 이미지 전환
    var isPlay: Bool = false
    let bgmSize: Double = 0.92
    var musicWidth : NSLayoutConstraint?
    var musicHeight : NSLayoutConstraint?
    var musicTop : NSLayoutConstraint?
    
    let navigationBarAppearance = UINavigationBarAppearance()
    
    // ImageView 설정 함수
    private func setImageView(image:UIImage, color:UIColor = .clear, alpha:CGFloat = 1.0) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        imageView.alpha = alpha
        imageView.tintColor = color
        return imageView
    }
    
    // 방 화면 버튼 ImageView 정의
    lazy var roomImageView: UIImageView = setImageView(image: UIImage(named: "roomImage")!)
    lazy var musicImageView: UIImageView = setImageView(image: UIImage(named: "musicnote-x")!)
    lazy var memoImageView: UIImageView = setImageView(image: UIImage(named: "memo")!)
    lazy var albumImageView: UIImageView = setImageView(image: UIImage(named: "album")!)
    lazy var frameImageView: UIImageView = setImageView(image: UIImage(named: "frame")!)
    lazy var frameLayerImageView: UIImageView = setImageView(image: UIImage(named:"frame-layer")!)
    lazy var letterImageView: UIImageView = setImageView(image: UIImage(named: "letter")!)
    lazy var settingImageView: UIImageView = setImageView(image: UIImage(systemName: "gearshape.fill")!, color: UIColor(named: "iconColor")!)
    lazy var noteOneImageView: UIImageView = setImageView(image: UIImage(named: "music1")!, alpha: 0.0)
    lazy var noteTwoImageView: UIImageView = setImageView(image: UIImage(named: "music2")!, alpha: 0.0)
    lazy var noteThreeImageView: UIImageView = setImageView(image: UIImage(named: "music3")!, alpha: 0.0)
    
    // 편지 사진 위 투명 버튼
    let letterButton = UIButton()
    
    // 액자 내부 사진 ImageView
    let frameHasImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //DoorViewController를 띄우고 한번이라도 실행되었다면 다음부턴 안띄움
        if UserDefaults.standard.object(forKey: "oldUser") is Bool {
            let doorViewController = DoorViewController()
            doorViewController.modalPresentationStyle = .overFullScreen
            if isDoorView {
                present(doorViewController, animated: false, completion: nil)
                isDoorView = false
            }
        } else {
            let onBoarding = OnboardingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            isDoorView = false
            onBoarding.modalPresentationStyle = .overFullScreen
            present(onBoarding, animated: false)
            isDoorView = false
        }
        
        imageInput()
        
        // 네비게이션 바 삭제
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // 편지 사진에 애니메이션 추가
        UIView.animate(withDuration: 2, delay: 0.5, options: [.repeat, .autoreverse], animations: { self.letterImageView.center.y -= 10.0 }, completion: nil)
        
        // 음표 애니메이션
        noteAnimation()
    }
    
    //MARK: -viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 네비게이션 바 다시 등장
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // 비행기 위치 초기화
        self.letterImageView.center.y += 10
        // 음표위치 초기화
        self.noteThreeImageView.center.y += 2
        self.noteTwoImageView.center.y -= 6
        self.noteOneImageView.center.y += 10
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
        view.addSubview(frameLayerImageView)
        view.addSubview(settingImageView)
        view.addSubview(musicImageView)
        view.addSubview(letterButton)
        view.addSubview(noteOneImageView)
        view.addSubview(noteTwoImageView)
        view.addSubview(noteThreeImageView)
        
        // 처음에 기본 이미지 추가
        if CoreDataManager.shared.frameImage?.count == 0 {
            CoreDataManager.shared.saveFrameCoreData(image: UIImage(named: "frame person")!.pngData()!)
            CoreDataManager.shared.readFrameCoreData()
        }
        
        setupLayout()
        
        // 배경화면 크기 AspectFill로 지정
        roomImageView.layer.masksToBounds = true
        roomImageView.contentMode = .scaleAspectFill
        
        // 음악 사진 터치 가능하도록 설정
        musicImageView.isUserInteractionEnabled = true
        musicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(controlSound(_:))))
        
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
        frameLayerImageView.isUserInteractionEnabled = true
        frameLayerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frameViewTapped(_:))))
        
        // 편지 사진 터치 가능하도록 설정
        letterImageView.isUserInteractionEnabled = true
        letterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(letterViewTapped(_:))))
        
        // 모달 닫히는 것 감지하여 토스트 수행
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .rotateBack, object: nil)
        
        // 비행기 이미지 앞에 투명 버튼
        letterButton.translatesAutoresizingMaskIntoConstraints = false
        letterButton.addTarget(self, action: #selector(letterViewTapped(_:)), for: .touchUpInside)
    }
    
    //MARK: - setupLayout
    func setupLayout(){
        
        // musicImageView layout
        musicWidth = musicImageView.widthAnchor.constraint(equalToConstant: 28 * bgmSize)
        musicWidth?.isActive = true
        musicHeight = musicImageView.heightAnchor.constraint(equalToConstant: 28 * bgmSize)
        musicHeight?.isActive = true
        musicTop = musicImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 15)
        musicTop?.isActive = true
        
        NSLayoutConstraint.activate([
            // roomImageView layout
            roomImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            roomImageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            
            // memoImageView layout
            memoImageView.widthAnchor.constraint(equalToConstant: 124),
            memoImageView.heightAnchor.constraint(equalToConstant: 79),
            memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            
            // albumImageView layout
            albumImageView.widthAnchor.constraint(equalToConstant: 73),
            albumImageView.heightAnchor.constraint(equalToConstant: 92),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:  -115),
            albumImageView.bottomAnchor.constraint(equalTo: memoImageView.topAnchor, constant: -125),
            
            // frameImageView layout
            frameImageView.widthAnchor.constraint(equalToConstant: 68),
            frameImageView.heightAnchor.constraint(equalToConstant: 100),
            frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            frameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            // frameHasImageView layout
            frameHasImageView.widthAnchor.constraint(equalToConstant: 53),
            frameHasImageView.heightAnchor.constraint(equalToConstant: 85),
            frameHasImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            frameHasImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            // frameLayerImageView layout
            frameLayerImageView.widthAnchor.constraint(equalToConstant: 53),
            frameLayerImageView.heightAnchor.constraint(equalToConstant: 85),
            frameLayerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            frameLayerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            // letterImageView layout
            letterImageView.widthAnchor.constraint(equalToConstant: 77),
            letterImageView.heightAnchor.constraint(equalToConstant: 66),
            letterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            letterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 4),
            
            // settingImageView layout
            settingImageView.widthAnchor.constraint(equalToConstant: 30),
            settingImageView.heightAnchor.constraint(equalToConstant: 30),
            settingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 15),
            settingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 15),
            
            // musicImageView layout
            musicImageView.trailingAnchor.constraint(equalTo: settingImageView.leadingAnchor, constant: -20),
            
            // 편지 투명 버튼 layout
            letterButton.widthAnchor.constraint(equalToConstant: 90),
            letterButton.heightAnchor.constraint(equalToConstant: 80),
            letterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            letterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 4),
            
            // note(1~3) imageview layout
            noteThreeImageView.widthAnchor.constraint(equalToConstant: 9),
            noteThreeImageView.heightAnchor.constraint(equalToConstant: 13),
            noteThreeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 6.5),
            noteThreeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.43),
            
            noteTwoImageView.widthAnchor.constraint(equalToConstant: 8),
            noteTwoImageView.heightAnchor.constraint(equalToConstant: 12),
            noteTwoImageView.trailingAnchor.constraint(equalTo: noteThreeImageView.leadingAnchor, constant: -10),
            noteTwoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.37),
            
            noteOneImageView.widthAnchor.constraint(equalToConstant: 9),
            noteOneImageView.heightAnchor.constraint(equalToConstant: 13),
            noteOneImageView.trailingAnchor.constraint(equalTo: noteTwoImageView.leadingAnchor, constant: -10),
            noteOneImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.45)
        ])
    }
    
    // 음표 애니메이션
    func noteAnimation(){
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.noteThreeImageView.center.y -= 2
            self.noteTwoImageView.center.y += 6
            self.noteOneImageView.center.y -= 10
        })
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

    // 편지 토스트 알림 함수
    @objc func rotate(_ sender: UITapGestureRecognizer) {
        if letterCloseCheck {
            showToast(VC:self, text: "편지 전달".localized())
            letterCloseCheck = false
        }
    }
    
    // 배경음악 재생 함수
    @objc func controlSound(_ sender: UITapGestureRecognizer) {
        isPlay.toggle()
        if isPlay {
            AudioManager.shared.playSound("Many_Days")
            self.musicImageView.image = UIImage(named: "musicnote2")
            musicWidth?.constant = 26 * bgmSize
            musicHeight?.constant = 24 * bgmSize
            musicTop?.constant = view.bounds.height / 14
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],animations: {
                self.noteThreeImageView.alpha = 1.0
                self.noteTwoImageView.alpha = 1.0
                self.noteOneImageView.alpha = 1.0
            })
        } else {
            AudioManager.shared.stopSound()
            self.musicImageView.image = UIImage(named: "musicnote-x")
            musicWidth?.constant = 28 * bgmSize
            musicHeight?.constant = 28 * bgmSize
            musicTop?.constant = view.bounds.height / 15
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.noteThreeImageView.alpha = 0.0
                self.noteTwoImageView.alpha = 0.0
                self.noteOneImageView.alpha = 0.0
            })
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

// 토스트 알림 함수
func showToast(VC: UIViewController, text: String) {
    let toastLabel = UILabel()
    VC.view.addSubview(toastLabel)
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    toastLabel.centerXAnchor.constraint(equalTo: VC.view.centerXAnchor).isActive = true
    toastLabel.centerYAnchor.constraint(equalTo: VC.view.centerYAnchor).isActive = true
    toastLabel.leadingAnchor.constraint(equalTo: VC.view.leadingAnchor, constant: 24).isActive = true
    toastLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = UIFont.systemFont(ofSize: 16.0)
    toastLabel.textAlignment = .center;
    toastLabel.text = text
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
}}
