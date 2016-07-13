//
//  Places.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/6.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
class Window {
    static var windows = [Window(category:"Asia", name:"Taipei",image: ["Taipei","Taipei2"],latitude: "25.08534", longitude: "121.4228168"),Window(category:"Asia", name:"Osaka",image: ["Osaka","Osaka2"],latitude: "34.678395", longitude: "135.4600445"),Window(category:"Asia", name:"Brisbane",image: ["Brisbane","Brisbane2"],latitude: "-27.3810177", longitude: "152.4313083"),Window(category:"America", name:"SanFrancisco",image: ["SanFrancisco","SanFrancisco2"],latitude: "37.7576792", longitude: "-122.5078124"),Window(category:"America", name:"Hawaii",image: ["Hawaii","Hawaii2"],latitude: "21.410097", longitude: "157.970329"),Window(category:"Asia", name:"ShanHai",image: ["ShanHai","ShanHai2"],latitude: "31.2231276", longitude: "120.9148739"),Window(category:"Asia", name:"Hokkaido",image: ["Hokkaido","Hokkaido2"],latitude: "43.4349557", longitude: "140.5423807"),Window(category:"Asia", name:"Boracay",image: ["Boracay","Boracay2"],latitude: "11.973899", longitude: "121.9052984")]

    var category : String
    var name : String
    var image: Array<String>
    var latitude : String
    var longitude: String
    
    init(category: String,name: String,image:Array<String>,latitude:String,longitude: String){
        self.name = name
        self.category = category
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}
class Place{
    static var places = [Place(country:"Taiwan",city:"Taipei",window: [Window(category:"Asia", name:"松山文創",image: ["windowa","windowa2","windowa3","windowa4"],latitude: "25.0440864", longitude: "121.556474"),Window(category:"Asia", name:"信義威秀",image: ["windowb","windowb2","windowb3","windowb4"],latitude: "25.042354", longitude: "121.5628965")]),Place(country:"Japan",city:"Osaka",window: [Window(category:"Asia", name:"通天閣",image: ["windowc","windowc2","windowc3","windowc4"],latitude: "34.6980108", longitude: "135.4832048"),Window(category:"Asia", name:"道頓崛",image: ["windowd","windowd2","windowd3","windowd4"],latitude: "34.6980108", longitude: "135.4832048")])]
    var country: String
    var city: String
    var window: [Window]
    init(country: String,city: String,window: [Window]){
        self.country = country
        self.city = city
        self.window = window
    }
    
    
}
