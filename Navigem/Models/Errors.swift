//
//  Errors.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

enum ApiKeyError: LocalizedError {
    case missing, invalid
    
    var errorDescription: String? {
        switch self {
        case .missing:
            return NSLocalizedString(
                "DataMall API Key missing. Get key at https://www.mytransport.sg/content/mytransport/home/dataMall.html",
                comment: ""
            )
        case .invalid:
            return NSLocalizedString(
                "DataMall API Key invalid. Check if key is set or get new key at https://www.mytransport.sg/content/mytransport/home/dataMall.html",
                comment: ""
            )
        }
        
    }
}
