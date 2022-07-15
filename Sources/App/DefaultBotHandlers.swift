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
        
//        while self.isCheck {
//
//            sleep(10)
//            print("123")
//
//        }
        
    }

    private static func checkTickets(app: Vapor.Application, bot: TGBotPrtcl) {
        
        while self.isCheck {
            
            //for x in 6...9 {
            
            // 3-7 min
            let randomTime = Int.random(in: 180...420)
            sleep(UInt32(randomTime))
            
            let randomDate = Int.random(in: 26...28)
            
            var StrDate = String(randomDate)
            if StrDate.count == 1 {
                StrDate = "0" + StrDate
            }
            
            let date: String = StrDate + ".07.2022"
            
            let siteGrandTrain: String = "https://grandtrain.ru/tickets/2004000-2078750/\(date)/"
            let myUrlString: String = "https://poezd.ru/nalichie-mest/Sankt-Peterburg/Sevastopol/?SearchForm[dateTo]=\(date)"
            let myURL = URL(string: myUrlString)
            
            
            do {
                let myHTMLString = try String(contentsOf: myURL!, encoding: .utf8)
                let doc = try SwiftSoup.parse(myHTMLString)
                
                let check = try doc.getElementsByClass("poezd-routes-item-left-number").text()
                let time = NSDate()
                print("check \(date) \(time)")
                if check != "" {
                    
                    let options = try doc.getElementsByClass("poezd-routes").array()
                    let array = try options[0].getElementsByClass("poezd-routes-item").array()
                    
                    let params: TGSendMessageParams = .init(chatId: TGChatId.chat(385916120), text:
                                                                "✅ Ублюдок кожаный, есть тикет на \(date) \n\(siteGrandTrain)")
                    
                    try bot.sendMessage(params: params)
                    
                    for i in array {
                        
                        let text = try i.text()
                        
                        let params: TGSendMessageParams = .init(chatId: TGChatId.chat(385916120), text: text)
                        try bot.sendMessage(params: params)
                        
                    }
                    
                    self.isCheck = false
                    break
                }
                
            } catch let error {
                let params: TGSendMessageParams = .init(chatId: TGChatId.chat(385916120), text: error.localizedDescription)
                
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
        let handler = TGMessageHandler(filters: (.all && !.command.names(["/ping"]))) { update, bot in
            //let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "EEE")
            //try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }

    /// add handler for command "/ping"
    private static func commandStartHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/start"]) { update, bot in
            try update.message?.reply(text: "Ума не хватает самому искать, ладно помогу... 🚂", bot: bot)
            self.isCheck = true
            checkTickets(app: app, bot: bot)
        }
        bot.connection.dispatcher.add(handler)
    }
    
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
        }
        bot.connection.dispatcher.add(handler)
    }
    
    /// add handler for command "/show_buttons" - show message with buttons
    private static func commandShowButtonsHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/show_buttons"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons: [[TGInlineKeyboardButton]] = [
                [.init(text: "Button 1", callbackData: "press 1"), .init(text: "Button 2", callbackData: "press 2")]
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
        }

        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler2)
    }
}
