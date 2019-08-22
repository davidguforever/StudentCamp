
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


#if os(iOS) || os(tvOS)
    import UIKit

public extension UICollectionView {
    /// default CollectionView cell indentifier  return "Cell"
    static var defaultCellIdentifier: String {
        return "Cell"
    }
    

    /// Register NIB to table view. NIB name and cell reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - nibName: Name of the NIB.
    ///   - cellIdentifier: Name of the reusable cell identifier.
    ///   - bundleIdentifier: Name of the bundle identifier if not local.
    func registerNib(_ nibName: String, cellIdentifier: String = defaultCellIdentifier, bundleIdentifier: String? = nil) {
        register(UINib(nibName: nibName,
                       bundle: bundleIdentifier != nil ? Bundle(identifier: bundleIdentifier!) : nil),
                 forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    ///  Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the collection.
    subscript(indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: UICollectionView.defaultCellIdentifier, for: indexPath)
    }
    

    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath:  The index path of the cell from the collection.
    ///   - identifier: Name of the reusable cell identifier.
    subscript(indexPath: IndexPath, identifier: String) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
}

    
    // MARK: - Properties
    public extension UICollectionView {
        
        /// Index path of last item in collectionView.
        public var indexPathForLastItem: IndexPath? {
            return indexPathForLastItem(inSection: lastSection)
        }
        
        /// Index of last section in collectionView.
        public var lastSection: Int {
            return numberOfSections > 0 ? numberOfSections - 1 : 0
        }
        
    }
    
    // MARK: - Methods
    public extension UICollectionView {
        
        /// Number of all items in all sections of collectionView.
        ///
        /// - Returns: The count of all rows in the collectionView.
        public func numberOfItems() -> Int {
            var section = 0
            var itemsCount = 0
            while section < self.numberOfSections {
                itemsCount += numberOfItems(inSection: section)
                section += 1
            }
            return itemsCount
        }
        
        /// IndexPath for last item in section.
        ///
        /// - Parameter section: section to get last item in.
        /// - Returns: optional last indexPath for last item in section (if applicable).
        public func indexPathForLastItem(inSection section: Int) -> IndexPath? {
            guard section >= 0 else {
                return nil
            }
            guard section < numberOfSections else {
                return nil
            }
            guard numberOfItems(inSection: section) > 0 else {
                return IndexPath(item: 0, section: section)
            }
            return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
        }
        
        /// Reload data with a completion handler.
        ///
        /// - Parameter completion: completion handler to run after reloadData finishes.
        public func reloadData(_ completion: @escaping () -> Void) {
            UIView.animate(withDuration: 0, animations: {
                self.reloadData()
            }, completion: { _ in
                completion()
            })
        }
        
        /// Dequeue reusable UICollectionViewCell using class name.
        ///
        /// - Parameters:
        ///   - name: UICollectionViewCell type.
        ///   - indexPath: location of cell in collectionView.
        /// - Returns: UICollectionViewCell object with associated class name.
        public func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T? {
            return dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T
        }
        
        /// Dequeue reusable UICollectionReusableView using class name.
        ///
        /// - Parameters:
        ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
        ///   - name: UICollectionReusableView type.
        ///   - indexPath: location of cell in collectionView.
        /// - Returns: UICollectionReusableView object with associated class name.
        public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T? {
            return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T
        }
        
        /// Register UICollectionReusableView using class name.
        ///
        /// - Parameters:
        ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
        ///   - name: UICollectionReusableView type.
        public func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
            register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
        }
        
        /// Register UICollectionViewCell using class name.
        ///
        /// - Parameters:
        ///   - nib: Nib file used to create the collectionView cell.
        ///   - name: UICollectionViewCell type.
        public func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
            register(nib, forCellWithReuseIdentifier: String(describing: name))
        }
        
        /// Register UICollectionViewCell using class name.
        ///
        /// - Parameter name: UICollectionViewCell type.
        public func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
            register(T.self, forCellWithReuseIdentifier: String(describing: name))
        }
        
        /// Register UICollectionReusableView using class name.
        ///
        /// - Parameters:
        ///   - nib: Nib file used to create the reusable view.
        ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
        ///   - name: UICollectionReusableView type.
        public func register<T: UICollectionReusableView>(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: T.Type) {
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
        }
        
    }
#endif
