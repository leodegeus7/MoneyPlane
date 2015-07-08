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
    

    func addEntradaParaPessoa(myPeerID: String, valor: NSNumber, data: NSDate, descricao: String, tipo: String) ->Bool {
        
        //Cria entrada
        let entradaEntidade = NSEntityDescription.entityForName("Entrada", inManagedObjectContext: managedContext)
        
        let entrada = Entrada(entity: entradaEntidade!, insertIntoManagedObjectContext: managedContext)
        
        entrada.valor = valor
        entrada.tipo = tipo
        entrada.descricao = descricao
        entrada.data = data
        
        
        //Carregar a pessoa com a qual a transaçao foi feita
        
        let request = NSFetchRequest(entityName: "Pessoa")
        request.predicate = NSPredicate(format: "myPeerId BEGINSWITH[cd] %@", myPeerID)
        
        
        var error : NSError?
        var objetos = managedContext.executeFetchRequest(request, error: &error)
        
        
        let pessoas = objetos as! [Pessoa]
        
        
        //Se a pessoa existe, adiciona a entrada
        if(pessoas.count>0){
            let pessoa = pessoas[0]
            entrada.individuo = pessoa
            
            let entradas = pessoa.transacao.mutableCopy() as! NSMutableOrderedSet
            entradas.addObject(entrada)
            pessoa.transacao = entradas.copy() as! NSOrderedSet
            
            
        }

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
     /*
func removePessoa(pessoa: Pessoa) -> Bool{
managedContext.deleteObject(pessoa)

var error: NSError?

return managedContext.save(&error)
}

func searchInPessoaEntity(predicate: NSPredicate) -> [Pessoa]? {

let request = NSFetchRequest(entityName: "Pessoa")
request.predicate = predicate

var error : NSError?
var objetos = managedContext.executeFetchRequest(request, error: &error)

if let results = objetos{
return results as? [Pessoa]
} else{
return nil
}

}

func alterarNomePessoa(name:String) ->Bool {
//Carregar a pessoa com a qual a transaçao foi feita

let request = NSFetchRequest(entityName: "Pessoa")
request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", name)


var error : NSError?
var objetos = managedContext.executeFetchRequest(request, error: &error)

if let persons = objetos {
if error == nil {
for person in persons {
(person as! Pessoa).nome = "ALTERADO"
}
}
}

return managedContext.save(&error)
}*/





}