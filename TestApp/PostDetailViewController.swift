//
//  ViewController.swift
//  TestApp
//
//  Created by Pooja on 23/06/23.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var comments = [Comment]()
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        likeButton.isSelected.toggle()
        likeButton.setTitle("Liked", for: .selected)
        likeButton.setTitle("Like", for: .normal)
    }

    @IBAction func addCommentBtnTapped(_  sender : UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddCommenTextViewController") as? AddCommenTextViewController {
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addReplyButtonTapped(for index : Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddCommenTextViewController") as? AddCommenTextViewController {
            vc.delegate = self
            vc.index = index
            self.navigationController?.present(vc, animated: true)
        }
    }
}


extension PostDetailViewController : UITableViewDelegate,UITableViewDataSource {
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments[section].replies.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell else { return  UIView() }
        cell.addComment(comment: comments[section].comment)
        cell.btnAddReply.isHidden = false
        cell.addReplyBtnAction = {
            self.addReplyButtonTapped(for: section)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell") as? ReplyTableViewCell else { return  UITableViewCell() }
        cell.addReply(text: "Someone replied : " + comments[indexPath.section].replies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

extension PostDetailViewController : AddCommentDelegate {
    
    func getUserAddedComment(commentText: String) {
        self.comments.append(Comment(comment: commentText))
        self.commentTableView.reloadData()
    }
    
    func getUserAddedReply(for index: Int, reply: String) {
        self.comments[index].addReplyOnComment(reply: reply)
        self.commentTableView.reloadData()
    }
    
}
