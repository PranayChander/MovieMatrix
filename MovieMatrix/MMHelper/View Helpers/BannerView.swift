//
//  BannerView.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit


fileprivate extension CGFloat {
    static let cornerRadius: CGFloat = 8.0
    static let shadowRadius: CGFloat = 5.0
    static let shadowOpacity: CGFloat = 0.4
    static let shadowOffsetLength: CGFloat = 2.0
    static let stackViewPadding: CGFloat = 16.0
}

class BannerView: UIControl {
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let stackView = UIStackView()
    
    var animationDistance: CGFloat {
        return self.frame.height + self.layoutMargins.top
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.configureStackView()
        self.configureShadowAndRounding()
    }
    
    func configure(with viewModel: BannerViewModel) {
        self.titleLabel.text = viewModel.title
        self.bodyLabel.text = viewModel.body
    }
    
    func configureStackView() {
        self.titleLabel.font = .preferredFont(forTextStyle: .headline)
        self.bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.bodyLabel.numberOfLines = 2
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.bodyLabel)
        self.stackView.axis = .vertical
        self.stackView.spacing = 8.0
        self.stackView.distribution = .fillProportionally
        self.stackView.alignment = .fill
        
        self.addSubview(stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .stackViewPadding),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.stackViewPadding),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: .stackViewPadding),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -.stackViewPadding),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configureShadowAndRounding() {
        self.layer.cornerRadius = .cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(CGFloat.shadowOpacity)
        self.layer.shadowRadius = .shadowRadius
        self.layer.shadowOffset = CGSize(width: .shadowOffsetLength, height: .shadowOffsetLength)
        
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = .white
        
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
        blurEffectView.constrainToSuperview()
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = .cornerRadius
    }
}
