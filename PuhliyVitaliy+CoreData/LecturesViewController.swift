//
//  LecturesViewController.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 08.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import CoreData

class LecturesViewController: UIViewController {
    
//    MARK:- IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
//    MARK:- Property
    let coreData = CoreDataStack.shared
    private var lectors: [Lector] = []
    private var selectedLector: Lector?
    private var lecture: Lecture?
    private var tfLectureTheme: UITextField?
    
    lazy var frc = { () -> NSFetchedResultsController<Lecture> in
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Lecture>(entityName: "Lecture")

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLectors()
    }
    
    //    MARK:- IBAction
    @IBAction private func clickedBtnPlus(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
//    MARK: - Custom
    private func loadLectors() {
        let fetchRequest = NSFetchRequest<Lector>(entityName: "Lector")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            lectors = try coreData.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Add new", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Theme"
        }
        
        alert.addTextField { (textField) in
            self.tfLectureTheme = textField
            textField.placeholder = "Lector"
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            textField.inputView = pickerView
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let themeOpt = alert?.textFields![0].text
            guard let theme = themeOpt, !theme.isEmpty, self.selectedLector != nil else {
                self.alert(message: "Fields can`t be empty!")
                return
            }
            self.lecture = Lecture(context: self.coreData.persistentContainer.viewContext)
            self.lecture?.theme = theme
            self.lecture?.lector = self.selectedLector
            self.lecture?.id = UUID.init().uuidString
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

extension LecturesViewController: NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let object = frc.object(at: indexPath)
        cell.textLabel?.text = object.theme!
        cell.detailTextLabel?.text = object.lector!.name!
        return cell
    }

}

extension LecturesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        lectors[row].name
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lectors.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLector = lectors[row]
        tfLectureTheme?.text = lectors[row].name
    }
}
