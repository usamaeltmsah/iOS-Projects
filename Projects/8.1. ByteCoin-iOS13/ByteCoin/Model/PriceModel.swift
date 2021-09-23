//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Usama Fouad on 20/09/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct PriceModel {
    let price: Double
    
    var bitCoinString: String {
        return String(format: "%.2f", price)
    }
}
