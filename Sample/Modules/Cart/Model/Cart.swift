//
//  Cart.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import Foundation
import UIKit

extension Cart {
    
    struct State {
        let items: [Item]
    }
    
    struct Item {
        let id: String
        let image: UIImage?
        let name: String
        let price: Int?
        let oldPrice: Int?
        let quantity: Int
    }
}

final class Cart {
    
    private static var items: [Item] = [
        Item(id: "1", image: UIImage(named: "c-item-1"), name: "Вода Святой источник негазированная", price: 90, oldPrice: 129, quantity: 3),
        Item(id: "2", image: UIImage(named: "c-item-2"), name: "Туалетная бумага Zewa Плюс 2 слоя", price: 115, oldPrice: 135, quantity: 1),
        Item(id: "3", image: UIImage(named: "c-item-3"), name: "Ба­тон на­рез­ной Че­рё­муш­ки на­рез­ка", price: 34, oldPrice: 49, quantity: 2),
        Item(id: "4", image: UIImage(named: "c-item-4"), name: "Спелые бананы", price: 104, oldPrice: 149, quantity: 1), //104
        Item(id: "5", image: UIImage(named: "c-item-5"), name: "Киви", price: 66, oldPrice: 95, quantity: 3),
        Item(id: "6", image: UIImage(named: "c-item-6"), name: "Яблоки Гренни", price: 101, oldPrice: 145, quantity: 5),
    ]
    
    private(set) var state: State
    
    init() {
        
        let items: [Item] = Self.items.map { item in
            Item(id: item.id,
                 image: item.image,
                 name: item.name,
                 price:  Bool.random() ? item.price : nil,
                 oldPrice: item.oldPrice,
                 quantity: item.quantity)
        }
        
        self.state = State(items: items)
    }
    
    func addProduct(_ productID: String, completion: @escaping (State) -> Void) {
        
        var items: [Item] = state.items
        
        if let item = Self.items.first(where: { $0.id == productID }) {
            items.append(Item(id: item.id,
                              image: item.image,
                              name: item.name,
                              price: item.price,
                              oldPrice: item.oldPrice,
                              quantity: 1))
        }
        
        self.state = State(items: items)
        
        completion(self.state)
    }
    
    func increaseQuantity(productID: String, completion: @escaping (State) -> Void) {
        guard let quantity = state.items.first(where: { $0.id == productID })?.quantity else { return }
        
        setQuantity(quantity + 1, forProduct: productID, completion: completion)
    }
    
    func decreaseQuantity(productID: String, completion: @escaping (State) -> Void) {
        guard let quantity = state.items.first(where: { $0.id == productID })?.quantity else { return }
        
        setQuantity(quantity - 1, forProduct: productID, completion: completion)
    }
    
    func setQuantity(_ quantity: Int, forProduct productID: String, completion: @escaping (State) -> Void) {
        
        guard quantity > 0 else {
            removeProduct(productID, completion: completion)
            return
        }
        
        let items: [Item] = state.items.map { item in
            guard item.id == productID else { return item }
            
            return Item(
                id: item.id,
                image: item.image,
                name: item.name,
                price: item.price,
                oldPrice: item.oldPrice,
                quantity: quantity)
        }
        
        self.state = State(items: items)
        
        completion(self.state)
    }
    
    func removeProduct(_ productID: String, completion: @escaping (State) -> Void) {
        
        let items: [Item] = state.items.compactMap { item in
            item.id == productID ? nil : item
        }
        
        self.state = State(items: items)
        
        completion(self.state)
    }
}
