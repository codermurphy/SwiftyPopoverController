//
//  MPPopoverConfig.swift
//  qichat
//
//  Created by Qihe_mac on 2020/6/16.
//  Copyright © 2020 Qihe_mac. All rights reserved.
//

import UIKit


struct MPPopoverConfig {
    
    /// 箭头高度
    static var arrowHeight: CGFloat = 10
    
    /// 箭头底边宽度
    static var arrowBase: CGFloat = 18
    
    /// 是否展示箭头
    var showArrow: Bool = true
    
    /// 内容size
    var contentSize: CGSize = CGSize(width: 118, height: 100)
    
    /// 背景色
    var backgroundColor: UIColor = UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33 / 255.0, alpha: 1)
    
    /// 外层颜色
    var containerColor: UIColor = .clear
    
    /// 圆角
    var cornorRadius: CGFloat = 8
    
    /// 是否显示阴影
    var showShadow: Bool = false
    
    /// 阴影相关设置
    var shadowColor: UIColor = .white
    var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    var shadowRadius: CGFloat = 5
    var shadowOpacity: CGFloat = 0.0
    
    /// 内容颜色
    var textColor: UIColor = .white
    
    /// 内容字体
    var font: UIFont = .systemFont(ofSize: 15)
    
    /// 内容对其方式
    var textAligment: NSTextAlignment = .left
    
    /// 内容边距
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(horizontal: 32, vertical: 20)
    
    /// 是否显示内容分割线
    var showSeparator: Bool = true
    
    /// 分割线颜色
    var separatorColor: UIColor = .white
    
    /// 分割线高度
    var separatorHeigh: CGFloat = 1
    
    /// 分割线边界
    var separatorInset: UIEdgeInsets = .zero
    
    /// 菜单行高
    var menuPerHeight: CGFloat = 50
    
    /// 图标和文本的间距
    var iconAndTextMargin: CGFloat = 10
    
    /// 是否展示边框
    var showBorder: Bool = false
    
    /// 边框宽度
    var borderWidth: CGFloat = 1
    
    /// 边框颜色
    var borderColor: UIColor = .lightGray
}
