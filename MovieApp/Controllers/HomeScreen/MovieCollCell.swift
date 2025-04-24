//
//  MovieCollCell.swift
//  MovieApp
//
//  Created by Sourabh Modi on 18/10/24.
//

import UIKit

class MovieCollCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var maoviePosterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        maoviePosterView.layer.cornerRadius = 8
        maoviePosterView.layer.masksToBounds = true
    }
}
