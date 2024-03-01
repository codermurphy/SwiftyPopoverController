//
//  MPPopoverController.swift
//  qichat
//
//  Created by Qihe_mac on 2020/6/15.
//  Copyright © 2020 Qihe_mac. All rights reserved.
//

import UIKit

class MPPopoverController: UIViewController {
    
    // MARK: - initial methods
    
    enum PopoverStyle {
        case message(message: String)
        case menu(list: [(icon: UIImage?,title: String?)])
    }
    
    init(config: MPPopoverConfig,style: PopoverStyle) {
        self.config = config
        self.style = style
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.delegate = self
        self.preferredContentSize = config.contentSize
        if #available(iOS 11.0, *) {
            
        }
        else {
           self.automaticallyAdjustsScrollViewInsets = false
        }
        self.resetContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func showPopover(with item: UIBarButtonItem?,config: MPPopoverConfig = MPPopoverConfig(),style: PopoverStyle) -> MPPopoverController {
        
        let popover = MPPopoverController(config: config,style: style)
        popover.popoverPresentationController?.barButtonItem = item
        return popover
        
    }

    static func showPopover(with sourceView: UIView,config: MPPopoverConfig = MPPopoverConfig(),arrowDirection: UIPopoverArrowDirection? = nil,style: PopoverStyle) -> MPPopoverController {
        
        let popover = MPPopoverController(config: config,style: style)
        popover.popoverPresentationController?.sourceView = sourceView
        //popover.popoverPresentationController?.sourceRect = sourceView.bounds
        popover.popoverPresentationController?.sourceRect = CGRect(x: config.offset.x, y: config.offset.y, width: sourceView.bounds.width, height: sourceView.bounds.height)        
        if let directions = arrowDirection {
            popover.popoverPresentationController?.permittedArrowDirections = directions

        }
        return popover
    }

    
    // MARK: - property
    
    private var config: MPPopoverConfig
    
    private let style: PopoverStyle
    
    private var isLayout = false
    
    var didSelecteCallback: ((Int,MPPopoverController)->Void)?
    
    private var menu: [(icon: UIImage?,title: String?)] {
        switch self.style {
        case let .menu(list):
            return list
        default:
            return []
        }
    }
    
    private weak var presentedView: UIView?
    
