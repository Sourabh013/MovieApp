//
//  MovieDetailedController.swift
//  MovieApp
//
//  Created by Sourabh Modi on 19/10/24.
//

import Foundation
import UIKit
import SDWebImage

class MovieDetailedController: UIViewController {
    var selectedMovie: GetMovieListModel?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDecrepLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieDetailsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMovieDetails()
        moviePosterView.layer.cornerRadius = 8
        moviePosterView.layer.masksToBounds = true
        viewDesign(to: movieDetailsView)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    // Method for mapMovieDetails-----
    func mapMovieDetails() {
        if let movie = selectedMovie {
            movieTitleLabel.text = "Title - \(movie.Title)"
            movieYearLabel.text = "Year - \(movie.Year)"
            if let imageURL = URL(string: movie.Poster) {
                moviePosterView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder.png"))
            }
        }
    }
    func viewDesign(to view: UIView) {
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 0.5
            view.layer.masksToBounds = true
        }
}
