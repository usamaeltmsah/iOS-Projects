//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9FD65CB4-74B2-4D3C-836F-E4D2B5350E64"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performUrl(with: urlString)
    }
    
    func performUrl(with urlString: String) {
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let price = self.pasrseJSON(coinData: safeData) {
                        delegate?.didUpdatePrice(self, price: price)
                    }
                }
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
        
        func pasrseJSON(coinData: Data) -> PriceModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: coinData)
                let lastPrice = decodedData.rate
                let price = PriceModel(price: lastPrice)
               return price
            } catch {
                print(error)
                return nil
            }
        }
}
