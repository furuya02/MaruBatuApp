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
    case Draw
}

class MaruBatu {


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
        default:
            return UIImage()
        }
    }

    // 「まる」「ばつ」をセットする
    func set(index:Int) ->Bool {
        if winner() != .None { // 勝敗が付いている場合は、これ以上プレイできない
            return false
        }
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
            default: break
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
                    if winner() != .None {
                        if let contextRef = UIGraphicsGetCurrentContext() {
                            contextRef.setFillColor(winnerColor().cgColor)
                            contextRef.fill(CGRect(x: 0, y: 0, width: baseSize * 3, height: baseSize * 3));
                        }
                    }
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

    func winner() -> Kind {
        if kinds[0] == kinds[1] && kinds[0] == kinds[2] { // 0,1,2
            return kinds[0]
        }
        if kinds[0] == kinds[4] && kinds[0] == kinds[8] { // 0,4,8
            return kinds[0]
        }
        if kinds[0] == kinds[3] && kinds[0] == kinds[6] { // 0,4,6
            return kinds[0]
        }
        if kinds[1] == kinds[4] && kinds[1] == kinds[7] { // 1,4,7
            return kinds[1]
        }
        if kinds[2] == kinds[4] && kinds[2] == kinds[6] { // 2,4,6
            return kinds[2]
        }
        if kinds[2] == kinds[5] && kinds[2] == kinds[8] { // 2,5,8
            return kinds[2]
        }
        if kinds[3] == kinds[4] && kinds[3] == kinds[5] { // 3,4,5
            return kinds[3]
        }
        if kinds[6] == kinds[7] && kinds[6] == kinds[8] { // 6,7,8
            return kinds[6]
        }
        if count() == 9 {
            return .Draw
        }
        return .None
    }

    func winnerColor() ->UIColor {
        if winner() == .Batu {
            return UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        } else if winner() == .Maru {
            return UIColor.init(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        } else if winner() == .Draw {
            return UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        }
        return UIColor.white
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
