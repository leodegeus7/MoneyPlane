//
//  ExtratoTableViewController.swift
//  CoreData
//
//  Created by Leonardo Koppe Malanski on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class ExtratoTableViewController: UITableViewController {

    var numerodeCells = 5

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
//        DataManager.instance.atualizarArrayTransacao()
//        var teste = DataManager.instance.arrayTransacoes
//        print(teste.count)
//
//         return DataManager.instance.arrayTransacoes[0]["\(DataManager.instance.nomeSelecionado)"]!.count
        
        var nome = DataManager.instance.nomeSelecionado
        DataManager.instance.getTransacoesDeUsuario(nome)
        
        return DataManager.instance.transacoesdaPessoaSelecionada.count
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! ExtratoTableViewCell
        let valor: AnyObject? = DataManager.instance.transacoesdaPessoaSelecionada[indexPath.row]["valor"]
        cell1.valorTransacao.text = "R$\(valor!)"
        
        let data: AnyObject? = DataManager.instance.transacoesdaPessoaSelecionada[indexPath.row]["data"]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        var dataFormatada = dateFormatter.stringFromDate(data! as! NSDate)
        
        
        
        cell1.dataTransacao.text = "\(dataFormatada)"
        
       
//        if indexPath.row == (numerodeCells-1) {
//                       if (cell1.valorTransacao.text as! NSString).containsString("-") {
//                cell1.valorTransacao.textColor = UIColor.redColor()
//            
//            }
//
//        } else {
//            cell1.dataTransacao.text = "01/01/2015"
//            cell1.valorTransacao.text = "-5,00"
//        }
        return cell1


    }

    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataManager.instance.deletarTransacaoDeUsuario(DataManager.instance.nomeSelecionado, indexTransacao: indexPath.row)
            tableView.reloadData()
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
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
