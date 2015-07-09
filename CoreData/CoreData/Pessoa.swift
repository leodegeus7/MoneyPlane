//
//  Pessoa.swift
//  
//
//  Created by Felipe Ramon de Lara on 7/7/15.
//
//

import Foundation
import CoreData

class Pessoa: NSManagedObject {

    @NSManaged var foto: String
    @NSManaged var myPeerID: String
    @NSManaged var nome: String
    @NSManaged var transacao: NSOrderedSet

}
