//
//  ViewController.swift
//  MovelRater
//
//  Created by Luochun on 2019/4/18.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import EasyPeasy
import JTAppleCalendar
import MTUIFlash
import CoreLocation

private let Titles = ["营务", "日程表"]

fileprivate let reuseIdentifier = "IndexCell"

class HomeViewController: MTBaseViewController {
    var viewPagerNavigationBar = BmoViewPagerNavigationBar()
    
    @IBOutlet weak var viewPager: BmoViewPager!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addNavigationBarLeftButton(self, action: #selector(messgae(_:)), image: UIImage(named: "message")!)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(named: "message")!, for: .normal)
        button.addTarget(self, action: #selector(messgae(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem?.tintColor = MTColor.title222
        
        addNavigationBarRightButton(self, action: #selector(add(_:)), image: UIImage(named: "add")!)
        
        MTConfiguration.shared.menuWidth = 150
        MTConfiguration.shared.textFont = UIFont.systemFont(ofSize: 16)
        MTConfiguration.shared.backgoundTintColor = .black
        MTConfiguration.shared.textAlignment = .center
        MTConfiguration.shared.cornerRadius = 8
        MTConfiguration.shared.menuRowHeight = 45
        
        //viewPagerNavigationBar.backgroundColor  = .lightGray
        
        viewPager.dataSource = self
        viewPagerNavigationBar.autoFocus = false
        viewPagerNavigationBar.viewPager = viewPager
        
        
        viewPagerNavigationBar.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 80, y: 0, width: 140, height: 42)
        navigationItem.titleView = viewPagerNavigationBar
    }
    
    @objc func messgae(_ sender: UIButton) {
        MTPopOverMenu.showForSender(sender: sender, with: ["分组", "查看分组信息"], done: { (index) in
            switch index {
            case 0:
                if User.shared.role == .manager {
                    let vc = UIStoryboard.Scene.setGroup
                    vc.hidesBottomBarWhenPushed = true
                    self.pushVC(vc)
                } else if User.shared.role == .teacher {
                    let vc = UIStoryboard.Scene.grouping
                    vc.hidesBottomBarWhenPushed = true
                    self.pushVC(vc)
                } else if User.shared.role == .student {
                    showMessage("无权限")
                }
            case 1:
                if User.shared.role == .manager {
                    let vc = UIStoryboard.Scene.grouping
                    vc.hidesBottomBarWhenPushed = true
                    self.pushVC(vc)
                } else if User.shared.role == .teacher {
                    let vc = UIStoryboard.Scene.grouping
                    vc.hidesBottomBarWhenPushed = true
                    self.pushVC(vc)
                } else if User.shared.role == .student {
                    //let vc = UIStoryboard.Scene.myGroup
                    let vc = UIStoryboard.Scene.grouping
                    vc.hidesBottomBarWhenPushed = true
                    self.pushVC(vc)
                }
                
            default:
                break
                
            }
        }) {
            // cancel
            
        }

    }
    
    @objc func add(_ sender: UIButton) {
        if viewPager.pageControlIndex == 0 {
            MTPopOverMenu.showForSender(sender: sender, with: ["报名", "查看报名情况"], done: { (index) in
                switch index {
                case 0:
                    
                    if User.shared.role == .student {
                        HttpApi.queryIsBeginEnter({ (v, err) in
                            if let va = v, va == "0" {
                                showMessage("活动未开始")
                            } else {
                                let vc = UIStoryboard.Scene.review
                                vc.hidesBottomBarWhenPushed = true
                                self.pushVC(vc)
                            }
                        })
                        
                    } else {
                        if User.shared.role == .manager {
                            let vc = UIStoryboard.Scene.setApply
                            vc.hidesBottomBarWhenPushed = true
                            self.pushVC(vc)
                        } else if User.shared.role == .teacher {
                            let vc = UIStoryboard.Scene.teacherApply
                            vc.hidesBottomBarWhenPushed = true
                            self.pushVC(vc)
                        }
                    }
                    
                case 1:
                    if User.shared.role == .student {
                        MTHUD.showLoading()
                        HttpApi.queryInfoStudent(User.shared.userName!, handle: { (res, err) in
                            MTHUD.hide()
                            if let v = res, let list = v["list"] as? String {
                                showMessage( list == "1"  ? "报名成功，已通过审核": "报名未审核")
                            } else {
                                showMessage(err)
                            }
                        })
                    } else {
                        let vc = UIStoryboard.Scene.applyNumbers
                        vc.hidesBottomBarWhenPushed = true
                        self.pushVC(vc)
                    }
                    
                default:
                    break
                    
                }
            }) {
                // cancel
                
            }
        } else {
            self.selectPhoto { (img) in
                
            }
        }
    }
    
    
}

extension HomeViewController: BmoViewPagerDataSource {
    
