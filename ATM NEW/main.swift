//
//  main.swift
//  ATM NEW
//
//  Created by Nishit Mishra on 22/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation


enum NotesTypes:Int{
    case hundredRupeeNote = 100
    case twoHundredRupeeNote = 200
    case fiveHundredRupeeNote = 500
    case twoThousandRupeeNote = 2000
}

class Money:NSObject{
    var value:Int?
}
class Hun:Money{
    override var value : Int?{
        get{
            return 100
        }
        set{}
    }
}
class TwoHun:Money{
    override var value : Int?{
        get{
            return 200
        }
        set{}
    }
}


class Container{
    var dict = [Int:Int]()
    var dict2 = [Money:Int]()
    init(){
        dict[NotesTypes.twoThousandRupeeNote.rawValue] = 0
        dict[NotesTypes.fiveHundredRupeeNote.rawValue] = 0
        dict[NotesTypes.twoHundredRupeeNote.rawValue] = 0
        dict[NotesTypes.hundredRupeeNote.rawValue] = 0
    }
    var totalMoney : Int{
        get{
            var total = 0
            for (key,value) in dict{
                total = total + value * key
            }
            return total
        }
        set{

        }
    }
    var newTotalMoney : Int{
        get{
            return 200
        }
        set{
            
        }
    }
}
class ATM{
    var container = Container()
    
    func computeDebit(amount:inout Int,denominationValue:Int,count:inout Int){
        while(amount >= denominationValue && count > 0){
            amount = amount - denominationValue
            count -= 1
        }
    }
    
    func debitMoneyWith(amount:Int){
        if amount <= container.totalMoney{
            print("Amount to debit : ",amount)
            var amountLeft = amount
            var twoThousandRupeeNote = container.dict[NotesTypes.twoThousandRupeeNote.rawValue]!
            var fiveHundredRupeeNote = container.dict[NotesTypes.fiveHundredRupeeNote.rawValue]!
            var twoHundredRupeeNote = container.dict[NotesTypes.twoHundredRupeeNote.rawValue]!
            var hundredRupeeNote = container.dict[NotesTypes.hundredRupeeNote.rawValue]!
            
            if Int(amountLeft/NotesTypes.twoThousandRupeeNote.rawValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.twoThousandRupeeNote.rawValue, count: &twoThousandRupeeNote)
            }
            if Int(amountLeft/NotesTypes.fiveHundredRupeeNote.rawValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.fiveHundredRupeeNote.rawValue, count: &fiveHundredRupeeNote)
            }
            if Int(amountLeft/NotesTypes.twoHundredRupeeNote.rawValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.twoHundredRupeeNote.rawValue, count: &twoHundredRupeeNote)
            }
            if Int(amountLeft/NotesTypes.hundredRupeeNote.rawValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.hundredRupeeNote.rawValue, count: &hundredRupeeNote)
            }
            if amountLeft == 0{
                container.dict[NotesTypes.twoThousandRupeeNote.rawValue] = twoThousandRupeeNote
                container.dict[NotesTypes.fiveHundredRupeeNote.rawValue] = fiveHundredRupeeNote
                container.dict[NotesTypes.twoHundredRupeeNote.rawValue] = twoHundredRupeeNote
                container.dict[NotesTypes.hundredRupeeNote.rawValue] = hundredRupeeNote
                print("Money Debited")
                print(container.dict)
            }else{
                print("Not enough money in the atm")
            }
        }else{
            print("Not enough money in the atm")
        }
    }
    
    func addMoney(dict:[NotesTypes:Int]){
        for (key1,Value) in dict{
            if self.container.dict[key1.rawValue] != nil{
            for (key2,value) in self.container.dict{
                if key1.rawValue == key2{
                    self.container.dict[key2] = value + Value
                }
            }
            }else{
                self.container.dict[key1.rawValue] = Value
            }
        }
        print(container.dict)
    }
}

func Credit(atm:ATM){
    print("Enter the choice of notes")
    print("1. 100")
    print("2. 200")
    print("3. 500")
    print("4. 2000")
    print("Enter between 1 and 4")
    let choice = readLine()
    if (Int(choice ?? "0") ?? 0) > 4 || (Int(choice ?? "0") ?? 0) < 1{
        print("Please enter between 1 and 4")
        
        return
    }
    print("Enter the number of notes")
    let numOfNotes = readLine()
    switch choice {
    case String(1):
        atm.addMoney(dict: [NotesTypes.hundredRupeeNote:Int(numOfNotes ?? "0")!])
    case String(2):
        atm.addMoney(dict: [NotesTypes.twoHundredRupeeNote:Int(numOfNotes ?? "0")!])
    case String(3):
        atm.addMoney(dict: [NotesTypes.fiveHundredRupeeNote:Int(numOfNotes ?? "0")!])
    case String(4):
        atm.addMoney(dict: [NotesTypes.twoThousandRupeeNote:Int(numOfNotes ?? "0")!])
        default: break
    }
}

func Debit(atm : ATM){
    print("Enter the amount of money")
    let amount = readLine()
    if (Int(amount ?? "0") ?? 0)%100 == 0{
        atm.debitMoneyWith(amount: Int(amount ?? "0") ?? 0)
    }else{
        print(" \n Please enter the amount in the multiples of 100. \n")
    }
}

   
var atm = ATM()
var shouldContinue = true
func start(){
    while(shouldContinue){
    print("1. Withdraw")
    print("2. Credit")
    print("3. Exit")
    print("Enter your choice between 1 and 3: ")
    let choice = readLine()
    if (Int(choice ?? "0") ?? 0) > 3 || (Int(choice ?? "0") ?? 0) < 1{
        print("Please enter between 1 and 3")
        start()
    }else{
        switch choice {
            case String(1):
                Debit(atm:atm)
            case String(2):
                Credit(atm:atm)
            case String(3): shouldContinue = !shouldContinue
            default: break
        }
    }
    }
}

start()
