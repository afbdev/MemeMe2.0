//
//  TableViewController.swift
//  MemeMe2.0
//
//  Created by afbdev on 9/14/16.
//  Copyright © 2016 afbdev. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var memes: [Meme]!
    
    @IBOutlet var tableView: UITableView!

    @IBAction func addMeme(_ sender: AnyObject) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        self.present(controller, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    // TABLE VIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        cell.textLabel?.text = self.memes[(indexPath as NSIndexPath).row].topText
        cell.detailTextLabel?.text = self.memes[(indexPath as NSIndexPath).row].bottomText
        cell.imageView?.image = self.memes[(indexPath as NSIndexPath).row].memedImage
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemedImageViewController") as! MemedImageViewController
        controller.meme = self.memes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }


    
}
