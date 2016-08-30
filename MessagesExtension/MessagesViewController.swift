//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by hirauchi.shinichi on 2016/08/30.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    @IBOutlet weak var comppactView: UIView!
    @IBOutlet weak var fullScreenView: UIView!

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!

    var maruBatu = MaruBatu(url: URL(string: "0000000005")!)
    var message = MSMessage()
    var buttons:[UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttons = [button1 ,button2 ,button3 ,button4 ,button5 ,button6 ,button7 ,button8 ,button9]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action

    @IBAction func tapStartButton(_ sender: AnyObject) {
        message = MSMessage() // 初期化
        requestPresentationStyle(.expanded) // FullScreenへ移行する
    }

    @IBAction func tapPlayButton(_ sender: AnyObject) {
        let index = sender.tag - 1
        if maruBatu.set(index: index) {
            // マル、若しくはバツを置けた場合は、メッセージとして送信する
            let layout = MSMessageTemplateLayout()
            layout.image = maruBatu.renderSticker(opaque: true)
            message.url = maruBatu.url()
            message.layout = layout
            self.activeConversation?.insert(message, completionHandler: nil)
            dismiss()
        }
    }

    // MARK: - Private

    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .compact {
            comppactView.isHidden = false
            fullScreenView.isHidden = true
        } else {
            comppactView.isHidden = true
            fullScreenView.isHidden = false
        }
    }

    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        if let selectedMessage = conversation.selectedMessage {
            // 選択中のMSMessageが有効な場合、urlからデータを取得してMaruBatuを初期化する
            maruBatu = MaruBatu(url: selectedMessage.url!)
            for i in 0 ..< 9 {
                buttons[i].setImage(maruBatu.image(index: i), for: .normal)
            }
        }
        presentViewController(for: conversation, with: presentationStyle)
    }

    override func didResignActive(with conversation: MSConversation) {
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if let conversation = activeConversation {
            presentViewController(for: conversation, with: presentationStyle)
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    }

}
