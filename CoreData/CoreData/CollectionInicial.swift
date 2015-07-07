//
//  CollectionInicial.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

let reuseIdentifier = "CustomCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
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
            controle.append(trueBool)
        }
        
        return numeroDeCelulas    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionInicialCell
        
        cell.backgroundColor = UIColor.blackColor()

        cell.texttESTE.text = "oi"
        
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


