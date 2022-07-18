//
//  DoorViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/18.
//

import UIKit

class DoorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "doorBackground")
        doorSetup()
    }
    
    private func doorSetup() {
        
        let doorImageView: UIImageView = {
            let imageView = UIImageView()
            let myImage: UIImage = UIImage(named: "door")!
            imageView.image = myImage
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        view.addSubview(doorImageView)
    
        NSLayoutConstraint.activate([
            doorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.width / 10),
            doorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.width / 10),
            doorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 10),
            doorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width / 10)
        ])
    }
    

}
