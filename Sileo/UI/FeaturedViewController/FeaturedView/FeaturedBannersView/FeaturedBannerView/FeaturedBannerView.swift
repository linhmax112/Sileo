//
//  FeaturedBannerView.swift
//  Sileo
//
//  Created by CoolStar on 7/6/19.
//  Copyright © 2019 CoolStar. All rights reserved.
//

import Foundation

protocol FeaturedBannerViewPreview: class {
    func viewController(bannerView: FeaturedBannerView) -> UIViewController?
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
}

class FeaturedBannerView: UIButton, UIViewControllerPreviewingDelegate {
    weak var previewDelegate: FeaturedBannerViewPreview?
    var banner: [String: Any] = [:] {
        didSet {
            if let bannerURL = banner["url"] as? String {
                bannerImageView?.sd_setImage(with: URL(string: bannerURL))
            }
            
            if let bannerTitle = banner["title"] as? String {
                self.accessibilityLabel = bannerTitle
                bannerTitleLabel?.text = bannerTitle
            }
            
            let displayText = (banner["displayText"] as? Bool) ?? true
            let hideShadow = (banner["hideShadow"] as? Bool) ?? false
            
            darkeningView?.isHidden = !displayText || hideShadow
            bannerTitleLabel?.isHidden = !displayText
        }
    }
    
    var darkeningView: UIView?
    var highlightView: UIView?
    var bannerImageView: UIImageView?
    var bannerTitleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.accessibilityIgnoresInvertColors = true
        
        self.clipsToBounds = true
        
        bannerImageView = UIImageView(frame: self.bounds)
        bannerImageView?.contentMode = .scaleAspectFill
        bannerImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bannerImageView?.isUserInteractionEnabled = false
        self.addSubview(bannerImageView!)
        
        darkeningView = CSGradientView(frame: self.bounds)
        darkeningView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        darkeningView?.isUserInteractionEnabled = false
        self.addSubview(darkeningView!)
        
        let bannerTitleLabel = UILabel(frame: .zero)
        bannerTitleLabel.textColor = .white
        bannerTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        bannerTitleLabel.isUserInteractionEnabled = false
        bannerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bannerTitleLabel)
        
        self.bannerTitleLabel = bannerTitleLabel
        
        bannerTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        bannerTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        bannerTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        let highlightView = UIView(frame: .zero)
        highlightView.backgroundColor = .clear
        highlightView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        highlightView.isUserInteractionEnabled = false
        self.addSubview(highlightView)
        
        self.highlightView = highlightView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                highlightView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
            } else {
                highlightView?.backgroundColor = .clear
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        self.previewDelegate?.viewController(bannerView: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.previewDelegate?.previewingContext(previewingContext, commit: viewControllerToCommit)
    }
}
