//
//  TransactionManager.swift
//  MoneyLover
//
//  Created by Ngo Truong on 12/6/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class TransactionManager: NSObject {
    
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    var dataStored = DataStored()
    
    func addTransaction(transactionModel: TransactionModel) -> Bool {
        var id = 0
        let listTransaction = dataStored.fetchRecordsForEntity("Transaction", inManagedObjectContext: managedObjectContext)
        if let lastTransaction = listTransaction.last as? Transaction {
            if let idTransaction = lastTransaction.idTransaction as? Int {
                id = idTransaction + 1
                transactionModel.idTransaction = id
            }
        }
        if let transaction = dataStored.createRecordForEntity("Transaction", inManagedObjectContext: managedObjectContext) as? Transaction {
            transaction.amount = transactionModel.amount
            transaction.note = transactionModel.note
            transaction.date = transactionModel.date
            transaction.idTransaction = id
            if let category = dataStored.createRecordForEntity("Category", inManagedObjectContext: managedObjectContext) as? Category {
                category.icon = transactionModel.categoryWithTransaction?.iconCategory
                category.name = transactionModel.categoryWithTransaction?.nameCategory
                category.type = transactionModel.categoryWithTransaction?.typeCategory
                category.idCategory = transactionModel.categoryWithTransaction?.idCategory
                transaction.categoryWithTransaction = category
                do {
                    try managedObjectContext.save()
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    func editTransaction(transactionModel: TransactionModel) -> Bool {
        let listTransaction = dataStored.fetchRecordsForEntity("Transaction", inManagedObjectContext: managedObjectContext)
        for transaction in listTransaction {
            if let transaction = transaction as? Transaction {
                if transaction.idTransaction == transactionModel.idTransaction {
                    transaction.amount = transactionModel.amount
                    transaction.note = transactionModel.note
                    transaction.date = transactionModel.date
                    transaction.categoryWithTransaction?.icon = transactionModel.categoryWithTransaction?.iconCategory
                    transaction.categoryWithTransaction?.name = transactionModel.categoryWithTransaction?.nameCategory
                    transaction.categoryWithTransaction?.type = transactionModel.categoryWithTransaction?.typeCategory
                    transaction.categoryWithTransaction?.idCategory = transactionModel.categoryWithTransaction?.idCategory
                    do {
                        try managedObjectContext.save()
                        return true
                    } catch {
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func deleteTransaction(idTransaction: Int) -> Bool {
        let listTransaction = dataStored.fetchRecordsForEntity("Transaction", inManagedObjectContext: managedObjectContext)
        for transaction in listTransaction {
            if let transaction = transaction as? Transaction {
                if transaction.idTransaction == idTransaction {
                    managedObjectContext.deleteObject(transaction)
                    do {
                        try managedObjectContext.save()
                        return true
                    } catch {
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func showTransaction() -> [Transaction] {
        let listCategory = dataStored.fetchRecordsForEntity("Transaction", inManagedObjectContext: managedObjectContext)
        var listTransaction = [Transaction]()
        for categories in listCategory {
            if let transaction = categories as? Transaction {
                listTransaction.append(transaction)
            }
        }
        return listTransaction
    }
}
