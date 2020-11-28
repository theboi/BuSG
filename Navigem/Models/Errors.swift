//
//  Errors.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

enum ApiKeyError: LocalizedError {
    case missing
    
    var errorDescription: String? {
        switch self {
        case .missing:
            return NSLocalizedString(
                "DataMall API Key missing. Get access at https://www.mytransport.sg/content/mytransport/home/dataMall.html",
                comment: ""
            )
        }
    }
}
