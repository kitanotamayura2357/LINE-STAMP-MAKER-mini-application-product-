//
//  SelectPictureViewController.swift
//  line-stamp-maker
//
//  Created by Takashi Imoto on 2019/06/25.
//  Copyright © 2019 Takashi Imoto. All rights reserved.
//

import UIKit
import Photos


class SelectPictureViewController: UIViewController {
    @IBOutlet weak var SelectPictureLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBAction func saveImageButton(_ sender: Any) {
    }
    var photoAssets = [PHAsset]()
    var imageList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectPictureLabel.text = "写真を選択"
        // Do any additional setup after loading the view.
        
        
    
        // ソート条件を指定
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        // 画像をすべて取得
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as PHAsset)
            
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,
                                 targetSize: PHImageManagerMaximumSize,
                                 contentMode: .aspectFit,
                                 options: nil) { (image, info) -> Void in

//                                    print("image",image)
                                    print("assets",assets)

//                                    self.imageview.image = image
                                    self.imageList.append(image!)
                                    self.imageview.image = self.imageList[0]



            }
        }
//        print("PHImageManagerMaximumSize",PHImageManagerMaximumSize)
//        print("photoAssets",photoAssets)
//        print("imageList",imageList)
//        print("imageList1",imageList[0])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toViewController2") {
            let vc2: StampListViewController = (segue.destination as? StampListViewController)!
            // ViewControllerのtextVC2にメッセージを設定
            vc2.imageList = imageList
        }
    }
    

}
