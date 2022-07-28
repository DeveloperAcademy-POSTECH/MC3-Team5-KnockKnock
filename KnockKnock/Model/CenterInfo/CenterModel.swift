//
//  CenterModel.swift
//  KnockKnock
//
//  Created by LeeJaehoon on 2022/07/25.
//

import Foundation

struct CenterModel: Codable {
    let name: String
    let address: String
    let tel: String
    let url: String
    let gps: GpsInfo
}

struct GpsInfo: Codable {
    let latitude: Double // 위도
    let longitude: Double // 경도
}
