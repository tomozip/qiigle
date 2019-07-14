//
//  Api.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Moya
import RxSwift

import Moya

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum QiitaTarget {
    case articles(String, Int)
    case trends(Int)
    case likes(String, Int)
}

extension QiitaTarget: TargetType {
    var baseURL: URL { return URL(string: "https://qiita.com/api/v2")! }
    var path: String {
        switch self {
        case .articles(_), .trends:
            return "/items"
        case let .likes(id, _):
            return "/items/\(id)/likes"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case let .articles(query, page):
            return .requestParameters(parameters: ["query": query, "page": page, "per_page": "20"], encoding: URLEncoding.queryString)
        case let .trends(page):
            return .requestParameters(parameters: ["query": "stocks:>20 created:>2018-03-01", "page": page, "per_page": "20"], encoding: URLEncoding.queryString)
        case let .likes(_, page):
            return .requestParameters(parameters: ["page": page, "per_page": "20"], encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]? { return nil }

    // テストの時などに、実際にAPIを叩かずにローカルのjsonファイルを読み込める
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}
