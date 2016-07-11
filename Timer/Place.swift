//
//  Places.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/6.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import UIKit
class Place {
    static var places = [Place(category:"Asia", name:"Taipei",image: "Taipei",image2: "Taipei2",latitude: "25.08534", longitude: "121.4228168"),Place(category:"Asia", name:"Osaka",image: "Osaka",image2: "Osaka2",latitude: "34.678395", longitude: "135.4600445"),Place(category:"Asia", name:"Brisbane",image: "Brisbane",image2: "Brisbane2",latitude: "-27.3810177", longitude: "152.4313083"),Place(category:"America", name:"SanFrancisco",image: "SanFrancisco",image2: "SanFrancisco2",latitude: "37.7576792", longitude: "-122.5078124"),Place(category:"America", name:"Hawaii",image: "Hawaii",image2: "Hawaii2",latitude: "21.410097", longitude: "157.970329"),Place(category:"Asia", name:"ShanHai",image: "ShanHai",image2: "ShanHai2",latitude: "31.2231276", longitude: "120.9148739"),Place(category:"Asia", name:"Hokkaido",image: "Hokkaido",image2: "Hokkaido2",latitude: "43.4349557", longitude: "140.5423807"),Place(category:"Asia", name:"Boracay",image: "Boracay",image2: "Boracay2",latitude: "11.973899", longitude: "121.9052984")]

    var category : String
    var name : String
    var image: String
    var image2 : String
    var latitude : String
    var longitude: String
    init(category: String,name: String,image:String,image2:String,latitude:String,longitude: String){
        self.name = name
        self.category = category
        self.image = image
        self.image2 = image2
        self.latitude = latitude
        self.longitude = longitude
    }
}