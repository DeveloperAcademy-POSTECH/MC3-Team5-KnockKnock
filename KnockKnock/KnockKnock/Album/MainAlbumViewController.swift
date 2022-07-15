//
//  MainAlbumViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/15.
//

import UIKit
import PhotosUI

class MainAlbumViewController: UIViewController {
    
    var itemProviders: [NSItemProvider] = []
    var imageArray: [UIImage] = []
    
    //ImagePicker 작동 버튼
    lazy var pickerButton: UIButton! = {
        let button = UIButton(type:.system)
        button.setTitle("Image", for:.normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(presentPicker(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //ImagePicker 함수
    @objc func presentPicker(_ sender: Any) {
        //ImagePicker 기본 설정
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        //Picker 표시
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(pickerButton)
        
        //pickerButton AutoLayout
        pickerButton.adjustsImageSizeForAccessibilityContentSizeCategory = false
        pickerButton.topAnchor.constraint(equalTo: view.topAnchor, constant:100).isActive = true
        pickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:CGFloat(0.04)).isActive = true
        pickerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(0.15)).isActive = true
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


extension MainAlbumViewController: PHPickerViewControllerDelegate {
    //받아온 이미지를 imageArray 배열에 추가
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]){
        dismiss(animated:true)
        itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage else { return }
                        self.imageArray.append(image)
                    }
                }
            }
        }
    }
}
