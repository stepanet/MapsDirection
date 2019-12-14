//
//  MainController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Brian Voong on 11/3/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
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

class MainController: UIViewController, UITextFieldDelegate {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
        setupRegionForMap()
        
//      setupAnnotationsForMap()
        performLocalSearch()
        setupSearchUI()
        setupLocationsCarousel()
        locationsController.mainController = self
    }

    let locationsController = LocationsCarouselController(scrollDirection: .horizontal)
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    fileprivate func setupLocationsCarousel() {
  
        let locationsView = locationsController.view!
        view.addSubview(locationsView)
        locationsView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
    
    let searchTextField = UITextField(placeholder: "Поиск")
    
    fileprivate func setupSearchUI() {
        let whiteContainer = UIView(backgroundColor: .gray)
        whiteContainer.layer.cornerRadius = 5
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        // listen for text changes and then perform new search
        // OLD SCHOOL
       searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)

        
        // NEW SCHOOL Search Throttling
        // search on the last keystroke of text changes and basically wait 500 milliseconds
//        _ = NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .sink { (_) in
//                self.performLocalSearch()
//        }
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    
    
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        
        mapView.annotations.forEach { (annotation) in
            if annotation.title == "TEST" {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search:", err)
                return
            }
            
            // Success
            // remove old annotations
            self.mapView.removeAnnotations(self.mapView.annotations)
                self.locationsController.items.removeAll()
            
            resp?.mapItems.forEach({ (mapItem) in
                print(mapItem.address())
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
                self.locationsController.items.append(mapItem)
            })
            
            if resp?.mapItems.count != 0 {
                self.locationsController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    fileprivate func setupAnnotationsForMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        mapView.addAnnotation(annotation)
        
        let appleCampusAnnotation = MKPointAnnotation()
        appleCampusAnnotation.coordinate = .init(latitude: 37.3326, longitude: -122.030024)
        appleCampusAnnotation.title = "Apple Campus"
        appleCampusAnnotation.subtitle = "Cupertino, CA"
        mapView.addAnnotation(appleCampusAnnotation)
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    fileprivate func setupRegionForMap() {
        //let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let centerCoordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}



// SwiftUI Preview
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
