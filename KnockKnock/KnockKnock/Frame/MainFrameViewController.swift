//
//  MainFrameViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/18.
//

import UIKit

class MainFrameViewController: UIViewController {
    
    var getimage: UIImage?
    var getindex: Int?
    
    //액자 사진 ImageView
    var frameImageView: UIImageView = {
        let frameView = UIImageView()
        frameView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        frameView.contentMode = .scaleAspectFit
        return frameView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if ((CoreDataManager.shared.frameImage?.isEmpty) == nil) {
//            print("hi")
//
//        } else {
//        CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
//        }
        CoreDataManager.shared.readFrameCoreData()
        
        print("viewWillAppear 1")
        guard let image = CoreDataManager.shared.frameImage?.last else {return}
        frameImageView.image = UIImage(data: image.value(forKey: "image") as! Data)
        frameImageView.setNeedsDisplay()
        print("viewWillAppear 2")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //        frameImageView.image = (getimage == nil ? UIImage(systemName:"photo") : self.getimage)
        view.addSubview(frameImageView)
        
        //NavigationBar에 설정 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(actionSheet))
        
        //frameImageView AutoLayout
        NSLayoutConstraint.activate([
            self.frameImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.frameImageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            self.frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.frameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        print("viewDidLoad 1")
        CoreDataManager.shared.readFrameCoreData()
        guard let image = CoreDataManager.shared.frameImage?.last else {return}
        guard let frameImageData = image.value(forKey: "image") as? Data else {
            print("frameImageData 터짐")
            return }
        
        
        frameImageView.image = UIImage(data: frameImageData)
        frameImageView.setNeedsDisplay()
        
        print("viewDidLoad 2")
        print("\(CoreDataManager.shared.frameImage?.count)")
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
    
    func frameTapped() {
        let frame = FrameViewController()
        frame.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(frame, animated:true)
    }
    func defaultTapped() {
        CoreDataManager.shared.saveFrameCoreData(image: (UIImage(systemName: "photo")?.pngData())!)
        CoreDataManager.shared.readFrameCoreData()
        CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
        frameImageView.image?.didChangeValue(forKey: "image")
        frameImageView.setNeedsDisplay()
    }
    
    
}
