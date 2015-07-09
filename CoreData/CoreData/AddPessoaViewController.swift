//
//  AddPessoaViewController.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class AddPessoaViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var controleFoto = false

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
    

    
    @IBAction func addPessoaBotao(sender: UIButton) {
        if !(nomePessoa.text.isEmpty) {
            if controleFoto {
        DataManager.instance.addPessoa(nomePessoa.text, myPeerID: "", imagem: "DocumentsFotos\(DataManager.instance.indiceFoto)")
        navigationController?.popToRootViewControllerAnimated(true)
        controleFoto = false
            }
            else {
                DataManager.instance.mostrarUIAlert("Atenção", message: "Clique no personagem para adicionar uma foto", viewController: self)
            
            }
        }
        else {
            DataManager.instance.mostrarUIAlert("Atenção", message: "Digite um nome para contato", viewController: self)
            
        }
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
        println("\(path)")
        charIconButton.setImage(image, forState: UIControlState.Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
        controleFoto = true
    }
    
 

}
