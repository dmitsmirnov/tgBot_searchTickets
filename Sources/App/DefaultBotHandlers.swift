import Vapor
import telegram_vapor_bot
import Foundation
import SwiftSoup


final class DefaultBotHandlers {
    
    static var isCheck: Bool = true
    
    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        
        //checkTickets(date: "15.09.2022", app: app, bot: bot)
        
        defaultHandler(app: app, bot: bot)
        commandStartHandler(app: app, bot: bot)
        commandStopHandler(app: app, bot: bot)
        commandStatusHandler(app: app, bot: bot)
        
        commandShowButtonsHandler(app: app, bot: bot)
        buttonsActionHandler(app: app, bot: bot)
        
        
        commandSetRangeHandler(app: app, bot: bot)
        
//        let buttons: [[TGInlineKeyboardButton]] = [
//            [.init(text: "Button 1", callbackData: "press 1"),
//            .init(text: "Button 2", callbackData: "press 2")]
//        ]
//        let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
//        let params: TGSendMessageParams = .init(chatId: .chat(385916120),
//                                                text: "Keyboard activ",
//                                                replyMarkup: .inlineKeyboardMarkup(keyboard))
//        do {
//            try bot.sendMessage(params: params)
//        } catch {
//
//        }
        
    }

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
        var countTickets: Int
        
        var typeVagon: String = ""
    }
    
    static var tasks: [Task] = []
    
    private static func checkTickets(app: Vapor.Application, bot: TGBotPrtcl, idMessage: Int64) {
        
        tasks.removeAll()
        
        // poezd-info-header-title
        // 028С  Таврия сим-мос
        // 028Ч  Таврия мос-сим
        
        //var task1 = Task(id: 1, from: "Sankt-Peterburg", to: "Kostroma(2010090)", range0: 30, range1: 30, date: ".07.2023", description: "for Irina and Anton", numberPoezd: "", countTickets: 1, typeVagon: "")
        var task1 = Task(id: 1, from: "Sankt-Peterburg", to: "Sevastopol", range0: 10, range1: 14, date: ".07.2025", description: "for me Sevastopol", numberPoezd: "", countTickets: 3, typeVagon: "Плац")
        var task2 = Task(id: 2, from: "Sankt-Peterburg", to: "Evpatoriya-Kurort", range0: 10, range1: 14, date: ".07.2025", description: "for me Evpatoriya", numberPoezd: "", countTickets: 3, typeVagon: "Плац")
        //var task2 = Task(id: 2, from: "Simferopol", to: "Sankt-Peterburg", range0: 24, range1: 28, date: ".08.2023", description: "for alex", numberPoezd: "", countTickets: 3, typeVagon: "Плац")
        //var task3 = Task(id: 3, from: "Adler", to: "Simferopol", range0: 19, range1: 20, date: ".07.2023", description: "for Tanya", numberPoezd: "", countTickets: 1, typeVagon: "Плац")
        //var task4 = Task(id: 4, from: "Simferopol", to: "Sankt-Peterburg", range0: 1, range1: 2, date: ".08.2023", description: "for Tanya", numberPoezd: "", countTickets: 1, typeVagon: "Плац")
        
     
        //var task2 = Task(id: 2, from: "Novorossiysk", to: "Voronej", range0: 27, range1: 27, date: ".08.2023", description: "for margarita", numberPoezd: "", countTickets: 1, typeVagon: "")
        
        //var task3 = Task(id: 3, from: "Sankt-Peterburg", to: "Sevastopol", range0: 28, range1: 30, date: ".07.2023", description: "for sister", numberPoezd: "", countTickets: 1, typeVagon: "Плац")
        
        //var task4 = Task(id: 4, from: "Rostov", to: "Gagra", range0: 8, range1: 8, date: ".08.2023", description: "for Valery", numberPoezd: "", countTickets: 1, typeVagon: "")
        
        //let task4 = Task(id: 4, from: "Evpatoriya-Kurort", to: "Sankt-Peterburg", range0: 28, range1: 30, date: ".09.2022")
        
        //var tasks: [Task] = [task1, task2, task3]
        
        //tasks.append(task1)
        //tasks.append(task2)
        //tasks.append(task3)
        tasks.append(task1)
        tasks.append(task2)
        //tasks.append(task4)
        //tasks.append(task5)
        //tasks.append(task6)
        
        // 385916120 my
        // 5139830532 tania
        // let idMessage = 5139830532
        
        while self.isCheck {
             
            let taskNow = tasks.randomElement()
            
            // 3-7 min
            let randomTime = Int.random(in: 180...420)
            //let randomTime = Int.random(in: 5...20)
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
                
                if taskNow!.typeVagon != "" {
                    
                    let typeVagon = try doc.getElementsByClass("poezd-routes-item-left").text()
                    if !typeVagon.contains(taskNow!.typeVagon) {
                        continue
                    }
                }
                
                //var countTicketsFind = check.replacingOccurrences(of: "(", with: "")
                //countTicketsFind = countTicketsFind.replacingOccurrences(of: ")", with: "")
                
                //if taskNow!.countTickets > Int(countTicketsFind)! {
                //    continue
                //}
                
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
                
                // count seats
                var countTicketsFind = check.replacingOccurrences(of: "(", with: "")
                countTicketsFind = countTicketsFind.replacingOccurrences(of: ")", with: "")
                
                let options = try doc.getElementsByClass("poezd-routes").array()
                let array = try options[0].getElementsByClass("poezd-routes-item").array()
                
                for i in array {
                    
                    let text = try i.text()
                    
                    let params: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text: text)
                    try bot.sendMessage(params: params)
                    
                }
                // seats
            
                let params: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text:
                                                            "✅ Нашел для тебя тикет на \(date): \n\(taskNow!.from) - \(taskNow!.to) \n\(myUrlString) \n\(taskNow!.description)")
                
                try bot.sendMessage(params: params)
                
