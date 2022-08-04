//
//  MainFrameViewController.swift
//  KnockKnock
//
//  Created by HWANG-C-K on 2022/07/18.
//

import UIKit

class MainFrameViewController: UIViewController {
    
    //액자 사진 ImageView
    var frameImageView: UIImageView = {
        let frameView = UIImageView()
        frameView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        frameView.translatesAutoresizingMaskIntoConstraints = false
        frameView.contentMode = .scaleAspectFit
        return frameView
    }()
    //액자 사진 확대를 위해 scrollView를 만들고 이미지뷰를 넣음
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentMode = .scaleAspectFit
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        readImage()
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //scrollView 세팅
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.addSubview(frameImageView)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        //NavigationBar에 설정 버튼 생성
        navigationItem.title = "액자"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(actionSheet))
        
        //frameImageView AutoLayout
        NSLayoutConstraint.activate([
            self.scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/3),
            self.scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            self.frameImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.frameImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/3)
        ])
    
        print("\(String(describing: CoreDataManager.shared.frameImage?.count))")
    }
    
    //ActionSheet 함수
    @objc func actionSheet (_ sender: Any) {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //ActionSheet 버튼 생성 및 추가
        let cancelAction = UIAlertAction(title:"돌아가기", style: UIAlertAction.Style.cancel, handler: nil)
        let changeAction = UIAlertAction(title:"액자 사진 변경하기", style: .default, handler: { action in
            self.frameTapped()
        })
        let defaultAction = UIAlertAction(title:"기본 사진으로 변경하기", style: .default, handler: {
            action in self.defaultTapped()
        })
        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        alert.addAction(defaultAction)
        
        present(alert, animated:true)
    }
    
    //액자 사진 변경하기 버튼 함수
    func frameTapped() {
        let frame = FrameViewController()
        frame.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(frame, animated:true)
    }
    
    //기본 사진으로 변경하기 함수
    func defaultTapped() {
        DispatchQueue.main.async {
            //CoreData에 이미지가 존재하는 경우 제거
            if CoreDataManager.shared.frameImage!.count > 0 {
                CoreDataManager.shared.deleteFrameCoreData(object: (CoreDataManager.shared.frameImage?.first!)!)
            }
            
            //CoreData에 기본 이미지 추가
            CoreDataManager.shared.saveFrameCoreData(image: (UIImage(named: "frame person")?.pngData())!)
            CoreDataManager.shared.readFrameCoreData()
            self.frameImageView.image = UIImage(data:(CoreDataManager.shared.frameImage?.last?.value(forKey: "image") as? Data)!)
        }
    }
    
    //CoreData의 이미지를 불러와서 표시하는 함수
    func readImage() {
        CoreDataManager.shared.readFrameCoreData()
        guard let image = CoreDataManager.shared.frameImage?.last else {return}
        frameImageView.image = UIImage(data: image.value(forKey: "image") as! Data)
    }
}

// 스크롤뷰 줌기능 함수
extension MainFrameViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return frameImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = frameImageView.image {
                let ratioW = frameImageView.frame.width / image.size.width
                let ratioH = frameImageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > frameImageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - frameImageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > frameImageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - frameImageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}

