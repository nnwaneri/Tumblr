//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Harold  on 11/20/17.
//  Copyright © 2017 Harold . All rights reserved.
//

import UIKit
import  AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    var valueToPass:String!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.tableView.rowHeight = 210
        
      
     
        fetchPhotoData()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Images")
        tableView.insertSubview(refreshControl, at: 0)
        
        self.valueToPass = "Hey"
        
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPhotoData()
    }
    
    func fetchPhotoData() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This would run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                
                let response = dataDictionary["response"] as! [String:Any]
                self.posts = response["posts"] as! [[String:Any]]
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
        task.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = posts[indexPath.row]
        
        
        let photos = post["photos"] as? [[String: Any]]
        let photo = photos![0]
        let originalSize = photo["original_size"] as! [String:Any]
        let urlString = originalSize["url"] as! String
        let url = URL(string: urlString)
        
        let caption = post["summary"] as! String
        
        cell.captionLabel.text = caption
        cell.photoImageView.af_setImage(withURL: url!)
        cell.selectionStyle = .none
      
        return cell
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "detailSegue") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! DetailViewController
                
                
                let post = posts[indexPath.row]
                let photos = post["photos"] as? [[String: Any]]
                let photo = photos![0]
                let originalSize = photo["original_size"] as! [String:Any]
                let urlString = originalSize["url"] as! String
               
                
                
                dvc.passedUrlValue = urlString
               
            }
          
           
        }
        
        else{
            
            print("Nope")
        }
        
    }

}


