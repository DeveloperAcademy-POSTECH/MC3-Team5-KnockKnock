//
//  CellDetailViewController.swift
//  KnockKnock
//
//  Created by hurdasol on 2022/07/15.
//

import UIKit

class CellDetailViewController: UIViewController {

    var slabel: UILabel = {
        var label = UILabel()
        label.text = "성공"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .cyan
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(slabel)
        slabel.translatesAutoresizingMaskIntoConstraints = false
        slabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        slabel.heightAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        slabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        

        
    }


}
