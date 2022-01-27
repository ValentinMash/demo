import Foundation
import Darwin
protocol Car {
    var model: String { get }
    var color: String { get }
    var buildDate: Int { get }
    var price: Double { get set }
    var accessories: [String] { get set }
    var isServiced: Bool { get set }
}
protocol Dealership {
    var name: String { get }                 // название дилерского центра по марке авто
    var showroomCapacity: Int { get }        // макс вместимость автосалона по кол-ву машин
    var stockCars: [Cars] { get set }        // машины на парковке склада
    var showroomCars: [Cars] { get set }     //машины в автосалоне
    var cars: [Cars] { get set }              //список всех машин в наличии
    
    func offerAccesories(_ :[String])        //предложение о покупке доп оборудорвания
    func presaleService(_ : Cars)            //получает машину и отправляет на предпродажную подготовку
    func addToShowroom(_ : Cars)             //получает машину, делает предпродажную подготовку + перегоняет с парковки склада в автосалон
    func sellCar(_ : Cars)                   //продат машину из атосалона и проверяет выполнена ли предпродажная подг, если у авто нет допоборудования? Предложить!
    func orderCar()                          // делает заказ новой машины с завода и добавляет машину на парковку склада
}

struct Cars: Car, Equatable {
    var model: String
    var color: String
    var buildDate: Int
    var price: Double
    var accessories: [String]
    var isServiced: Bool
    let VINnumber: String
}

struct AdditionalData {
    let optionDefault: Set = ["Сигнализация", "Тонировка", "Спортивные диски"]
    let varityCar = ["color": ["Red", "Grey", "Light blue", "Dark blue", "Green", "Yellow", "Pink", "Brown", "White", "Black", "Violet", "Gold", "Silver", "Amber", "Azure", "Beige", "Chocolate", "Coral", "Lilac", "Raspberry", "Snow", "Light sea green"],
                     "buildDate": [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021],
                     "price": [100000.0, 200000.0,300000.0, 400000.0,500000.0, 600000.0,700000.0, 800000.0, 900000.0, 1000000.0],
                     "accessories": ["Сигнализация", "Тонировка", "Спортивные диски"],
                     "isServiced": [true, false],
                     "BMW": ["X1", "X3", "X5", "X6", "3-Series", "5-Series", "7-Series", "1M", "M3", "M5", "M6", "M8", "Z4"],
                     "Honda": ["Accord", "Civic", "CR-V", "Fit", "Freed", "Stepwgn", "Vezel", "CR-Z", "Grace", "Insight", "Jade"],
                     "Audi": ["A3", "A4", "A6", "A8", "Q3", "Q5", "Q7", "A5", "R8", "RS6", "RS7", "TT"],
                     "Lexus":["GX460", "LX470", "LX570", "NX200", "RX300", "RX330", "RX350", "CT200h", "IS200t", "IS300"],
                     "Volvo":["S40", "S60", "S80", "XC40", "XC60", "XC70", "XC90", "C40", "S90", "V40", "V60"]]
}

class Dealerships: Dealership {
    var name: String
    var showroomCapacity: Int
    var stockCars: [Cars]
    var showroomCars: [Cars]
    var cars: [Cars] {
        get { return stockCars + showroomCars}
        set {  }
    }
    
    init(name: String, showroomCapacity: Int, stockCars: [Cars], showroomCars: [Cars]) {
        self.name = name
        self.showroomCapacity = showroomCapacity
        self.stockCars = stockCars
        self.showroomCars = showroomCars
    }
    func offerAccesories(_ acces: [String]) {
        print("Предложено следующее доп. оборудование: \(acces[0]), \(acces[1]), \(acces[2]).")
    }
    
