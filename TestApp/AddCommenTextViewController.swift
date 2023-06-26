//
//  AddCommenTextViewController.swift
//  TestApp
//
//  Created by Pooja on 23/06/23.
//

import UIKit

protocol AddCommentDelegate {
    
    func getUserAddedComment(commentText : String)
    func getUserAddedReply(for index : Int,reply : String)
    
}

class AddCommenTextViewController: UIViewController {
    
    var delegate : AddCommentDelegate?
    var index : Int?
    var placeholderText = "Write your comment here ..."
    var isKeyboardOpen : Bool = false
    
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var labelEmptyComment: UILabel!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        textViewComment.text = placeholderText
        textViewComment.textColor = .lightGray
        labelEmptyComment.isHidden = true
        textViewComment.delegate = self
        textViewComment.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        if isKeyboardOpen {
            view.endEditing(true) // Dismiss the keyboard
        } else {
            dismiss(animated: true, completion: nil) // Dismiss the view controller
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let text = textViewComment.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty || text == placeholderText {
            labelEmptyComment.isHidden = false
            labelEmptyComment.text = "Please add some comment"
        } else {
            self.dismiss(animated: true) { [weak self] in
                if let i = self?.index {
                    self?.delegate?.getUserAddedReply(for: i, reply: text)
                } else {
                    self?.delegate?.getUserAddedComment(commentText: text)
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            let keyboardHeight = keyboardFrame.size.height
            UIView.animate(withDuration: animationDuration) {
                self.isKeyboardOpen = true
                self.constraintBottom.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.isKeyboardOpen = false
                self.constraintBottom.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

extension AddCommenTextViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        labelEmptyComment.isHidden = true
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.textViewComment.text.count == 2000{
            labelEmptyComment.text = "Maximum limit reached"
            labelEmptyComment.isHidden = false
        }
    }
}



