//
//  MaruBatu.swift
//  MaruBatuApp
//
//  Created by hirauchi.shinichi on 2016/08/30.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

enum Kind {
    case Maru
    case Batu
    case None
}


class MaruBatu {

    var kinds: [Kind] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    var count = 0

    init(url:URL) {
        var str = url.absoluteString
        for (index,c) in str.characters.enumerated() {
            if index == 9 {
                count = Int(String(c))!
            } else {
                switch c {
                case "1":
                    kinds[index] = .Maru
                case "2":
                    kinds[index] = .Batu
                default:
                    kinds[index] = .None
                }
            }
        }
    }

    func image(index:Int) -> UIImage {

        switch kinds[index] {
        case .None:
            return UIImage()
        case .Maru:
            return UIImage(named: "maru.png")!
        case .Batu:
            return UIImage(named: "batu.png")!
        }
    }

    func set(index:Int) ->Bool {
        if kinds[index] == .None { // その場所が、まだ空白の場合だけ、マル若しくは、バツが置ける
            // 何番目に置いたかでマルかバツかが決まる
            kinds[index] = count%2==0 ? .Batu : .Maru
            count += 1
            return true
        }
        return false
    }

    func url() -> URL {
        var result = ""
        for var kind in kinds {
            switch kind {
            case .None:
                result = result + "0"
            case .Maru:
                result = result + "1"
            case .Batu:
                result = result + "2"
            }
        }

        result = result + count.description
        return URL(string: result)!
    }

    // 現在の対戦状況を画像で返す
    func renderSticker(opaque: Bool) -> UIImage? {
        let baseSize = 100 // ひとマスのサイズは、縦横100
        if let backImage = UIImage(named: "back.png") {
            if let maruImage = UIImage(named: "maru.png") {
                if let batuImage = UIImage(named: "batu.png") {
                    UIGraphicsBeginImageContext(CGSize(width:baseSize * 3, height:baseSize * 3))
                    backImage.draw(in: CGRect(x: 0, y: 0, width: baseSize * 3, height: baseSize * 3))
                    for i in 0 ..< 9 {
                        let x:Int = i % 3
                        let y:Int = i / 3
                        if kinds[i] == .Maru {
                            maruImage.draw(in: CGRect(x: x * baseSize, y: y * baseSize, width: baseSize, height: baseSize))
                        } else if kinds[i] == .Batu {
                            batuImage.draw(in: CGRect(x: x * baseSize, y: y * baseSize, width: baseSize, height: baseSize))
                        }
                    }
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    return newImage
                }
            }
        }
        return UIImage()
    }

}
