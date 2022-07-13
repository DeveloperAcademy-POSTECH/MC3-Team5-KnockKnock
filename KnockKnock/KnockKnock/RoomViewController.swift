//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.image = myImage
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(memoImageView)
        
        memoImageView.translatesAutoresizingMaskIntoConstraints = false
        memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
    }
    
}

