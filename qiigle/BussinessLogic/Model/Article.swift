//
//  Article.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Foundation

struct Article: Codable {

    let id: String
    let user: User
    let body: String
    let title: String
    let createdAt: String
    let likesCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case user
        case body
        case title
        case createdAt = "created_at"
        case likesCount = "likes_count"
    }
}
