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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(frameImageView)

        //NavigationBar에 설정 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        
        frameImageView.image = UIImage(named:"letter")
        
        //frameImageView AutoLayout
        NSLayoutConstraint.activate([
              self.frameImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
              self.frameImageView.heightAnchor.constraint(equalTo: view.heightAnchor),
              self.frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              self.frameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