    // Optional
    @objc func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 2)),
            NSAttributedString.Key.foregroundColor : UIColor(hex: 0xbbbbbb)
            //NSForegroundColorAttributeName : UIColor.groupTableViewBackground
        ]
    }
    @objc func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20.0),
            NSAttributedString.Key.foregroundColor : MTColor.main
        ]
    }
    
    
    @objc func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UnderLineView()
        //view.marginX = 15.0
        view.marginX = 0.0
        view.lineWidth = 3.0
        view.strokeColor = .white
        return view
    }
    
    @objc func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        //let str =  Titles[page]
        //return CGSize(width: str.widthWithFont(font: UIFont.boldSystemFont(ofSize: 16)) + 16 , height: navigationBar.height)
        return CGSize(width: 70 , height: navigationBar.height)
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return Titles[page]
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return Titles.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = page == 0 ? UIStoryboard.Scene.index : UIStoryboard.Scene.schedule
        return vc
    }
}


class IndexViewController: MTBaseViewController {
    
    @IBOutlet weak  var monthLabel: UILabel!
    @IBOutlet weak  var signButton: UIButton!
    
    @IBOutlet weak  var dabianButton: UIButton!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var selectMonthDate = Date()
    
    let df = DateFormatter()
    
    var isBegin: Bool = false   /// 活动是否开始
    var endLine: Date?  /// 结束日期
    
    var xy: (Float,Float) = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel.text = Date().toString("yyyy.MM")
        
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = false
        
        
        calendarView.scrollToDate(Date())
        
        /// 选中当天
        calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        
        LocationManager.shared.startPositioning(self)
        LocationManager.shared.clousre = { (x, y) in
            self.xy = (Float(x), Float(y))
        }
        
        switch User.shared.role {
        case .student:
            MTHUD.showLoading()
            HttpApi.querySignInMsg(Date().toString("yyyy-MM-dd")) { (value, error) in
                MTHUD.hide()
                if let list = value?["list"] as? JSONMap, let isBegin = list["isBegin"] as? String {
                    if isBegin == "1" {
                        self.signButton.setTitle("今日签到", for: .normal)
                    } else {
                        showMessage("活动未开始")
                    }
                } else {
                    showMessage(error)
                }
            }
            signButton.setTitle("开始签到", for: .normal)
        case .teacher:
            signButton.setTitle("开始签到", for: .normal)
        case .manager:
            MTHUD.showLoading()
            HttpApi.querySignInMsg(Date().toString("yyyy-MM-dd")) { (value, error) in
                MTHUD.hide()
                if let list = value?["list"] as? JSONMap, let isBegin = list["isBegin"] as? String {
                    if isBegin == "1" {
                        self.signButton.setTitle("结束签到", for: .normal)
                    } else {
                        self.signButton.setTitle("开始签到", for: .normal)
                    }
                } else {
                    showMessage(error)
                }
            }

        }

    }
    
    @IBAction func sign() {
        switch User.shared.role {
        case .student:
            MTHUD.showLoading()
            HttpApi.querySignInMsg(Date().toString("yyyy-MM-dd")) { (res, err) in
                MTHUD.hide()
                if let list = res?["list"] as? JSONMap {
                    if let long = list["longitude"] as? String, let lat = list["latitude"] as? String {
                        let dis = LocationManager.distance(Double(self.xy.0), long1: Double(self.xy.1),
                                                           lat2: Double(lat)!, long2: Double(long)!)
                        if dis < 200 {
                            
                            MTHUD.showLoading()
                            HttpApi.signIn(Date().toString("yyyy-MM-dd"), userName:User.shared.userName!) { (res, err) in
                                MTHUD.hide()
                                if let _ = res {
                                    showMessage("签到成功")
                                } else {
                                    showMessage(err)
                                }
                            }
                        } else {
                            showMessage("不在签到范围")
                        }
                    }
                } else {
                    showMessage(err)
                }
            }
            
        case .teacher:
            showMessage("没有权限")
        case .manager:
            if self.signButton.title(for:.normal) == "结束签到" {
                MTHUD.showLoading()
                HttpApi.endSignIn(Date().toString("yyyy-MM-dd")) { (res, err) in
                    MTHUD.hide()
                    if let _ = res {
                        showMessage("设置成功")
                        self.signButton.setTitle("开始签到", for: .normal)
                    }
                }
            } else {
                MTHUD.showLoading()
                print(String(format: "lat: %f   long: %f ", xy.0 , xy.1))
                HttpApi.beginSignIn(Date().toString("yyyy-MM-dd"), longitude: xy.1, latitude: xy.0) { (res, error) in
                    MTHUD.hide()
                    if let _ = res {
                        showMessage("设置成功")
                        self.signButton.setTitle("结束签到", for: .normal)
                    }
                }
            }

        }
    }
    
    @IBAction func dabian() {
        if User.shared.role == .manager {
            let vc = UIStoryboard.Scene.setReply
            vc.hidesBottomBarWhenPushed = true
            pushVC(vc)
        } else {
            let vc = UIStoryboard.Scene.replyInfo
            vc.hidesBottomBarWhenPushed = true
            pushVC(vc)
        }
    }
    
    
    @IBAction func loadPrevious() {
        self.calendarView.scrollToSegment(.previous)
    }
    
    
    @IBAction func loadNext() {
        self.calendarView.scrollToSegment(.next)
    }
    
    
    var isLoaded: Bool = false

}


