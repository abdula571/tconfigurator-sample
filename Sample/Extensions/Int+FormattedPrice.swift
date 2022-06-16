//
//  Int+FormattedPrice.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit

extension Int {
    
    var formattedPrice: String {
        
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 0
        nf.groupingSeparator = " "
        nf.currencyCode = "RUB"
        
        if let formattedString = nf.string(for: self) {
            return formattedString
        }
        
        return "\(self) ₽"
    }
}
