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
    var albumImageArray: [NSManagedObject]? = []
    
    //MARK: - 메모 부분 CoreData
    
    //데이터 저장
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
    
    //데이터 불러오기
    func readCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity의 fetchRequest 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        
        do {
            // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
            let resultCDArray = try managedContext.fetch(fetchRequest)
            self.resultArray = resultCDArray

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCoreData(object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 객체를 넘기고 바로 삭제
        managedContext.delete(object)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    //데이터 업데이트
    func updateCoreData(id: UUID, title: String, memo: String, image: Data) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let object = result[0] as! NSManagedObject
            
            object.setValue(title, forKey: "title")
            object.setValue(memo, forKey: "memo")
            object.setValue(image, forKey: "image")
            
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    // MARK: - 앨범 부분 CoreData
    //[CREATE]
    func saveAlbumCoreData(image: Data) {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // App Delegate 내부에 있는 viewContext 호출
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "Album", in: managedContext)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 값 설정
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
    
    //[READ]
    func readAlbumCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity의 fetchRequest 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Album")
        
        do {
            // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
            let resultCDArray = try managedContext.fetch(fetchRequest)
            self.albumImageArray = resultCDArray

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //[DELETE]
    func deleteAlbumCoreData(object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 객체를 넘기고 바로 삭제
        managedContext.delete(object)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
}
