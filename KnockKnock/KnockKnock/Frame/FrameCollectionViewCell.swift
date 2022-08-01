//
//  FrameCollectionViewCell.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/19.
//

import UIKit

class FrameCollectionViewCell: UICollectionViewCell {
    static let id = "frameImageCell"
    
    //Cell에 ImageView 추가
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @available(*, unavailable)
    required init?(coder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        
        //Cell 내에서 ImageView의 위치 지정
        self.contentView.addSubview(self.imageView)
        NSLayoutConstraint.activate([
              self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
              self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
              self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
              self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }
    
    //이미지 할당
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(image:nil)
    }
    func prepare(image: UIImage?){
        self.imageView.image = image
    }
}
