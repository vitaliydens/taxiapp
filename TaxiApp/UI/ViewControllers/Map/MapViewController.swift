//
//  ViewController.swift
//  TaxiApp
//
//  Created by Developer on 25.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    override func loadView() {
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView

      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
      marker.title = "Sydney"
      marker.snippet = "Australia"
      marker.map = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

