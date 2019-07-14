//
//  Lke.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Foundation

struct Like: Codable {

    let user: User
    let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case user
        case createdAt = "created_at"
    }
}
