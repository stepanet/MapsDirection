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
        //mapView.mapType = .hybrid
        
        setupRegionForMap()
        
        //setupAnnotationsForMap()
        //performLocalSearch()
        setupSearchUI()
    }
    
    let searchTextField = UITextField(placeholder: "Поиск")
    
    

    fileprivate func setupSearchUI() {

        let whiteContainer = UIView(backgroundColor: .white)
        view.addSubview(whiteContainer)
        whiteContainer.layer.cornerRadius = 15
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        //listen for text changes OLD SCOOL
        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
        
        //NEW SCOOL
        
//        NotificationCenter.default
//        .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
//        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//        .sink { (_) in
//                print(1231230)
//                self.performLocalSearch()
//        }
        
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    
    fileprivate func performLocalSearch()  {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search", err)
                return
            }
            
            //sucess
            self.mapView.removeAnnotations(self.mapView.annotations)
            resp?.mapItems.forEach({ (mapItem) in

                //let placemark = mapItem.placemark
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
        
        
//        let sp = MKPointAnnotation()
//        sp.coordinate = CLLocationCoordinate2D(latitude: 59.937500, longitude: 30.308611)
//        sp.title = "St Petersburg"
//        sp.subtitle = "RU"
//        mapView.addAnnotation(sp)
                
        mapView.showAnnotations(self.mapView.annotations, animated: true)
 
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region =  MKCoordinateRegion(center: centerCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

extension MKMapItem {
    func address() -> String {
        var addressString = ""
        
        if placemark.subThoroughfare != nil {
            addressString += placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + " "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + " "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country! + " "
        }
        
        return addressString
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
