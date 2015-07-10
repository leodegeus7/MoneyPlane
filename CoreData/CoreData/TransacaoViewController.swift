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
    var transacaoTipo = ""
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var botaoVerdeOutlet: UIButton!
    @IBOutlet weak var botaoVermelhoOutlet: UIButton!
    @IBOutlet weak var pessoaImage: UIButton!
    @IBOutlet weak var textFieldTransacao: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.hidden = true
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
                        if !(self!.transacaoTipo == "") {
                            if !(self!.textFieldTransacao.text.isEmpty){
                                var valorNegativo = "-\(self!.textFieldTransacao.text)"
                                if self!.transacaoTipo == "entrada" {
                                    
                                    DataManager.instance.mandarValorParaOutroIphone(valorNegativo)
                                    self!.shake()
                                    self!.textFieldTransacao.resignFirstResponder()
                                    
                                
                                }
                                else  if self!.transacaoTipo == "saida" {
                                    DataManager.instance.mandarValorParaOutroIphone(self!.textFieldTransacao.text)
                                    self!.shake()
                                    self!.textFieldTransacao.resignFirstResponder()
                                    
                                }
                                

                                
                                
                            }
                            else {
                                DataManager.instance.mostrarUIAlert("Atenção", message: "Digite um valor para transferir", viewController: self!)
                            }
                        }
                        else {
                            
                            DataManager.instance.mostrarUIAlert("Atenção", message: "Clique nas flechas para escolher o tipo de transacao", viewController: self!)
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
    
    @IBAction func botaoVerdeAction(sender: AnyObject) {
        transacaoTipo = "entrada"
        DataManager.instance.transacaoTemporario = "entrada"
        botaoVermelhoOutlet.alpha = 0.1
        botaoVerdeOutlet.alpha = 1
    }
    
    
    @IBAction func botaoVermelhoAction(sender: AnyObject) {
        transacaoTipo = "saida"
        DataManager.instance.transacaoTemporario = "saida"
        botaoVermelhoOutlet.alpha = 1
        botaoVerdeOutlet.alpha = 0.1
    }
    
    
    func shake() {
        multiPeer.serviceAdvertiser.startAdvertisingPeer()
        multiPeer.serviceBrowser.startBrowsingForPeers()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("desligarServico"), userInfo: nil, repeats: false)
        println("ligadoServico")
        self.controle = false

        self.timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("mandarValor"), userInfo: nil, repeats: true)
        self.mandarValor()
        self.loader.hidden = false
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
    

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if textField == textFieldTransacao {
            if count(string) > 0 {
                let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789,.").invertedSet
                let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = count(prospectiveText) <= 8
                
                let scanner = NSScanner(string: prospectiveText)
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
                
                result = replacementStringIsLegal &&
                    resultingStringLengthIsLegal &&
                resultingTextIsNumeric
            }
        }
        return result
    }
    
    
    func desligarServico() {
        //multiPeer.serviceAdvertiser.stopAdvertisingPeer()
        //multiPeer.serviceBrowser.stopBrowsingForPeers()
        self.controle = true
        println("desligadoServico")
        if !(timer == nil){
            timer.invalidate()}
        timer = nil
        self.loader.hidden = true
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    

}
