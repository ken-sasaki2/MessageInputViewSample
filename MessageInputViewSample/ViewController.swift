//
//  ViewController.swift
//  MessageInputViewSample
//
//  Created by sasaki.ken on 2023/07/29.
//

import UIKit

final class ViewController: UIViewController {
    
    private var tableView = UITableView()
    private var messageInputView = UIView()
    private var textView = UITextView()
    private var cameraButton = UIButton()
    private var sendButton = UIButton()
    
    private var messageInputViewFrame: CGRect?
    private var tableViewSize: CGSize?
    private var keyboardFrame: CGRect?
    
    private let BUTTON_SIZE: CGFloat = 44
    private let INPUT_VIEW_HEIGHT: CGFloat = 44
    private let TEXT_VIEW_HEIGHT: CGFloat = 36
    private let TEXT_VIEW_MARGIN: CGFloat = 4
    private let MIN_TEXT_VIEW_HEIGHT: CGFloat = 36
    private let MAX_TEXT_VIEW_HEIGHT: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpLayoutContainer()
        setUpNotification()
    }
    
    private func setUpLayoutContainer() {
        setUpTableView()
        setUpMessageInputView()
        setUpCameraButton()
        setUpTextView()
        setUpSendButton()
        messageInputViewFrame = messageInputView.frame
        tableViewSize = tableView.frame.size
    }
    
    private func setUpTableView() {
        let barHeight = UIApplication.shared.statusBarFrame.height
        let frame = CGRect(
            x: 0,
            y: barHeight,
            width: view.frame.width,
            height: view.frame.height - (barHeight + INPUT_VIEW_HEIGHT)
        )
        tableView.frame = frame
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
    }
    
    private func setUpMessageInputView() {
        let barHeight = UIApplication.shared.statusBarFrame.height
        let frame = CGRect(
            x: 0,
            y: view.frame.height - (barHeight + INPUT_VIEW_HEIGHT),
            width: view.frame.width,
            height: INPUT_VIEW_HEIGHT
        )
        messageInputView.frame = frame
        messageInputView.backgroundColor = .darkGray
        view.addSubview(messageInputView)
    }
    
    private func setUpCameraButton() {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: BUTTON_SIZE,
            height: BUTTON_SIZE
        )
        cameraButton.frame = frame
        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        cameraButton.tintColor = .black
        cameraButton.backgroundColor = .clear
        cameraButton.addTarget(self, action: #selector(onCameraButtonTapped(_:)), for: .touchUpInside)
        messageInputView.addSubview(cameraButton)
    }
    
    private func setUpTextView() {
        let frame = CGRect(
            x: BUTTON_SIZE,
            y: TEXT_VIEW_MARGIN,
            width: view.frame.width - (BUTTON_SIZE * 2),
            height: TEXT_VIEW_HEIGHT
        )
        textView.frame = frame
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
        textView.delegate = self
        textView.backgroundColor = .lightGray
        messageInputView.addSubview(textView)
    }
    
    private func setUpSendButton() {
        let frame = CGRect(
            x: view.frame.width - BUTTON_SIZE,
            y: 0,
            width: BUTTON_SIZE,
            height: BUTTON_SIZE
        )
        sendButton.frame = frame
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .black
        sendButton.backgroundColor = .clear
        sendButton.addTarget(self, action: #selector(onSendButtonTapped(_:)), for: .touchUpInside)
        messageInputView.addSubview(sendButton)
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardFrame = keyboardInfo.cgRectValue
        drawMessageInputView()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let messageInputViewFrame = messageInputViewFrame else {
            return
        }
        guard let tableViewSize = tableViewSize else {
            return
        }
        messageInputView.frame = messageInputViewFrame
        tableView.frame.size = tableViewSize
    }
    
    func drawMessageInputView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let bound = UIScreen.main.bounds.size
        var height = textView.sizeThatFits(CGSize(
            width: textView.frame.size.width,
            height: CGFloat.greatestFiniteMagnitude)
        ).height
        
        if height < MIN_TEXT_VIEW_HEIGHT {
            height = MIN_TEXT_VIEW_HEIGHT
        } else if MAX_TEXT_VIEW_HEIGHT < height {
            height = MAX_TEXT_VIEW_HEIGHT
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
                y: bound.height - keyboardFrame.size.height - messageInputView.frame.height,
                width: view.frame.width,
                height: height + (TEXT_VIEW_MARGIN * 2)
            )
            tableView.frame.size = CGSize(
                width: tableView.frame.width,
                height: bound.height - (statusBarHeight + keyboardFrame.height + height)
            )
        }
    }
    
    @objc private func onCameraButtonTapped(_ sender: UIButton) {
        print("camera.")
    }
    
    @objc private func onSendButtonTapped(_ sender: UIButton) {
        print("send.")
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        drawMessageInputView()
    }
}
