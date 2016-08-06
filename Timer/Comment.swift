//
//  Comment.swift
//  Timer
//
//  Created by 蔡舜珵 on 2016/7/17.
//  Copyright © 2016年 蔡舜珵. All rights reserved.
//

import Foundation
class Comment {
    
    static let commentPost = Comment()
    
    
    var comment:String?
    var photoURL:String?
    var name:String?
    var date:String?
    var commentCount:String?
    
    
    
    func deleteAll(){
        
        comment = nil
        photoURL = nil
        name = nil
        date = nil
        commentCount = nil
    }
}
