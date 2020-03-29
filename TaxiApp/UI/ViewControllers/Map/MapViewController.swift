//
//  ViewController.swift
//  TaxiApp
//
//  Created by Developer on 25.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - IBAction
    @IBAction private func menuItemClicked(_ sender: UIBarButtonItem) {
        showMenu()
    }
    
// MARK: - Private
    private func showMenu() {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            present(menu, animated: true, completion: nil)
        }
    }
    
    private func setupMenu() {
        let leftMenu = Storyboard.menu.instanceOf(viewController: MenuTableViewController.self)!
        let menuLeftNavigationController = SideMenuNavigationController(rootViewController: leftMenu)
        menuLeftNavigationController.leftSide = true
        let menuPresentationStyle: SideMenuPresentationStyle = .viewSlideOut
        menuPresentationStyle.menuStartAlpha = 0
        menuPresentationStyle.onTopShadowOpacity = 1
        var settings = SideMenuSettings()
        settings.presentationStyle = menuPresentationStyle
        settings.statusBarEndAlpha = 0
        menuLeftNavigationController.settings = settings
        menuLeftNavigationController.setNavigationBarHidden(true, animated: true)
        SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()

    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    locationManager.stopUpdatingLocation()
  }
}