    func presaleService(_ car: Cars) {
        print("Автомобиль \(self.name)\(car.model) отправлен на предпродажную подготовку")
    }
    //принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
    func addToShowroom(_ car: Cars) {
        if stockCars.contains(car) {
            let tempCar = car
            let stockCarsTemp = cars
            if let indexCar = stockCarsTemp.firstIndex(of: tempCar) {
                var thisCar = stockCars.remove(at: indexCar)
                thisCar.isServiced = true
                showroomCars.append(thisCar)
                print("Предпродажная подготовка выполнена. Автомобиль \(self.name) \(car.model) перемещен в автосалон.")
            }
        }
        else {
            print("Такого авто нет в наличии.")
        }
    }
    //принимает машину в качестве параметра. Метод продает машину из автосалона,проверяет, выполнена ли предпродажная подготовка. если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить.
    func sellCar(_ car: Cars) {
        let optionCar = Set(car.accessories)
        let firstPosition = AdditionalData()
        let missingOptions = Array(firstPosition.optionDefault.symmetricDifference(optionCar))
        
        let tempCar = car
        let showroomCarsTemp = showroomCars
        if let indexCar = showroomCarsTemp.firstIndex(of: tempCar) {
            var thisCar = showroomCars.remove(at: indexCar)
            thisCar.isServiced == false ? thisCar.isServiced = true : print("Автомобиль готов к продаже")
            for opt in missingOptions {
                thisCar.accessories.append(opt)
            }
            print("Автомобиль продан")
        }
        else {
            print("Невозможно продать автомобиль")
        }
    }
    //не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.
    func orderCar() {
        let secondPositiont = AdditionalData()
        if let col = secondPositiont.varityCar["color"], let build = secondPositiont.varityCar["buildDate"], let pr = secondPositiont.varityCar["price"],let access = secondPositiont.varityCar["accessories"],let isServ = secondPositiont.varityCar["isServiced"], let mod = secondPositiont.varityCar[self.name] {
            let color = col.randomElement()
            let buildDate = build.randomElement()
            let price = pr.randomElement()
            let accessoriesc = [access.randomElement()]
            let isServiced = isServ.randomElement()
            let model = mod.randomElement()
            let VINnumber: String = UUID().uuidString
            
            let carOrder = Cars(model: model as! String, color: color as! String, buildDate: buildDate as! Int, price: price as! Double, accessories: accessoriesc as! [String], isServiced: isServiced as! Bool, VINnumber: VINnumber)
            
            stockCars.append(carOrder)
            print("К дилеру \(self.name) прибыл новый автомобиль.")
        }
    }
}

protocol SpecialOffer {
    func addEmergencyPack() // добавляет аптечку и огнетушитель к доп. оборудованию
    func makeSpecialOffer() throws -> String //если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
}



extension Dealerships: SpecialOffer {
    func addEmergencyPack() {
        for auto in showroomCars {
            if let index = showroomCars.firstIndex(of: auto) {
                var thisCar = showroomCars.remove(at: index)
                thisCar.accessories.append("Аптечка")
                thisCar.accessories.append("Огнетушитель")
                showroomCars.append(thisCar)
            }
        }
        for auto in stockCars {
            if let index = stockCars.firstIndex(of: auto) {
                var thisCar = stockCars.remove(at: index)
                thisCar.accessories.append("Аптечка")
                thisCar.accessories.append("Огнетушитель")
                stockCars.append(thisCar)
            }
        }
        print("У автомобилей в багажнике имеются средства для помощи, в случай ДТП")
    }
    
// Обработка ошибок
    
    func makeSpecialOffer() throws -> String {
        for auto in showroomCars {
            guard auto.buildDate < 2021 else { throw NSError (domain: "Автомобиль не подходит под условие акции", code: 101)}
                if let index = showroomCars.firstIndex(of: auto) {
                    var thisCar = showroomCars.remove(at: index)
                    thisCar.price -= thisCar.price * 0.15
                    thisCar.accessories.append("Аптечка"); thisCar.accessories.append("Огнетушитель")
                    showroomCars.append(thisCar)
                }
            }
        
        for auto in stockCars {
            guard auto.buildDate < 2021 else { throw NSError (domain: "Автомобиль не подходит под условие акции", code: 101)}
                if let index = stockCars.firstIndex(of: auto) {
                    var thisCar = stockCars.remove(at: index)
                    thisCar.price -= thisCar.price * 0.15
                    thisCar.accessories.append("Аптечка"); thisCar.accessories.append("Огнетушитель")
                    showroomCars.append(thisCar)
                }
            }
        return "Все автомобили моложе 2021 года, продаются со скидкой 15%. Доп.оборудование в подарок!(Аптечка и огнетушитель)"
    }
}

