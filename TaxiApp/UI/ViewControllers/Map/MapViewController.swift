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
    
// MARK: - Lifecycle
    override func loadView() {
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
      marker.title = "Sydney"
      marker.snippet = "Australia"
      marker.map = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
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

