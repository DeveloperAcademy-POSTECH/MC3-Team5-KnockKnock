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
    
    // 배경음악재생 이미지 전환
    var isPlay: Bool = false
    
    var musicWidth : NSLayoutConstraint?
    var musicHeight : NSLayoutConstraint?
    var musicTop : NSLayoutConstraint?
    
    let navigationBarAppearance = UINavigationBarAppearance()
    
    let letterButton = UIButton()
    
    
    // 배경화면
    let roomImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "roomImage")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 배경음악 버튼 ImageView
    let musicImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "musicnote-x")!
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
    
    // 액자 사진 레이어 ImageView
    let frameLayerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named:"frame-layer")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 편지 버튼 ImageView
    let letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 음표 1
    let noteOneImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "music1")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        imageView.alpha = 0.0
        return imageView
    }()
    
    // 음표 2
    let noteTwoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "music2")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        imageView.alpha = 0.0
        return imageView
    }()
    
    // 음표 3
    let noteThreeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "music3")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        imageView.alpha = 0.0
        return imageView
    }()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DoorViewController를 띄우고 한번이라도 실행되었다면 다음부턴 안띄움
        //뷰디드어피어 부분을 옮겨옴
        if UserDefaults.standard.object(forKey: "oldUser") is Bool {
            let doorViewController = DoorViewController()
            doorViewController.modalPresentationStyle = .overFullScreen
            if isDoorView {
                present(doorViewController, animated: false, completion: nil)
                isDoorView = false
            }
        } else {
            let onBoarding = OnboardingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            onBoarding.modalPresentationStyle = .overFullScreen
            present(onBoarding, animated: false)
            
        }
        

        imageInput()
        // 네비게이션 뷰 삭제
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 애니메이션 넣는 코드
        UIView.animate(withDuration: 2, delay: 0.5,
                       options: [.repeat, .autoreverse], animations: {
                            self.letterImageView.center.y -= 10.0
            }, completion: nil)
        
        // 음표 애니메이션
        noteAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // 다시 등장
            navigationController?.setNavigationBarHidden(false, animated: animated)
        
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
        imageInput()
        
        // 배경화면 크기 AspectFill로 맞춤
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
    
    // DoorViewController를 띄우고 한번이라도 실행되었다면 다음부턴 안띄움
    override func viewDidAppear(_ animated: Bool) {
//        let doorViewController = DoorViewController()
//        doorViewController.modalPresentationStyle = .overFullScreen
//        if isDoorView {
//            present(doorViewController, animated: false, completion: nil)
//            isDoorView = false
//        }
    }
    
    func setupLayout(){
        // musicImageView layout
        musicWidth = musicImageView.widthAnchor.constraint(equalToConstant: 28)
        musicWidth?.isActive = true
        musicHeight = musicImageView.heightAnchor.constraint(equalToConstant: 28)
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
            frameLayerImageView.widthAnchor.constraint(equalToConstant: 68),
            frameLayerImageView.heightAnchor.constraint(equalToConstant: 100),
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
            
            // 비행기 앞에 투명 버튼
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

    // 토스트 알림 함수
    @objc func rotate(_ sender: UITapGestureRecognizer) {
        if letterCloseCheck {
            showToast(VC:self, text: "편지가 하늘에 잘 전달되었어요.")
            letterCloseCheck = false
        }
    }
    
    // 배경음악 재생 함수
    @objc func controlSound(_ sender: UITapGestureRecognizer) {
        isPlay.toggle()
        
        if isPlay {
            AudioManager.shared.playSound("forest")
            self.musicImageView.image = UIImage(named: "musicnote2")
            musicWidth?.constant = 26
            musicHeight?.constant = 24
            musicTop?.constant = view.bounds.height / 14
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],animations: {
                self.noteThreeImageView.alpha = 1.0
                self.noteTwoImageView.alpha = 1.0
                self.noteOneImageView.alpha = 1.0
            })
            
        } else {
            AudioManager.shared.stopSound()
            self.musicImageView.image = UIImage(named: "musicnote-x")
            musicWidth?.constant = 28
            musicHeight?.constant = 28
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
//UserDefaults 사용
public class Storage {
    static func isFirstTime() -> Bool{
        //UserDefaults object 가져오기
        let defaults = UserDefaults.standard
        //UserDefaults 를 이용해 값 가져오기
        if defaults.object(forKey: "isFirstTime") == nil {
            //UserDefaults 를 이용해 값 저장하기
            defaults.set("Yes", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
}
