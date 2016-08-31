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

    var maruBatu = MaruBatu(data: nil)
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
        maruBatu = MaruBatu(data: nil)
        requestPresentationStyle(.expanded) // FullScreenへ移行する
    }

    @IBAction func tapPlayButton(_ sender: AnyObject) {
        let index = sender.tag - 1
        if maruBatu.set(index: index) {
            refresh()
            //buttons[index].setImage(maruBatu.image(index: index), for: .normal)

            // マル、若しくはバツを置けた場合は、メッセージとして送信する
            var message = MSMessage(session: MSSession()) // 初めての場合は、セッションを初期化する
            if let selectedMessage = self.activeConversation?.selectedMessage {
                if let session = selectedMessage.session {
                    message = MSMessage(session: session) // ２回目以降は、同じセッションとする
                    message.summaryText = "更新されました"
                }
            }
            let layout = MSMessageTemplateLayout()
            layout.image = maruBatu.renderSticker()
            message.url = URL(string: maruBatu.data())
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

    private func refresh() {
        for i in 0 ..< 9 {
            buttons[i].setImage(maruBatu.image(index: i), for: .normal)
        }
        if maruBatu.winner() != .None {
            fullScreenView.backgroundColor = maruBatu.winnerColor()
        }
    }

    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {

        if let message = conversation.selectedMessage {
            if let url = message.url {
                // 選択中のMSMessageが有効な場合、urlからデータを取得してMaruBatuを初期化する
                maruBatu = MaruBatu(data: url.absoluteString)
            }
        }
        refresh()
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
