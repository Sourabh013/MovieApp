//
//  HomeController.swift
//  MovieApp
//
//  Created by Sourabh Modi on 18/10/24.
//

import UIKit
import SDWebImage

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var movieList: [GetMovieListModel] = []
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    var currentPage = 0
    let pageSize = 3
    var isLoading = false
    var isOnline = true
    var totalMoviesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList()
        // Configure XIB for collection view
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .networkStatusChanged, object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        movieListCollectionView?.refreshControl = refreshControl
        
    }
    func setupCollectionView() {
        movieListCollectionView.dataSource = self
        movieListCollectionView.delegate = self
        let uiNib: UINib = UINib(nibName: "MovieCollCell", bundle: nil)
        movieListCollectionView.register(uiNib, forCellWithReuseIdentifier: "movie_coll_cell")
        gridCollectionView()
    }
    @objc func loadData() {
        currentPage = 0
        movieList.removeAll()
        checkNetworkAndFetchMovies()
        DispatchQueue.main.async {
            self.movieListCollectionView.refreshControl?.endRefreshing()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCollCell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: "movie_coll_cell", for: indexPath) as? MovieCollCell else {
            fatalError("Unable to dequeue MovieCollCell")
        }
        
        let movie = movieList[indexPath.item]
        movieCollCell.titleLabel.text = movie.Title
        let imageURL = URL(string: movie.Poster)
        movieCollCell.maoviePosterView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        // movieCollCell.configure(with: movie)
        
        return movieCollCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movieList[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailCon: MovieDetailedController = storyBoard.instantiateViewController(withIdentifier: "movie_detail_con") as! MovieDetailedController
        // Pass the selected Movie to detailed VC
        movieDetailCon.selectedMovie = selectedMovie
        self.present(movieDetailCon, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieList.count - 1 && !isLoading && movieList.count < totalMoviesCount     {
            loadMoreMovies()
        }
    }
    // Methods for check network availability
    @objc func networkStatusChanged() {
        checkNetworkAndFetchMovies()
    }
    private func checkNetworkAndFetchMovies() {
        isOnline = NetworkCheck.shared.isConnected
        if isOnline {
            print("Network available----------")
            getMovieList()
        } else {
            print("Device is offline---------")
            loadMoviesFromLocalDatabase()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // Mwthod for grid view
    func gridCollectionView() {
        if let layout = movieListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = movieListCollectionView.bounds.width
            let itemWidth = (width / 2) - 10
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
    }
    // Method for getMovieDetails from local DB
    func loadMoviesFromLocalDatabase() {
        guard !isLoading else { return }
        isLoading = true
        
        let offset = currentPage * pageSize
        let movies = CoreDataManager.shared.fetchMovies(offset: offset, limit: pageSize)
        let newMovies = movies.map { movieEntity in
            return GetMovieListModel(Title: movieEntity.movieTitle ?? "",
                                     Year: String(movieEntity.movieYear),
                                     imdbID: String(movieEntity.movieId),
                                     MediaType: movieEntity.movieMediaType ?? "",
                                     Poster: movieEntity.moviePoster ?? "")
        }
        self.movieList.append(contentsOf: newMovies)
        
        if self.totalMoviesCount == 0 {
            self.totalMoviesCount = CoreDataManager.shared.getTotalMoviesCount()
        }
        
        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
            self.isLoading = false
        }
        print("Loaded \(newMovies.count) movies from local database. Total: \(self.movieList.count)")
    }
    // Method to get Movie list------
    func getMovieList() {
        guard !isLoading else { return }
        isLoading = true
        let movieFetcher = GetMovieList()
        movieFetcher.getMovieList{ [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    CoreDataManager.shared.saveMovies(response.Search)
                    self.movieList = response.Search
                    self.totalMoviesCount = Int(response.totalResults) ?? 0
                    self.movieListCollectionView.reloadData()
                    
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
    func loadMoreMovies() {
        if isOnline {
            currentPage += 1
            loadMoviesFromLocalDatabase()
        } else {
            currentPage += 1
            loadMoviesFromLocalDatabase()
        }
    }
}
