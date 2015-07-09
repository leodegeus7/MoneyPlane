//
//  TransacaoViewController.swift
//  CoreData
//
//  Created by Leonardo Geus on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import CoreMotion


class TransacaoViewController: UIViewController,UITextFieldDelegate {
    let manager = CMMotionManager()
    var multiPeer = ColorServiceManager()
    var timer:NSTimer!
    var timer2:NSTimer!
    var controle = true
    @IBOutlet weak var pessoaImage: UIButton!
    @IBOutlet weak var textFieldTransacao: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pessoaImage.layer.borderWidth = 2.0
        pessoaImage.layer.masksToBounds = false
        pessoaImage.layer.borderColor = UIColor.blackColor().CGColor
        pessoaImage.layer.cornerRadius = 35.5
        pessoaImage.clipsToBounds = true
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                if data.userAcceleration.x > 1.5 {
                    
                    if self!.controle {
                        if !(self!.textFieldTransacao.text.isEmpty){
                            DataManager.instance.mandarValorParaOutroIphone(self!.textFieldTransacao.text)
                            self!.shake()
                        }
                        else {
                            DataManager.instance.mostrarUIAlert("Atenção", message: "Digite um valor para transferir", viewController: self!)
                        
                        
                        }
                    }
                    else {
                        println("esperaaa o timer!")
                    }
                
                        
                
                }
            }
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func shake() {
        multiPeer.serviceAdvertiser.startAdvertisingPeer()
        multiPeer.serviceBrowser.startBrowsingForPeers()
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(40, target: self, selector: Selector("desligarServico"), userInfo: nil, repeats: false)
        println("ligadoServico")
        self.controle = false

        self.timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("mandarValor"), userInfo: nil, repeats: true)
        self.mandarValor()
    }
    
    func mandarValor() {
        if DataManager.instance.mandarTransacao {
            multiPeer.sendColor(textFieldTransacao.text)
            DataManager.instance.mandarTransacao = false
            if !(timer2 == nil) {
                timer2.invalidate()}
            timer2 = nil
            desligarServico()
        }
    }
    
    
    func desligarServico() {
        multiPeer.serviceAdvertiser.stopAdvertisingPeer()
        multiPeer.serviceBrowser.stopBrowsingForPeers()
        self.controle = true
        println("desligadoServico")
        if !(timer == nil){
            timer.invalidate()}
        timer = nil
    }
    

}
