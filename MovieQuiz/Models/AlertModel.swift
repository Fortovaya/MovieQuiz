//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Алина on 07.12.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
