//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//Arrays are value types:

var a = [1, 2, 3]
var b = a

// a = [1, 2, 3]; b = [1, 2, 3]
b.append(4)
// a = [1, 2, 3]; b = [1, 2, 3, 4]

// Reference type example
class C { var data: Int = -1 }
var x = C()
var y = x						// x is copied to y
x.data = 42						// changes the instance referred to by x (and y)
print("\(x.data), \(y.data)")	// prints "42, 42"

//Mutability, Reference type:

class Dog {
    var wasFed = false
}

let dog = Dog()
dog.wasFed = false
let puppy = dog
//puppy and dog declared as constant still we are able to change the wasfed variable, because wasFed is variable. And let meant that you can not change the reference of dog or puppy but still instances are mutable. So something like: dog = puppy will give error.
puppy.wasFed = true
dog.wasFed
puppy.wasFed


//MARK:Mixing with Value and Reference type.
//MARK: When we have refernce inside the value type (class inside struct). This makes it complex because class inside shares the same reference even multiple instances of struc are created
//This is classically known as copy-on-write issue

//Following is the supportive solution:

struct Address { //ValueType
    var streetAddress: String //ValueType
    var city: String //ValueType
    var state: String //ValueType
    var postalCode: String //ValueType
}

class Person {          // Reference type
    var name: String      // Value type
    var address: Address  // Value type
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}

struct Payment {
    let amount: Float
    //First: is hide the direct access of reference type when used inside value type.
    //both computed properties (of person) private so that callers can’t access.
    private var _billedTo: Person
    
    //Access for reading
    private var billedToForRead: Person {
        return _billedTo
    }
    
    //Second: Private access to write, every time it initializes for reference type when caller instaiates.
    //isUniquelyReferencedNonObjC checks if nobody hodls the reference then it's passed the previously created object only.
    private var billedToForWrite: Person {
        mutating get {
            if !isUniquelyReferencedNonObjC(&_billedTo) {
                _billedTo = Person(name: _billedTo.name, address: _billedTo.address)
            }
            return _billedTo
        }
    }
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        _billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
    
    //Third: Provide managed access to update the reference type's objects. And use the private write initialization.
    mutating func updateBilledToAddress(address: Address) {
        billedToForWrite.address = address
    }
    
    mutating func updateBilledToName(name: String) {
        billedToForWrite.name = name
    }
    //Verdict: It requires a clever/hard way to handle the reference type inside the value type. I would love to improve the solution by transfering this responsibility to someone else. Once found would love to keep them posted here. Or if you have siggestions please come forward and pull request it.
}

//Without copy-on-write mechanism:

/*let billAddress = Address(streetAddress: "144 Bhuvneshwaru Layout", city: "Bangalore", state: "Karnataka", postalCode: "569982")
let billPayer = Person(name: "Upendra", address: billAddress)

let bill = Payment(amount: 42.99, billedTo: billPayer)
let bill2 = bill

// 3
billPayer.name = "Shyam"

bill.billedTo.name    // "Shyam"
bill2.billedTo.name   // "Shyam"
*/


