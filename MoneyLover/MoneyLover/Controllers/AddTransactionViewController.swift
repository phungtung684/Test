//
//  AddTransactionViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/28/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class AddTransactionViewController: UITableViewController {
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var iconCategoryImageView: UIImageView!
    @IBOutlet weak var nameCategoryLabel: UILabel!
    var category: CategoryModel?
    var dateCurrent = NSDate()
    var noteCurrent: String?
    var wallet: Wallet?
    var transactionManager = TransactionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Transaction"
        let buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(saveAction))
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = buttonSave
        navigationItem.leftBarButtonItem = buttonCancel
        self.navigationController?.navigationBar.tintColor = UIColor.greenColor()
        self.dateLabel?.text = getDateCurrent()
        inputAmountTextField?.keyboardType = .NumberPad
    }
    
    @objc private func saveAction() {
        print(category?.nameCategory)
        print(noteCurrent)
        print(inputAmountTextField?.text )
        if let category = category, let noteCurrent = noteCurrent, let amount = inputAmountTextField?.text {
            let transactionModel = TransactionModel()
            transactionModel.categoryWithTransaction = category
            transactionModel.date = dateCurrent
            transactionModel.note = noteCurrent
            if let amount = Double(amount) {
                transactionModel.amount = amount
                if transactionManager.addTransaction(transactionModel) {
                    print("Thanh cong")
                }
            } else {
                self.presentAlertWithTitle("Error", message: "ReEnter Amount")
            }
        } else {
            print("Empty")
        }
    }
    
    @objc private func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCategoryViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            if let showCategories = segue.destinationViewController as? ShowCategoryViewController {
                showCategories.delegate = self
            }
        } else if segue.identifier == "NoteViewController" {
            if let noteViewController = segue.destinationViewController as? NoteViewController {
                noteViewController.delegate = self
                noteViewController.noteCurrent = noteCurrent
            }
        } else if segue.identifier == "DateViewController" {
            if let dateViewController = segue.destinationViewController as? DateViewController {
                dateViewController.delegate = self
                dateViewController.dateDidChoose = dateCurrent
            }
        }
    }
    
    private func getDateCurrent() -> String {
        let date = NSDate()
        return "\(date.weekDay), \(date.day) \(date.month) \(date.year)"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
//            let storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
//            if let addWalletViewController = storyBoard?.instantiateViewControllerWithIdentifier("ChooseWalletTableViewController") as? ChooseWalletTableViewController {
//                let navController = UINavigationController(rootViewController: addWalletViewController)
//                self.presentViewController(navController, animated:true, completion: nil)
//            }
        }
    }
}

extension AddTransactionViewController: DataNote {
    func didInputNote(string: String) {
        if string == "" {
            self.noteLabel?.textColor = UIColor.lightGrayColor()
            self.noteLabel?.text = "Note"
            self.noteCurrent = nil
        } else {
            self.noteCurrent = string
            self.noteLabel?.textColor = UIColor.blackColor()
            self.noteLabel?.text = string
        }
    }
}

extension AddTransactionViewController: ChooseCategoryDelegate {
    func didChooseCategory(categoryModel: CategoryModel?) {
        if let categoryModel = categoryModel {
            category = categoryModel
            nameCategoryLabel?.textColor = UIColor.blackColor()
            iconCategoryImageView?.image = UIImage(named: categoryModel.iconCategory)
            nameCategoryLabel?.text = categoryModel.nameCategory
        }
    }
}

extension AddTransactionViewController: ChooseDateDelegate {
    func didChooseDate(date: NSDate?) {
        if let date = date {
            self.dateCurrent = date
            self.dateLabel?.text = date.getFormatDate()
        }
    }
}
