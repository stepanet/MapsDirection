//
//  LocationCarouselController.swift
//  MapsDirection
//
//  Created by Jack Sp@rroW on 12.12.2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import LBTATools
import UIKit
import MapKit

class LocationCell: LBTAListCell<MKMapItem> {
    
    
    override var item: MKMapItem! {
        didSet {
            label.text = item.name
        }
    }
    let label = UILabel(text: "Location", font: .boldSystemFont(ofSize: 16))
    
    
    override func setupViews() {
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
        layer.cornerRadius = 5
        
        stack(label).withMargins(.allSides(16))
        
    }
}


class LocationCarouselController: LBTAListController<LocationCell, MKMapItem> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        
//        let placemark = MKPlacemark(coordinate: .init(latitude: 10, longitude: 10))
//        let dummyMapItem = MKMapItem(placemark: placemark)
//        dummyMapItem.name = "Dummy location"
//        self.items = [dummyMapItem]
        //    self.items = ["1","2","3"]
    }
}
extension LocationCarouselController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
