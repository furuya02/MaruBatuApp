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
            kinds[index] = count%2==0 ? .Maru : .Batu
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


    func renderSticker(opaque: Bool) -> UIImage? {



        var backImage = UIImage(named: "back.png")
        var maruImage = UIImage(named: "maru.png")
        var batuImage = UIImage(named: "batu.png")

        return backImage;
//        UIGraphicsBeginImageContext(backImage.size);
//
//        CGRect rect = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
//
//        [ratuImage drawInRect:rect];
//        [batuImage drawInRect:rect blendMode:kCGBlendModeScreen alpha:0.5];
//
//        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();  
//        
//        [imageView3 setImage:resultingImage];



//        guard let partsImage = renderParts() else { return nil }
//
//        // Determine the size to draw as a sticker.
//        let outputSize: CGSize
//        let iceCreamSize: CGSize
//
//        if opaque {
//            // Scale the ice cream image to fit in the center of the sticker.
//            let scale = min((StickerProperties.size.width - StickerProperties.opaquePadding.width) / partsImage.size.height,
//                            (StickerProperties.size.height - StickerProperties.opaquePadding.height) / partsImage.size.width)
//            iceCreamSize = CGSize(width: partsImage.size.width * scale, height: partsImage.size.height * scale)
//            outputSize = StickerProperties.size
//        }
//        else {
//            // Scale the ice cream to fit it's height into the sticker.
//            let scale = StickerProperties.size.width / partsImage.size.height
//            iceCreamSize = CGSize(width: partsImage.size.width * scale, height: partsImage.size.height * scale)
//            outputSize = iceCreamSize
//        }
//
//        // Scale the ice cream image to the correct size.
//        let renderer = UIGraphicsImageRenderer(size: outputSize)
//        let image = renderer.image { context in
//            let backgroundColor: UIColor
//            if opaque {
//                // Give the image a colored background.
//                backgroundColor = UIColor(red: 250.0 / 255.0, green: 225.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
//            }
//            else {
//                // Give the image a clear background
//                backgroundColor = UIColor.clear
//            }
//
//            // Draw the background
//            backgroundColor.setFill()
//            context.fill(CGRect(origin: CGPoint.zero, size: StickerProperties.size))
//
//            // Draw the scaled composited image.
//            var drawRect = CGRect.zero
//            drawRect.size = iceCreamSize
//            drawRect.origin.x = (outputSize.width / 2.0) - (iceCreamSize.width / 2.0)
//            drawRect.origin.y = (outputSize.height / 2.0) - (iceCreamSize.height / 2.0)
//
//            partsImage.draw(in: drawRect)
//        }
//
//        return image
    }

}
