import UIKit
import SwiftSoup

final class DefaultBotHandlers {
    
    static var isCheck: Bool = true
    
//    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
//
//        //checkTickets(date: "15.09.2022", app: app, bot: bot)
//
//        defaultHandler(app: app, bot: bot)
//        commandStartHandler(app: app, bot: bot)
//        commandStopHandler(app: app, bot: bot)
//        commandStatusHandler(app: app, bot: bot)
//
//        commandShowButtonsHandler(app: app, bot: bot)
//        buttonsActionHandler(app: app, bot: bot)
//
//
//        commandSetRangeHandler(app: app, bot: bot)
//
//    }

    static var rangeX0: Int = 26
    static var rangeX1: Int = 28
    
    struct Task: Identifiable {
        
        let id: Int
        
        let from: String
        let to: String
        
        let range0: Int
        let range1: Int
        
        // formate - .07.2022
        let date: String
        let description: String
        
        let numberPoezd: String
        var needDownPlace: Bool = false
    }
    
    static var tasks: [Task] = []
    
    private static func checkTickets(idMessage: Int64) {
        
        tasks.removeAll()
        
        // poezd-info-header-title
        // 028С  Таврия сим-мос
        // 028Ч  Таврия мос-сим
        
        var task1 = Task(id: 1, from: "Sankt-Peterburg", to: "Adler", range0: 17, range1: 17, date: ".07.2023", description: "for Dmitry", numberPoezd: "")
        //var task2 = Task(id: 2, from: "Novorossiysk", to: "Moskva", range0: 14, range1: 14, date: ".07.2023", description: "for Alexandra", numberPoezd: "")
        //task1.needDownPlace = true
        //let task2 = Task(id: 2, from: "Simferopol", to: "Sochi", range0: 1, range1: 2, date: ".09.2022", description: "Анастасия", numberPoezd: "")
        //let task3 = Task(id: 3, from: "Kerch", to: "Moskva", range0: 26, range1: 30, date: ".08.2022", description: "Андрей Храмов", numberPoezd: "")
        //let task4 = Task(id: 4, from: "Sevastopol", to: "Moskva", range0: 26, range1: 30, date: ".08.2022", description: "Андрей Храмов", numberPoezd: "")
        //let task5 = Task(id: 5, from: "Sevastopol", to: "Sankt-Peterburg", range0: 4, range1: 6, date: ".01.2023", description: "Smirnov Dmitry", numberPoezd: "")
        //let task2 = Task(id: 2, from: "Sankt-Peterburg", to: "Simferopol", range0: 16, range1: 16, date: ".06.2023", description: "для Ани", numberPoezd: "")
        
        //let task3 = Task(id: 3, from: "Sankt-Peterburg", to: "Evpatoriya-Kurort", range0: 14, range1: 16, date: ".08.2022", description: "для Вероники")
        //let task4 = Task(id: 4, from: "Evpatoriya-Kurort", to: "Sankt-Peterburg", range0: 26, range1: 27, date: ".08.2022", description: "для Вероники")
        
        //let task5 = Task(id: 5, from: "Sevastopol", to: "Sankt-Peterburg", range0: 6, range1: 8, date: ".08.2022", description: "для Бандита")
        
        //let task6 = Task(id: 6, from: "Simferopol", to: "Sankt-Peterburg", range0: 6, range1: 8, date: ".01.2023", description: "для Тани", numberPoezd: "")
        
        //let task4 = Task(id: 4, from: "Evpatoriya-Kurort", to: "Sankt-Peterburg", range0: 28, range1: 30, date: ".09.2022")
        
        //var tasks: [Task] = [task1, task2, task3]
        
        tasks.append(task1)
        //tasks.append(task2)
        //tasks.append(task3)
        //tasks.append(task4)
        //tasks.append(task5)
        //tasks.append(task6)
        
        // 385916120 my
        // 5139830532 tania
        // let idMessage = 5139830532
        
        while self.isCheck {
             
            let taskNow = tasks.randomElement()
            
            // 3-7 min
            //let randomTime = Int.random(in: 180...420)
            let randomTime = Int.random(in: 5...10)
            sleep(UInt32(randomTime))
            
            let randomDate = Int.random(in: taskNow!.range0...taskNow!.range1)
            
            var StrDate = String(randomDate)
            if StrDate.count == 1 {
                StrDate = "0" + StrDate
            }
            
            let date: String = StrDate + taskNow!.date
            
            //let siteGrandTrain: String = "https://grandtrain.ru/tickets/2004000-2078750/\(date)/"
            //let myUrlString: String = "https://poezd.ru/nalichie-mest/Sankt-Peterburg/Sevastopol/?SearchForm[dateTo]=\(date)"
            
            let myUrlString: String =  "https://poezd.ru/nalichie-mest/\(taskNow!.from)/\(taskNow!.to)/?SearchForm%5BdateTo%5D=\(date)"
            let myURL = URL(string: myUrlString)
            
            
            do {
                let myHTMLString = try String(contentsOf: myURL!, encoding: .utf8)
                let doc = try SwiftSoup.parse(myHTMLString)
                
                let check = try doc.getElementsByClass("poezd-routes-item-left-number").text()
                
                let tem = "dMMMMyEEEE Hms"
                let formater = DateFormatter()
                formater.setLocalizedDateFormatFromTemplate(tem)
                formater.locale = Locale(identifier: "ru_RU")
                
                let time = formater.string(from: Date())
                
                print("check \(date) \(time)")
                
                if check == "" {
                    continue
                }
                
                var checkPoezd = false
                if taskNow?.numberPoezd != "" {
                    checkPoezd = true
                }
                
                //if checkPoezd
                // cheak number poezd
                if checkPoezd {
                    let numbersPoezd = try doc.getElementsByClass("poezd-info-header-title").array()
                    
                    //var listPoesd: [String] = []
                    var isNeedPoezd = false
                    for i in numbersPoezd {
                        //listPoesd.append(try i.text())
                        let poezd = try i.text()
                        if poezd == taskNow?.numberPoezd {
                            isNeedPoezd = true
                            break
                        }
                    }
                    
                    if !isNeedPoezd {
                        continue
                    }
                    
                }
                
                if taskNow!.needDownPlace {
                    // seats
                    let href_button = try doc.getElementById("select_train")?.attr("href")
                    
                    let myURLNew = URL(string: href_button!)
                    let myHTMLString2 = try String(contentsOf: myURLNew!, encoding: .utf8)
                    
                    //let doc2 = try SwiftSoup.parse(myHTMLString2)
                    let down1 = myHTMLString2.contains("Нижние &nbsp;&mdash;&nbsp;нет")
                    let down2 = myHTMLString2.contains("Нижние боковые&nbsp;&mdash;&nbsp;нет")
                    
                    if down1 || down2 {
                        continue
                    }
                    
                }
                
                
                let options = try doc.getElementsByClass("poezd-routes").array()
                let array = try options[0].getElementsByClass("poezd-routes-item").array()
                // seats
                
                
//                let params: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text:
//                                                            "✅ Нашел для тебя тикет на \(date): \n\(taskNow!.from) - \(taskNow!.to) \n\(myUrlString) \n\(taskNow!.description)")
//
//                try bot.sendMessage(params: params)
                
                for i in array {
                    
                    let text = try i.text()
                    
                  //  let params: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text: text)
                  //  try bot.sendMessage(params: params)
                    
                }
                                
            } catch let error {
                //let params: TGSendMessageParams = .init(chatId: TGChatId.chat(Int64(idMessage)), text: error.localizedDescription)
                
                do {
                //    try bot.sendMessage(params: params)
                } catch {
                    
                }
            }
            
        }
        
    }
   
}

var bot: DefaultBotHandlers = DefaultBotHandlers()

