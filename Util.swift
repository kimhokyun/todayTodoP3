import Foundation

func makeTimeFormat(format:String,date:Date) -> String{
    //https://formestory.tistory.com/6
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format // "a hh:mm", "yyyy-mm-dd a hh:mm:ss" etc...
    dateFormatter.locale = Locale(identifier:"ko_KR")
    return dateFormatter.string(from: date)
}


