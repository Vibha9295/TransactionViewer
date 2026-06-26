//
//  TransactionServiceError.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

enum TransactionServiceError: LocalizedError {
    case fileNotFound
    case decodingFailed(Error)
}
