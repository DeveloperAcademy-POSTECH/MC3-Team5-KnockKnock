//
//  KeychainManager.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import Foundation

class KeychainManager {
    
    ///kSecClassGenericPassword : 일반 암호 항목을 나타내는 값  <--- 사용
    ///kSecClassInternetPassword : 인터넷 비밀번호 항목을 나타내는 값.
    ///kSecClassCertificate : 인증서 항목을 나타내는 .
    ///kSecClassIdentity: ID 항목을 나타내는 값.
    ///kSecClassKey : 암호화 키 항목을 나타내는 값.
    
    
    // 키체인 저장하기
    func addItem(key: Any, pwd: Any) -> Bool {
        
        // 키체인 생성을 위한 쿼리(CFDictionary; addQuery)를 작성
        //kSecClass : 데이터의 종류를 지정
        //kSecAttrAccount : 데이터 저장을 위한 키를 입력
        //kSecValueData : 저장될 데이터를 Data Type으로 형변환하여 전달
        
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: key,
                                         kSecValueData: (pwd as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return updateItem(value: pwd, key: key)
            }
            
            print("addItem Error : \(status.description))")
            return false
        }()
        return result
    }
    
    // 키체인 읽기
    func getItem(key: Any) -> Any? {
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key,
                                      kSecReturnAttributes: true,
                                      kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        print("getItem Error : \(result.description)")
        return nil
    }
    
    // 키체인 업데이트
    func updateItem(value: Any, key: Any) -> Bool {
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                              kSecAttrAccount: key]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess { return true }
            
            print("updateItem Error : \(status.description)")
            return false
        }()
        
        return result
    }
    
    // 키체인 삭제
    func deleteItem(key: String) -> Bool {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                            kSecAttrAccount: key]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess { return true }
        
        print("deleteItem Error : \(status.description)")
        return false
    }   
}
