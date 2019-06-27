//
//  StampListViewController.swift
//  line-stamp-maker
//
//  Created by Takashi Imoto on 2019/06/25.
//  Copyright © 2019 Takashi Imoto. All rights reserved.
//

import UIKit
//import CoreImage

class StampListViewController: UIViewController {

    @IBOutlet weak var StampListLabel: UILabel!
    @IBOutlet weak var arrangedImage: UIImageView!
    var imageList = [UIImage]()
    
    let imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        StampListLabel.text = "Stamp List"

        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // UIImage から CGImage を作る
        let cgImage = imageList[2].cgImage!
        // CGImage から CIImage を作る
        let ciImage = CIImage(cgImage: cgImage)
        // 顔検出実行
        let features = detector!.features(in: ciImage, options: [CIDetectorSmile : false])
        for feature in features as! [CIFaceFeature] {
            
            let img = imageList[2]
            let fb: CGRect = feature.bounds
            let rect: CGRect = CGRect(x: fb.origin.x - fb.width*0.5, y: (img.size.height - fb.origin.y - fb.size.height) - fb.height*0.8, width: fb.width*2.0, height: fb.height*2.0)
            
            let cropping = img.cropping(to: rect)

            // テンプレートと合成する
            
            // テンプレートの読み込み
            let templateImage:UIImage = UIImage(named: "Line_stamp_maker_test_template_picture")!
            // 新しいが画像の生成
            let newSize = CGSize(width: templateImage.size.width, height: templateImage.size.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, templateImage.scale)
            cropping?.draw(in: CGRect(x:0+newSize.width/4,y:0+newSize.height/3,width: newSize.width/2, height: newSize.height/2), blendMode: CGBlendMode.normal, alpha: 1.0)

            templateImage.draw(in: CGRect(x:0,y:0,width: newSize.width, height: newSize.height))
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = view.frame.size.height
            imageView.image = newImage
            let newRect = CGRect(x:0, y:0, width:200, height: 200)
            imageView.frame = newRect
            imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
            
            
            arrangedImage.image = newImage
            
          
        }
        
        
    }
    
    // セーブを行う
    func saveImage() {
        
        //                 クリックした UIImageView を取得
        //                let targetImageView = sender.view! as! UIImageView
        
        //                 その中の UIImage を取得
        //                let targetImage = targetImageView.image!
        
        // UIImage の画像をカメラロールに画像を保存
        UIImageWriteToSavedPhotosAlbum(arrangedImage.image!, self, #selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    // 保存を試みた結果をダイアログで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    
    @IBAction func SaveImageButton(_ sender: Any) {
        
        saveImage()
    }
    

    
}

extension UIImage {
    func cropping(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}






