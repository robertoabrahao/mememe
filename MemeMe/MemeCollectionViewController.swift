//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Roberto Abrahao on 5/24/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme]!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Obtain a copy of the memes shared model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    @IBAction func addMeme(sender: AnyObject) {

        //Return to the meme editor view controller
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Return the number of memes in the collection
        return self.memes.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //Return the current cell to populate the table view
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! UICollectionViewCell
        let meme = memes[indexPath.item]
        cell.backgroundView = UIImageView(image: meme.memedImage)
        
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Instantiate the meme detail view controller
        var memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController")as! MemeDetailViewController
        
        //Set the memed image to the meme detail view controller
        memeDetailVC.memedImage = memes[indexPath.row].memedImage
        
        //Navigates to the meme detail view controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(memeDetailVC, animated: true)
        }

    }
}
