//
//  ChatVC.swift
//  Chat
//
//  Created by IMRAN on 20/04/21.
//

import UIKit
import SDWebImage

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
    
    @IBOutlet weak var tfChat: UITextField!
    
    @IBOutlet weak var chatSendBtn: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBAction func onTappedButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            sendTextChat()
        case 2:
            self.navigationController?.popToRootViewController(animated: true)
        case 3:
            print("Tapped search")
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
        if let friendName = friendName, let friendProfilePic = friendProfilePic, let url = URL(string: friendProfilePic), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.userName.text = friendName
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
        let messagesViewModel = MessagesViewModel(userId: friendId ?? "")
        messagesViewModel.bindMessagesViewModelToController = {
            self.messages = messagesViewModel.messagesData
            self.refreshList()
        }
    }
    
    func refreshList(){
        DispatchQueue.main.async {
            self.tvMessages.reloadData()
            let indexpath = IndexPath(row: self.messages.count-1, section: 0)
            self.tvMessages.scrollToRow(at: indexpath, at: .bottom, animated: false)
            self.view.hideProgress(spinner: self.spinner)
        }
    }
    
    func sendTextChat(){
        if let message = tfChat.text, !message.isEmpty {
            self.view.showProgress(spinner: spinner)
            let image = UIImage(named: "icon_back")
            if let data = image?.pngData() {
                let chatViewModel = ChatViewModel(userId: friendId ?? "", message: message, type: .text, file: data, fileName: "")
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
            largerImageView.sd_setImage(with: url as URL , placeholderImage: nil)
            largerScrollView.zoomScale = 1.0
        }
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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
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
        view.endEditing(true)
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


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = messages[indexPath.item]
        if messageData.to == friendId {
            if messageData.type == "media" || messageData.type == "document" {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendImageCell", for: indexPath) as! ChatCell
                let image = messageData.attachments
                if image.count > 0 , let url = URL(string: image[0]) {
                    cell.chatImage.sd_setImage(with: url as URL , placeholderImage: nil)
                }else{
                    cell.chatImage.image = UIImage(named: AssetsName.icon_default_chat_image)
                }
                cell.chatImage.setCorner(value: 20.0)
                return cell
            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! ChatCell
                let message = messageData.message
                cell.chatMessage.text = "  \(message ?? "")  "
                cell.chatMessage.setRoundedCorner()
                return cell
            }
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnCell", for: indexPath) as! ChatCell
            let message = messageData.message
            cell.chatMessage.text = "  \(message ?? "")  "
            cell.chatMessage.setRoundedCorner()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageData = messages[indexPath.item]
        let images = messageData.attachments
        if (messageData.type == "media" || messageData.type == "document") && images.count > 0 {
                self.showLargeImage(imageUrlString: images[0])
        }
    }
}

extension ChatVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.view.showProgress(spinner: self.spinner)
        let image = info[.originalImage] as! UIImage
        let imageUrl = info[.imageURL] as! NSURL
        let fileName = imageUrl.absoluteString
        if let imageData = image.pngData() {
            let chatVM = ChatViewModel(userId: friendId ?? "", message: "", type: .media, file: imageData, fileName: fileName ?? "file.png")
            chatVM.isChatSent = {
                self.loadChatList()
                }
            }
        dismiss(animated:true, completion: nil)
    }
}
