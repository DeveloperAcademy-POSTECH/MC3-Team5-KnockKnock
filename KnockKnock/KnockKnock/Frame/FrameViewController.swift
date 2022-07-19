//
//  FrameViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/19.
//

import UIKit
import PhotosUI

class FrameViewController: UIViewController {
    
    var itemProviders: [NSItemProvider] = []
    
    private let cancelButton : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("버튼입니당", for: .normal)
        button.tintColor = .cyan
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.readAlbumCoreData()
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(cancelButton)
        //CollectionView AutoLayout
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
        CoreDataManager.shared.readAlbumCoreData()
        collectionView.reloadData()
    }
    
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
    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated:true)
    }
}


extension FrameViewController: PHPickerViewControllerDelegate {
    //받아온 이미지를 imageArray 배열에 추가
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]){
        dismiss(animated:true)
        itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage else { return }
                        CoreDataManager.shared.saveAlbumCoreData(image: image.pngData()!)
                        CoreDataManager.shared.readAlbumCoreData()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        
       
    }
}

extension FrameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
//        self.imageArray.count
        return CoreDataManager.shared.albumImageArray!.count
    }
    
    //CollectionView의 각 cell에 이미지 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumImageCell.id, for: indexPath) as! albumImageCell
        
        cell.prepare(image:UIImage(data: CoreDataManager.shared.albumImageArray!.reversed()[indexPath.item].value(forKey: "image") as! Data))
                     
        return cell
      }
}

//CollectionView의 이미지 클릭시 CellDetailView 표시
extension FrameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellDetailVC = CellDetailViewController()
        cellDetailVC.getindex = indexPath.item
        cellDetailVC.getimage = UIImage(data: CoreDataManager.shared.albumImageArray!.reversed()[indexPath.item].value(forKey: "image") as! Data)
        self.navigationController?.pushViewController(cellDetailVC,animated: true)
    }
}
