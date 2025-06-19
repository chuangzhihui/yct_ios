//
//  YCTApiWatchDuration.swift
//  YCT
//
//  Created by Lucky on 07/04/2024.
//

import Foundation

final class YCTApiWatchDuration: YCTBaseRequest {
    let videoId: String
    let duration: Int64

    init(videoId: String, duration: Int64) {
        self.videoId = videoId
        self.duration = duration
    }
    override func requestUrl() -> String {
        return "/index/user/watch"
    }
    
    override func yct_requestArgument() -> [AnyHashable : Any] {
        return ["videoId": videoId,
                "duration": duration]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func responseSerializerType() -> YTKResponseSerializerType {
        return .JSON
    }
}
