//
//  Entrada.swift
//  
//
//  Created by Felipe Ramon de Lara on 7/7/15.
//
//

import Foundation
import CoreData

class Entrada: NSManagedObject {

    @NSManaged var data: NSDate
    @NSManaged var descricao: String
    @NSManaged var valor: NSNumber
    @NSManaged var tipo: String
    @NSManaged var individuo: Pessoa

}
