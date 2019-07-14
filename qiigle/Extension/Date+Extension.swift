//
//  Date+Extension.swift
//  qiigle
//
//  Created by 島田智貴 on 2019/07/14.
//  Copyright © 2019 Tomozip. All rights reserved.
//

import Foundation

extension Date {

    static func from(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssSSSZ"
        return formatter.date(from: string)!
    }

//    let date = NSDate()
//    // タイムゾーンを言語設定にあわせる
//    formatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
//    let formatter = NSDataFormatter()
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//    // 上記の形式の日付文字列を取得します
//    // （例）2015-04-22T11:08:17.098+09:00
//    let str:String = formatter.stringFromDate(date)
//
//    // 上記の形式の日付文字列から日付データを取得します。
//    let d:NSDate = formatter.dateFromString("2015-04-22T11:08:17.098+09:00")
}

extension Date {

    func offsetFrom() -> String {
        if yearsFrom()   > 0 { return "\(yearsFrom())年前"   }
        if monthsFrom()  > 0 { return "\(monthsFrom())ヶ月前"  }
        if weeksFrom()   > 0 { return "\(weeksFrom())週間前"   }
        if daysFrom()    > 0 { return "\(daysFrom())日前"    }
        if hoursFrom()   > 0 { return "\(hoursFrom())時間前"   }
        if minutesFrom() > 0 { return "\(minutesFrom())分前" }
        if secondsFrom() > 0 { return "\(secondsFrom())秒前" }
        return ""
    }

    func yearsFrom() -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    func monthsFrom() -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
    }
    func weeksFrom() -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
    }
    func daysFrom() -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    func hoursFrom() -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
    }
    func minutesFrom() -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
    }
    func secondsFrom() -> Int {
        return Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
    }

}
