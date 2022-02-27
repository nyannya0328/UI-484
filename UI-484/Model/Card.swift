//
//  Card.swift
//  UI-484
//
//  Created by nyannyan0328 on 2022/02/27.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID().uuidString
    var name : String
    var cardNumber : String
    var cardImage : String
}

var cards : [Card] = [

    Card(name: "Jake", cardNumber: "1234 5678 9010 3546", cardImage: "Card1"),
    Card(name: "Chapman", cardNumber: "1234 9876 9010 3546", cardImage: "Card2"),
    Card(name: "Roki", cardNumber: "1234 5678 9807 3546", cardImage: "Card3"),

]
