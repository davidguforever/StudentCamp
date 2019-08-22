
//
//  LocationManager.swift
//  CampClub
//
//  Created by Luochun on 2019/4/27.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

typealias MKPositioningClosure = ((Double, Double) -> ())

class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    var clousre : MKPositioningClosure?
    private var locationManager : CLLocationManager?
    private var viewController : UIViewController?      // 承接外部传过来的视图控制器，做弹框处理
    
    
    // 外部初始化的对象调用，执行定位处理。
    func startPositioning(_ vc: UIViewController) {
        viewController = vc
        if (self.locationManager != nil) && (CLLocationManager.authorizationStatus() == .denied) {
            // 定位提示
            alter(viewController: viewController!)
        } else {
            requestLocationServicesAuthorization()
        }
    }
    
    
    // 初始化定位
    private func requestLocationServicesAuthorization() {
        
        if (self.locationManager == nil) {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
        }
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            let distance : CLLocationDistance = 10.0
            locationManager?.distanceFilter = distance
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    
    // 获取定位代理返回状态进行处理
    private func reportLocationServicesAuthorizationStatus(status:CLAuthorizationStatus) {
        
        if status == .notDetermined {
            // 未决定,继续请求授权
            requestLocationServicesAuthorization()
        } else if (status == .restricted) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        } else if (status == .denied) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        }
    }
    
    
    private func alter(viewController:UIViewController) {
        
//        AlertController.shared.showAlertMsg(viewController, "定位服务未开启,是否前往开启?", "请进入系统[设置]->[隐私]->[定位服务]中打开开关，并允许“赏金猎人”使用定位服务") { (action) in
//            let url = URL(fileURLWithPath: UIApplicationOpenSettingsURLString)
//            if UIApplication.shared.canOpenURL(url){
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
}

extension LocationManager:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                return
            }
            
            if let place = placemarks?[0]{
                
                let v = (place.location?.coordinate.latitude, place.location?.coordinate.longitude)
                
                self.clousre!(v.0!, v.1!)
            } else {
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        reportLocationServicesAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.stopUpdatingLocation()
    }
    
    
    static func distance(_ lat1: Double, long1: Double, lat2: Double, long2: Double) -> Double {
        print("---------------------\n")
        print(String(format: "%f   %f   %f   %f", lat1, long1, lat2 , long2))
        print("---------------------\n")
        let c1 = CLLocation(latitude: lat1, longitude: long1)
        let c2 = CLLocation(latitude: lat2, longitude: long2)
        return c1.distance(from: c2)
    }
}

