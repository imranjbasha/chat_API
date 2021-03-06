//
//  ChatVC.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit
import SDWebImage
import OpalImagePicker
import Photos
import AVFoundation
import AVKit

class ChatVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tvMessages: UITableView!
    
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var chatInputView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var largerView: UIView!
        
    @IBOutlet weak var largerScrollView: UIScrollView!{
        didSet{
            largerScrollView.delegate = self
            largerScrollView.minimumZoomScale = 1.0
            largerScrollView.maximumZoomScale = 10.0
        }
    }
    
    @IBOutlet weak var largerImageView: UIImageView!
    
    var friendId : String?
    
    var friendName : String?
    
    var friendProfilePic : String?

    
    var messages: [Message] = []
    
    var isVisible: Bool = false
    
    var spinner = UIActivityIndicatorView(style: .large)
        
    var friendsVC :FriendsListVC?

    var attatchments: [Media] = []
    
    var isKeypadHidden: Bool = true

    @IBOutlet weak var tfChat: UITextField!
    
    @IBOutlet weak var chatSendBtn: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
        
    @IBOutlet weak var clearView: UIView!
    
    @IBAction func onTappedButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            sendTextChat()
        case 2:
            self.navigationController?.popToRootViewController(animated: true)
        case 3:
            showClearAllAlert()
        case 4:
            largerView.isHidden =  true
            largerScrollView.minimumZoomScale = 1.0
            largerScrollView.maximumZoomScale = 10.0
        case 5:
            //camera
            openCamera()
        case 6:
            //gallery
            openGallery()
        default:
            print("default")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        updateUI()
        loadChatList()
    }
    
    func updateUI(){
        self.view.showProgress(spinner: spinner)
        chatSendBtn.roundedButton()
        tvMessages.delegate = self
        tvMessages.dataSource = self
        chatInputView.setCornerRadius(value: 25.0)
        chatInputView.setBorder(color: UIColor.gray, width: 1.0)
        addGesturesObservers()
        if let friendName = friendName {
            self.userName.text = friendName
        }
        if let friendProfilePic = friendProfilePic, let url = URL(string: friendProfilePic), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.userProfilePic.maskCircle(image: image)
        }else {
            guard let image = UIImage(named: AssetsName.default_profile) else { return }
            self.userProfilePic.maskCircle(image: image)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largerImageView
    }
    
    func addGesturesObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tvMessages.addGestureRecognizer(tapGesture)
    }
    
    func loadChatList(){
            refreshList()
            let messagesViewModel = MessagesViewModel(userId: friendId ?? "")
            messagesViewModel.bindMessagesViewModelToController = {
                self.messages = messagesViewModel.messagesData
                self.refreshList()
            }
        }
    
    func refreshList(){
        DispatchQueue.main.async {
            self.tvMessages.reloadData()
            if self.messages.count > 0 {
                let indexpath = IndexPath(row: self.messages.count-1, section: 0)
                self.tvMessages.scrollToRow(at: indexpath, at: .bottom, animated: false)
            }
            self.view.hideProgress(spinner: self.spinner)
//            self.callback?(self.messages, self.friendId ?? "")
            self.friendsVC?.onShownMessages(messages: self.messages, userId: self.friendId ?? "")
        }
    }
    
    func sendTextChat(){
        if let message = tfChat.text, !message.isEmpty {
            self.view.showProgress(spinner: spinner)
            let image = UIImage(named: "icon_back")
            if let data = image?.pngData() {
                let chatViewModel = ChatViewModel(userId: friendId ?? "", message: message, type: .text)
                chatViewModel.isChatSent = {
                    self.tfChat.text = ""
                    self.loadChatList()
                }
            }
        }
    }
    
    func showLargeImage(imageUrlString: String) {
        if let url = URL(string: imageUrlString) {
            largerView.isHidden = false
            largerImageView.sd_setImage(with: url as URL , placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
            largerScrollView.zoomScale = 1.0
        }
    }
    
    func loadVideo(videoUrl: URL){
            let avPlayer = AVPlayer(url: videoUrl)
            let avController = AVPlayerViewController()
            avController.player = avPlayer
            avPlayer.play()
            present(avController, animated: true, completion: nil)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 5
        presentOpalImagePickerController(imagePicker, animated: true,
            select: { (assets) in
                self.attatchments.removeAll()
                let group = DispatchGroup()
                for asset in assets {
                    group.enter()
                    switch asset.mediaType {
                    case .image:
                        print("image")
                            let image = self.getImageFromAsset(asset: asset)
                            guard let data = image.pngData() else { return }
                            let media = Media(mediaType: .image, data: data)
                            self.attatchments.append(media)
                            group.leave()
                    case .video:
                        print("video")
                            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, info) in
                                guard let asset = asset as? AVURLAsset, let data = try? Data(contentsOf: asset.url) else {
                                    group.leave()
                                    return
                                }
                                let media = Media(mediaType: .video, data: data)
                                self.attatchments.append(media)
                                group.leave()
                              }
                    case .unknown:
                        group.leave()
                        return
                    case .audio:
                        group.leave()
                        return
                    @unknown default:
                        group.leave()
                        return
                    }
                }
                group.notify(queue: .main) {
                    imagePicker.dismiss(animated: true) {
                        let chatVM = ChatViewModel(userId: self.friendId ?? "", message: "", type: .media, files: self.attatchments)
                        chatVM.isChatSent = {
                            self.loadChatList()
                            }

                    }
                }
                //Select Assets
            }, cancel: {
                self.attatchments.removeAll()
                imagePicker.dismiss(animated: true, completion: nil)
            })
        
        
    }
    
    func getImageFromAsset(asset: PHAsset) -> UIImage {
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            if let result = result {
                thumbnail = result
            }
        })
        
        return thumbnail
    }
    
    
    func showDeleteAlert(message: Message){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteForMe = UIAlertAction(title: "Delete just for me", style: .destructive) { (action) in
            self.deleteMessage(message: message, shouldDeleteForBoth: false)
        }
        
        let deleteForAll = UIAlertAction(title: "Delete for me and \(userName.text ?? "this user")", style: .destructive) { (action) in
            self.deleteMessage(message: message, shouldDeleteForBoth: true)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.title = "Are you sure you want to delete the message with \(userName.text ?? "this user") ?"
        alertController.addAction(deleteForMe)
        alertController.addAction(deleteForAll)
        alertController.addAction(cancel)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func showClearAllAlert(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteForMe = UIAlertAction(title: "Delete just for me", style: .destructive) { (action) in
            self.clearAll(shouldDeleteForBoth: false)
        }
        
        let deleteForAll = UIAlertAction(title: "Delete for me and \(userName.text ?? "this user")", style: .destructive) { (action) in
            self.clearAll(shouldDeleteForBoth: true)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.title = "Are you sure you want to delete the chat with \(userName.text ?? "this user") ?"
        alertController.addAction(deleteForMe)
        alertController.addAction(deleteForAll)
        alertController.addAction(cancel)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func deleteMessage(message: Message, shouldDeleteForBoth: Bool){
        if let messageId = message._id, let friendId = friendId {
            let deleteVM = DeleteChatViewModel(messageId: messageId, type: ChatDeleteType.single, userId: friendId, shouldDeleteForBoth: shouldDeleteForBoth)
            deleteVM.isMessageDeleted = {
                self.loadChatList()
            }
        }
    }
    
    func clearAll(shouldDeleteForBoth: Bool){
        let deleteVM = DeleteChatViewModel(messageId: "", type: ChatDeleteType.all, userId: friendId ?? "", shouldDeleteForBoth: shouldDeleteForBoth)
        deleteVM.isClearedAll = {
            self.loadChatList()
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = view.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            bottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        if bottomConstraint.constant > 10 {
            isKeypadHidden = false
        }else {
            isKeypadHidden = true
        }
        view.endEditing(true)
    }
    
    /* func convertUTCtoLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
         if let date = dateFormatter.date(from: date as String){
             dateFormatter.dateFormat = "hh:mm a"
             return dateFormatter.string(from: date)
         }else {
             return ""
         }
    } */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = messages[indexPath.item]
        if messageData.to == friendId {
            if messageData.type == "media" || messageData.type == "document" {
                let image = messageData.attachments
                if image.count > 1 {
                    let cell =  tableView.dequeueReusableCell(withIdentifier: "MultiOwnImageCell", for: indexPath) as! ChatCell
                    let urlString = image[0]
                    if let url = URL(string: urlString) {
                        cell.chatImage.sd_setImage(with: url as URL , placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
                        if urlString.contains("mp4"){
                            DispatchQueue.global().async {
                                if let url = URL(string: urlString),let thumbnail = UtilsClass.getThumbnailImage(forUrl: url){
                                    DispatchQueue.main.async {
                                        cell.chatImage.image = thumbnail
                                    }
                                }
                            }
                        }
                    }else{
                        cell.chatImage.image = UIImage(named: AssetsName.icon_image_placeholder)
                    }
                    cell.attachementCount.text = "+\(image.count-1)"
                    cell.chatImage.setCorner(value: 20.0)
                    cell.countView.setCornerRadius(value: 20.0)
                    cell.timeStamp.text =  UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                    return cell
                }else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnImageCell", for: indexPath) as! ChatCell
                if image.count > 0 , let url = URL(string: image[0]) {
                    let urlString = image[0]
                    cell.chatImage.sd_setImage(with: url as URL , placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
                    if urlString.contains("mp4"){
                        DispatchQueue.global().async {
                            if let url = URL(string: urlString),let thumbnail = UtilsClass.getThumbnailImage(forUrl: url){
                                DispatchQueue.main.async {
                                    cell.chatImage.image = thumbnail
                                    cell.videoPlayerView.setCornerRadius(value: 30.0)
                                    cell.videoPlayerView.setBorder(color: .black, width: 1.0)
                                    cell.videoPlayerView.isHidden = false
                                }
                            }
                        }
                    }else{
                        cell.videoPlayerView.isHidden = true
                    }
                }else{
                    cell.videoPlayerView.isHidden = true
                    cell.chatImage.image = UIImage(named: AssetsName.icon_image_placeholder)
                }
                cell.chatImage.setCorner(value: 20.0)
                cell.timeStamp.text =  UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                return cell
                }
            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnCell", for: indexPath) as! ChatCell
                let message = messageData.message
                cell.chatMessage.text = "\(message ?? "")    "
                cell.textOuterView.setCornerRadius(value: 15.0)
                cell.timeStamp.text = UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                return cell
            }
        }else{
            if messageData.type == "media" || messageData.type == "document" {
                let image = messageData.attachments
                if image.count > 1 {
                    let cell =  tableView.dequeueReusableCell(withIdentifier: "MultiFriendImageCell", for: indexPath) as! ChatCell
                    let urlString = image[0]
                    if let url = URL(string: urlString) {
                        cell.chatImage.sd_setImage(with: url as URL , placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
                        if urlString.contains("mp4"){
                            DispatchQueue.global().async {
                                if let url = URL(string: urlString),let thumbnail = UtilsClass.getThumbnailImage(forUrl: url){
                                    DispatchQueue.main.async {
                                        cell.chatImage.image = thumbnail
                                    }
                                }
                            }
                        }
                    }else{
                        cell.chatImage.image = UIImage(named: AssetsName.icon_image_placeholder)
                    }
                    cell.attachementCount.text = "+\(image.count-1)"
                    cell.chatImage.setCorner(value: 20.0)
                    cell.countView.setCornerRadius(value: 20.0)
                    cell.timeStamp.text =  UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                    return cell
                }else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendImageCell", for: indexPath) as! ChatCell
                if image.count > 0 , let url = URL(string: image[0]) {
                    let urlString = image[0]
                    cell.chatImage.sd_setImage(with: url as URL , placeholderImage: UIImage(named: AssetsName.icon_image_placeholder))
                    if urlString.contains("mp4"){
                        DispatchQueue.global().async {
                            if let url = URL(string: urlString),let thumbnail = UtilsClass.getThumbnailImage(forUrl: url){
                                DispatchQueue.main.async {
                                    cell.chatImage.image = thumbnail
                                    cell.videoPlayerView.setCornerRadius(value: 30.0)
                                    cell.videoPlayerView.setBorder(color: .black, width: 1.0)
                                    cell.videoPlayerView.isHidden = false
                                }
                            }
                        }
                    }else{
                        cell.videoPlayerView.isHidden = true
                    }
                }else{
                    cell.videoPlayerView.isHidden = true
                    cell.chatImage.image = UIImage(named: AssetsName.icon_image_placeholder)
                }
                cell.chatImage.setCorner(value: 20.0)
                cell.timeStamp.text =  UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                return cell
                }
            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! ChatCell
                let message = messageData.message
                cell.chatMessage.text = "\(message ?? "")    "
                cell.textOuterView.setCornerRadius(value: 15.0)
                cell.timeStamp.text = UtilsClass.convertUTCtoLocal(date: messageData.timestamp ?? "")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isKeypadHidden {
        let messageData = messages[indexPath.item]
        let images = messageData.attachments
        if (messageData.type == "media" || messageData.type == "document") && images.count == 1 {
            let media = images[0]
            if media.contains("mp4"){
                if let url = URL(string: media){
                    self.loadVideo(videoUrl: url)
                }
            }else{
                self.showLargeImage(imageUrlString: media)
            }
        }else if images.count > 1 {
            let mediaVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaVC") as! MediaVC
            mediaVC.mediasUrlString = images
            present(mediaVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let message = messages[indexPath.item]
            self.showDeleteAlert(message: message)
        }
    }
}

extension ChatVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.view.showProgress(spinner: self.spinner)
        let image = info[.originalImage] as! UIImage
        var fileName = UUID().uuidString
        if let imageUrl = info[.mediaURL] as? NSURL, let absoluteString = imageUrl.absoluteString {
            fileName = absoluteString
        }
        if let imageData = image.pngData() {
            let media = Media(mediaType: .image, data: imageData)
            let file = [media]
            let chatVM = ChatViewModel(userId: friendId ?? "", message: "", type: .media, files: file, fileName: fileName)
            chatVM.isChatSent = {
                self.loadChatList()
                }
            }
        dismiss(animated:true, completion: nil)
    }
}
