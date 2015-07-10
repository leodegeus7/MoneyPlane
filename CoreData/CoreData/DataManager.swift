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
    var arrayPessoasConvertido = [NSDictionary]()
    var arrayTransacoes = [[NSDictionary]]()


    var indiceFoto = 0
    var multiPeer = ColorServiceManager()
    var transacaoView = TransacaoViewController()
    var timer:NSTimer!
    var mandarTransacao = false
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var myPeerIdTemporario = ""
    var controleSeMyPeer = false
    var valorTemporario = ""
    var transacaoTemporario = ""
    var saldoDosUsuarios = [Float]()
    var rowSelecionada = 0
    
    var transacoesdaPessoaSelecionada = [NSDictionary]()
    
    
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
    

    func addEntradaParaPessoa(pessoa: String, valor: NSNumber, data: NSDate, descricao: String, tipo: String) ->Bool {
        
        //Cria entrada
        let entradaEntidade = NSEntityDescription.entityForName("Entrada", inManagedObjectContext: managedContext)
        
        let entrada = Entrada(entity: entradaEntidade!, insertIntoManagedObjectContext: managedContext)
        
        entrada.valor = valor
        entrada.tipo = tipo
        entrada.descricao = descricao
        entrada.data = data
        
        
        //Carregar a pessoa com a qual a transaçao foi feita
        
        let request = NSFetchRequest(entityName: "Pessoa")
        request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", pessoa)
        
        
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


    
//    
//    func addTransacao(myPeerID:String, valor:String, hora:String, descricao:String) {
//        let pessoaEntidade = NSEntityDescription.entityForName("Pessoa", inManagedObjectContext: managedContext)
//        let pessoa = Pessoa(entity: pessoaEntidade!, insertIntoManagedObjectContext: managedContext)
//        let entradaEntidade = NSEntityDescription.entityForName("Entrada", inManagedObjectContext: managedContext)
//        let entrada = Entrada(entity: entradaEntidade!, insertIntoManagedObjectContext: managedContext)
//        
//        var arrayTransacao = NSMutableOrderedSet()
//        
//    }
    
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
        var indiceFotoString = "/Fotos\(indiceFoto)"
        indiceFoto++
        salvarIndiceFotoTXT()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var path = documentsDirectory.stringByAppendingString("\(indiceFotoString).png")
        var data = UIImagePNGRepresentation(imagem)
        data.writeToFile(path, atomically: true)
        return path
    }
    
    func acharImagemUser(imagem:String)->String {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var path = documentsDirectory.stringByAppendingString("/\(imagem).png")
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
    
    func atualizarArrayPessoas() {
        var arrayPessoas = DataManager.instance.getPessoa()
        for pessoa in arrayPessoas! {
            let nome = pessoa.nome
            let myPeerID = pessoa.myPeerID
            let foto = pessoa.foto
            let transacao = pessoa.transacao
            let dicionario = ["nome":nome,"myPeerID":myPeerID,"foto":foto,"transacao":transacao]
            
            arrayPessoasConvertido.append(dicionario)
            
        }
    }
    
    func calcularSaldoDoUsuario(nome: String) -> Float {
        //calcular saldo dos usuarios para apresentar na tela inicial
    
        
        let request = NSFetchRequest(entityName: "Pessoa")
        request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", nome)
        
        
        var error : NSError?
        var objetos = managedContext.executeFetchRequest(request, error: &error)
        
        
        let pessoas = objetos as! [Pessoa]
        var saldo:Float = 0.0
        if(pessoas.count>0){
            let pessoa = pessoas[0]
            
            let entradas = pessoa.transacao.mutableCopy() as! NSMutableOrderedSet
            
            for entrada in entradas {
                saldo += (entrada as! Entrada).valor.floatValue
            }
        }
        
        return saldo
    }
    
    func deletarTransacaoDeUsuario(nome: String, indexTransacao: Int) -> Bool {
        //deletar do coredada a dada transacao do usuario

        
        //Carregar a pessoa com a qual a transaçao foi feita
        
        let request = NSFetchRequest(entityName: "Pessoa")
        request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", nome)
        
        
        var error : NSError?
        var objetos = managedContext.executeFetchRequest(request, error: &error)
        
        
        let pessoas = objetos as! [Pessoa]
        
        if(pessoas.count>0){
            let pessoa = pessoas[0]
            
            let entradas = pessoa.transacao.mutableCopy() as! NSMutableOrderedSet
            entradas.removeObjectAtIndex(indexTransacao)
            pessoa.transacao = entradas.copy() as! NSOrderedSet
            
            
        }
        
        return managedContext.save(&error)

        
    }
    
    
//    func atualizarArrayTransacao() {
//        
//        
//        var arrayDePessoasCoreData = DataManager.instance.getPessoa()
//        var pessoaEscolhidaCoreData = arrayDePessoasCoreData?.first
//        
//        for pessoa in arrayDePessoasCoreData! {
//            var nomePessoa = pessoa.nome
//            var transacoesPessoa = [NSDictionary]()
//            for var i=0 ; i < pessoa.transacao.count ; i++ {
//                let entrada: Entrada = pessoa.transacao.array[i] as! Entrada
//                let valor = entrada.valor
//                let data = entrada.data
//                let descricao = entrada.descricao
//                let tipo = entrada.tipo
//                let dicionarioEntradas = ["valor":valor,"data":data,"descricao":descricao,"tipo":tipo]
//                transacoesPessoa.append(dicionarioEntradas)
//                
//            }
//            
//            let dicionarioPessoa = ["\(nomePessoa)":transacoesPessoa]
//
//            
//            arrayTransacoes.append(transacoesPessoa)
//            
//        }
//        
//        
////        transacoesPessoasCoreData.data =
////        
////        var arrayDePessoas = arrayPessoasConvertido
////        var pessoaEscolhida = arrayDePessoas[pessoa]
////        var transacoesPessoas = pessoaEscolhida["transacao"] as! NSArray
////        for var i = 0 ;i < transacoesPessoas.count ; i++ {
////            var data =
////        
////
//    
//        
//   // println("\(array)")
//    
//        
//}
    
    
    
    func getEntradasFromPessoa(nome: String){
        transacoesdaPessoaSelecionada.removeAll(keepCapacity: false)
        
        let request = NSFetchRequest(entityName: "Pessoa")
        request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", nome)
        
        
        var error : NSError?
        var objetos = managedContext.executeFetchRequest(request, error: &error)
        
        
        let pessoas = objetos as! [Pessoa]
        
        
        
        if(pessoas.count>0){
            let pessoa = pessoas[0]
            
            let entradas = pessoa.transacao.mutableCopy() as! NSMutableOrderedSet
            
            for entrada in entradas {
                println("valor entrada \((entrada as! Entrada).valor)")
                var valor = (entrada as! Entrada).valor
                var data = (entrada as! Entrada).data
                var descricao = (entrada as! Entrada).descricao
                var tipo = (entrada as! Entrada).tipo
                
                var dicionarioEntradas = ["valor":valor,"data":data,"descricao":descricao,"tipo":tipo]
                transacoesdaPessoaSelecionada.append(dicionarioEntradas)

            }
        }
        
        print(transacoesdaPessoaSelecionada)
    }
    
//

    

    //func alterarNomePessoa(name:String) ->Bool {
    ////Carregar a pessoa com a qual a transaçao foi feita
    //
    //let request = NSFetchRequest(entityName: "Pessoa")
    //request.predicate = NSPredicate(format: "nome BEGINSWITH[cd] %@", name)
    //
    //
    //var error : NSError?
    //var objetos = managedContext.executeFetchRequest(request, error: &error)
    //
    //if let persons = objetos {
    //if error == nil {
    //for person in persons {
    //(person as! Pessoa).nome = "ALTERADO"
    //}
    //}
    //}
    //
    //return managedContext.save(&error)
    //}*/
    //
    //
    //
}