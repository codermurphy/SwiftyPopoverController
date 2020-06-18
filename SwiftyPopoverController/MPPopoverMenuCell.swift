//
//  MPPopoverMenuCell.swift
//  qichat
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 Qihe_mac. All rights reserved.
//

import UIKit

class MPPopoverMenuCell: UITableViewCell {

    // MARK: - initial methods
    
    init(config: MPPopoverConfig,content: (icon: UIImage?,title: String?),showSeparator: Bool) {
        self.config = config
        self.content = content
        self.showSeparator = showSeparator
        super.init(style: .default, reuseIdentifier: nil)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - property
    
    private var config: MPPopoverConfig
    
    private var content: (icon: UIImage?,title: String?)
    
    private var showSeparator: Bool
    
    // MARK: - UI
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var separatorLine: UIView = {
        let line = UIView()
        return line
    }()
    
    // MARK: - setUp UI
    
    private func setUpUI() {
        if self.content.icon != nil { self.contentView.addSubview(self.icon); self.icon.image = self.content.icon }
        if self.showSeparator { self.contentView.addSubview(self.separatorLine); self.separatorLine.backgroundColor = self.config.separatorColor }
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.textAlignment = self.config.textAligment
        self.titleLabel.font = self.config.font
        self.titleLabel.textColor = self.config.textColor
        self.titleLabel.text = self.content.title
    }
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.content.icon != nil {
            self.icon.sizeToFit()
            self.icon.frame.origin.x = self.config.contentEdgeInsets.left
            self.icon.frame.origin.y = (self.contentView.bounds.height - self.icon.image!.size.height) * 0.5
            self.titleLabel.sizeToFit()
            self.titleLabel.frame.origin.x = self.icon.frame.origin.x + self.icon.frame.size.width + self.config.iconAndTextMargin
            self.titleLabel.center.y = self.icon.center.y
            self.titleLabel.frame.size.width = self.contentView.frame.width - self.titleLabel.frame.origin.x - self.icon.frame.origin.x
        }
        else {
            self.titleLabel.sizeToFit()
            self.titleLabel.frame.origin.x = self.config.contentEdgeInsets.left
            self.titleLabel.frame.origin.y = (self.contentView.bounds.height - self.titleLabel.frame.size.height) * 0.5
            self.titleLabel.frame.size.width = self.contentView.frame.width - self.titleLabel.frame.origin.x * 2
        }
        
        self.separatorLine.frame.origin.x = self.config.separatorInset.left
        self.separatorLine.frame.size.width = self.contentView.bounds.width - self.config.separatorInset.left - self.config.separatorInset.right
        self.separatorLine.frame.size.height = self.config.separatorHeigh
        self.separatorLine.frame.origin.y = self.contentView.bounds.height - self.config.separatorHeigh
        
    }
}
