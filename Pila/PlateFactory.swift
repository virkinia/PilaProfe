//
//  Food.swift
//  Pila
//
//  Created by Dev2 on 29/04/2019.
//  Copyright © 2019 Dev2. All rights reserved.
//

import Foundation



class PlateFactory {

    static let shared = PlateFactory()
    
    private let platosPreparados = ["pizza", "sushi", "lasagna", "solomillo", "patatas", "ensalada", "pato", "rabo de toro", "lentejas", "hamburguesa", "espagueti", "paella", "fabada", "cocido", "tequeños"]

    private var plateList: [Plate] = []

    init() {
        loadPlates()
    }

    deinit {
        UserDefaults.standard.setValue(plateList, forKey: "platosPreparados")
    }
    
    var count: Int {
        return plateList.count
    }
    
    func filter(text: String) -> [Plate] {
        return plateList.filter { (plateText) -> Bool in
            plateText.lowercased().hasPrefix(text.lowercased())
        }
    }
    
    func insert(plate: String, at index: Int) {
        plateList.insert(plate, at: index)
        UserDefaults.standard.setValue(plateList, forKey: "platosPreparados")

    }
    
    func removePlateAt(index: Int) -> Plate {
        let plato = plateList.remove(at: index)
        UserDefaults.standard.setValue(plateList, forKey: "platosPreparados")
        return plato

    }
    
    subscript(index: Int) -> Plate {
        get {
            return plateList[index]
        }
        set(newValue) {
            plateList[index] = newValue
        }
    }
}

extension PlateFactory: RandomFactory {
    
    func generateRandom() -> GameItem {
        let index = Int.random(in: 0 ..< plateList.count)
        return plateList[index]
    }
    
}
extension PlateFactory {
    func loadPlates() {
         plateList = UserDefaults.standard.stringArray(forKey: "platosPreparados") ?? platosPreparados
    }
}

