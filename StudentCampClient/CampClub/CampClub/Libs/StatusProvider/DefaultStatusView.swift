//
//  EmptyStatusView
//
//  Created by MarioHahn on 25/08/16.
//

import Foundation
import UIKit

open class DefaultStatusView: UIView, StatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: StatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            actionButton.setTitle(status.actionTitle, for: UIControl.State())
            
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            actionButton.isHidden = status.action == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButton.isHidden
        }
    }
    
    public let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    public let descriptionLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    public let activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        #if os(tvOS)
            $0.activityIndicatorViewStyle = .whiteLarge
        #endif
        
        #if os(iOS)
            $0.style = .gray
        #endif
        return $0
    }(UIActivityIndicatorView(style: .whiteLarge))
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    public let actionButton: UIButton = {
        
        return $0
    }(UIButton(type: .system))
	
	public let verticalStackView: UIStackView = {
		$0.axis = .vertical
		$0.spacing = 20
        $0.alignment = .center

		return $0
	}(UIStackView())
    
    public let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
	public override init(frame: CGRect) {
		super.init(frame: frame)
        
        actionButton.addTarget(self, action: #selector(DefaultStatusView.actionButtonAction), for: .touchUpInside)
		
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        horizontalStackView.addArrangedSubview(verticalStackView)
		
		verticalStackView.addArrangedSubview(imageView)
		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(descriptionLabel)
		verticalStackView.addArrangedSubview(actionButton)
		
		NSLayoutConstraint.activate([
			horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
			horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
    
    #if os(tvOS)
    override open var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [actionButton]
    }
    #endif
    
    @objc func actionButtonAction() {
        status?.action?()
    }
	
	open override var tintColor: UIColor! {
		didSet {
			titleLabel.textColor = tintColor
			descriptionLabel.textColor = tintColor
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
