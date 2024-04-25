//
//  TempratureAndTImeCell.swift
//  Weather
//
//  Created by Саша Тихонов on 12/12/2023.
//

import UIKit
import SnapKit

class TemperatureAndTimeCell: UICollectionViewCell {
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 15)
        label.textAlignment = .center
        return label
    }()
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 15)
        label.textAlignment = .center
        return label
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(imageView.snp.top)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.bounds.height * 0.36)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.bottom.equalTo(temperatureLabel.snp.top)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.bounds.height * 0.25)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(contentView.bounds.height * 0.36)
        }
    }
    
    func configure(withTitle timeTitle: String, temperatureTitle: String, image: UIImage?) {
        timeLabel.text = timeTitle
        temperatureLabel.text = temperatureTitle
        imageView.image = image
    }
}
