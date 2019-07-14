//
//  NetworkProvider.swift
//  Iyashi
//
//  Created by nukotsuka on 2019/03/27.
//  Copyright © 2019 Arriv, Inc. All rights reserved.
//

import Moya

private let defaultPlugins: [PluginType] = [
    LoggerPlugin(),
]

final class NetworkProvider<Target: TargetType>: MoyaProvider<Target> {
    init(plugins: [PluginType] = defaultPlugins) {
        super.init(plugins: plugins)
    }
}
