//
//  CommentTableViewCell.swift
//  TestApp
//
//  Created by Pooja on 23/06/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var addReplyBtnAction : (() -> ())?

    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var btnAddReply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func addComment(comment : String) {
        labelComment.text = comment
    }
    
    
    @IBAction func addReplyBtnTapped(_ sender: UIButton) {
        self.addReplyBtnAction?()
    }
}


class ReplyTableViewCell : UITableViewCell {
    
    @IBOutlet weak var labelReply: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func addReply(text : String) {
        labelReply.text = text
    }
}
