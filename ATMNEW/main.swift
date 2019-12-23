//
//  main.swift
//  ATM
//
//  Created by Nishit Mishra on 20/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation

enum NotesTypes{
    case Hun
    case TwoHun
    case FiveHun
    case TwoThousand
    var denominationValue : Int{
        switch self{
        case .Hun: return 100
        case .TwoHun: return 200
        case .FiveHun: return 500
        case .TwoThousand:  return 2000
        @unknown default:
            return 0
        }
    }
}


class DenominationValue:NSObject{
   static var shared = DenominationValue()
    var hun = Hun()
    var twoHun = TwoHun()
    var fiveHun = FiveHun()
    var twoThousand = TwoThousand()
    func getDenomination(key:NotesTypes)->Money{
        switch key{
        case .Hun: return hun
        case .TwoHun: return twoHun
        case .FiveHun: return fiveHun
        case .TwoThousand: return twoThousand
        default:
            return Money()
        }
    }
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

class FiveHun:Money{
    override var value : Int?{
        get{
            return 500
        }
        set{}
    }
}
class TwoThousand:Money{
    override var value : Int?{
        get{
            return 2000
        }
        set{}
    }
}



class Container{
    var dict = [Money:Int]()
    init(){
        dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoThousand)] = 0
        dict[DenominationValue.shared.getDenomination(key:NotesTypes.FiveHun)] = 0
        dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoHun)] = 0
        dict[DenominationValue.shared.getDenomination(key:NotesTypes.Hun)] = 0
    }
    var totalMoney : Int{
        get{
            var total = 0
            for (key,value) in dict{
                total = total + value * (key.value ?? 0)
            }
            return total
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
            var twoThousandRupeeNote = container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoThousand)]!
            var fiveHundredRupeeNote = container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.FiveHun)]!
            var twoHundredRupeeNote = container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoHun)]!
            var hundredRupeeNote = container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.Hun)]!
            
            if Int(amountLeft/NotesTypes.TwoThousand.denominationValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.TwoThousand.denominationValue, count: &twoThousandRupeeNote)
            }
            if Int(amountLeft/NotesTypes.FiveHun.denominationValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.FiveHun.denominationValue, count: &fiveHundredRupeeNote)
            }
            if Int(amountLeft/NotesTypes.TwoHun.denominationValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.TwoHun.denominationValue, count: &twoHundredRupeeNote)
            }
            if Int(amountLeft/NotesTypes.Hun.denominationValue) > 0{
                computeDebit(amount: &amountLeft, denominationValue: NotesTypes.Hun.denominationValue, count: &hundredRupeeNote)
            }
            if amountLeft == 0{
                container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoThousand)] = twoThousandRupeeNote
                container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.FiveHun)] = fiveHundredRupeeNote
                container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.TwoHun)] = twoHundredRupeeNote
                container.dict[DenominationValue.shared.getDenomination(key:NotesTypes.Hun)] = hundredRupeeNote
                print("Money Debited")
                print(container.dict)
            }else{
                print("Not enough money in the atm")
            }
        }else{
            print("Not enough money in the atm")
        }
    }
    
    func addMoney(dict:[Money:Int]){
        for (key1,Value) in dict{
            if self.container.dict[key1] != nil{
            for (key2,value) in self.container.dict{
                if key1 == key2{
                    self.container.dict[key2] = value + Value
                }
            }
            }else{
                self.container.dict[key1] = Value
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
    if numOfNotes == ""{
        print("Please Enter the value in numbers")
        Credit(atm: atm)
    }else{
        switch choice {
        case String(1):
            atm.addMoney(dict: [DenominationValue.shared.hun:Int(numOfNotes ?? "0")!])
        case String(2):
            atm.addMoney(dict: [DenominationValue.shared.twoHun:Int(numOfNotes ?? "0")!])
        case String(3):
            atm.addMoney(dict: [DenominationValue.shared.fiveHun:Int(numOfNotes ?? "0")!])
        case String(4):
            atm.addMoney(dict: [DenominationValue.shared.twoThousand:Int(numOfNotes ?? "0")!])
            default: break
        }
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
