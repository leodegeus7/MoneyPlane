//
//  AddPessoaViewController.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class AddPessoaViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {


    @IBOutlet weak var nomePessoa: UITextField!
    @IBOutlet weak var charIconButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        charIconButton.layer.borderWidth = 2.0
        charIconButton.layer.masksToBounds = false
        charIconButton.layer.borderColor = UIColor.blackColor().CGColor
        charIconButton.layer.cornerRadius = 35.5
        charIconButton.clipsToBounds = true
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPessoaButton(sender: AnyObject) {
        
        
    }
    

    
    @IBAction func trocarImagem(sender: AnyObject) {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        

        self.presentViewController(picker, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        var path = DataManager.instance.salvarImagem(image)
        charIconButton.setImage(image, forState: UIControlState.Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
 

}
