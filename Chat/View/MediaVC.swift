//
//  MediaVC.swift
//  Chat
//
//  Created by IMRAN on 05/05/21.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class MediaVC: UIViewController {
    
    @IBOutlet weak var cvMedias: UICollectionView!
    
    var mediasUrlString: [String] = []
    

    @IBAction func onTappedBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cvMedias.delegate = self
        cvMedias.dataSource = self
        cvMedias.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func loadVideo(videoUrl: URL){
            let avPlayer = AVPlayer(url: videoUrl)
            let avController = AVPlayerViewController()
            avController.player = avPlayer
            avPlayer.play()
            present(avController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MediaVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediasUrlString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let media = self.mediasUrlString[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        cell.mediaImage.sd_setImage(with: URL(string: media), placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
        cell.imageOuterView.setCornerRadius(value: 15.0)
        if media.contains("mp4"){
            cell.videoPlayerView.setCornerRadius(value: 30.0)
            cell.videoPlayerView.setBorder(color: .black, width: 1.0)
            cell.videoPlayerView.isHidden = false
            DispatchQueue.global().async {
                if let url = URL(string: media),let thumbnail = UtilsClass.getThumbnailImage(forUrl: url){
                    DispatchQueue.main.async {
                        cell.mediaImage.image = thumbnail
                    }
                }
            }
            
        }else{
            cell.videoPlayerView.isHidden = true
        }
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = self.mediasUrlString[indexPath.item]
        if media.contains("mp4"){
            if let url = URL(string: media){
                self.loadVideo(videoUrl: url)
            }
        }
    }
    
    
}
