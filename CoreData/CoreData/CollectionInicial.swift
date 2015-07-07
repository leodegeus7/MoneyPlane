//
//  CollectionInicial.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

let reuseIdentifier = "CustomCell"

var isGraphViewShowing = true
var controle = [Bool]()


class CollectionInicial: UICollectionViewController {


}

extension CollectionInicial : UICollectionViewDataSource {
    
    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numeroDeCelulas = 5
        for _ in 1...numeroDeCelulas {
            var trueBool = true
            controle.append(trueBool)}
        return numeroDeCelulas    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionInicialCell
        cell.backgroundColor = UIColor.clearColor()
        
        cell.imagePessoa.layer.borderWidth = 2.0
        cell.imagePessoa.layer.masksToBounds = false
        cell.imagePessoa.layer.borderColor = UIColor.blackColor().CGColor
        cell.imagePessoa.layer.cornerRadius = 35.5
        cell.imagePessoa.clipsToBounds = true
        
        
        
        return cell
    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionInicialCell
        
 
        if (controle[indexPath.row]) {

        UIView.transitionFromView(cell.viewUsuario,
                    toView: cell.viewSaldo,
                    duration: 1.0,
                    options: UIViewAnimationOptions.TransitionFlipFromLeft
                        | UIViewAnimationOptions.ShowHideTransitionViews,
                    completion:nil)
                
        } else {
        UIView.transitionFromView(cell.viewSaldo,
                    toView: cell.viewUsuario,
                    duration: 1.0,
                    options: UIViewAnimationOptions.TransitionFlipFromRight
                        | UIViewAnimationOptions.ShowHideTransitionViews,
                    completion: nil)
            }
        controle[indexPath.row] = !controle[indexPath.row]
    }
    
}


extension CollectionInicial : UICollectionViewDelegateFlowLayout {

    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            let sectionInsets = UIEdgeInsets(top: 20.0, left: 30.0, bottom: 20.0, right: 30.0)
            
            return sectionInsets
    }
}