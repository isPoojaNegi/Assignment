//
//  CommentModel.swift
//  TestApp
//
//  Created by Pooja on 26/06/23.
//

import Foundation

struct Comment{
    var comment : String
    var replies : [String]
    
    init(comment: String, replies: [String] = []) {
        self.comment = comment
        self.replies = replies
    }
    
    mutating func addReplyOnComment(reply : String) {
        self.replies.append(reply)
    }
}
