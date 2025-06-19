//
//  YCTApiFetchProduct.swift
//  YCT
//
//  Created by Lucky on 26/03/2024.
//

import Foundation

final class YCTApiFetchProduct: YCTBaseRequest {
    let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    override func requestUrl() -> String {
        return "/product/productListing"
    }
    
    override func yct_requestArgument() -> [AnyHashable : Any] {
        return ["userId": userId]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func responseSerializerType() -> YTKResponseSerializerType {
        return .JSON
    }
}
