//
//  Entrada.swift
//  CoreData
//
//  Created by Leonardo Geus on 06/07/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import Foundation
import CoreData

class Entrada: NSManagedObject {

    @NSManaged var data: String
    @NSManaged var descricao: String
    @NSManaged var valor: NSNumber
    @NSManaged var individuo: Pessoa

}
