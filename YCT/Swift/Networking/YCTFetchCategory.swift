//
//  YCTFetchCategory.swift
//  YCT
//
//  Created by Lucky on 31/03/2024.
//

import Foundation

final class YCTFetchCategory: YCTBaseRequest {
    
    override func requestUrl() -> String {
        return "/product/categoryInfo"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func responseSerializerType() -> YTKResponseSerializerType {
        return .JSON
    }
}
