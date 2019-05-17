//
//  SetupViewController.swift
//  Pila
//
//  Created by Dev2 on 29/04/2019.
//  Copyright © 2019 Dev2. All rights reserved.
//

import UIKit

class SetupPlateViewController: UIViewController {
    
    @IBOutlet weak var tblFood: UITableView!
    @IBOutlet weak var txtfFood: UITextField!
    
    let plateSearcher = UISearchController(searchResultsController: nil)
    var platesFiltered: [Plate] = []
    
    deinit {
        debugPrint("Me muerooo setup plate 🥴")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let applicationDelegate = UIApplication.shared.delegate as? AppDelegate {
//                applicationDelegate.pruebaLocalizarDelegate()
//            
//            // Aquí puedo acceder a los valores AppDelegate
//        }
        
        tblFood.delegate = self
        tblFood.dataSource = self
        
        plateSearcher.searchResultsUpdater = self
        plateSearcher.obscuresBackgroundDuringPresentation = false
        tblFood.tableHeaderView = plateSearcher.searchBar
        
        let tercero = PlateFactory.shared[2]
        debugPrint("El tercer alimento es \(tercero)")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        debugPrint("setup viewWillAppear")
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        debugPrint("setup viewDidAppear")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        debugPrint("setup viewWillDisappear")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        debugPrint("setup viewDidDisappear")
//    }
//

    @IBAction func btnEditPressed(_ sender: UIBarButtonItem) {
        if tblFood.isEditing {
            tblFood.isEditing = false
            sender.title = "Edit"
        } else {
            tblFood.isEditing = true
            sender.title = "Done"
        }
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        if let foodText = txtfFood.text,
            !foodText.isEmpty {
            PlateFactory.shared.insert(plate: foodText, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tblFood.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        debugPrint("Vamos a suponer que grabo, pero no 😞")
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
}

// Código para gestionar los filtros de búsquedas
extension SetupPlateViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            debugPrint("Han escrito \(searchText)")
        }
    }

}

extension SetupPlateViewController: UITableViewDelegate {
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint("Se pulsó la fila \(indexPath.row)")
    }
}

extension SetupPlateViewController: UITableViewDataSource {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlateFactory.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "FoodTableViewCellIdentifier"
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if let foodTableViewCell = tableViewCell as? FoodTableViewCell {
            
//            let foodList = Food.shared.foodList
//            let foodName = foodList[indexPath.row]
//            foodTableViewCell.configure(info: foodName)
            
            foodTableViewCell.configure(info: PlateFactory.shared[indexPath.row])
            return foodTableViewCell
        }
        
        return tableViewCell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 3
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 4
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let foodToMove = PlateFactory.shared.removePlateAt(index: sourceIndexPath.row)        
        PlateFactory.shared.insert(plate: foodToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        debugPrint("Editing style \(editingStyle) index \(indexPath)")
        
        switch editingStyle {
        case .delete:
            debugPrint("Quiero borrar la \(indexPath.row)")
            PlateFactory.shared.removePlateAt(index: indexPath.row)
            tblFood.deleteRows(at: [indexPath], with: .automatic)
        default:
            break;
        }
    }
}
