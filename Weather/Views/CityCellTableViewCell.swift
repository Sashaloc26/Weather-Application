//
//  CityCellTableViewCell.swift
//  Weather
//
//  Created by Саша Тихонов on 25/12/2023.
//

import UIKit
import SnapKit

class CityCellTableViewCell: UITableViewCell {
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.helveticaFont(with: 30)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CityCellTableViewCell {
    func setupCell() {
        contentView.backgroundColor = .gray
        contentView.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(3)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    func configure(withCity city: String) {
        cityLabel.text = city
    }
}

