//
//  MapVC.swift
//  ArcMap
//
//  Created by Igor Eydman on 4/22/18.
//  Copyright © 2018 Igor Eydman. All rights reserved.
//

import UIKit
import ArcGIS

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    
    private var map:AGSMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map = AGSMap(basemap: AGSBasemap.darkGrayCanvasVector())
        
        // Assign the map to the map view
        self.mapView.map = self.map
        
        let myPoint = AGSPoint(x: -122.4479, y: 37.7531, spatialReference: AGSSpatialReference.wgs84())
        let myViewpoint = AGSViewpoint(center: myPoint, scale: 300000)
        map.initialViewpoint = myViewpoint
        
        // Start location display with current location and auto pan with user while walking
        self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.compassNavigation
        self.mapView.locationDisplay.initialZoomScale = 2000
        self.mapView.locationDisplay.start(completion: nil)
        
        // Register touch delegate
        self.mapView.touchDelegate = self
        
        setupCompass()
        
    }
    
    // Mark: Re-center map
    @IBAction func recenterTapped(_ sender: Any) {
        
        self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode.recenter
        self.mapView.locationDisplay.initialZoomScale = 5000
        self.mapView.locationDisplay.wanderExtentFactor = 0.7
        self.mapView.locationDisplay.start(completion: nil)
    }
    
    // Mark: - Stop navigation
    @IBAction func stopTapped(_ sender: Any) {
        
        self.mapView.locationDisplay.stop()
    }
    
    // Mark: Setup Compass
    func setupCompass() {
        self.mapView.map?.load {(error:Error?) -> Void in
            if error == nil {
                //add north arrow observer
                self.mapView.addObserver(self, forKeyPath: "rotation", options: .new, context: nil) }
        }
    }
    
    override func observeValue(forKeyPath key: String!, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if key == "rotation" {
            let rotationAngle = -(self.mapView.rotation*Double.pi/180)
            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            self.compassImage.transform = transform
        }
        
        let speed = self.mapView.locationDisplay.location!.velocity
        self.speedLabel.text = "Speed: \(String(format: "%.2f", speed)) mi/h"
    }
}

extension MapVC: AGSGeoViewTouchDelegate {
    
    //MARK: - AGSGeoViewTouchDelegate
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint,
                 mapPoint: AGSPoint) { //
        print("map screen is tapped!")
        
        let convertedPoint = AGSGeometryEngine.projectGeometry(mapPoint, to: AGSSpatialReference.wgs84())
        
        let coodinate = convertedPoint?.copy() as! AGSPoint
        
        print("mapPoint longitude is : \(mapPoint.x)","mapPoint latitude is : \(mapPoint.y)")
        print("ConvertedPoint longitude is : \(coodinate.x)","ConvertedPoint latitude is : \(coodinate.y)")
        
        // MARK: Callout tags
        // TODO: Magnet to nearest street
        if self.mapView.callout.isHidden {
            self.mapView.callout.color = UIColor.customBlack
            self.mapView.callout.title = "WGS84 Coordinates"
            self.mapView.callout.titleColor = UIColor.customWhite
            self.mapView.callout.detail = String(format: "longitude: %.4f, latitude: %.4f", coodinate.x, coodinate.y)
            self.mapView.callout.detailColor = UIColor.customWhite
            self.mapView.callout.isAccessoryButtonHidden = true
            self.mapView.callout.show(at: mapPoint, screenOffset: CGPoint.zero, rotateOffsetWithMap: false, animated: true)
        }
        else {
            self.mapView.callout.dismiss() }
    }
}

// Mark: Search
extension MapVC: UITextFieldDelegate {
    //performGeocoding(withSearchText: )
}
