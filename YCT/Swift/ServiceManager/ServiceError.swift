//
//  ServiceError.swift
//  Motion2Coach
//
//  Created by nawaz on 1/24/23.
//

import Foundation
struct ServiceError {
    
    var status: Int = ServiceConstants.ServiceError.generic
    var message: String = ServiceConstants.ServiceError.genericError
    
}
