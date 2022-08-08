//
//  PasscodeViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import LocalAuthentication
import UIKit
import AVFoundation

enum PasscodeMode {
    case pass
    case new
    case change
}

class PasscodeViewController: UIViewController {
    
    let settingViewController = SettingViewController()
    let keychainManager = KeychainManager()
    var passcodeMode: PasscodeMode = .pass
    var isPasscode: Bool? = false
    var newPasscodes = [Int]()
    var passcodes = [Int]()
    var tasks = [Task]()
    
    // 비밀번호 상태 이미지
    lazy var passcodeImage1: UIImageView = setupPasscodeImage()
    lazy var passcodeImage2: UIImageView = setupPasscodeImage()
    lazy var passcodeImage3: UIImageView = setupPasscodeImage()
    lazy var passcodeImage4: UIImageView = setupPasscodeImage()
    
    // 비밀번호 상태 라벨
    lazy var titleLabel: UILabel = setupPasscodeLabel(text: "암호 입력".localized(), color: .black, size: 25)
    lazy var subTitleLabel: UILabel = setupPasscodeLabel(text: "암호를 입력해 주세요.".localized(), color: .gray, size: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "doorBackground")
        loadTasks()
        passcodeField()
        setupNumberPad()
    }
    
    // 비밀번호 상태 이미지
    private func setupPasscodeImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // 비밀번호 상태 라벨
    private func setupPasscodeLabel(text: String, color: UIColor, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.text = text
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // 비밀번호 등록 여부와, UserDefaults의 값을 load
    private func loadTasks() {
        isPasscode = keychainManager.getItem(key: "passcode") == nil ? false : true
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let imageName = $0["imageName"] as? String else {return nil}
            guard let title = $0["title"] as? String else {return nil}
            guard let isSwitch = $0["isSwitch"] as? Bool else {return nil}
            guard let isSwitchOn = $0["isSwitchOn"] as? Bool else { return nil}
            return Task(imageName: imageName, title: title, isSwitch: isSwitch, isSwitchOn: isSwitchOn)
        }
    }
    
    private func passcodeField() {
        let passcodeButtonHeight = (view.frame.size.width / 12) * 3.5
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            return stackView
        }()
        
        let hStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 30
            return stackView
        }()
        
        view.addSubview(vStackView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subTitleLabel)
        vStackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(passcodeImage1)
        hStackView.addArrangedSubview(passcodeImage2)
        hStackView.addArrangedSubview(passcodeImage3)
        hStackView.addArrangedSubview(passcodeImage4)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -passcodeButtonHeight),
        ])
    }
    
    // 숫자패드 버튼 생성 함수
    private func setupNumberPad() {
        let buttonWidthSize = view.frame.size.width / 3
        let buttonHeightSize = buttonWidthSize / 2
        
        // 숫자 버튼
        for n in 0..<3 {
            for m in 0..<3 {
                lazy var numberButton: UIButton = {
                    let button = UIButton(frame: CGRect(x: buttonWidthSize * CGFloat(m), y: view.frame.size.height - buttonHeightSize * (4.5 - CGFloat(n)), width: buttonWidthSize, height: buttonHeightSize))
                    button.setTitleColor(.black, for: .normal)
                    button.setTitle(String((m + 1) + (n * 3)), for: .normal)
                    button.tag = (m + 1) + (n * 3)
                    button.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
                    return button
                }()
                view.addSubview(numberButton)
            }
        }
        
        // FaceID / 취소 버튼
        let faceButton = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        faceButton.setTitleColor(.black, for: .normal)
        
        switch passcodeMode {
        case .pass:
            faceButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            if tasks.count == 3 && tasks[1].isSwitchOn {
                view.addSubview(faceButton)
            }
        case .new, .change:
            faceButton.setTitle("취소".localized(), for: .normal)
            view.addSubview(faceButton)
        }
        faceButton.tintColor = .black
        faceButton.tag = 11
        faceButton.addTarget(self, action: #selector(facePressed(_ :)), for: .touchUpInside)
        
        // 숫자 0 버튼
        lazy var zeroButton: UIButton = {
            let zeroButton = UIButton(frame: CGRect(x: buttonWidthSize, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
            zeroButton.setTitleColor(.black, for: .normal)
            zeroButton.setTitle("0", for: .normal)
            zeroButton.tag = 0
            zeroButton.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
            return zeroButton
        }()
        
        // 삭제 버튼
        lazy var deleteButton: UIButton = {
            let deleteButton = UIButton(frame: CGRect(x: buttonWidthSize * 2, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
            deleteButton.setTitleColor(.label, for: .normal)
            deleteButton.setImage(UIImage(systemName: "delete.backward"), for: .normal)
            deleteButton.tintColor = .black
            deleteButton.tag = 12
            deleteButton.addTarget(self, action: #selector(deletePressed(_ :)), for: .touchUpInside)
            return deleteButton
        }()
        
        view.addSubview(zeroButton)
        view.addSubview(deleteButton)
    }
    
    // number button 눌렸을 때
    @objc private func numberPressed(_ sender: UIButton) {
        let number = sender.tag
        passcodes.append(number)
        update()
    }
    
    @objc private func facePressed(_ sender: UIButton) {
        switch passcodeMode {
        case .pass:
            biometry()
        case .new:
            settingViewController.tasks[0].isSwitchOn = false
            NotificationCenter.default.post(name: .fatchTable, object: nil)
            self.dismiss(animated: true)
        case .change:
            self.dismiss(animated: true)
        }
    }
    
    @objc private func deletePressed(_ sender: UIButton) {
        if passcodes.count >= 1{
            passcodes.removeLast()
            print(passcodes)
            update()
        }
    }
    
    // 비밀번호 4자리 입력 완료
    func update() {
        if passcodes.count == 4 {
            switch passcodeMode {
            case .pass:
                if let keychainPasscodes = keychainManager.getItem(key: "passcode") as? String {
                    let registedPasscodes = keychainPasscodes.map { Int(String($0))! }
                    if passcodes == registedPasscodes {
                        self.dismiss(animated: true)
                    } else {
                        passcodes.removeAll()
                        subTitleLabel.textColor = .red
                        subTitleLabel.text = "비밀번호를 다시 입력해주세요.".localized()
                        shakeWith(duration: 0.5, angle: .pi/30, yOffset: 0.5)
                    }
                }
            case .new, .change:
                if newPasscodes.isEmpty {
                    newPasscodes = passcodes
                    passcodes.removeAll()
                    subTitleLabel.textColor = .gray
                    subTitleLabel.text = "확인을 위해 다시 입력해주세요.".localized()
                } else if newPasscodes != passcodes {
                    passcodes.removeAll()
                    newPasscodes.removeAll()
                    subTitleLabel.textColor = .red
                    subTitleLabel.text = "비밀번호 등록을 다시 진행해주세요.".localized()
                } else {
                    var pwd = ""
                    for n in newPasscodes {
                        pwd += String(n)
                    }
                    if keychainManager.addItem(key: "passcode", pwd: pwd) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
        passcodeImage1.image = UIImage(systemName: passcodes.count > 0 ? "circle.fill" : "minus")
        passcodeImage2.image = UIImage(systemName: passcodes.count > 1 ? "circle.fill" : "minus")
        passcodeImage3.image = UIImage(systemName: passcodes.count > 2 ? "circle.fill" : "minus")
        passcodeImage4.image = UIImage(systemName: passcodes.count > 3 ? "circle.fill" : "minus")
    }
    
    // 생체인증기능 가능 여부 확인후 인증 실행
    func biometry() {
        if isPasscode! && tasks[1].isSwitchOn {
            // Touch ID와 Face ID 인증을 사용하기 위한 초기화를 합니다.
            let authContext = LAContext()
            var error: NSError?
            // 각 상황별 안내 문구
            var description: String!
            // Touch ID와 Face ID를 지원하는 기기인지 확인
            if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                
                // 스위치 문을 통해 인증 타입을 확인하여 보여줄 안내 문구 설정
                switch authContext.biometryType {
                case .faceID:
                    description = "소중한 정보를 보호하기 위해서 Face ID로 인증해주세요.".localized()
                case .touchID:
                    description = "소중한 정보를 보호하기 위해서 Touch ID를 인증해주세요.".localized()
                case .none:
                    description = "소중한 정보를 보호하기 위해서 로그인 해주세요".localized()
                    break
                default:
                    break
                }
                
                // Touch ID와 Face ID 인증 시작
                // authContext를 이용하여 인증을 요청하면 인증 성공 여부와 인증 실패시 결과가 에러를 통해 값으로 내려온다.
                // 위의 두 결과를 통해 여러가지 인증 처리를 하면 된다.
                authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { success, error in
                    DispatchQueue.main.async {
                        guard success, error == nil else {
                            AudioServicesPlaySystemSound(4095)
                            return
                        }
                        self.dismiss(animated: false)
                    }
                }
            }
        }
    }
    
    // 암호입력 틀렸을때 애니메이션
    private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
        
        let numberOfFrames: Double = 6
        let frameDuration = Double(1/numberOfFrames)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [],
                                animations: {
            AudioServicesPlaySystemSound(4095)
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform(rotationAngle: -angle)
                AudioServicesPlaySystemSound(4095)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*2,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*3,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*4,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration*5,
                               relativeDuration: frameDuration) {
                self.subTitleLabel.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
}

// 비밀번호 뷰 dismiss되었을때 셋팅 뷰 함수 실행하기 위한 노티피케이션
extension Notification.Name {
    static let fatchTable = Notification.Name("fatchTable")
}

// 최상단 뷰를 불러오기 위한 코드 1
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

// 최상단 뷰를 불러오기 위한 코드 2
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        return keyWindow?.rootViewController?.topMostViewController()
    }
}
