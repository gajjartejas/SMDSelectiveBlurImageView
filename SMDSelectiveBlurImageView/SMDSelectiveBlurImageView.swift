//
//  SMDSelectiveBlurImageView.swift
//  SMDSelectiveBlurImageView
//
//  Created by Tejas on 02/12/17.
//  Copyright © 2017 Tejas. All rights reserved.
//

import UIKit

public class SMDSelectiveBlurImageView: UIImageView {
    
   public  override func awakeFromNib() {
        isUserInteractionEnabled = true
    }
    
   public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var croppedImg: UIImage? = nil
        let touch: UITouch? = touches.first
        var currentPoint: CGPoint? = touch?.location(in: self)
        let ratioW: CGFloat = self.image!.size.width / self.frame.size.width
        let ratioH: CGFloat = self.image!.size.height / self.frame.size.height
        
        var currentpoint_x = (currentPoint?.x)!
        var currentpoint_y = (currentPoint?.y)!
        
        currentPoint?.x = ratioW * currentpoint_x
        currentPoint?.y = ratioH * currentpoint_y
        
        currentpoint_x = (currentPoint?.x)!
        currentpoint_y = (currentPoint?.y)!
        
        let circleSizeW: CGFloat = 60 * ratioW
        let circleSizeH: CGFloat = 60 * ratioH
        currentPoint?.x = (currentpoint_x - circleSizeW / 2 < 0) ? 0 : currentpoint_x - circleSizeW / 2
        currentPoint?.y = (currentpoint_y - circleSizeH / 2 < 0) ? 0 : currentpoint_y - circleSizeH / 2
        let cropRect = CGRect(x: (currentPoint?.x)!, y: (currentPoint?.y)!, width: CGFloat(circleSizeW), height: CGFloat(circleSizeH))
        
        croppedImg = croppIngimage(byImageName: (self.image)!, to: cropRect)
        
        if croppedImg == nil {
            return
        }
        
        // Blur Effect
        croppedImg = croppedImg?.imageWithGaussianBlur9()
        
        // Contrast Effect
        // croppedImg = [croppedImg imageWithContrast:50];
        
        croppedImg = roundedRectImage(from: croppedImg, withRadious: 6)
        self.image = addImage(to: self.image!, withImage2: croppedImg!, andRect: cropRect)
    }
    
    func croppIngimage(byImageName imageToCrop: UIImage, to rect: CGRect) -> UIImage? {
        
        let imageRefNilable: CGImage? = imageToCrop.cgImage?.cropping(to: rect)
        
        guard let imageRef = imageRefNilable else {
            return nil
        }
        let cropped = UIImage(cgImage: imageRef)
        return cropped
    }
    
    func roundedRectImage(from image: UIImage?, withRadious radious: CGFloat) -> UIImage? {
        if radious == 0.0 {
            return image
        }
        if image != nil {
            let imageWidth: CGFloat = image!.size.width
            let imageHeight: CGFloat = image!.size.height
            let rect = CGRect(x: 0.0, y: 0.0, width: imageWidth, height: imageHeight)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            let context: CGContext? = UIGraphicsGetCurrentContext()
            context?.beginPath()
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: radious, y: radious)
            let rectWidth: CGFloat = rect.width / radious
            let rectHeight: CGFloat = rect.height / radious
            context?.move(to: CGPoint(x: rectWidth, y: rectHeight / 2.0))
            context?.addArc(tangent1End: CGPoint(x: rectWidth, y: rectHeight), tangent2End: CGPoint(x: rectWidth / 2.0, y: rectHeight), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: 0.0, y: rectHeight), tangent2End: CGPoint(x: 0.0, y: rectHeight / 2.0), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: 0.0, y: 0.0), tangent2End: CGPoint(x: rectWidth / 2.0, y: 0.0), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: rectWidth, y: 0.0), tangent2End: CGPoint(x: rectWidth, y: rectHeight / 2.0), radius: radious)
            context?.restoreGState()
            context?.closePath()
            context?.clip()
            image?.draw(in: CGRect(x: 0.0, y: 0.0, width: imageWidth, height: imageHeight))
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return nil
    }
    
    func addImage(to img: UIImage, withImage2 img2: UIImage, andRect cropRect: CGRect) -> UIImage {
        let size = CGSize(width: (self.image?.size.width)!, height: (self.image?.size.height)!)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let pointImg1 = CGPoint(x: 0, y: 0)
        img.draw(at: pointImg1)
        let pointImg2: CGPoint = cropRect.origin
        img2.draw(at: pointImg2)
        let result: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UIImage {
    
    func imageWithGaussianBlur9() -> UIImage {
        
        let weight: [Float] = [0.4270270270, 0.8045945946, 0.6216216216, 0.4040540541, 0.1222162162]
        
        // Blur horizontally
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[0]))
        for x in 1..<5  {
            draw(in: CGRect(x: CGFloat(x), y: 0, width: CGFloat(size.width), height: CGFloat(size.height)), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[x]))
            draw(in: CGRect(x: CGFloat(-x), y: 0, width: CGFloat(size.width), height: size.height), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[x]))
        }
        let horizBlurredImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Blur vertically
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        horizBlurredImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[0]))
        for y in 1..<5 {
            horizBlurredImage?.draw(in: CGRect(x: 0, y: CGFloat(y), width: CGFloat(size.width), height: CGFloat(size.height)), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[y]))
            horizBlurredImage?.draw(in: CGRect(x: 0, y: CGFloat(-y), width: CGFloat(size.width), height: CGFloat(size.height)), blendMode: CGBlendMode.normal, alpha: CGFloat(weight[y]))
        }
        let blurredImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //
        return blurredImage!
    }
}
