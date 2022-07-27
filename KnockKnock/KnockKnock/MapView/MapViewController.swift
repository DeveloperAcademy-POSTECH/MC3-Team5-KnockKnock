//
//  MapViewController.swift
//  KnockKnock
//
//  Created by LeeJaehoon on 2022/07/26.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapConstraints()
        
        CenterDataManager.shared.centerInfoParse()
        
        addPins()
        
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mapView.delegate = self
    }
    
    func addPins() {
        let centerData = CenterDataManager.shared.getCenterData()
        
        for data in centerData {
            
//            let pin = MKPointAnnotation()
            let pin = CustomPointAnnotation()
            pin.title = data.name
            pin.subtitle = "주소 : " + data.address
            pin.tel = data.tel
            
            print(pin.tel)
            
            pin.coordinate = CLLocationCoordinate2D(
                latitude: data.gps.latitude,
                longitude: data.gps.longitude
            )
            
            mapView.addAnnotation(pin)
        }
    }
}

// override
class CustomPointAnnotation: MKPointAnnotation {
    var tel: String!
}



extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        annotationView.image = UIImage(systemName: "pin.fill")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(systemName: "building.2.crop.circle.fill"))
//        annotationView.detailCalloutAccessoryView = UIImageView(image: UIImage(systemName: "building.2.crop.circle.fill"))

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation Click")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! CustomPointAnnotation
        
        if view.rightCalloutAccessoryView == control {
            // right accessory
            print("right")
            print(annotation.tel)
        } else {
            // left accessory
            print("left")
        }
    }
}
