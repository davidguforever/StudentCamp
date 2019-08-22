//
//  SingleTextTableViewController.swift
//
//  Created by Luochun on 2017/8/15.
//  Copyright © 2017年 Maintis. All rights reserved.
//

import UIKit
import MTCobwebs

fileprivate let cellHeight: CGFloat = 45.0
fileprivate let headerHeight: CGFloat = 10.0
fileprivate let maxHeight: CGFloat = cellHeight * 7

extension UIViewController {
    func showPopupMenuText(_ title: String,  dictionary: JSONMap , selectedText: String? = nil, compeleted: @escaping (_ index: Int) -> ()) {
        //let sortedKeyValues = Array(dictionary).sorted(by: { $0.0 < $1.0 })
        let array = (Array(dictionary.values) as! [String]).sorted()
        if let text = selectedText {
            if let index = array.index(of: text) {
                showPopupMenu(title, rows: array, selectedIndex: index, compeleted: compeleted)
            }
        }
        showPopupMenu(title, rows: array, compeleted: compeleted)
    }
    
    func showPopupMenuText(_ title: String,  rows: [String] , selectedText: String? = nil, compeleted: @escaping (_ index: Int) -> ()) {
        
        if let text = selectedText {
            if let index = rows.index(of: text) {
                showPopupMenu(title, rows: rows, selectedIndex: index, compeleted: compeleted)
            }
        }
        showPopupMenu(title, rows: rows, compeleted: compeleted)
    }
    
    func showPopupMenu(_ title: String,  rows: [String] , selectedIndex: Int? = nil, compeleted: @escaping (_ index: Int) -> ()) {
        view.endEditing(true)
        
        let vc = SingleTextTableViewController(rows, selectedIndex: selectedIndex)
        vc.title = title
        vc.completedCallBack = compeleted
        
        let popupController = STPopupController(rootViewController: vc)
        popupController.hidesCloseButton = true
        let blurEffect = UIBlurEffect(style: .dark)
        popupController.backgroundView = UIVisualEffectView(effect: blurEffect)
        popupController.backgroundView?.alpha = 0.5
        popupController.navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: MTColor.main, NSAttributedString.Key.font: pingFang_SC.medium(16)]
        
        popupController.style = .bottomSheet
        popupController.present(in: self)
        
    }
}

class SingleTextTableViewController: UITableViewController {

    private var array = [String]()
    private var selectedIndex: Int?
    
    var completedCallBack: ((_ index: Int) -> ())?
    
    
    public convenience init(_ dataSource: [String], selectedIndex: Int?) {
        
        self.init(style: .plain)
        array.append(contentsOf: dataSource)
        self.selectedIndex = selectedIndex
        contentSizeInPopup = CGSize(width: view.frame.width, height: min( CGFloat(dataSource.count) * cellHeight + headerHeight , maxHeight) + kTabbarSafeBottomMargin )
    }
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(hex: 0xDBDBDB)
        
        //tableView.registerNib(cellClass: InvestmentListCell.self)
        
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.estimatedRowHeight = 560
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
    }
    
    // MARK: - Table view data source
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10  // 55       //return CGFloat.leastNormalMagnitude
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: headerHeight))
        view.backgroundColor = UIColor.clear
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: cellHeight))
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        label.textColor = MTColor.main
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        view.addSubview(label)
        return view
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none // 居中
        cell.textLabel?.textAlignment = .center
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.text = array[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.textLabel?.textColor = MTColor.main
        } else {
            cell.textLabel?.textColor = MTColor.des666
        }
        
        let line = UIView(frame: CGRect(x: 0, y: cellHeight - 1, width: view.width, height: 1))
        line.backgroundColor = MTColor.pageback
        cell.contentView.addSubview(line)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if let block = completedCallBack {
            block(indexPath.row)
        }
        
        self.st_dismiss(animated: true, completion: nil)
    }
}



// Tabbar safe bottom margin.
let kTabbarSafeBottomMargin: CGFloat = (UIDevice.isIPhoneXSeries ? 34.0 : 0.0)

extension UIDevice {
    /// iphone有刘海
    public static var isIPhoneXSeries: Bool {
        var iPhoneXSeries = false
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return iPhoneXSeries
        }
        
        if #available(iOS 11.0, *)  {
            if let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom {
                if bottom > CGFloat(0.0) {
                    iPhoneXSeries = true
                }
            }
        }
        
        return iPhoneXSeries
    }
}
