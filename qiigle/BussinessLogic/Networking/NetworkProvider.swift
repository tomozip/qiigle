//
//  NetworkProvider.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/13.
//  Copyright © 2019 Tomozip. All rights reserved.
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