//                for i in array {
//
//                    let text = try i.text()
//
//                    let params: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text: text)
//                    try bot.sendMessage(params: params)
//
//                }
                
                //let params2: TGSendMessageParams = .init(chatId: TGChatId.chat(idMessage), text: "Задание завершено ✅")
                //try bot.sendMessage(params: params2)
                
                // check tasks
//                tasks.removeAll(where: { $0.id == taskNow?.id })
//                if tasks.count == 0 {
//                    self.isCheck = false
//                    break
//                }
                
                
            } catch let error {
                let params: TGSendMessageParams = .init(chatId: TGChatId.chat(Int64(idMessage)), text: error.localizedDescription)
                
                do {
                    try bot.sendMessage(params: params)
                } catch {
                    
                }
            }
            
            //}
            
        }
        
    }
    
    /// add handler for all messages unless command "/ping"
    private static func defaultHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGMessageHandler(filters: (.all && !.command.names(["/setRange"]))) { update, bot in
            //let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "EEE")
            //try bot.sendMessage(params: params)
            print(update.message?.text)
            
            
        }
        bot.connection.dispatcher.add(handler)
    }

    /// add handler for command "/ping"
    private static func commandStartHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/start"]) { update, bot in
            try update.message?.reply(text: "Ума не хватает самому искать, ладно помогу... 🚂", bot: bot)
            //try update.message?.reply(text: "Санкт-Петербург - Севастополь \(rangeX0)-\(rangeX1).07.22", bot: bot)
            self.isCheck = true
            //print(update.message?.chat.id)
            checkTickets(app: app, bot: bot, idMessage: Int64(update.message!.chat.id))
        }
        bot.connection.dispatcher.add(handler)
        
        //let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "Укажите диапазон - пример: (11-15)")
        //let param: TGSetChatMenuButtonParams = .init()
        
        //var types = bot.setChatMenuButton(params: TGSetChatMenuButtonParams.init())
        
        
    }
    
//    func showMainMenu(context: Context, text: String) throws {
//           // Use replies in group chats, otherwise bot won't be able to see the text typed by user.
//           // In private chats don't clutter the chat with quoted replies.
//           let replyTo = context.privateChat ? nil : context.message?.messageId
//
//           var markup = ReplyKeyboardMarkup()
//           //markup.one_time_keyboard = true
//           markup.resizeKeyboard = true
//           markup.selective = replyTo != nil
//           markup.keyboardStrings = [
//               [ Commands.add[0], Commands.list[0], Commands.delete[0] ],
//               [ Commands.help[0], Commands.support[0] ]
//           ]
//           context.respondAsync(text,
//               replyToMessageId: replyTo, // ok to pass nil, it will be ignored
//               replyMarkup: markup)
//
//       }
    
    private static func commandStopHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/stop"]) { update, bot in
            try update.message?.reply(text: "Ну и сам ищи тогда, петух 💩", bot: bot)
            self.isCheck = false
        }
        bot.connection.dispatcher.add(handler)
    }
    
    private static func commandStatusHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/status"]) { update, bot in
            try update.message?.reply(text: String(self.isCheck), bot: bot)
            try update.message?.reply(text: "Текущие задания: " + String(self.tasks.count), bot: bot)
            
            for task in self.tasks {
                try update.message?.reply(text: "📍\(task.from) - \(task.to): \(task.range0)-\(task.range1)\(task.date) - \(task.description)", bot: bot)
            }
            
        }
        bot.connection.dispatcher.add(handler)
    }
    
    private static func commandSetRangeHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        let handler = TGCommandHandler(commands: ["/setRange"]) { update, bot in
//            try update.message?.reply(text: "test", bot: bot)
//            print(update.message?.newChatTitle)
//        }
//        bot.connection.dispatcher.add(handler)
        let handler = TGMessageHandler(filters: (.command.names(["/setRange"]))) { update, bot in
            let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "Укажите диапазон - пример: (11-15)")
            try bot.sendMessage(params: params)
            print(update.message?.text)
        }
        
//        let handler2 = TGCallbackQueryHandler(pattern: "Укажите диапазон - пример: (11-15)") { update, bot in
//            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
//                                                            text: update.callbackQuery?.data  ?? "data not exist",
//                                                            showAlert: nil,
//                                                            url: nil,
//                                                            cacheTime: nil)
//            try bot.answerCallbackQuery(params: params)
//            print(update.message?.text)
//        }
        
        bot.connection.dispatcher.add(handler)
        //bot.connection.dispatcher.add(handler2)
    }
    
    /// add handler for command "/show_buttons" - show message with buttons
    private static func commandShowButtonsHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/show_buttons"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons: [[TGInlineKeyboardButton]] = [
                [.init(text: "Button 1", callbackData: "press 1"),
                .init(text: "Button 2", callbackData: "press 2")]
            ]
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId),
                                                    text: "Keyboard activ",
                                                    replyMarkup: .inlineKeyboardMarkup(keyboard))
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    /// add two handlers for callbacks buttons
    private static func buttonsActionHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCallbackQueryHandler(pattern: "press 1") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        let handler2 = TGCallbackQueryHandler(pattern: "press 2") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
            print(update.callbackQuery!.data)
        }

        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler2)
    }
}
