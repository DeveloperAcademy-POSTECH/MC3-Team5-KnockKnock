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
        return imageView
    }()
    
    let textView = UITextView()
    
    let textViewPlaceHolder = "편지를 입력해주세요."
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .rotateBack, object: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(paperPlainImageView)
        paperPlainImageView.translatesAutoresizingMaskIntoConstraints = false
        paperPlainImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        paperPlainImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paperPlainImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        paperPlainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        
        // MARK: 메모사진이 터치 가능하도록 함
        paperPlainImageView.isUserInteractionEnabled = true
        paperPlainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpDismissModalButton)))
        
        createTextView()
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
        textView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = self

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



