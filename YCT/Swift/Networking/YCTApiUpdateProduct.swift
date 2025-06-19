//
//  YCTApiUpdateProduct.swift
//  YCT
//
//  Created by Lucky on 28/03/2024.
//

import Foundation

final class YCTApiUpdateProduct: YCTBaseRequest {
    let product: Product
    let productId: Int
    init(productId: Int, product: Product) {
        self.product = product
        self.productId = productId
    }
    override func requestUrl() -> String {
        return "/product/update/\(productId)"
    }
    
    override func yct_requestArgument() -> [AnyHashable : Any] {
        return product.dictionary ?? [:]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .PUT
    }
    
    override func responseSerializerType() -> YTKResponseSerializerType {
        return .JSON
    }
}
