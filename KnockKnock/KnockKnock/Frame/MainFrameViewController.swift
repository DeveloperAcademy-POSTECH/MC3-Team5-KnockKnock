//
//  MainFrameViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/18.
//

import UIKit

class MainFrameViewController: UIViewController {
    
    //액자 사진 ImageView
    var frameImageView: UIImageView = {
        let frameView = UIImageView()
        frameView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        frameView.contentMode = .scaleAspectFit
        return frameView
    }()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        readImage()
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(frameImageView)
        navigationItem.title = "액자"
        //NavigationBar에 설정 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(actionSheet))
        
        //frameImageView AutoLayout
        NSLayoutConstraint.activate([
            self.frameImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.frameImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/3),
            self.frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.frameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        readImage()
    
        print("\(String(describing: CoreDataManager.shared.frameImage?.count))")
    }
    
    //ActionSheet 함수
    @objc func actionSheet (_ sender: Any) {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //ActionSheet 버튼 생성 및 추가
        let cancelAction = UIAlertAction(title:"돌아가기", style: UIAlertAction.Style.cancel, handler: nil)
        let changeAction = UIAlertAction(title:"액자 사진 변경하기", style: .default, handler: { action in
            self.frameTapped()
        })
        let defaultAction = UIAlertAction(title:"기본 사진으로 변경하기", style: .default, handler: {
            action in self.defaultTapped()
        })
        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        alert.addAction(defaultAction)
        
        present(alert, animated:true)
    }
    
    //액자 사진 변경하기 버튼 함수
    func frameTapped() {
        let frame = FrameViewController()
        frame.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(frame, animated:true)
    }
    
    //기본 사진으로 변경하기 함수
    func defaultTapped() {
        DispatchQueue.main.async {
            //CoreData에 이미지가 존재하는 경우 제거
            if CoreDataManager.shared.frameImage!.count > 0 {
                CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
            } else { }
            
            //CoreData에 기본 이미지 추가
            CoreDataManager.shared.saveFrameCoreData(image: (UIImage(named: "frame person")?.jpegData(compressionQuality: 0))!)
            CoreDataManager.shared.readFrameCoreData()
            self.frameImageView.image = UIImage(data:(CoreDataManager.shared.frameImage?.last?.value(forKey: "image") as? Data)!)
        }
        
        frameImageView.image?.didChangeValue(forKey: "image")
        frameImageView.setNeedsDisplay()
    }
    
    //CoreData의 이미지를 불러와서 표시하는 함수
    func readImage() {
        CoreDataManager.shared.readFrameCoreData()
        guard let image = CoreDataManager.shared.frameImage?.last else {return}
        frameImageView.image = UIImage(data: image.value(forKey: "image") as! Data)
        frameImageView.setNeedsDisplay()
    }
}
