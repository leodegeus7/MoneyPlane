//
//  EscolhaPessoaTableViewController.swift
//  CoreData
//
//  Created by Leonardo Koppe Malanski on 07/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import Foundation

class EscolhaPessoaTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

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
        
        var numeroDeCells = 5
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
    
        return numeroDeCells
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EscolhaPessoaTableViewCell

        switch indexPath.row {
        case 0:
            cell.nomePessoa.text = "Leonardo de Geus"
            cell.saldoPessoa.text = "-15,30"
        case 1:
            cell.nomePessoa.text = "Leonardo Piovezan"
            cell.saldoPessoa.text = "1,30"
        break
        default:
            cell.nomePessoa.text = "Default"
            cell.saldoPessoa.text = "Nil"
        }
        
        cell.imagemPessoa.image = UIImage (named: "profileIcon")
        cell.imagemPessoa?.layer.borderWidth = 2.0
        cell.imagemPessoa?.layer.masksToBounds = false
        cell.imagemPessoa?.layer.cornerRadius = 30
        cell.imagemPessoa?.clipsToBounds = true
        cell.saldoPessoa.textColor = UIColor.darkGrayColor()
        cell.nomePessoa.textColor = UIColor.darkGrayColor()
    
        if (cell.saldoPessoa.text as! NSString).containsString("-") {
            cell.imagemPessoa?.layer.borderColor = UIColor.redColor().CGColor
        
        } else {
            cell.imagemPessoa?.layer.borderColor = UIColor.blueColor().CGColor
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
