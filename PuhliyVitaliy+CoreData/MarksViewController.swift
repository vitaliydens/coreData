
//
//  LecturesViewController.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 08.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import CoreData

class MarksViewController: UIViewController {
    
//    MARK:- IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
//    MARK:- Property
    let coreData = CoreDataStack.shared
    var student: Student?
    var homeworks: [Homework] = []
    
    private var mark: Mark?
    private var selectedHomework: Homework?
    private var tfLectureTheme: UITextField?
    
    lazy var frc = { () -> NSFetchedResultsController<Mark> in
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Mark>(entityName: "Mark")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "student == %@", student!)

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHomeworks()
    }
    
    //    MARK:- IBAction
    @IBAction private func clickedBtnPlus(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
//    MARK: - Custom
    private func loadHomeworks() {
        let fetchRequest = NSFetchRequest<Homework>(entityName: "Homework")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            homeworks = try coreData.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Add new", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Mark"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Clarification"
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
            let markOpt = alert?.textFields![0].text
            let clarificationOpt = alert?.textFields![1].text
            guard let mark = markOpt, !mark.isEmpty, let clarification = clarificationOpt, !clarification.isEmpty, self.selectedHomework != nil else {
                self.alert(message: "Fields can`t be empty!")
                return
            }
            self.mark = Mark(context: self.coreData.persistentContainer.viewContext)
            self.mark?.mark = mark
            self.mark?.clarification = clarification
            self.mark?.id = UUID.init().uuidString
            
            self.saveCoreData()
            
            self.student?.addToMarks(self.mark!)
            
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

extension MarksViewController: NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
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
        cell.textLabel?.text = object.mark
        cell.detailTextLabel?.text = object.clarification
        return cell
    }

}

extension MarksViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        homeworks[row].task
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        homeworks.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHomework = homeworks[row]
        tfLectureTheme?.text = homeworks[row].task
    }
}

