//
//  EscolhaPessoaTableViewController.swift
//  CoreData
//
//  Created by Leonardo Koppe Malanski on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class EscolhaPessoaTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    let verdeEscuro = UIColor (red: 10/255.0, green: 111/255.0, blue: 48/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
    
        return DataManager.instance.arrayPessoasConvertido.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let date = NSDate()
        var valor = Float((DataManager.instance.valorTemporario as NSString).floatValue)
        let usuario = DataManager.instance.arrayPessoasConvertido[indexPath.row]["nome"] as? String

        DataManager.instance.addEntradaParaPessoa(usuario!, valor: valor, data: date, descricao: "", tipo: DataManager.instance.transacaoTemporario)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewControllerWithIdentifier("CollectionViewController") as! UIViewController
        navigationController?.pushViewController(secondViewController, animated: true)
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EscolhaPessoaTableViewCell
        
        
        cell.nomePessoa.text = DataManager.instance.arrayPessoasConvertido[indexPath.row]["nome"] as? String
        cell.saldoPessoa.text = "0,00"
        
        
        let caminhoImagem = DataManager.instance.acharImagemUser(pessoaListaArray[indexPath.row]["foto"] as! String)
        cell.imagemPessoa.image = UIImage(contentsOfFile: caminhoImagem)

        cell.imagemPessoa?.layer.borderWidth = 3.0
        cell.imagemPessoa?.layer.masksToBounds = false
        cell.imagemPessoa?.layer.cornerRadius = 30
        cell.imagemPessoa?.clipsToBounds = true
        cell.saldoPessoa.textColor = UIColor.darkGrayColor()
        cell.nomePessoa.textColor = UIColor.darkGrayColor()
    
        if (cell.saldoPessoa.text as! NSString).containsString("-") {
            cell.imagemPessoa?.layer.borderColor = UIColor.redColor().CGColor
        
        } else {
            cell.imagemPessoa?.layer.borderColor = verdeEscuro.CGColor
            
        }
    
        return cell
    }
    

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
