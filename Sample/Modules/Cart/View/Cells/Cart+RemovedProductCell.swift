//
//  Cart+RemovedProductCell.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit
import TConfigurator

protocol RemovedProductCellDelegate_Cart: AnyObject {
    
    func removedProductCell(_ cell: RemovedProductCell_Cart, returnProduct productID: String)
}

final class RemovedProductCell_Cart: UITableViewCell {
    
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let returnButton = UIButton()
    
    
    private weak var delegate: RemovedProductCellDelegate_Cart?
    private var productID: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        returnButton.addTarget(self, action: #selector(didTapReturn), for: .touchUpInside)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RemovedProductCell_Cart {
    
    @objc
    private func didTapReturn() {
        delegate?.removedProductCell(self, returnProduct: productID)
    }
}

extension RemovedProductCell_Cart: T.Configurable {
    
    struct DTO {
        let id: String
        let image: UIImage?
        let name: String
    }
    
    typealias Delegate = RemovedProductCellDelegate_Cart
    
    static var identifier: String { RemovedProductCell_Cart.description() }
    
    func config(_ product: DTO!, delegate: Delegate?) {
        self.delegate = delegate
        self.productID = product.id
        
        productImageView.image = product.image
        productTitleLabel.text = product.name
    }
}


//MARK: - Layout RemovedProductCell_Cart
extension RemovedProductCell_Cart {
    
    private func setupLayout() {
        
        let bottomLineView = UIView()
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(returnButton)
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
            
            it.snp.makeConstraints { make in
                make.leading.equalTo(productImageView.snp.trailing).offset(10)
                make.centerY.equalToSuperview()
            }
        }
        
        returnButton.configured { it in
            it.setTitle("Вернуть", for: .normal)
            it.backgroundColor = UIColor.controlBg1
            it.setTitleColor(UIColor.black, for: .normal)
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
