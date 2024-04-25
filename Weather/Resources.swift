//
//  Resources.swift
//  Weather
//
//  Created by Саша Тихонов on 10/12/2023.
//

import Foundation
import UIKit

enum Fonts {
    static func helveticaFont(with size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

struct CitiesData {
    let citiesData: [(id: Int16, name: String)] = [
        (1, "Minsk"),
        (2, "Lodz"),
        (3, "Moscow"),
        (4, "London"),
        (5, "Paris"),
        (6, "Lisbon"),
        (7, "Istanbul"),
        (8, "Saint Petersburg"),
        (9, "Berlin"),
        (10, "Madrid"),
        (11, "Kyiv"),
        (12, "Rome"),
        (13, "Paris"),
        (14, "Vienna"),
        (15, "Hamburg"),
        (16, "Warsaw"),
        (17, "Bucharest"),
        (18, "Budapest"),
        (19, "Barcelona"),
        (20, "Munich"),
        (21, "Prague"),
        (22, "Milan"),
        (23, "Tbilisi"),
        (24, "Yerevan"),
        (25, "Odesa"),
        (26, "Birmingham"),
        (27, "Krasnodar"),
        (28, "Sofia"),
        (29, "Kazan"),
        (30, "Kharkiv"),
    ]
}
