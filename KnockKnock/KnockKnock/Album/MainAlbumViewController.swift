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
    
    //CollectionView 기본 설정
    private let gridFlowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        return layout
    }()
    
    //CollectionView 정의
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame:.zero, collectionViewLayout: self.gridFlowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInset = .zero
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.register(albumImageCell.self, forCellWithReuseIdentifier: "albumImageCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(collectionView)
        
        //NavigationBar에 ImagePicker 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentPicker))
        
        //CollectionView AutoLayout
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
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
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension MainAlbumViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //CollectionView Cell의 Size 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        guard
            let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else{fatalError()}
        
        let cellColumns = 3
        let widthOfCells = collectionView.bounds.width
        let widthOfSpacing = CGFloat(cellColumns - 1) * flowLayout.minimumInteritemSpacing
        let width = (widthOfCells-widthOfSpacing) / CGFloat(cellColumns)

        return CGSize(width: width, height: width)
    }
    
    //CollectionView에 표시되는 Item의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageArray.count
    }
    
    //CollectionView의 각 cell에 이미지 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumImageCell.id, for: indexPath) as! albumImageCell
        cell.prepare(image: self.imageArray[indexPath.item])
        return cell
      }
}
