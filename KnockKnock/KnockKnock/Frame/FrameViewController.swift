//
//  FrameViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/19.
//

import UIKit
import QCropper

class FrameViewController: UIViewController, UINavigationControllerDelegate {
    
    var itemProviders: [NSItemProvider] = []
    
    //취소 버튼
    private let cancelButton : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
    
    //MARK: - viewDidLoad
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
            
            cancelButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -15),
            cancelButton.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 15)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
        CoreDataManager.shared.readAlbumCoreData()
        collectionView.reloadData()
    }
    
    //취소 버튼 함수
    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated:true)
    }
}

extension FrameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //CollectionView Cell의 Size 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        guard
            let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError() }
        
        let cellColumns = 3
        let widthOfCells = collectionView.bounds.width
        let widthOfSpacing = CGFloat(cellColumns - 1) * flowLayout.minimumInteritemSpacing
        let width = (widthOfCells-widthOfSpacing) / CGFloat(cellColumns)

        return CGSize(width: width, height: width)
    }
    
    //CollectionView에 표시되는 Item의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.shared.albumImageArray!.count
    }
    
    //CollectionView의 각 cell에 이미지 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumImageCell.id, for: indexPath) as! albumImageCell
        
        cell.prepare(image:UIImage(data: CoreDataManager.shared.albumImageArray!.reversed()[indexPath.item].value(forKey: "image") as! Data))
                     
        return cell
      }
}

//CollectionView의 이미지 클릭 시 작동
extension FrameViewController: UICollectionViewDelegate, UIImagePickerControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //CoreData에 이미지 저장
        CoreDataManager.shared.saveFrameCoreData(image: (CoreDataManager.shared.albumImageArray!.reversed()[indexPath.item].value(forKey: "image") as? Data)!)
        
        //CoreData에 이미지가 더 존재하는 경우 처음 이미지 삭제
        if CoreDataManager.shared.frameImage!.count > 0 {
            CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
        }
        
        //추가중
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        if let imageData = CoreDataManager.shared.albumImageArray!.reversed()[indexPath.item].value(forKey: "image") as? Data {
            if let image = UIImage(data: imageData) {
                print(image)
                let cropper = CropperViewController(originalImage: image)
                cropper.delegate = self
                picker.dismiss(animated: true) {
                    let alert = UIAlertController(title: "액자 사진 비율 안내",
                                                  message: "종횡비 3:4가 가장 적합합니다.",
                                                  preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "확인", style: .default, handler: {
                        action in self.present(cropper, animated: true, completion: nil)
                    })
                    alert.addAction(alertAction)
                    self.present(alert, animated:true)
                }
            }
        }
    }
}

// 크롭된 이미지 저장
extension FrameViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state, let image = cropper.originalImage.cropped(withCropperState: state) {
            //CoreData에 이미지가 존재하는 경우 제거
            if CoreDataManager.shared.frameImage!.count > 0 {
                CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
            }
            //CoreData에 이미지 저장
            CoreDataManager.shared.saveFrameCoreData(image: image.pngData()!)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
