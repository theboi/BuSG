//
//  String.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
