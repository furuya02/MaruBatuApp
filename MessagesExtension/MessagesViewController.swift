//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by hirauchi.shinichi on 2016/09/09.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!

    @IBOutlet weak var compactView: UIView!
    @IBOutlet weak var fullScreenView: UIView!

    var maruBatu = MaruBatu(data: nil)
    var buttons:[UIButton] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button1 ,button2 ,button3 ,button4 ,button5 ,button6 ,button7 ,button8 ,button9]
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
        presentViewController(style: presentationStyle)
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        presentViewController(style: presentationStyle)
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

    private func presentViewController(style: MSMessagesAppPresentationStyle) {
        compactView.isHidden = style == .expanded
        fullScreenView.isHidden = style == .compact
    }

    private func refresh() {
        for i in 0 ..< 9 {
            buttons[i].setImage(maruBatu.image(index: i), for: .normal)
        }
        if maruBatu.winner() != .None {
            fullScreenView.backgroundColor = maruBatu.winnerColor()
        }
    }
}
