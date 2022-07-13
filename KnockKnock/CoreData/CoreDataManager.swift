//
//  CoreDataManager.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit
import CoreData

class CoreDataManager {
    // 어디서든 쓰기위해 설정
    static let shared = CoreDataManager()
    
    var resultArray: [NSManagedObject]?
    
    func saveCoreData(title: String, memo: String, image: Data) {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // App Delegate 내부에 있는 viewContext 호출
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 값 설정
        object.setValue(title, forKey: "title")
        object.setValue(memo, forKey: "memo")
        object.setValue(Date(), forKey: "date")
        object.setValue(UUID(), forKey: "id")
        object.setValue(image, forKey: "image")
        
        do {
            // managedContext 내부의 변경사항 저장
            try managedContext.save()
        } catch let error as NSError {
            // 에러 발생시
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
