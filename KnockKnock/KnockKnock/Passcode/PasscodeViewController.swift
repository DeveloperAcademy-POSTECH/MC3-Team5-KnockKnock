//
//  PasscodeViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import LocalAuthentication
import UIKit

class PasscodeViewController: UIViewController {
    
    var passcodes = [Int]()
    var newPasscodes = [Int]()
    let settingViewController = SettingViewController()
    let keychainManager = KeychainManager()
    var isRegister: Bool? = false
    var tasks = [Task]()
    
    // 비밀번호 상태 이미지
    lazy var passcodeImage1: UIImageView = setupPasscodeImage()
    lazy var passcodeImage2: UIImageView = setupPasscodeImage()
    lazy var passcodeImage3: UIImageView = setupPasscodeImage()
    lazy var passcodeImage4: UIImageView = setupPasscodeImage()
    
    // 비밀번호 상태 라벨
    lazy var titleLabel: UILabel = {
        setupPasscodeLabel(text: "암호 입력", color: .black, size: 25)
    }()
    lazy var subTitleLabel: UILabel = {
        setupPasscodeLabel(text: "암호를 입력해 주세요.", color: .gray, size: 15)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "doorBackground")
        loadTasks()
        passcodeField()
        setupNumberPad()
        biometry()
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
        isRegister = keychainManager.getItem(key: "passcode") == nil ? true : false

        
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else {return nil}
            guard let isSwitch = $0["isSwitch"] as? Bool else {return nil}
            guard let isSwitchOn = $0["isSwitchOn"] as? Bool else { return nil}
            return Task(title: title, isSwitch: isSwitch, isSwitchOn: isSwitchOn)
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
    
    private func setupNumberPad() {
        
        let buttonWidthSize = view.frame.size.width / 3
        let buttonHeightSize = buttonWidthSize / 2
        
        for n in 0..<3 {
            for m in 0..<3 {
                let button = UIButton(frame: CGRect(x: buttonWidthSize * CGFloat(m), y: view.frame.size.height - buttonHeightSize * (4.5 - CGFloat(n)), width: buttonWidthSize, height: buttonHeightSize))
                button.setTitleColor(.black, for: .normal)
                
                //                button.backgroundColor = .white
                button.setTitle(String((m + 1) + (n * 3)), for: .normal)
                button.tag = (m + 1) + (n * 3)
                button.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
        
        let faceButton = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        faceButton.setTitleColor(.black, for: .normal)
        //        faceButton.backgroundColor = .white
        if isRegister! {
            faceButton.setTitle("취소", for: .normal)
        } else {
            faceButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        }
        faceButton.tintColor = .black
        faceButton.tag = 11
        faceButton.addTarget(self, action: #selector(facePressed(_ :)), for: .touchUpInside)
        view.addSubview(faceButton)
        
        let zeroButton = UIButton(frame: CGRect(x: buttonWidthSize, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        zeroButton.setTitleColor(.black, for: .normal)
        //        zeroButton.backgroundColor = .white
        zeroButton.setTitle("0", for: .normal)
        zeroButton.tag = 0
        zeroButton.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
        view.addSubview(zeroButton)
        
        let deleteButton = UIButton(frame: CGRect(x: buttonWidthSize * 2, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        deleteButton.setTitleColor(.label, for: .normal)
        //        deleteButton.backgroundColor = .white
        deleteButton.setImage(UIImage(systemName: "delete.backward"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.tag = 12
        deleteButton.addTarget(self, action: #selector(deletePressed(_ :)), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
    
    @objc private func numberPressed(_ sender: UIButton) {
        let number = sender.tag
        passcodes.append(number)
        update()
        
    }
    
    @objc private func facePressed(_ sender: UIButton) {
        if isRegister! {
            settingViewController.tasks[0].isSwitchOn = false
            NotificationCenter.default.post(name: .fatchTable, object: nil)
            self.dismiss(animated: true)
        } else {
            biometry()
        }
    }
    
    @objc private func deletePressed(_ sender: UIButton) {
        if passcodes.count >= 1{
            passcodes.removeLast()
            print(passcodes)
            update()
        }
    }
    
    private func update() {
        print(passcodes)
        
        if passcodes.count == 4 {
            if isRegister! {
                if newPasscodes.isEmpty {
                    newPasscodes = passcodes
                    passcodes.removeAll()
                    subTitleLabel.textColor = .gray
                    subTitleLabel.text = "확인을 위해 다시 입력해주세요."
                } else if newPasscodes != passcodes {
                    passcodes.removeAll()
                    newPasscodes.removeAll()
                    subTitleLabel.textColor = .red
                    subTitleLabel.text = "비밀번호 등록을 다시 진행해주세요."
                } else {
                    var pwd = ""
                    for n in newPasscodes {
                        pwd += String(n)
                    }
                    if keychainManager.addItem(key: "passcode", pwd: pwd) {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                if let keychainPasscides = keychainManager.getItem(key: "passcode") as? String {
                    let registedPasscodes = keychainPasscides.map { Int(String($0))! }
                    if passcodes == registedPasscodes {
                        self.dismiss(animated: true)
                    } else {
                        passcodes.removeAll()
                        subTitleLabel.textColor = .red
                        subTitleLabel.text = "비밀번호 다시 입력해주세요."
                    }
                }

            }
        }
        passcodeImage1.image = UIImage(systemName: passcodes.count > 0 ? "circle.fill" : "minus")
        passcodeImage2.image = UIImage(systemName: passcodes.count > 1 ? "circle.fill" : "minus")
        passcodeImage3.image = UIImage(systemName: passcodes.count > 2 ? "circle.fill" : "minus")
        passcodeImage4.image = UIImage(systemName: passcodes.count > 3 ? "circle.fill" : "minus")
    }
    
    private func biometry() {
        if !isRegister! {
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
                    description = "소중한 정보를 보호하기 위해서 Face ID로 인증해주세요."
                case .touchID:
                    description = "소중한 정보를 보호하기 위해서 Touch ID를 인증해주세요."
                case .none:
                    description = "소중한 정보를 보호하기 위해서 로그인 해주세요"
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
                            return
                        }
                        self.dismiss(animated: false)
                    }
                }
            } else {

            }
        }
        
    }
    
}

extension Notification.Name {
    static let fatchTable = Notification.Name("fatchTable")
}
