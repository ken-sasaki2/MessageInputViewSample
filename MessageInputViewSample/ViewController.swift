//
//  ViewController.swift
//  MessageInputViewSample
//
//  Created by sasaki.ken on 2023/07/29.
//

import UIKit

final class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    private var tableViewSize: CGSize?
    private var keyboardFrame: CGRect?
    private var messageInputViewFrame: CGRect?
    private let MIN_HEIGHT_MSG: CGFloat = 50
    private let MAX_HEIGHT_MSG: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setInitLayoutPosition()
        setUpNotification()
    }
    
    private func setInitLayoutPosition() {
        messageInputViewFrame = messageInputView.frame
        tableViewSize = tableView.frame.size
    }
    
    private func setUpDelegate() {
        textView.delegate = self
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardFrame = keyboardInfo.cgRectValue
        drawMessageInputView()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let messageInputViewFrame = messageInputViewFrame else {
            return
        }
        guard let tableViewSize = tableViewSize else {
            return
        }
        messageInputView.frame = messageInputViewFrame
        tableView.frame.size = tableViewSize
    }
    
    private func drawMessageInputView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let screenSize = UIScreen.main.bounds.size
        var height = textView.sizeThatFits(CGSize(
            width: textView.frame.size.width,
            height: CGFloat.greatestFiniteMagnitude
        )).height
        
        if height < MIN_HEIGHT_MSG {
            height = MIN_HEIGHT_MSG
        } else if MAX_HEIGHT_MSG < height {
            height = MAX_HEIGHT_MSG
        }
        
        if let keyboardFrame = keyboardFrame {
            textView.frame = CGRect(
                x: textView.frame.origin.x,
                y: textView.frame.origin.y,
                width: textView.frame.width,
                height: height
            )
            messageInputView.frame = CGRect(
                x: messageInputView.frame.origin.x,
                y: screenSize.height - keyboardFrame.size.height - messageInputView.frame.height,
                width: messageInputView.frame.width,
                height: height
            )
            tableView.frame.size = CGSize(
                width: tableView.frame.width,
                height: screenSize.height - (statusBarHeight + keyboardFrame.height)
            )
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        drawMessageInputView()
    }
    
    @IBAction func onCamertaButtonTapped(_ sender: UIButton) {
        print("camera.")
    }
    
    @IBAction func onSendButtonTapped(_ sender: UIButton) {
        print("send.")
    }
}
