//
//  LoggerPlugin.swift
//  Iyashi
//
//  Created by nukotsuka on 2019/03/27.
//  Copyright © 2019 Arriv, Inc. All rights reserved.
//

import Moya
import Result

class LoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        let representation = request.request?.representation ?? ""
        print("ℹ️: 🚀 \(representation)")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            let representation = response.request?.representation ?? ""
            DispatchQueue.global(qos: .background).async {
                let emoji = 200 ..< 300 ~= response.statusCode ? "🎉" : "🌧"
                print("ℹ️: \(emoji) \(response.statusCode) \(representation)")
            }
        case let .failure(error):
            print("⚠️: \(error)")
        }
    }
}

private extension URLRequest {
    var representation: String? {
        guard let httpMethod = httpMethod else { return nil }
        guard let url = url?.absoluteString else { return nil }

        return "\(httpMethod) \(url)"
    }
}
