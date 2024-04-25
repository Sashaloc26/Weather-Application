//
//  PartyCloudView.swift
//  Weather
//
//  Created by Саша Тихонов on 06/12/2023.
//

import UIKit

class PartyCloudView: UIView {
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.4).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor,
            UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 0).cgColor
        ]
        layer.locations = [0, 1, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.41, b: 0.8, c: -0.8, d: 1.62, tx: 0.59, ty: -0.74))
        return layer
    }()
    
    private let shadowsView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        return view
    }()
    
    private let shapesView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        layer.addSublayer(gradientLayer)
        
        // Shadows view setup
        addSubview(shadowsView)
        let shadowPath = UIBezierPath(roundedRect: shadowsView.bounds, cornerRadius: 15)
        let shadowLayer = CALayer()
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 24
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.bounds = shadowsView.bounds
        shadowLayer.position = shadowsView.center
        shadowsView.layer.addSublayer(shadowLayer)
        
        // Shapes view setup
        addSubview(shapesView)
        shapesView.layer.addSublayer(gradientLayer)
        shapesView.layer.cornerRadius = 15
        
        // Add constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Add constraints for ShadowsView
        shadowsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            
            shapesView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
                
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = shapesView.bounds
        gradientLayer.bounds = shapesView.bounds.insetBy(dx: -0.5 * shapesView.bounds.size.width, dy: -0.5 * shapesView.bounds.size.height)
        gradientLayer.position = shapesView.center
    }
}

