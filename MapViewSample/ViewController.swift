//
//  ViewController.swift
//  MapViewSample
//
//  Created by Jey on 10/18/16.
//  Copyright © 2016 Jey. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        
        zoomToRegion()
        
        let location = CLLocationCoordinate2DMake(50.073992, 14.450272)
        let dropPin = CustomPointAnnotation(name: "rand", street: "rand", type: "rand", postCode: "rand");
        dropPin.coordinate = location
        dropPin.imageName = "freeWash"
        mapView.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("delegate called")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = CustomCalloutView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = false
        }
        else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        return anView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation!.isKind(of: MKUserLocation.self){
            return
        }
       
        let location = CLLocationCoordinate2D(latitude: 50.073992, longitude: 14.450272)
        let region = MKCoordinateRegionMakeWithDistance(location, 3000.0, 4000.0)
        mapView.setRegion(region, animated: true)
        
        let customView = (Bundle.main.loadNibNamed("CustomCalloutView", owner: self, options: nil))?[0] as! CustomCalloutView;
        let calloutViewFrame = customView.frame;
        customView.frame = CGRect(x: -calloutViewFrame.size.width/2.23, y: -calloutViewFrame.size.height-7, width: 315, height: 200)
        view.addSubview(customView)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        for childView:AnyObject in view.subviews{
            childView.removeFromSuperview();
        }
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: 50.075538, longitude: 14.4378)
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var name: String
    var street: String
    var type: String
    var postCode: String
    
    init(name: String, street: String, type: String, postCode: String) {
        self.name = name
        self.street = street
        self.type = type
        self.postCode = postCode
    }
}
