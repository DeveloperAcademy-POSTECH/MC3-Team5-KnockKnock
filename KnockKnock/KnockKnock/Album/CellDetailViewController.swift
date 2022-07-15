//
//  CellDetailViewController.swift
//  KnockKnock
//
//  Created by hurdasol on 2022/07/15.
//

import UIKit

class CellDetailViewController: UIViewController {
    //받아오는 이미지
    var getimage: UIImage?
    //이미지뷰
    var simageView: UIImageView = {
        var imgView = UIImageView()
        imgView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    //MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //이미지뷰의 이미지를 받아온 이미지 넣기
        simageView.image = self.getimage
        view.addSubview(simageView)
        
        //이미지뷰 레이아웃
        simageView.translatesAutoresizingMaskIntoConstraints = false
        simageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        simageView.heightAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        simageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        simageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
}
