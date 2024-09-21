//
//  Params.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 17.02.2024.
//

import Foundation
import FMDB

enum ParamType: Int {
    case undef = 0
    case aiKey = 1
    case aiModel = 2
    case apiAdress = 3
    case apiUser = 4
    case apiPassword = 5
}

struct Param {
    let id: Int
//    var type: ParamType
    var typeInt: Int
    var value: String
    
    init(id: Int, type: ParamType, value: String){
        self.id = id
        self.typeInt = Int(type.rawValue)
        self.value = value
    }
    
    init?(from result: FMResultSet) {
        if let value = result.string(forColumn: "value") {
            self.id = Int(result.int(forColumn: "id"))
            self.typeInt = Int(result.int(forColumn: "type_int"))
            self.value = value
        } else {
            return nil
        }
    }
}

extension Param {
    var type: ParamType {
        get {
            return ParamType(rawValue: Int(self.typeInt)) ?? .undef
        }
        set {
            self.typeInt = Int(newValue.rawValue)
        }
    }
}
