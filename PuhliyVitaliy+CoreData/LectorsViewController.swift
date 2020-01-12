//
//  LectorsViewController.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 08.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import CoreData

class LectorsViewController: UIViewController {
//    MARK:- IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
//    MARK:- Property
    let coreData = CoreDataStack.shared
    
    lazy var frc = { () -> NSFetchedResultsController<Lector> in
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Lector>(entityName: "Lector")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        controller.delegate = self
        return controller
    }()
    
    //    MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //    MARK:- IBAction
    @IBAction private func clickedBtnPlus(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
//    MARK: - Custom
    private func showAlert() {
        let alert = UIAlertController(title: "Add new", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }

        alert.addTextField { (textField) in
             textField.placeholder = "Surname"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let nameOpt = alert?.textFields![0].text
            let surNameOpt = alert?.textFields![1].text
            guard let name = nameOpt, !name.isEmpty, let surName = surNameOpt, !surName.isEmpty else {
                self.alert(message: "Fields can`t be empty!")
                return
            }
            let lector = Lector(context: self.coreData.persistentContainer.viewContext)
            lector.name = name
            lector.surName = surName
            lector.id = UUID.init().uuidString
            self.saveCoreData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveCoreData() {
           do {
               try coreData.persistentContainer.viewContext.save()
           } catch {
               debugPrint(error)
           }
       }
}

extension LectorsViewController: NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        frc.sections!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let object = frc.object(at: indexPath)
        cell.textLabel?.text = object.name! + " " + object.surName!
        return cell
    }

}
