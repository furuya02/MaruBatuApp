//
//  MaruBatu.swift
//  MaruBatuApp
//
//  Created by hirauchi.shinichi on 2016/08/30.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class MaruBatu {

    enum Kind {
        case Maru
        case Batu
        case None
    }

    var kinds: [Kind] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]

    init(data:String?) {
        if let str = data {
            for (index,c) in str.characters.enumerated() {
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

    // MARK: - Public

    // 指定位置の画像を返す
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

    // 「まる」「ばつ」をセットする
    func set(index:Int) ->Bool {
        if kinds[index] == .None { // その場所が、まだ空白の場合だけ、マル若しくは、バツが置ける
            kinds[index] = count() % 2 == 0 ? .Batu : .Maru // 何番目に置いたかでマルかバツかが決まる
            return true
        }
        return false
    }

    // 現在の対戦状況を文字列で返す
    func data() -> String {
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
        return result
    }

    // 現在の対戦状況を画像で返す
    func renderSticker() -> UIImage? {
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

    // MARK: - Private

    func count() -> Int {
        var result = 0
        for var kind in kinds {
            if (kind != .None) {
                result += 1
            }
        }
        return result
    }
}
