//
//  UIImage+AppImages.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit

class AppImages {
    
    var trash24: UIImage? { UIImage(named: "trash-h24") }
    
    var cartIncreaseButton: UIImage? { UIImage(named: "cart-increase-button") }
    var cartDecreaseButton: UIImage? { UIImage(named: "cart-decrease-button") }
}

extension UIImage {
    static let app = AppImages()
}
