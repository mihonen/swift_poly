//
//  File.swift
//  
//
//  Created by Ville Muhonen on 29.12.2022.
//

import Foundation



extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