var bmwx1 = Cars(model: "x1", color: "White", buildDate: 2020, price: 200.0, accessories: ["Сигнализация"], isServiced: true, VINnumber: "abc123")
var bmwx3 = Cars(model: "x3", color: "Blue", buildDate: 2020, price: 350.0, accessories: ["Тонировка", "Сигнализация"], isServiced: false, VINnumber: "def456")
var bmwx6 = Cars(model: "x6", color: "Red", buildDate: 2021, price: 550.0, accessories: ["Тонировка"], isServiced: false, VINnumber: "zxc098")
var hondaInsight = Cars(model: "Insight", color: "Coral", buildDate: 2010, price: 250.0, accessories: ["Спортивные диски"], isServiced: true, VINnumber: "lkj456")
var hondaFit = Cars(model: "Fit", color: "Blue", buildDate: 2017, price: 450.0, accessories: ["Спортивные диски"], isServiced: false, VINnumber: "vbn456")
var audiA3 = Cars(model: "A3", color: "Grey", buildDate: 2020, price: 550.0, accessories: ["Тонировка"], isServiced: false, VINnumber: "als980")
var audiQ7 = Cars(model: "Q7", color: "Yellow", buildDate: 2020, price: 680.0, accessories: ["Тонировка", "Спортивные диски"], isServiced: true, VINnumber: "ert293")
var lexusCT200h = Cars(model: "CT200h", color: "Kakao", buildDate: 2011, price: 610.0, accessories: ["Тонировка", "Спортивные диски"], isServiced: false, VINnumber: "uuq110")
var lexusLX570 = Cars(model: "LX570", color: "Green", buildDate: 2018, price: 870.0, accessories: ["Тонировка", "Сигнализация"], isServiced: false, VINnumber: "lfv710")
var volvoXC40 = Cars(model: "XC40", color: "Gold", buildDate: 2016, price: 758.0, accessories: ["Сигнализация"], isServiced: false, VINnumber: "pqh755")
var volvoV60 = Cars(model: "V60", color: "Silver", buildDate: 2017, price: 840.0, accessories: ["Сигнализация", "Тонировка"], isServiced: true, VINnumber: "mzn810")


var BmwDealer = Dealerships(name: "BMW", showroomCapacity: 10, stockCars: [bmwx3], showroomCars: [bmwx6,bmwx1])
var HondaDealer = Dealerships(name: "Honda", showroomCapacity: 10, stockCars: [hondaFit], showroomCars: [hondaInsight])
var AudiDealer = Dealerships(name: "Audi", showroomCapacity: 15, stockCars: [audiA3], showroomCars: [audiQ7])
var LexusDealer = Dealerships(name: "Lexus", showroomCapacity: 12, stockCars: [lexusLX570], showroomCars: [lexusCT200h])
var VolvoDealer = Dealerships(name: "Volvo", showroomCapacity: 15, stockCars: [volvoV60], showroomCars: [volvoXC40])

AudiDealer.orderCar()
try AudiDealer.makeSpecialOffer()




var dealerMass: [Dealerships] = [BmwDealer, HondaDealer, AudiDealer, LexusDealer, VolvoDealer]
for dealer in dealerMass {
    switch dealer.name {
    case "Honda":
        print("Управляй реальностью")
    case "BMW":
        print("С удовольствием за рулем")
    case "Audi":
        print("Превосходство высоких технологий")
    case "Lexus":
        print("Бесконечное тремеление к совершенству")
    case "Volvo":
        print("Volvo for life")
    default:
        print("No slogan.")
    }
}
