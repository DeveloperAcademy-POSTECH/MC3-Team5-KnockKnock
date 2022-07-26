//
//  CenterDataManager.swift
//  KnockKnock
//
//  Created by LeeJaehoon on 2022/07/25.
//

import Foundation

class CenterDataManager {
    
    static let shared = CenterDataManager()
    var centerData: [CenterModel] = []
    
    func centerInfoParse() {
        guard let path = Bundle.main.path(forResource: "CenterInfo", ofType: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        
        
        guard let data = data,
              let centers = try? decoder.decode([CenterModel].self, from: data) else {
            return
        }
        self.centerData = centers
        
    }
    
    func getCenterData() -> [CenterModel] {
        return centerData
    }
    
}
