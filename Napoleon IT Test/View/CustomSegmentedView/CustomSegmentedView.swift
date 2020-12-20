//
//  CustomSegmentedView.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 20.12.2020.
//

import UIKit

class CustomSegmentedView: UIView {
    
    // MARK: - UI elements
    let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let topTenButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Топ 10", for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.buttonTintBlue, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 36.0 / 2.0
        button.layer.borderColor = UIColor.buttonTintBlue.cgColor
        
        return button
    }()
    
    let shopsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Магазины", for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.buttonTintBlue, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 36.0 / 2.0
        button.layer.borderColor = UIColor.buttonTintBlue.cgColor
        
        return button
    }()
    
    let goodsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Товары", for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.buttonTintBlue, for: .selected)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 36.0 / 2.0
        button.layer.borderColor = UIColor.buttonTintBlue.cgColor
        
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(buttonStack)
        
        buttonStack.addArrangedSubview(topTenButton)
        buttonStack.addArrangedSubview(shopsButton)
        buttonStack.addArrangedSubview(goodsButton)
        
        topTenButton.addTarget(self, action: #selector(topTenSelected), for: .touchUpInside)
        shopsButton.addTarget(self, action: #selector(shopsSelected), for: .touchUpInside)
        goodsButton.addTarget(self, action: #selector(goodsSelected), for: .touchUpInside)
        
        topTenSelected()
        
        needsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Constraints
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 3.5),
            buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5)
        ])
        
        super.updateConstraints()
    }
    
    // MARK: Helper methods
    func selectButton(buttonLayer: CALayer) {
        buttonLayer.borderWidth = 1.0
    }
    
    func unselectButton(buttonLayer: CALayer) {
        buttonLayer.borderWidth = 0.0
    }
    
    // MARK: - Actions
    @objc func topTenSelected() {
        topTenButton.isSelected = true
        shopsButton.isSelected = false
        goodsButton.isSelected = false
        
        selectButton(buttonLayer: topTenButton.layer)
        unselectButton(buttonLayer: shopsButton.layer)
        unselectButton(buttonLayer: goodsButton.layer)
    }
    
    @objc func shopsSelected() {
        topTenButton.isSelected = false
        shopsButton.isSelected = true
        goodsButton.isSelected = false
        
        unselectButton(buttonLayer: topTenButton.layer)
        selectButton(buttonLayer: shopsButton.layer)
        unselectButton(buttonLayer: goodsButton.layer)
    }
    
    @objc func goodsSelected() {
        topTenButton.isSelected = false
        shopsButton.isSelected = false
        goodsButton.isSelected = true
        
        unselectButton(buttonLayer: topTenButton.layer)
        unselectButton(buttonLayer: shopsButton.layer)
        selectButton(buttonLayer: goodsButton.layer)
    }
}
