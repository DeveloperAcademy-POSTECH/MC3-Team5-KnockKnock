//
//  MainMemoView.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit
import CoreData

class MainMemoView: UIViewController {
    
    // TableView 생성
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.readCoreData()
        tableView.reloadData()
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backGroundColor")
        
        // 메모 CoreData 불러오기
        CoreDataManager.shared.readCoreData()
        
        // 네비게이션 아이템 생성
        navigationItem.title = "다이어리".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToMemoVC))
        
        // TableView 추가
        view.addSubview(tableView)
        applyConstraints()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
    }
    
    // TableView Constraints 함수
    private func applyConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
    // 메모 작성 버튼 함수
    @objc fileprivate func goToMemoVC(){
        let memoVC = MemoDetailViewController()
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
}

extension MainMemoView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = CoreDataManager.shared.resultArray?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        guard let result = CoreDataManager.shared.resultArray?.reversed()[indexPath.item] else { return UITableViewCell() }
        cell.setUI(result: result)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.deleteCoreData(object: CoreDataManager.shared.resultArray!.reversed()[indexPath.item])
            CoreDataManager.shared.readCoreData()
            tableView.reloadData()
        }
    }
    
    // Cell 클릭 시 해당 메모 화면으로 이동 create by JERRY
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath) as! MainTableViewCell)
        let resultArraySize = CoreDataManager.shared.resultArray?.count
        let index = resultArraySize! - indexPath.row - 1
        let cell = CoreDataManager.shared.resultArray![index]
        
        let memoVC = MemoDetailViewController()
        memoVC.set(result: cell)
        navigationController?.pushViewController(memoVC, animated: true)
    }
}

// TableView에 들어가는 메모 Cell 형식
class MainTableViewCell: UITableViewCell {
    
    var title = UILabel()
    var memo = UILabel()
    var date = UILabel()
    private let memoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    static let reuseIdentifier: String = "MainTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date) // "January 14, 2021"
    }
    
    func setUI(result: NSManagedObject) {
        // 테이블 뷰 세팅
        self.title.text = result.value(forKey: "title") as? String
        self.memo.text = result.value(forKey: "memo") as? String
        if let date = result.value(forKey: "date") as? Date {
            self.date.text = getStringFromDate(date: date)
        }
        self.memoImage.image = UIImage(data: result.value(forKey: "image") as! Data)
        
        self.addSubview(title)
        self.addSubview(memo)
        self.addSubview(date)
        self.addSubview(memoImage)
        
        if memoImage == UIImage(systemName: "photo"){
        memoImage.backgroundColor = .white
        memoImage.translatesAutoresizingMaskIntoConstraints = false
        memoImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        memoImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        memoImage.topAnchor.constraint(equalTo: self.topAnchor, constant:  14).isActive = true
        memoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  14).isActive = true
        memoImage.layer.masksToBounds = true
        memoImage.layer.cornerRadius = 10
        } else {
            memoImage.translatesAutoresizingMaskIntoConstraints = false
            memoImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
            memoImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
            memoImage.topAnchor.constraint(equalTo: self.topAnchor, constant:  14).isActive = true
            memoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  14).isActive = true
            memoImage.layer.masksToBounds = true
            memoImage.layer.cornerRadius = 10
        }
        
        title.font = UIFont(name: "MapoFlowerIsland", size: 19)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 21).isActive = true
        title.leadingAnchor.constraint(equalTo: memoImage.trailingAnchor, constant: 14).isActive = true
        
        if memo.text == "메모를 입력해주세요.".localized() {
            memo.textColor = UIColor(named: "memoColor")
            memo.font = UIFont(name: "MapoFlowerIsland", size: 16)
            memo.text = " "
            memo.translatesAutoresizingMaskIntoConstraints = false
            memo.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7).isActive = true
            memo.leadingAnchor.constraint(equalTo: memoImage.trailingAnchor, constant: 14).isActive = true
        } else {
            memo.textColor = UIColor(named: "memoColor")
            memo.font = UIFont(name: "MapoFlowerIsland", size: 16)
            memo.translatesAutoresizingMaskIntoConstraints = false
            memo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14).isActive = true
            memo.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7).isActive = true
            memo.leadingAnchor.constraint(equalTo: memoImage.trailingAnchor, constant: 14).isActive = true
        }
        
        date.textColor = UIColor(named: "dateColor")
        date.font = UIFont(name: "MapoFlowerIsland", size: 14)
    
        date.translatesAutoresizingMaskIntoConstraints = false
        date.leadingAnchor.constraint(equalTo: memoImage.trailingAnchor, constant: 14).isActive = true
        date.topAnchor.constraint(equalTo: memo.bottomAnchor, constant: 6).isActive = true
    }
}
