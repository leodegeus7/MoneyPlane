//
//  Pessoa.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import Foundation
import CoreData

class Pessoa: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var myPeerID: String
    @NSManaged var foto: String
    @NSManaged var transacao: Entrada

}
