import UIKit
import Starscream

/** View for the chat system. */
class ViewController: UIViewController, UITextFieldDelegate, SocketMessageReceiver {
    @IBOutlet var messageInput: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageArea: UITextView!
    @IBOutlet var roomMenu: UISegmentedControl!

    var chatSystem : ChatSystem? = nil;

    @IBAction func changeRoom(_ sender: UISegmentedControl) {
        chatSystem?.leaveRoom()
        let newRoom = sender.titleForSegment(at: sender.selectedSegmentIndex)
        chatSystem?.joinRoom(newRoom!)
    }

    func sendMessage() {
        chatSystem?.sendChat(text: messageInput.text!)
        messageInput.text = ""
    }

    @IBAction func submitMessageViaButton(_ sender: UIButton) {
        sendMessage()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // FIXME: pretty sure this isn't the right way
        sendMessage()
        return true
    }

    func receiveMessage(_ msg: ChatMessage) {
        // FIXME: perhaps there's a less yuck way?
        var newMsg = NSMutableAttributedString();
        if msg.type == "note" {
            newMsg = NSMutableAttributedString(string: "\n")
                .italic("\(msg.name!): \(msg.text!)")
        } else if msg.type == "chat" {
            newMsg = NSMutableAttributedString(string: "\n")
                .bold(msg.name!)
                .normal(": \(msg.text!)")
        }

        let curr = NSMutableAttributedString(attributedString: messageArea.attributedText)
        curr.append(newMsg)
        messageArea.attributedText = curr
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messageInput.delegate = self

        chatSystem = ChatSystem.init(
            startRoom: roomMenu.titleForSegment(at: 0)!,
            receiver: self)
    }
}
