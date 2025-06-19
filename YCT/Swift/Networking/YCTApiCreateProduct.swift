//
//  YCTApiCreateProduct.swift
//  YCT
//
//  Created by Lucky on 28/03/2024.
//

import Foundation

final class YCTApiCreateProduct: YCTBaseRequest {
    let product: Product
    
    init(product: Product) {
        self.product = product
    }
    override func requestUrl() -> String {
        return "/product/create"
    }
    
    override func yct_requestArgument() -> [AnyHashable : Any] {
        return product.dictionary ?? [:]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func responseSerializerType() -> YTKResponseSerializerType {
        return .JSON
    }
}
