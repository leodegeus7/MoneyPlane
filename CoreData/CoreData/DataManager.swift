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
    
    //Linha mágica do CoreData:
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
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var path = documentsDirectory.stringByAppendingString("\(indiceFotoString).png")
        var data = UIImagePNGRepresentation(imagem)
        data.writeToFile(path, atomically: true)
        return path
    }
    
    
    func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //SHAKE!!
    
    
    
    
    
    
}