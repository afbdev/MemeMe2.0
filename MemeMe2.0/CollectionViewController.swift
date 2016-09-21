//
//  CollectionViewController.swift
//  MemeMe2.0
//
//  Created by afbdev on 9/14/16.
//  Copyright © 2016 afbdev. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var memes: [Meme]!
    
    @IBOutlet var collection: UICollectionView!
    
    @IBAction func addMeme(_ sender: AnyObject) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        self.present(controller, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }
    


    
    // COLLECTION VIEW METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as? MemeCell {
            
            let meme = memes[indexPath.item]
            cell.memeImageView?.image = meme.memedImage
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemedImageViewController") as! MemedImageViewController
        controller.meme = self.memes[indexPath.item]
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 115, height: 115)
    }
    
    

}
