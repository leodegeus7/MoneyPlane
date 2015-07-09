//
//  DataManager.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    static let instance: DataManager = DataManager()

    var indiceFoto = 0
    var multiPeer = ColorServiceManager()
    var transacaoView = TransacaoViewController()
    var timer:NSTimer!
    var mandarTransacao = false
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    
    func getPessoa()->[Pessoa]? {
        let request = NSFetchRequest(entityName: "Pessoa")
        var error:NSError?
        var pessoaLista = managedContext.executeFetchRequest(request, error: &error)
        
        return pessoaLista as! [Pessoa]?
    }
    
    
    
    func addPessoa(nome:String, myPeerID: String, imagem:String)->Bool {
        let pessoaEntidade = NSEntityDescription.entityForName("Pessoa", inManagedObjectContext: managedContext)
        let pessoa = Pessoa(entity: pessoaEntidade!, insertIntoManagedObjectContext: managedContext)
        pessoa.nome = nome
        pessoa.myPeerID = myPeerID
        pessoa.foto = imagem
        
        var error:NSError?
        
        return managedContext.save(&error)
        
    }
    
    func addTransacao(myPeerID:String, valor:String, hora:String, descricao:String) {
        let pessoaEntidade = NSEntityDescription.entityForName("Pessoa", inManagedObjectContext: managedContext)
        let pessoa = Pessoa(entity: pessoaEntidade!, insertIntoManagedObjectContext: managedContext)
        let entradaEntidade = NSEntityDescription.entityForName("Entrada", inManagedObjectContext: managedContext)
        let entrada = Entrada(entity: entradaEntidade!, insertIntoManagedObjectContext: managedContext)
        
        var arrayTransacao = NSMutableOrderedSet()
        
    }
    
    func removePessoa(pessoa: Pessoa)->Bool{
        managedContext.deleteObject(pessoa)
        var error : NSError?
        managedContext.save(&error)
        
        return false
        
    }
    
    func carregarImagem(nomeImagem:String) -> UIImage {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var path = documentsDirectory.stringByAppendingString("\(nomeImagem)")
        var image = UIImage(contentsOfFile: path)
        return image!
    }
    
    
    func salvarImagem(imagem:UIImage)->String {
        var indiceFotoString = "Fotos\(indiceFoto)"
        indiceFoto++
        salvarIndiceFotoTXT()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var path = documentsDirectory.stringByAppendingString("\(indiceFotoString).png")
        var data = UIImagePNGRepresentation(imagem)
        data.writeToFile(path, atomically: true)
        return path
    }
    
    func importarIndiceFotoTXT ()
    {
        let file = "indice.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingPathComponent(file);
            //reading
            var error:NSError?
            let text2 = String(contentsOfFile: path, encoding:NSUTF8StringEncoding, error: &error)
            if let theError = error {
                salvarIndiceFotoTXT()
            }
            else if error == nil{
                var nsstringText2:NSString
                nsstringText2 = text2!
                
                DataManager.instance.indiceFoto = nsstringText2.integerValue
                
                //                var pontosString:String
                //                pontosString = "\(pontos)"
                //                pontosString = text2!
            }
            
        }
        else {
            println("ERRO: NAO ACHOU DOCUMENTS")
        }
    }

    func salvarIndiceFotoTXT ()
    {
        let file = "indice.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingPathComponent(file);
            let text = "\(DataManager.instance.indiceFoto)"
            
            //writing
            text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil);
        }
        else {
            println("ERRO: NAO ACHOU DOCUMENTS")
        }
    }
    
    
    
    func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //SHAKE!!
    
    func shake() {
        multiPeer.serviceAdvertiser.startAdvertisingPeer()
        multiPeer.serviceBrowser.startBrowsingForPeers()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("desligarServico"), userInfo: nil, repeats: false)
        println("ligadoServico")
        transacaoView.controle = false
        
    } 
    
    func desligarServico() {
        multiPeer.serviceAdvertiser.stopAdvertisingPeer()
        multiPeer.serviceBrowser.stopBrowsingForPeers()
        transacaoView.controle = true
        println("desligadoServico")
        if !(timer == nil){
            timer.invalidate()}
        timer = nil
    }
    
    func mandarValorParaOutroIphone(valor:String) {
        multiPeer.sendColor(valor)
    }
    
    func mostrarUIAlert(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}