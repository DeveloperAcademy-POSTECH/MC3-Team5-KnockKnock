//
//  MemoDetailViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit
import CoreData

class MemoDetailViewController: UIViewController {
    let imageView = UIImageView(image: nil)
    let button = UIButton(type: .custom)
    let field = UITextField()
    let textView = UITextView()
    let titleFieldPlaceHolder = "제목을 입력해주세요.".localized()
    let textViewPlaceHolder = "메모를 입력해주세요.".localized()
    let date = NSDate() // 현재 시간 가져오기
    let formatter = DateFormatter()
    private var memoId: UUID?
    
    // 바깥 화면 누를 때 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료".localized(), style: .plain, target: self, action: #selector(finishMemo(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleTextField()
        createImageButton()
        memoTextView()
    }
    
    // 메모 제목 TextField
    func titleTextField() {
        field.placeholder = titleFieldPlaceHolder
        field.textAlignment = .left
        field.font = UIFont(name: "MapoFlowerIsland", size: 24)
        
        self.view.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: view.bounds.width - 50).isActive = true
        field.heightAnchor.constraint(equalToConstant: view.bounds.height / 20).isActive = true
        field.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 8).isActive = true
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // 메모 이미지 삽입 버튼
    func createImageButton() {
        let image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: view.bounds.height / 10))
        
        // ImageView가 비었을 때 / 차있을 때 지정
        button.setImage(imageView.image == nil ? image : imageView.image, for: .normal)
        button.imageView?.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray5
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width - 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10).isActive = true
    }
    
    // 메모 내용 TextView
    func memoTextView() {
        if memoId != nil {
            if textView.text == "메모를 입력해주세요.".localized() {
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 8
                let attributes = [NSAttributedString.Key.paragraphStyle : style]
                textView.attributedText = NSAttributedString(string: textViewPlaceHolder, attributes: attributes)
                textView.textContainer.lineFragmentPadding = 20

                textView.textColor = .lightGray
            } else {
                textView.textColor = .black
            }
        } else {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 8
            let attributes = [NSAttributedString.Key.paragraphStyle : style]
            textView.attributedText = NSAttributedString(string: textViewPlaceHolder, attributes: attributes)
            textView.textContainer.lineFragmentPadding = 20
            textView.textColor = .lightGray
        }
        textView.font = UIFont(name: "MapoFlowerIsland", size: 18)
        textView.delegate = self
        textView.backgroundColor = .clear
        
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
    }
    
    func set(result: NSManagedObject) {
        memoId = result.value(forKey: "id") as? UUID
        field.text = result.value(forKey: "title") as? String
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        let memoText = result.value(forKey: "memo") as? String ?? ""
        textView.attributedText = NSAttributedString(string: memoText , attributes: attributes)
        textView.textContainer.lineFragmentPadding = 20
        imageView.image = UIImage(data: result.value(forKey: "image") as! Data)
    }
    
    @objc fileprivate func finishMemo(_ sender: UIButton){
        // 제목이 빈 경우 알림창 표시
        if field.text == "" {
            let alert = UIAlertController(title: "제목을 적어주세요.".localized(), message: "", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            present(alert, animated: false, completion: nil)
        } else {
            // 이미 저장되어 있는 메모인 경우 업데이트
            if let memoId = memoId {
                CoreDataManager.shared.updateCoreData(id: memoId, title: field.text!, memo: textView.text, image: (imageView.image?.pngData())!)
            }
            // 새로 생성된 메모인 경우 저장
            else {
                CoreDataManager.shared.saveCoreData(title: field.text!, memo: textView.text, image: (imageView.image?.pngData() ?? UIImage(systemName: "photo")?.pngData())!)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func didTapButton(_ sender: UIButton){
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

// 메모 ImagePicker
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
    // 클릭되어 있을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= view.bounds.height / 4.5
        }
    }
    
    // 입력이 끝났을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}


