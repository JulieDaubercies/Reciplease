//
//  NetworkError.swift
//  Reciplease
//
//  Created by DAUBERCIES on 01/10/2021.
//

import Foundation

enum NetworkError: Error {
    case noData, invalidResponse, undecodableData
}

extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noData:
            return "Le service est momentanément insdisponible"
        case .invalidResponse:
            return "Erreur rencontrée lors de l'appel réseau"
        case .undecodableData:
            return "Les données rentrées sont incorrectes, impossible de charger des recettes"
        }
    }
}
