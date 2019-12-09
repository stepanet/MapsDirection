//
//  MainController.swift
//  MapsDirection
//
//  Created by Jack Sp@rroW on 08.12.2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import UIKit
import MapKit
import LBTATools

extension MainController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        
        annotationView.canShowCallout = true
        return annotationView
    }
}


class MainController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.mapType = .hybrid
        setupRegionForMap()
        
      //  setupAnnotationsForMap()
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch()  {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "кафе"
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search", err)
                return
            }
            
            //sucess
            resp?.mapItems.forEach({ (mapItem) in
                print(mapItem.placemark.subThoroughfare ?? "")
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            })
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        
    }
    
    
    fileprivate func setupAnnotationsForMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        annotation.title = "Это Москва"
        annotation.subtitle = "RU"
        mapView.addAnnotation(annotation)
        
        
        let sp = MKPointAnnotation()
        sp.coordinate = CLLocationCoordinate2D(latitude: 59.937500, longitude: 30.308611)
        sp.title = "St Petersburg"
        sp.subtitle = "RU"
        mapView.addAnnotation(sp)
        
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region =  MKCoordinateRegion(center: centerCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}


//SwiftUI preview

import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> MainController {
            return MainController()
        }
        
        func updateUIViewController(_ uiViewController: MainController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
        
        typealias UIViewControllerType = MainController
        
    }
    
}
