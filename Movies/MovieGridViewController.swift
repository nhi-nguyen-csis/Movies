//
//  MovieGridViewController.swift
//  Movies
//
//  Created by Nhi Nguyen on 3/4/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    // create an array of dictionary
    // type of key is String, type of value is Any
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //connect to the API network and get the list of similar superhero movie
        let url = URL(string: "https://api.themoviedb.org/3/movie/634649/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 // get the fetched dataDictionary from JSON and store only the result to movies
                 // we need to cast the JSON format into an array of dictionary by using as!
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 // once we downloaded the complete all similar movies fetched data
                 // we need to make tableview reload their data
                 // reloadData() call the 2 func tableView again
                 self.collectionView.reloadData()
                 print(self.movies)
             }
        }
        task.resume()
    } // end viewDidLoad()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // this's a special func. It's called when you're leaving your screen and you
    // want to prepare for the next screen - preparation for sending data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 2 tasks needed:
        // 1. Find the selected movie
        // 2. Pass the selected movie to the details view controller
        // TASK 1: find the selected movie, which one is tapped
        // - sender is the cell that is being tapped
        // in the parameter, sender is default Any type
        // so we need to let apple nows it's actually a UITableViewCell
        let cell = sender as! UICollectionViewCell
        // need to send what's the indexpath
        let indexPath = collectionView.indexPath(for: cell)!
        // get the selected movie
        let movie = movies[indexPath.row]
        // TASK 2: pass the selected movie to the MovieGridDetailsViewController
        // we need to cast to MovieGridDetailsViewController (the destination) as
        // it'll give me a generic UIViewController, which won't give me
        // access to the movie property I want
        let detailsViewController = segue.destination as! MovieDetailsViewController
        // the movie on the right is the one we declare in this func
        detailsViewController.movie = movie
        
        // when we transition deselect table cell
        // without this line, if you go back to the previous screen
        // the selected row is highlighted, and we don't want it
        // to be highlighted
        collectionView.deselectItem(at: indexPath, animated: true)
        //testing
        print("Loading GRID DETAIL VIEW CONTROLLER")
    }

}
