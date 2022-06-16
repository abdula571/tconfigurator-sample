//
//  CartViewController.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit
import TConfigurator

fileprivate struct RemovedProduct {
    let id: String
    let image: UIImage?
    let name: String
}

final class CartViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let tableManager = T.Manager()
    
    private var cart: Cart { UIApplication.enviroment.cart }
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AvailableProductCell_Cart.registerForTable(tableView)
        UnavailableProductCell_Cart.registerForTable(tableView)
        RemovedProductCell_Cart.registerForTable(tableView)
        
        tableView.dataSource = tableManager
        tableView.delegate = tableManager
        
        navigationItem.title = "Корзина"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI(state: cart.state)
    }
}

extension CartViewController {
    
    private func updateUI(state: Cart.State, removedProduct: RemovedProduct? = nil) {
        
        var cells: [T.Configurator] = cart.state.items.compactMap { item in
            guard let price = item.price else { return nil }
            
            let data = AvailableProductCell_Cart.DTO(
                id: item.id,
                image: item.image,
                name: item.name,
                price: price,
                oldPirce: item.oldPrice,
                quantity: item.quantity)
            
            return AvailableProductCell_Cart.Configurator(data: data, delegate: self)
        }
        
        if let removedProduct = removedProduct {
            cells.append(RemovedProductCell_Cart.assemble(
                .init(id: removedProduct.id,
                      image: removedProduct.image,
                      name: removedProduct.name),
                delegate: self)
            )
        }
        
        let unavailableProducts = cart.state.items.filter({ $0.price == nil }).map { item in
            UnavailableProductCell_Cart.assemble(
                .init(
                    id: item.id,
                    image: item.image,
                    name: item.name),
                delegate: self)
        }
        
        cells.append(contentsOf: unavailableProducts)
        
        tableManager.sections = [
            T.Section(cells)
        ]
        
        tableView.reloadData()
    }
}


//MARK: - Behaviors
extension CartViewController: AvailableProductCellDelegate_Cart {
    
    func availableProductCell(_ cell: AvailableProductCell_Cart, increaseQauntityFor productID: String) {
        
        cart.increaseQuantity(productID: productID) { [weak self] state in
            self?.updateUI(state: state)
        }
    }
    
    func availableProductCell(_ cell: AvailableProductCell_Cart, decreaseQauntityFor productID: String) {
        
        let removedProduct: RemovedProduct? = cart.state.items.first(where: { $0.id == productID}).map { item in
            RemovedProduct(id: item.id, image: item.image, name: item.name)
        }
        
        cart.decreaseQuantity(productID: productID) { [weak self] state in
            
            if !state.items.contains(where: { $0.id == productID}) { //Удален
                self?.updateUI(state: state, removedProduct: removedProduct)
            } else {
                self?.updateUI(state: state)
            }
        }
    }
    
    func availableProductCell(_ cell: AvailableProductCell_Cart, removeProduct productID: String) {
        
        cart.removeProduct(productID) { [weak self] state in
            self?.updateUI(state: state)
        }
    }
    
    func availableProductCell(_ cell: AvailableProductCell_Cart, didSelectProduct productID: String) {
        #warning("Показать экран товара")
    }
}

extension CartViewController: UnavailableProductCellDelegate_Cart {
    
    func unavailableProductCell(_ cell: UnavailableProductCell_Cart, removeProduct productID: String) {
        
        cart.removeProduct(productID) { [weak self] state in
            self?.updateUI(state: state)
        }
    }
}

extension CartViewController: RemovedProductCellDelegate_Cart {
    
    func removedProductCell(_ cell: RemovedProductCell_Cart, returnProduct productID: String) {
        
        cart.addProduct(productID) { [weak self] state in            
            self?.updateUI(state: state)
        }
    }
}

//MARK: - Layout CartViewController
extension CartViewController {
    
    private func createView() -> UIView {
        
        let view = UIView()
        
        view.addSubview(tableView)
        
        view.configured { it in
            it.backgroundColor = UIColor.white
        }
        
        tableView.configured { it in
            it.separatorStyle = .none
            
            if #available(iOS 15.0, *) {
                it.sectionHeaderTopPadding = .zero
            }
            
            it.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
        
        return view
    }
}
