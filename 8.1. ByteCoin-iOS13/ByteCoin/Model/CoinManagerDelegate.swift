//
//  CoinManagerDelegate.swift
//  ByteCoin
//
//  Created by Usama Fouad on 20/09/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: PriceModel)
    func didFailWithError(error: Error)
}
