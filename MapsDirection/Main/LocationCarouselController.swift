//
//  LocationCarouselController.swift
//  MapsDirection
//
//  Created by Jack Sp@rroW on 12.12.2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import LBTATools
import UIKit


class LocationCell: LBTAListCell<String> {
    override func setupViews() {
        backgroundColor = .yellow
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
        layer.cornerRadius = 5
        clipsToBounds = false
    }
}


class LocationCarouselController: LBTAListController<LocationCell, String>, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
            self.items = ["1","2","3"]
    }
}
