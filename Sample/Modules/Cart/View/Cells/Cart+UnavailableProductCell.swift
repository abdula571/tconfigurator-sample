//
//  Cart+UnavailableProductCell.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit

import UIKit
import TConfigurator

protocol UnavailableProductCellDelegate_Cart: AnyObject {
    
    func unavailableProductCell(_ cell: UnavailableProductCell_Cart, removeProduct productID: String)
}

final class UnavailableProductCell_Cart: UITableViewCell {
    
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let removeButton = UIButton()
    
    
    private weak var delegate: UnavailableProductCellDelegate_Cart?
    private var productID: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension UnavailableProductCell_Cart {
    
    @objc
    private func didTapRemove() {
        delegate?.unavailableProductCell(self, removeProduct: productID)
    }
}

extension UnavailableProductCell_Cart: T.Configurable {
    
    struct DTO {
        let id: String
        let image: UIImage?
        let name: String
    }
    
    typealias Delegate = UnavailableProductCellDelegate_Cart
    
    static var identifier: String { UnavailableProductCell_Cart.description() }
    
    func config(_ product: DTO!, delegate: Delegate?) {
        self.delegate = delegate
        self.productID = product.id
        
        productImageView.image = product.image
        productTitleLabel.text = product.name
    }
}


//MARK: - Layout UnavailableProductCell_Cart
extension UnavailableProductCell_Cart {
    
    private func setupLayout() {
        
        let statusLabel = UILabel()
        let bottomLineView = UIView()
        
        let titleAndStatusStackView = UIStackView(arrangedSubviews: [
            productTitleLabel,
            statusLabel
        ])
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleAndStatusStackView)
        contentView.addSubview(removeButton)
        contentView.addSubview(bottomLineView)
        
        productImageView.configured { it in
            it.backgroundColor = UIColor.clear
            it.layer.cornerRadius = 5
            it.alpha = 0.4
            
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
        }
        
        statusLabel.configured { it in
            it.text = "Нет в наличии"
            it.textColor = UIColor.primary
            it.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        }
        
        titleAndStatusStackView.configured { it in
            it.spacing = 4
            it.alignment = .leading
            it.axis = .vertical
            
            it.snp.makeConstraints { make in
                make.leading.equalTo(productImageView.snp.trailing).offset(10)
                make.centerY.equalToSuperview()
            }
        }
        
        removeButton.configured { it in
            it.setTitle("Удалить", for: .normal)
            it.backgroundColor = UIColor.controlBg1
            it.setTitleColor(UIColor.primary, for: .normal)
            it.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            it.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
            it.layer.cornerRadius = 10
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            it.snp.makeConstraints { make in
                make.leading.greaterThanOrEqualTo(productTitleLabel.snp.trailing).offset(12)
                make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
                make.centerY.equalToSuperview()
            }
        }
    }
}
