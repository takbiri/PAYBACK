//
//  ShoppingListViewController.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/20/21.
//

import UIKit

class ShoppingListViewController: UIViewController {

    var shoppingListViewModel = ShoppingListViewModel()
    var shoppingList:[ShoppingList] = []
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        shoppingListViewModel.delegate = self
        shoppingListViewModel.fetchList()
    }
    
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        let item = ShoppingList(title: textField.text!)
        shoppingListViewModel.saveItem(item: item)
        self.textField.text = ""
        self.textField.resignFirstResponder()
    }
    
}

extension ShoppingListViewController: ShoppingListViewModelDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func didFinishFetchShoppingList(_ list: [ShoppingList]) {
        self.shoppingList = list
        self.tableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingListViewModel.deleteItem(item: shoppingList[indexPath.row])
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if newString != "" {
            self.saveButton.isEnabled = true
        }else {
            self.saveButton.isEnabled = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            self.saveButton.isEnabled = false
        }
    }
}