    private weak var popoverBackgroundView: MPPopoverBackgroundView? {
        didSet {
            self.popoverBackgroundView?.arrowView.backgroundColor = self.config.backgroundColor
        }
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.config.backgroundColor
        self.view.layer.cornerRadius = self.config.cornorRadius
        self.view.clipsToBounds = true
        if self.config.showBorder {
            self.view.layer.borderColor = self.config.borderColor.cgColor
            self.view.layer.borderWidth = self.config.borderWidth
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let presentedView = self.popoverPresentationController?.presentedView {
            guard let popoverView = presentedView.subviews.first(where: { return $0.classForCoder == MPPopoverBackgroundView.self }) as? MPPopoverBackgroundView else { return }
            self.presentedView = presentedView
            self.showAnimation(animationView: presentedView, popoverView: popoverView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.presentedView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
        if self.popoverBackgroundView == nil {
            if let rootSupview = self.view.superview,let presentedView = self.popoverPresentationController?.presentedView {
                guard let popoverView = presentedView.subviews.first(where: { return $0.classForCoder == MPPopoverBackgroundView.self }) as? MPPopoverBackgroundView else { return }
                
                /// 屏蔽自带的圆角
                rootSupview.layer.cornerRadius = 0
                rootSupview.clipsToBounds = false
                if self.config.showShadow {
                    presentedView.layer.shadowColor = self.config.shadowColor.cgColor
                    presentedView.layer.shadowOffset = self.config.shadowOffset
                    presentedView.layer.shadowRadius = self.config.shadowRadius
                    presentedView.layer.shadowOpacity = self.config.shadowOpacity
                }
                
                /// 屏蔽自带的阴影
                guard let _shadowView = rootSupview.superview?.superview?.subviews.first(where: {$0.classForCoder.description() == "_UICutoutShadowView" }) else { return }
                _shadowView.isHidden = true
            }
        }

    }
    
    // MARK: - private methods
    // MARK: - zoom animation
    private func showAnimation(animationView: UIView,popoverView: MPPopoverBackgroundView) {
        
        let arrowOffset = popoverView.arrowOffset
        let arrowDirection = popoverView.arrowDirection
        animationView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        popoverView.arrowView.isHidden = !self.config.showArrow
        switch arrowDirection {
        case .up:
            let anchorPointX = ((popoverView.frame.size.width / 2) + arrowOffset) / popoverView.frame.size.width;
            animationView.layer.anchorPoint = CGPoint(x: anchorPointX, y: 0)
        case .down:
            let anchorPointX = ((popoverView.frame.size.width / 2) + arrowOffset) / popoverView.frame.size.width;
            animationView.layer.anchorPoint = CGPoint(x: anchorPointX, y: 1)
        case .left:
            let anchorPointY = ((popoverView.frame.size.height / 2) + arrowOffset) / popoverView.frame.size.height;
            animationView.layer.anchorPoint = CGPoint(x: 0, y: anchorPointY)
        case .right:
            let anchorPointY = ((popoverView.frame.size.height / 2) + arrowOffset) / popoverView.frame.size.height;
            animationView.layer.anchorPoint = CGPoint(x: 1, y: anchorPointY)
        default:
            break
        }
        
        UIView.animate(withDuration: 0.2) {
            animationView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    // MARK: - UI
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = self.config.font
        label.textColor = self.config.textColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var contentView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.config.contentSize.width, height: self.config.contentSize.height), style: .plain)
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = self.config.menuPerHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    // MARK: - layout
    
    private func layout() {
        guard !isLayout else { return }
        isLayout = true
        switch self.style {
        case let .message(message):
            self.messageLabel.text = message
            
            let scrollView = UIScrollView()
            scrollView.frame = self.view.bounds
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            self.view.addSubview(scrollView)
            
            scrollView.addSubview(self.messageLabel)
            
            let size = self.messageLabel.sizeThatFits(CGSize(width: self.config.contentSize.width - self.config.contentEdgeInsets.left -  self.config.contentEdgeInsets.right, height: CGFloat.greatestFiniteMagnitude))
            
            self.messageLabel.x = self.config.contentEdgeInsets.left
            self.messageLabel.y = self.config.contentEdgeInsets.top
            self.messageLabel.frame.size.width = self.config.contentSize.width - self.config.contentEdgeInsets.left -  self.config.contentEdgeInsets.right
            self.messageLabel.frame.size.height = size.height
            scrollView.contentSize = CGSize(width: self.view.bounds.width, height: size.height + self.config.contentEdgeInsets.top + self.config.contentEdgeInsets.bottom)
        case .menu:
            self.view.addSubview(self.contentView)
        }
    }
    
    private func resetContentSize() {
        
        switch self.style {
        case let .message(message):
            self.messageLabel.text = message
            let size = self.messageLabel.sizeThatFits(CGSize(width: self.config.contentSize.width - self.config.contentEdgeInsets.left -  self.config.contentEdgeInsets.right, height: CGFloat.greatestFiniteMagnitude))
            self.preferredContentSize = CGSize(width: self.config.contentSize.width, height: size.height + self.config.contentEdgeInsets.top + self.config.contentEdgeInsets.bottom)
            
        default:
            break
        }
    }
    
    deinit {
        debugPrint(Self.self)
    }
    
}


// MARK: - UIPopoverPresentationControllerDelegate
extension MPPopoverController: UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.popoverLayoutMargins = UIEdgeInsets(horizontal: 16, vertical: 10)
        popoverPresentationController.popoverBackgroundViewClass = MPPopoverBackgroundView.self
        popoverPresentationController.containerView?.backgroundColor = self.config.containerColor
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        
    }
    
}

extension MPPopoverController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = self.menu[indexPath.row]
        let showSeparator = self.config.showSeparator ? indexPath.row != self.menu.count - 1 : false
        let cell = MPPopoverMenuCell(config: self.config, content: content, showSeparator: showSeparator)
        return cell
    }
}

extension MPPopoverController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.didSelecteCallback?(indexPath.row,self)
        }
    }
}
