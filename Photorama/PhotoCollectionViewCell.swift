//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Olajide Osho on 05/05/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update(displaying image: UIImage?) {
        if let photoToDisplay = image {
            spinner.stopAnimating()
            imageView.image = image
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
