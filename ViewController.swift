//
//  ViewController.swift
//  tp8.3
//
//  Created by Admin on 20.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var studentNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [NSManagedObject]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section:Int) -> Int
    {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")! as UITableViewCell
        let student = students[indexPath.row];
        cell.textLabel?.text = student.value(forKey: "name") as? String

        return cell
    }
    
    func tableView( tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            managedObjectContext.delete(students[indexPath.row] as
                NSManagedObject) //Выбираем метод удаления объекта из модели данных
            do
            {
                try managedObjectContext.save() //Пробуем сохранить изменения в
                students.remove(at: indexPath.row) //Удаляем объект из модели
 
                tableView.deleteRows(at: [indexPath as IndexPath],with:
                    .left) //Удаляем строку из таблицы
            }
            catch let error as NSError
            {
                print("Data removing error: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as!
        AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        //Создаем ссылку на объект managedObjectContext из класса AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        do
        {
            students = try
                managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch let error as NSError
        {
            print("Data loading error: \(error)")
        }
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addSudentButton(_ sender: Any) {
        if studentNameTextField.text == "" || studentNameTextField.text == "Введите данные!"
        {
            studentNameTextField.text = "Введите данные!"
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as!
            AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            //Создаем ссылку на объект managedObjectContext из класса AppDelegate
            let newObject =
                NSEntityDescription.insertNewObject(forEntityName: "Students",
                                                    into: managedObjectContext) as NSManagedObject
            newObject.setValue(studentNameTextField.text!, forKey: "name")
            
            do
            {
                try managedObjectContext.save()
                students.append(newObject)
                studentNameTextField.text! = ""
                self.tableView.reloadData()
                self.view.endEditing(true)
            }
            catch let error as NSError
            {
                print("Data saving error: \(error)")
            }
        }
    }

}

