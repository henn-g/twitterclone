//
//  HomeTableViewVC.swift
//  Twitter
//
//  Created by Henry Guerra on 2/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewVC: UITableViewController {    
    
    /* Instance vars */
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    /* Public Actions */
    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    /* TWITTER API SPECIFIC CALLS */
    @objc func loadTweets() {
        numberOfTweets = 20
        
        let tweetAPI_Request = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let tweetAPI_RequestParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetAPI_Request, parameters: tweetAPI_RequestParams as [String : Any], success:
            { (tweets: [NSDictionary]) in
                
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
            
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            
            }, failure: { (Error) in
                print("Couldn't get tweets")
            })
    }
    
    // infinite scroll
    func loadMoreTweets() {
        let tweetAPI_Request = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        let tweetAPI_RequestParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetAPI_Request, parameters: tweetAPI_RequestParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Couldn't get tweets")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadTweets()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! HomeTableViewCell
        
        // set text for labels
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as! String

        // grab image data
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        if let imageData = data {
            cell.tweetImage.image = UIImage(data: imageData)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
    }

}
