//
//  MemedImageViewController.swift
//  MemeMe2.0
//
//  Created by afbdev on 9/16/16.
//  Copyright © 2016 afbdev. All rights reserved.
//

import UIKit

class MemedImageViewController: UIViewController {

    var meme: Meme!
    
    
    @IBOutlet var imageView: UIImageView!
    

    func editMeme() {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        controller.meme = self.meme
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = meme.memedImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: "editMeme")
        tabBarController?.tabBar.isHidden = true
    }
    

    
}
