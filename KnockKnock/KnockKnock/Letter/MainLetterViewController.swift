//
//  MainLetterViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/17.
//

import UIKit

var letterCloseCheck: Bool = false

class MainLetterViewController: UIViewController {

    
    let paperPlainImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(systemName: "paperplane.fill")!
        imageView.image = myImage
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    let letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letterBackGround")!
        //    .alpha(0.5)
        imageView.image = myImage
        return imageView
    }()
    
    let textView = UITextView()
    
    let textViewPlaceHolder = "편지를 입력해주세요."

    let letterTextField = UITextField()
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .rotateBack, object: nil)
    }
    
    override func viewDidLoad() {
        
        view.addSubview(letterImageView)
        
        letterImageView.translatesAutoresizingMaskIntoConstraints = false
        letterImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        letterImageView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        
        view.addSubview(paperPlainImageView)
        paperPlainImageView.translatesAutoresizingMaskIntoConstraints = false
        paperPlainImageView.trailingAnchor.constraint(equalTo: letterImageView.trailingAnchor, constant: -15).isActive = true
        paperPlainImageView.topAnchor.constraint(equalTo: letterImageView.topAnchor, constant: 15).isActive = true
        paperPlainImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        paperPlainImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // MARK: 메모사진이 터치 가능하도록 함
        paperPlainImageView.isUserInteractionEnabled = true
        paperPlainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpDismissModalButton)))
        
        createTextView()
        
        let label = UILabel()
        label.text = "To."
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        label.font = UIFont(name: "SawarabiMincho-Regular", size: 24)
        
        
        
        view.addSubview(letterTextField)
        letterTextField.translatesAutoresizingMaskIntoConstraints = false
        letterTextField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5).isActive = true
        letterTextField.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        letterTextField.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        letterTextField.font = UIFont(name: "MapoFlowerIsland", size: 22)
        

    }
    
    
    @objc
    func touchUpDismissModalButton(_ sender: UIButton) {
        if textView.text == "편지를 입력해주세요." || textView.text.count == 0 {
            
        } else {
            self.dismiss(animated: true, completion: nil)
            letterCloseCheck = true
            RoomViewController().reloadInputViews()
        }
        
    }
    
    func createTextView() {
        view.addSubview(textView)
        
        
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: view.bounds.width - 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        // 텍스트뷰 커스텀(행간)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        textView.attributedText = NSAttributedString(string: textViewPlaceHolder, attributes: attributes)
        textView.textColor = .lightGray
        textView.font = UIFont(name: "MapoFlowerIsland", size: 18)
        textView.delegate = self
        // 마진
        textView.textContainer.lineFragmentPadding = 20
        textView.backgroundColor = .clear
    }
    
}

extension MainLetterViewController: UITextViewDelegate {
    // 클릭 되있을때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}




extension UIImage {
    
    // 오펙 주기위한 extension
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

