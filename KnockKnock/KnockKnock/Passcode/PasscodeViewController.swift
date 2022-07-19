//
//  PasscodeViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import LocalAuthentication
import UIKit

class PasscodeViewController: UIViewController {
    
    var passcodes = [Int]()
    var userPasscodes = [5, 9, 5, 9]
    
    
    let passcodeImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "doorBackground")
        passcodeField()
        setupNumberPad()
    }
    
    
    private func passcodeField() {
        
        let passcodeButtonHeight = (view.frame.size.width / 12) * 3.5
        
        let titleLabel: UILabel = {
            let label = UILabel()
            //            label.font = UIFont(name: label.font.fontName, size: 35)
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.text = "암호 입력"
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let subTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "암호를 입력해 주세요."
            label.textColor = .systemFill
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            return stackView
        }()
        
        let hStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 30
            return stackView
        }()
        
        
        view.addSubview(vStackView)
        
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subTitleLabel)
        vStackView.addArrangedSubview(hStackView)
        
        hStackView.addArrangedSubview(passcodeImage1)
        hStackView.addArrangedSubview(passcodeImage2)
        hStackView.addArrangedSubview(passcodeImage3)
        hStackView.addArrangedSubview(passcodeImage4)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -passcodeButtonHeight),
        ])
    }
    
    private func setupNumberPad() {
        
        let buttonWidthSize = view.frame.size.width / 3
        let buttonHeightSize = buttonWidthSize / 2
        
        
        for n in 0..<3 {
            for m in 0..<3 {
                let button = UIButton(frame: CGRect(x: buttonWidthSize * CGFloat(m), y: view.frame.size.height - buttonHeightSize * (4.5 - CGFloat(n)), width: buttonWidthSize, height: buttonHeightSize))
                button.setTitleColor(.label, for: .normal)
                
//                button.backgroundColor = .white
                button.setTitle(String((m + 1) + (n * 3)), for: .normal)
                button.tag = (m + 1) + (n * 3)
                button.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
        
        let faceButton = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        faceButton.setTitleColor(.label, for: .normal)
//        faceButton.backgroundColor = .white
        faceButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        faceButton.tintColor = .label
        faceButton.tag = 11
        view.addSubview(faceButton)
        
        let zeroButton = UIButton(frame: CGRect(x: buttonWidthSize, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        zeroButton.setTitleColor(.label, for: .normal)
//        zeroButton.backgroundColor = .white
        zeroButton.setTitle("0", for: .normal)
        zeroButton.tag = 0
        zeroButton.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
        view.addSubview(zeroButton)
        
        let deleteButton = UIButton(frame: CGRect(x: buttonWidthSize * 2, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        deleteButton.setTitleColor(.label, for: .normal)
//        deleteButton.backgroundColor = .white
        deleteButton.setImage(UIImage(systemName: "delete.backward"), for: .normal)
        deleteButton.tintColor = .label
        deleteButton.tag = 12
        deleteButton.addTarget(self, action: #selector(deletePressed(_ :)), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
    
    @objc private func numberPressed(_ sender: UIButton) {
        let number = sender.tag
        passcodes.append(number)
        update()
        
    }
    
    @objc private func deletePressed(_ sender: UIButton) {
        passcodes.removeLast()
        print(passcodes)
        update()
    }
    
    private func update() {
        print(passcodes)
        
        if passcodes.count == 4 {
            if passcodes == userPasscodes {
                print("비밀번호 정답")
                self.dismiss(animated: false)
            } else {
                print("비밀번호 오답")
                passcodes.removeAll()
            }
            
        }
        passcodeImage1.image = UIImage(systemName: passcodes.count > 0 ? "circle.fill" : "minus")
        passcodeImage2.image = UIImage(systemName: passcodes.count > 1 ? "circle.fill" : "minus")
        passcodeImage3.image = UIImage(systemName: passcodes.count > 2 ? "circle.fill" : "minus")
        passcodeImage4.image = UIImage(systemName: passcodes.count > 3 ? "circle.fill" : "minus")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