class TestRangeSelectionViewControllerCell: JTAppleCell {
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var badgeView: UIView!
    
    override open func awakeFromNib() {
        label.layer.cornerRadius = 17
        label.layer.masksToBounds = true
        
    }
    
    var beenSelected: Bool = false {
        didSet {
            self.label.backgroundColor = beenSelected ? UIColor(hex: 0xcccccc) : .clear
            if beenSelected {
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" + self.label.text!)
            }
        }
    }
    
    var badge: Int = 0 {
        didSet {
            if badge == 0 {
                self.badgeView.isHidden = true
            } else {
                self.badgeView.isHidden = false
            }
        }
    }
    
}



extension IndexViewController {
    
    func setupMonthLabel(date: Date) {
        df.dateFormat = "yyyy.MM"
        monthLabel.text = df.string(from: date)
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
        //print(cellState.date)
    }
    
    
    func handleCellColor(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        /// 判断在当月及大于今日
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = MTColor.title222
        } else {
            cell.label.textColor = MTColor.des999
        }
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.beenSelected = cellState.isSelected
            /// 筛选
//            let selects = datasOnMonth.filter({cellState.date.toString("yyyy-MM-dd") == $0.statisticDay})
//            if selects.count > 0 {
//                cell.bindData(selects.first!.planStatisticInfos)
//            } else {
//                cell.bindData([])   /// 隐藏Badge
//            }

            
        } else {
            cell.beenSelected = false   ///一定要设置
//            cell.bindData([])       /// 隐藏Badge
        }
    }
    
    func handleCellSelection(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        //cell.selectedView.isHidden = !cellState.isSelected
        
    }
    
    
    func handleSelect(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
        if cellState.dateBelongsTo == .thisMonth {
            cell.beenSelected = cellState.isSelected
            
            //getPlansOnDay(date: cellState.date)
            if User.shared.role == .student {
                MTHUD.showLoading()
                HttpApi.querySignInStudentByDate(Date().toString("yyyy-MM-dd"), userName: User.shared.userName!) { (res, err) in
                    MTHUD.hide()
                    if let _ = res {
                        showMessage("已签到")
                    } else {
                        showMessage(err)
                    }
                }
            } else {
                let vc = UIStoryboard(name: "Sign", bundle: Bundle.main).instantiateVC(Sign_InfoViewController.self)!
                vc.hidesBottomBarWhenPushed = true
                vc.date = cellState.date.yyyyMMdd
                self.pushVC(vc)
            }
        }
        print(cellState.date)
    }
}


extension IndexViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! TestRangeSelectionViewControllerCell
        cell.label.text = cellState.text
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
        
//        getMonthPlans( visibleDates.monthDates.first!.date)
    }
    /// 提前处理点击事件
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        if cellState.dateBelongsTo == .thisMonth {//&& (cellState.date >= Date().zeroOfDay()) {
            return true
        } else {
            return false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if !isLoaded {
            isLoaded = true
            return
        }
        handleSelect(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let startDate = Date().adding(.year, value: -1)
        let endDate = Date().adding(.year, value: 1)
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
        return parameter
    }
    
    

}
