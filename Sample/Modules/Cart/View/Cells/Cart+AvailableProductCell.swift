//
//  Cart+AvailableProductCell.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit
import TConfigurator

protocol AvailableProductCellDelegate_Cart: AnyObject {
    
    func availableProductCell(_ cell: AvailableProductCell_Cart, increaseQauntityFor productID: String)
    func availableProductCell(_ cell: AvailableProductCell_Cart, decreaseQauntityFor productID: String)
    func availableProductCell(_ cell: AvailableProductCell_Cart, removeProduct productID: String)
    func availableProductCell(_ cell: AvailableProductCell_Cart, didSelectProduct productID: String)
}

final class AvailableProductCell_Cart: UITableViewCell {
    
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let oldPriceLabel = CCrossedLineLabel()
    
    private let minusButton = UIButton()
    private let quantityLabel = UILabel()
    private let plusButton = UIButton()
    
    
    private weak var delegate: AvailableProductCellDelegate_Cart?
    private var product: Product!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupLayout()
        
        productImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
        productTitleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
        
        minusButton.addTarget(self, action: #selector(didTapDecrease), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapIncrease), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension AvailableProductCell_Cart {
    
    @objc
    private func didSelect() {
        delegate?.availableProductCell(self, didSelectProduct: product.id)
    }
    
    @objc
    private func didTapIncrease() {
        delegate?.availableProductCell(self, increaseQauntityFor: product.id)
    }
    
    @objc
    private func didTapDecrease() {
        delegate?.availableProductCell(self, decreaseQauntityFor: product.id)
    }
}

extension AvailableProductCell_Cart: T.Configurable {
    
    struct Product {
        let id: String
        let image: UIImage?
        let name: String
        let price: Int
        let oldPirce: Int?
        let quantity: Int
    }
    
    typealias DTO = Product
    typealias Delegate = AvailableProductCellDelegate_Cart
    
    static var identifier: String { Self.description() }
    
    func config(_ product: Product!, delegate: AvailableProductCellDelegate_Cart?) {
        self.delegate = delegate
        self.product = product
        
        self.productImageView.image = product.image
        self.productTitleLabel.text = product.name
        self.priceLabel.text = product.price.formattedPrice
        self.quantityLabel.text = product.quantity.description
        
        if let oldPrice = product.oldPirce, product.price < oldPrice {
            self.oldPriceLabel.text = oldPrice.formattedPrice
            self.oldPriceLabel.isHidden = false
        } else {
            self.oldPriceLabel.isHidden = true
            self.oldPriceLabel.text = nil
        }
    }
    
    class Configurator: T.BaseConfigurator<AvailableProductCell_Cart>, T.Configurator {
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            guard let cell = tableView.cellForRow(at: indexPath) as? AvailableProductCell_Cart else { return nil }
            
            let removeAction = UIContextualAction(style: .destructive, title: nil) { action, _, success in
                self.delegate?.availableProductCell(cell, removeProduct: self.data.id)
                success(true)
            }.configured { it in
                it.image = UIImage.app.trash24
            }
            
            return UISwipeActionsConfiguration(actions: [
                removeAction
            ])
        }
    }
}


//MARK: - Layout AvailableProductCell_Cart
extension AvailableProductCell_Cart {
    
    private func setupLayout() {
        
        let titleAndPriceStackView = UIStackView(arrangedSubviews: [
            productTitleLabel,
            priceLabel
        ])
        
        let quantityView = UIView().configured { it in
            it.addSubview(minusButton)
            it.addSubview(quantityLabel)
            it.addSubview(plusButton)
        }
        let bottomLineView = UIView()
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleAndPriceStackView)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(quantityView)
        contentView.addSubview(bottomLineView)
        
        productImageView.configured { it in
            it.isUserInteractionEnabled = true
            it.backgroundColor = UIColor.clear
            it.layer.cornerRadius = 5
            
            it.snp.makeConstraints { make in
                make.top.equalTo(10)
                make.bottom.equalTo(-10)
                make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading)
                make.size.equalTo(CGSize(width: 55, height: 55))
            }
        }
        
        productTitleLabel.configured { it in
            it.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            it.textColor = UIColor.black
            it.numberOfLines = 2
            it.isUserInteractionEnabled = true
        }
        
        priceLabel.configured { it in
            it.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            it.textColor = UIColor.text
        }
        
        titleAndPriceStackView.configured { it in
            it.axis = .vertical
            it.spacing = 3
            it.alignment = .leading
            
            it.snp.makeConstraints { make in
                make.leading.equalTo(productImageView.snp.trailing).offset(10)
                make.centerY.equalToSuperview()
            }
        }
        
        oldPriceLabel.configured { it in
            it.textColor = UIColor.textSecondary
            it.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            it.snp.makeConstraints { make in
                make.leading.equalTo(priceLabel.snp.trailing).offset(8)
                make.centerY.equalTo(priceLabel.snp.centerY)
            }
        }
        
        quantityView.configured { it in
            it.layer.cornerRadius = 10
            it.backgroundColor = UIColor.controlBg1
            
            it.snp.makeConstraints { make in
                make.leading.greaterThanOrEqualTo(titleAndPriceStackView.snp.trailing).offset(16)
                make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
                make.centerY.equalToSuperview()
            }
        }
        
        minusButton.configured { it in
            it.setImage(UIImage.app.cartDecreaseButton?.withRenderingMode(.alwaysTemplate), for: .normal)
            it.tintColor = UIColor.black

            it.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 34, height: 34))
                make.top.leading.bottom.equalToSuperview()
            }
        }
        
        quantityLabel.configured { it in
            it.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            it.textColor = UIColor.black
            
            it.snp.makeConstraints { make in
                make.leading.equalTo(minusButton.snp.trailing).offset(2)
                make.centerY.equalToSuperview()
            }
        }
        
        plusButton.configured { it in
            it.setImage(UIImage.app.cartIncreaseButton?.withRenderingMode(.alwaysTemplate), for: .normal)
            it.tintColor = UIColor.black
            
            it.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 34, height: 34))
                make.leading.equalTo(quantityLabel.snp.trailing).offset(2)
                make.top.trailing.bottom.equalToSuperview()
            }
        }
        
        bottomLineView.configured { it in
            it.backgroundColor = UIColor.divider
            
            it.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.leading.equalTo(productTitleLabel.snp.leading)
                make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
                make.bottom.equalToSuperview()
            }
        }
    }
}
