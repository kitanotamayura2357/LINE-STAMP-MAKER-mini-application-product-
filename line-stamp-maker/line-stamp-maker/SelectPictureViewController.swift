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
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    var photoAssets = [PHAsset]()
    var imageList = [UIImage]()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
        SelectPictureLabel.text = "写真を選択"
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
                                 options: nil) { [unowned self] (image, info) -> Void in

                                    self.imageList.append(image!)
                                    self.pictureCollectionView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toViewController2") {
            let vc2: StampListViewController = (segue.destination as? StampListViewController)!
           
            guard let selectedImage = selectedImage else {return}
            vc2.selectedImage = selectedImage
            
        }
    }
}

extension SelectPictureViewController: UICollectionViewDelegate {
    
}

extension SelectPictureViewController: UICollectionViewDataSource {
    func collectionView(_ pictureCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
        
    }
    
    func collectionView(_ pictureCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pictureCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = imageList[indexPath.row]
        cell.layer.borderColor = UIColor( red: 1.0, green: 0.0, blue:0, alpha: 1.0 ).cgColor
        return cell
    }
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = imageList[indexPath.row]
        
        print("selectedImage",selectedImage)
        print("indexPath.row",indexPath.row)
        if selectedImage != nil {
            
            collectionView.visibleCells.forEach { cell in
                let curIndexPath = collectionView.indexPath(for: cell)
                cell.layer.borderWidth = indexPath == curIndexPath ? 3 : 0
            }
        }
    }
}




