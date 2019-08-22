//  UIStoryboard+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UIStoryboard {
    
    /// Get the application's main storyboard (Main.storyboard)
    ///
    ///         let storyboard = UIStoryboard.mainStoryboard
    ///
    public static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    public func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    public func instantiate<T: UIViewController>(controller: T.Type) -> T
        where T: Identifiable {
            return instantiateViewController(withIdentifier: T.identifier) as! T
    }
    
}


public protocol Identifiable {
    
    static var identifier: String { get }
}

public extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}



public protocol LoadableNib: class {
    
    static var nib: UINib { get }
}

public extension LoadableNib {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}


public extension UIView {
    
    func instantiateFromNib<T: UIView>(_:T.Type) -> T where T: LoadableNib {
        if let nib = T.nib.instantiate(withOwner: nil, options: nil).first as? T {
            return nib
        } else {
            fatalError("Nib \(T.nib) is not exist ?!")
        }
    }
    
    func instantiateFromNibOwner<T: UIView>(_:T.Type) where T: LoadableNib {
        let bundle = Bundle(for: type(of: self))
        if let nib = UINib(nibName: String(describing: T.self), bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView {
            nib.frame = self.bounds
            nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(nib)
        } else {
            fatalError("Nib \(T.nib) is not exist ?!")
        }
    }
    
}


public extension LoadableNib where Self: UIView {
    
    static func instantiate() -> Self {
        
        guard let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil) as? Self else {
            fatalError("Cannot loadNibNamed \(String(describing: self))")
        }
        return view
    }
}

public extension UITableView {
    
    public final func register<T: UITableViewCell>(cell: T.Type)
        where T: Identifiable {
            register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    public final func register<T: UITableViewCell>(cell: T.Type)
        where T: Identifiable & LoadableNib {
            register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    public final func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath)
        where T: Identifiable {
            dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
    }
}

