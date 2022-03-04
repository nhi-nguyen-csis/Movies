//
//  ViewController.swift
//  Movies
//
//  Created by Nhi Nguyen on 2/25/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //create an array of dictionary
    // type of key is String, type of value is Any
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                 
                 // once we downloaded the complete all movies fetched data
                 // we need to make tableview reload their data
                 // reloadData() call the 2 func tableView again
                 self.tableView.reloadData()
                 
                    print(dataDictionary)
                    // TODO: Get the array of movies
                 
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a new cell and cast it as MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //get the movie titles in the fetched data
        let movie = movies[indexPath.row]
        // cast it into type String
        let title = movie["title"] as! String
        
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }

    // - For Navigation
    // in a storyboard-based application, you will often want to do a little
    // preparation before navigation
    
    // this's a special func. It's called when you're leaving your screen and you
    // want to prepare for the next screen - preparation for sending data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 2 tasks needed
        // TASK 1: find the selected movie, which one is tapped
        // the sender is the cell that is being tapped
        // in the parameter, sender is default Any type
        // so we need to let apple nows it's actually a UITableViewCell
        let cell = sender as! UITableViewCell
        // need to send what's the indexpath
        let indexPath = tableView.indexPath(for: cell)!
        // get the selected movie
        let movie = movies[indexPath.row]
        // TASK 2: pass the selected movie to the details view controller
        // we need to cast to MovieDetailsViewController as
        // it'll give me a generic UIViewController, won't give me
        // access to the movie property I want
        let detailsViewController = segue.destination as! MovieDetailsViewController
        // the movie on the right is the one we declare in this func
        detailsViewController.movie = movie
        
        // when we transition deselect table cell
        // without this line, if you go back to the previous screen
        // the selected row is highlighted, and we don't want it
        // to be highlighted
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // get the new view controller using segue.destination
    // pass the selected object to the new view controller

}

