//
//  SettingViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import UIKit

class SettingViewController: UIViewController {
    
    var tasks = [Task(title: "화면 잠금", isSwitch: true, isSwitchOn: false)]
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "비밀번호 설정"
        view.backgroundColor = .red
        self.tableViewSetup()
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


}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(task.isSwitchOn, animated: true)
                                switchView.tag = indexPath.row
                                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        if task.isSwitch {
            cell.accessoryView = switchView
        } else {
            cell.accessoryView = nil
        }
                                
        
        return cell
    }
    
    @objc private func switchChanged(_ Sender: UISwitch) {
        
    }
    
}
