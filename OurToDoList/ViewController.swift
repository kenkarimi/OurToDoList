//
//  ViewController.swift
//  OurToDoList
//
//  Created by Kennedy Karimi on 27/07/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource { //Conforms to UIViewController, UITableViewDataSource
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }() //Anonymous closure pattern.
    
    var items = [String]() //Array of strings.

    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? [] //UserDefaults save data in the users device.
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self //This view controller(self) will be providing the data. Needs to conform to the UITableViewDataSource.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list item!", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter item..."
        }
        /*Code above is a simplified version of this:
        alert.addTextField(configurationHandler: { (field) in
            field.placeholder = "Enter item..."
        })*/
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in //weak self so we don't cause a memory leak. As such, self.items & self.table below now need to be optional self?.items & self?.table
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    //Enter new to do list item
                    DispatchQueue.main.async { //We wrap the code in this to make sure it occurs in the main thread because we are updating the UI and closures always execute in an asynchronous background function.
                        //UserDefaults save data in the users device.
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    //Give the table a frame(width & height).
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    //Function returns the number of rows in the list.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Function creates and returns a cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //'cell' is the identifier we created in the anonymous closure pattern called table.
        
        //NB: Every cell comes with a default text label(textLabel) so this isn't something that is manually created.
        cell.textLabel?.text = items[indexPath.row] //Cell's text label is going be the item at the n'th position from the data.
        return cell
    }
}

//NB: To build and run: Command + R

//You can show the software keyboard on the emulator whenever you run it by going to (I/O)/Keyboard/Toggle software keyboard on the toolbar.

//Using the app switcher on the emulator: Double click the home button.
