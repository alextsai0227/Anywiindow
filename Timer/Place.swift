//
//  Places.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/6.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
class Window {

    var name : String
    var image: Array<String>
    var latitude : String
    var longitude: String
    
    init(name: String,image:Array<String>,latitude:String,longitude: String){
        self.name = name
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}
class Place{
    static var places = [Place(country:"台灣",city:"台北",window: [Window(name:"松山文創",image: ["windowa"],latitude: "25.0440864", longitude: "121.556474"),Window(name:"信義威秀",image: ["windowb"],latitude: "25.042354", longitude: "121.5628965")],description:"台北市是台灣最大的都市。也是政治、經濟、文化的中心。台北的整體發展相當活潑多元，充滿朝氣。建築形式相當豐富，現代的、古代的都有。",latitude: "25.0440864", longtitude: "121.556474"),Place(country:"日本",city:"大阪",window: [Window(name:"通天閣",image: ["windowc"],latitude: "34.6980108", longitude: "135.4832048"),Window(name:"道頓崛",image: ["windowd"],latitude: "34.6980108", longitude: "135.4832048")],description:"大阪市是位於日本大阪府的都市，也是大阪府府治，為政令指定都市之一，亦是大阪都市圈、京阪神大都市圈、乃至於近畿地方的中心城市。",latitude: "34.6980108", longtitude: "135.4832048"),Place(country:"羅馬尼亞",city:"布加勒斯特",window: [Window(name:"布加勒斯特",image: ["布加勒斯特"],latitude: "44.4377401", longitude: "25.9545541")],description:"布加勒斯特，羅馬尼亞首都，位於羅馬尼亞東南部，瓦拉幾亞平原中部，多瑙河支流登博維察河畔。有「小巴黎」之稱。",latitude: "44.4377401", longtitude: "25.9545541"),Place(country:"保加利亞",city:"索非亞",window: [Window(name:"索非亞",image: ["索非亞"],latitude: "42.6953463", longitude: "23.1835169")],description:"索菲亞是東歐國家保加利亞的首都和最大城市，位於索非亞盆地南部，四周山地環繞，2006年人口1,246,791。俄土戰爭結束，保加利亞成為獨立民族國家後，索菲亞才成為該國的首都。",latitude: "42.6953463", longtitude: "23.1835169"),Place(country:"希臘",city:"雅典",window: [Window(name:"雅典",image: ["雅典"],latitude: "37.9908163", longitude: "23.6681269")],description:"雅典是世界上最老的城市之一，有記載的歷史就長達3000多年。現在雅典是歐洲第八大城市。雅典是希臘經濟、財政、工業、政治和文化中心。",latitude: "37.9908163", longtitude: "23.6681269"),Place(country:"馬其頓",city:"斯科普里",window: [Window(name:"斯科普里",image: ["斯科普里"],latitude: "41.0981207", longitude: "19.9866265")],description:"斯科普里是馬其頓的政治、文化、經濟、學術的中心都市。斯科普里在古羅馬時期的名稱是Scupi。",latitude: "41.0981207", longtitude: "19.9866265"),Place(country:"捷克",city:"布拉格",window: [Window(name:"布拉格",image: ["布拉格"],latitude: "50.0593307", longitude: "14.1847491")],description:"布拉格是一座著名的旅遊城市，市內擁有為數眾多的各個歷史時期、各種風格的建築，從羅馬式、哥德式建築、文藝復興、巴洛克、洛可可、新古典主義、新藝術運動風格到立體派和超現代主義。",latitude: "50.0593307", longtitude: "14.1847491"),Place(country:"德國",city:"柏林",window: [Window(name:"柏林",image: ["柏林"],latitude: "52.5072094", longitude: "13.1442637")],description:"柏林都會區有知名大學、研究院、體育賽事、管弦樂隊、博物館和知名人士。城市的歷史遺存使該市成為國際電影產品的交流中心。",latitude: "52.5072094", longtitude: "13.1442637"),Place(country:"英國",city:"倫敦",window: [Window(name:"倫敦",image: ["倫敦"],latitude: "51.5283063", longitude: "-0.3824722")],description:"倫敦是一個全球城市，在文藝、商業、教育、娛樂、時尚、金融、健康、媒體、專業服務、研究與發展、旅遊和交通方面都具有顯著的地位。",latitude: "51.5283063", longtitude: "-0.3824722"),Place(country:"新加坡",city:"新加坡",window: [Window(name:"金沙飯店",image: ["金沙酒店"],latitude: "1.2832131", longitude: "103.858113"),Window(name:"魚尾獅",image: ["魚尾獅"],latitude: "1.2868479", longitude: "103.8523381"),Window(name:"新加坡河畔",image: ["新加坡河畔"],latitude: "1.288280", longitude: "103.859095")],description:"新加坡為全球第三大金融中心，僅次於英國倫敦、美國紐約。整個城市在綠化和保潔方面效果顯著，故有花園城市的美稱。",latitude: "1.2832131", longtitude: "103.858113"),Place(country:"泰國",city:"普吉島",window: [Window(name:"普吉島",image: ["普吉島"],latitude: "7.9665083", longitude: "98.219842")],description:"普吉是一座位於泰國南部安達曼海海域上的島嶼，普吉府則管轄全島。普吉是世界知名的熱帶觀光勝地，其豐富的天然資源也替泰國帶來不小的財富。",latitude: "7.9665083", longtitude: "98.219842"),Place(country:"尼泊爾",city:"加德滿都",window: [Window(name:"加德滿都",image: ["加德滿都"],latitude: "27.7089558", longitude: "85.2910272")],description:"加德滿都是尼泊爾的首都也是尼泊爾最大的城市。加德滿都的海拔約1350米，三面環山，市區即於山間的加德滿都谷地之中，氣候宜人，有「山中天堂」之美譽。",latitude: "27.7089558", longtitude: "85.2910272"),Place(country:"俄羅斯",city:"莫斯科",window: [Window(name:"莫斯科",image: ["莫斯科"],latitude: "55.7485106", longitude: "37.0706961")],description:"莫斯科是俄羅斯聯邦和莫斯科州的首都，自成爲首都起就一直是政治、經濟、科學、文化及交通中心，城區人口約1200萬，是歐洲人口第二多的城市，僅次於伊斯坦堡，占據了全國總人口的1/10。",latitude: "55.7485106", longtitude: "37.0706961"),Place(country:"澳洲",city:"布里斯本",window: [Window(name:"布里斯本",image: ["布里斯本"],latitude: "-27.3810177", longitude: "152.4313083")],description:"布里斯本結合了藝術與戶外探險，南岸的河濱花園及潟湖旁坐落著各式文化機構與餐廳。搭乘明輪蒸汽船或渡輪，沿著布里斯本河順流而下；從袋鼠角的懸崖沿繩下降。",latitude: "-27.3810177", longtitude: "152.4313083"),Place(country:"巴西",city:"里約熱內盧",window: [Window(name:"里約熱內盧",image: ["里約熱內盧"],latitude: "-22.9109866", longitude: "-43.7292268")],description:"里約熱內盧，是位於巴西東南部的一座城市，是巴西第二大城，僅次於聖保羅，曾經是葡萄牙帝國首都，風景優美，",latitude: "-22.9109866", longtitude: "-43.7292268"),Place(country:"美國",city:"波士頓",window: [Window(name:"波士頓",image: ["波士頓"],latitude: "42.3132878", longitude: "-71.1975869")],description:"波士頓是美國馬薩諸塞州的首府和最大城市，也是新英格蘭地區的最大城市，其人口規模全美大都市排名第21，該市所在州的平均家庭收入全美排名第五。",latitude: "42.3132878", longtitude: "-71.1975869"),Place(country:"美國",city:"舊金山",window: [Window(name:"舊金山",image: ["舊金山"],latitude: "37.7576792", longitude: "-122.5078124")],description:"舊金山，正式名稱為舊金山市市郡，是美國加利福尼亞州北部的一座都市，也是加州唯一市郡合一的行政區，中文又音譯為三藩市和聖弗朗西斯科，亦別名「金門城市」、「灣邊之城」、「霧城」等。",latitude: "37.7576792", longtitude: "-122.5078124")]
    var country: String
    var city: String
    var window: [Window]
    var description: String
    var latitude : String
    var longtitude: String
    init(country: String,city: String,window: [Window],description:String,latitude:String,longtitude:String){
        self.country = country
        self.city = city
        self.window = window
        self.description = description
        self.longtitude = longtitude
        self.latitude = latitude
    }
    
    
}
