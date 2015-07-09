
//
//  CollectionInicial.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import CoreMotion

let reuseIdentifier = "CustomCell"

var isGraphViewShowing = true
var controle = [Bool]()
var multiPeer = ColorServiceManager()
var transacaoView = TransacaoViewController()
var timer:NSTimer!
var timerDesativarShake:NSTimer!
let manager = CMMotionManager()
var controleShake = true
var pessoaLista = DataManager.instance.getPessoa()


class CollectionInicial: UICollectionViewController {

    

    
    override func viewDidLoad() {
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                //println("\(controleShake) \(data.userAcceleration.x)")
                if data.userAcceleration.x > 1.5 && controleShake {
                        shake()
                        timerDesativarShake = NSTimer.scheduledTimerWithTimeInterval(40, target: self!, selector: Selector("desligarServico"), userInfo: nil, repeats: false)
                        controleShake = false}
                    
                    
                }
        }
        
        
        for pessoa in pessoaLista! {
            println("anTES\(pessoa.nome)  \(pessoa.foto)")
            
            
        }
        
    }

    func desligarServico() {
        multiPeer.serviceAdvertiser.stopAdvertisingPeer()
        multiPeer.serviceBrowser.stopBrowsingForPeers()
        transacaoView.controle = true
        println("desligadoServico")
        if !(timer == nil){
            timer.invalidate()}
        timer = nil
        controleShake = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: false)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "alerta:", name: "receberData", object: nil)
        
    }
    
    func alerta(notificao:NSNotification) {
        let userInfo = notificao.userInfo! as Dictionary
        let str = userInfo["teste"] as! String
        let user = userInfo["peerID"] as! String
        
        
        
        let alert = UIAlertController(title: "Atencão!", message: "Recebeu R$\(str),00 de \(user)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        desligarServico()

        println("dados recebidos")
    }

    override func viewWillDisappear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
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
    
    override func viewDidAppear(animated: Bool) {
        shake()
    }
    
    override func viewDidDisappear(animated: Bool) {
        desligarServico()
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


func shake() {
    multiPeer.serviceAdvertiser.startAdvertisingPeer()
    multiPeer.serviceBrowser.startBrowsingForPeers()
    println("ligadoServico")
//    transacaoView.controle = false


}




    