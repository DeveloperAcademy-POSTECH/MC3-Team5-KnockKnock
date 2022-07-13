//
//  MemoDetailViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

import UIKit

class MemoDetailViewController: UIViewController {
    let imageView = UIImageView(image: nil)
    let button = UIButton(type: .custom)
    let field = UITextField()
    let textView = UITextView()
    let titleFieldPlaceHolder = "제목을 입력해주세요."
    let textViewPlaceHolder = "메모를 입력해주세요."
    let date = NSDate() // 현재 시간 가져오기
    let formatter = DateFormatter()
    
    // 키보드 아무화면이나 누르면 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishMemo(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleTextField()
        createImageButton()
        memoTextView()
    }
    
    func titleTextField() {
        
        field.placeholder = titleFieldPlaceHolder
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 30)
        
        self.view.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        field.heightAnchor.constraint(equalToConstant: view.bounds.height / 20).isActive = true
        field.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 8).isActive = true
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func createImageButton() {
        let image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: view.bounds.height / 10))
        
        // 이미지뷰가 비었을때 image 차있을 때 imageView
        button.setImage(imageView.image == nil ? image : imageView.image, for: .normal)
        button.imageView?.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10   ).isActive = true
    }
    
    
    func memoTextView() {
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = self
        textView.backgroundColor = .clear
        
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
    }
    
    
    @objc fileprivate func finishMemo(_ sender: UIButton){
        // 객체 인스턴스 생성
//        formatter.locale = Locale(identifier: "ko") // 로케일 변경
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
//        print("현재시간: " + formatter.string(from: date as Date))
        if field.text == "" {
            
            let alert = UIAlertController(title: "제목을 꼭 적어주세요!", message: "", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            
        } else {
            CoreDataManager.shared.saveCoreData(title: field.text ?? "제목이 없어요", memo: textView.text ?? "메모가 없어요", image: imageView.image?.pngData() ?? UIImage(systemName: "photo")?.pngData() as! Data)
            
            navigationController?.popViewController(animated: true)
            
            
        }
    }
    
    
    @objc fileprivate func didTapButton(_ sender: UIButton){
        // 객체 인스턴스 생성
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension MemoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
        }
        createImageButton()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension MemoDetailViewController: UITextViewDelegate {
    // 클릭 되있을때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
        if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= view.bounds.height / 4.5
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


