//
//  CellDetailViewController.swift
//  KnockKnock
//
//  Created by hurdasol on 2022/07/15.
//

import UIKit

class CellDetailViewController: UIViewController {
    //해당 셀의 이미지 받아오기
    var getimage: UIImage?
    var getindex: Int?
    
    //ImageView
    var detailImageView: UIImageView = {
        var imgView = UIImageView()
        imgView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    //MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //ImageView의 이미지에 받아온 이미지 넣기
        detailImageView.image = self.getimage
        view.addSubview(detailImageView)
        
        //NavigationBar에 삭제 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(trashTapped))
        
        //ImageView 레이아웃
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        detailImageView.heightAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        detailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true  
    }
    
    //앨범 사진 삭제 함수
    @objc func trashTapped() {
        // alert 먼저 뜸
        let alert = UIAlertController(title: "사진 삭제", message: "사진을 삭제하시겠습니까?", preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { [self] action in
            CoreDataManager.shared.deleteAlbumCoreData(object: CoreDataManager.shared.albumImageArray!.reversed()[getindex!])
            CoreDataManager.shared.readAlbumCoreData()
            navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소 버튼이 눌림")
        }
        alert.addAction(success)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
