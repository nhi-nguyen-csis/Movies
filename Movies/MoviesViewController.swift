//
//  ViewController.swift
//  Movies
//
//  Created by Nhi Nguyen on 2/25/22.
//

import UIKit

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
        
        return cell
    }


}

