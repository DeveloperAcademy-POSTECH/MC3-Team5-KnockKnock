//
//  SettingViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//
import LocalAuthentication
import UIKit

class SettingViewController: UIViewController {
    
    let keyChainManager = KeychainManager()
    
    // 온보딩 다시보기 셀에 사용될 배열
    let onboardingCells: [String] = ["설명 다시보기"]
    
    // 비밀번호 설정 셀에 사용될 배열
    let sections: [String] = ["앱 설명", "앱 잠금"]
    
    // 테이블 뷰
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorInset = .zero
        return tableView
    }()
    
    var tasks = [Task(imageName: "lock", title: "비밀번호 설정", isSwitch: true, isSwitchOn: false)] {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fatchTable), name: .fatchTable, object: nil)
        title = "비밀번호 설정"
        view.backgroundColor = .red
        tableViewSetup()
        loadTasks()
    }
    
    private func tableViewSetup() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // tasks를 userDefaults에 저장
    func saveTasks() {
        let data = self.tasks.map {
            ["imageName": $0.imageName, "title": $0.title, "isSwitch": $0.isSwitch, "isSwitchOn": $0.isSwitchOn]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    // userDefaults에 저장된 내용을 tasks에 불러오기
    func loadTasks() {
        let isRegister = keyChainManager.getItem(key: "passcode") == nil ? false : true
        if isRegister {
            let userDefaults = UserDefaults.standard
            guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
            self.tasks = data.compactMap {
                guard let imageName = $0["imageName"] as? String else { return nil }
                guard let title = $0["title"] as? String else { return nil }
                guard let isSwitch = $0["isSwitch"] as? Bool else { return nil }
                guard let isSwitchOn = $0["isSwitchOn"] as? Bool else { return nil}
                return Task(imageName: imageName, title: title, isSwitch: isSwitch, isSwitchOn: isSwitchOn)
            }
        } else {
            tasks = [Task(imageName: "lock", title: "비밀번호 설정", isSwitch: true, isSwitchOn: false)]
        }
    }
    
    func isBiometry() -> Bool {
        let authContext = LAContext()
        var error: NSError?
        // Touch ID와 Face ID를 지원하는 기기인지 확인
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("생체 인식 사용가능")
            return true
        } else {
            print("생체 인식 사용불가능")
            return false
        }
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.onboardingCells.count
        } else {
            return self.tasks.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let onboardingCell = onboardingCells[indexPath.row]
            cell.imageView?.image = UIImage(systemName: "questionmark.circle")
            cell.textLabel?.text = onboardingCell
            cell.accessoryView = nil
        } else {
            let task = self.tasks[indexPath.row]
            cell.textLabel?.text = task.title
            cell.imageView?.image = UIImage(systemName: task.imageName)
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(task.isSwitchOn, animated: true)
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            if task.isSwitch {
                cell.accessoryView = switchView
                cell.selectionStyle = .none
            } else {
                cell.accessoryView = nil
            }
        }
        cell.imageView?.tintColor = .black
        return cell
    }
    
    // 비밀번호 변경 or 설명 다시보기 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let onBoarding =  OnboardingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            onBoarding.modalPresentationStyle = .overFullScreen
            present(onBoarding, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            let registerPasscode = PasscodeViewController()
            registerPasscode.modalPresentationStyle = .fullScreen
            registerPasscode.passcodeMode = .change
            present(registerPasscode, animated: true)
        }
    }
    
    // 비밀번호 스위치 off로 변경되면 생체인증, 비밀번호 변경 task 삭제 함수
    @objc func fatchTable() {
        tasks[0].isSwitchOn = false
        if self.tasks.count == 3 {
            self.tasks.removeLast(2)
            tableView.reloadData()
        }
    }
    
    // 셀 스위치 on/off 함수
    @objc private func switchChanged(_ sender: UISwitch!) {
        tasks[sender.tag].isSwitchOn = sender.isOn
        // 화면 잠금 스위치 작동
        if sender.tag == 0 {
            if sender.isOn {
                let registerPasscode = PasscodeViewController()
                registerPasscode.modalPresentationStyle = .fullScreen
                registerPasscode.passcodeMode = .new
                present(registerPasscode, animated: true)
                
                if tasks.count == 1 {
                    let task1 = Task(imageName: "faceid", title: "Touch ID, Face ID 사용", isSwitch: true, isSwitchOn: isBiometry())
                    let task2 = Task(imageName: "lock.rotation", title: "비밀번호 변경", isSwitch: false, isSwitchOn: false)
                    tasks.append(task1)
                    tasks.append(task2)
                    tableView.reloadData()
                }
            } else {
                // 키체인 삭제
                if keyChainManager.deleteItem(key: "passcode") {
                    fatchTable()
                }
            }
        }
        
        // 생체인증 스위치 작동
        if sender.tag == 1 {
            if sender.isOn {
                if isBiometry() {
                    tasks[1].isSwitchOn = true
                } else {
                    let alert = UIAlertController(title: "Touch ID 또는 Face ID 사용불가", message: "현재 Touch ID 또는 Face ID 등독이 되어 있지 않습니다.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "확인", style: .cancel)
                    alert.addAction(alertAction)
                    present(alert, animated: true)
                    tasks[1].isSwitchOn = false
                    sender.isOn = false
                }
            } else {
                tasks[1].isSwitchOn = false
            }
        }
    }
}

extension Notification.Name {
    static let fatchLabel = Notification.Name("fatchTable")
}
