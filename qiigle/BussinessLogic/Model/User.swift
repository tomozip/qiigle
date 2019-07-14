//
//  User.swift
//  OnaChat
//
//  Created by 島田智貴 on 2019/05/08.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Foundation

struct User: Codable {

    let id: String
    let profileImageUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image_url"
    }
}
