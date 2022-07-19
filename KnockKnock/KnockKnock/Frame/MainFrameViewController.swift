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
        frameImageView.image = (getimage == nil ? UIImage(systemName:"photo") : self.getimage)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        frameImageView.image = (getimage == nil ? UIImage(systemName:"photo") : self.getimage)
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
    }
    
    //ActionSheet 함수
    @objc func actionSheet (_ sender: Any) {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
            
        //ActionSheet 버튼 생성 및 추가
        let cancelAction = UIAlertAction(title:"돌아가기", style: UIAlertAction.Style.cancel, handler: nil)
        let changeAction = UIAlertAction(title:"액자 사진 변경하기", style: .default, handler: { action in
            self.frameTapped()
        })
        let defaultAction = UIAlertAction(title:"기본 사진으로 변경하기", style: .default, handler: {action in self.getimage = nil})
        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        alert.addAction(defaultAction)
        
        present(alert, animated:true)
     }
    
    func frameTapped() {
        let frame = FrameViewController()
        frame.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(frame, animated:true)
    }
   
}
