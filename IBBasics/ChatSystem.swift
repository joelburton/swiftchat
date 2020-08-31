import Foundation
import Starscream

let chatWsUrl = "http://joelburton-reactchat.herokuapp.com/chat"

let decoder = JSONDecoder()
let encoder = JSONEncoder()


/** Chat message structure (are serialized to/from JSON for transport. */
struct ChatMessage: Codable {
    var type: String
    var name: String?
    var room: String?
    var text: String?

    func toJson() -> String {
        return  try! String(data: encoder.encode(self), encoding: .utf8)!
    }

    static func fromJson(_ json: String) -> ChatMessage {
        let data = json.data(using: .utf8)!
        return try! decoder.decode(ChatMessage.self, from: data);
    }
}

/** A component which will get socket messages delivered to them */
protocol SocketMessageReceiver {
    func receiveMessage(_: ChatMessage)
}

/** Web socket chat system with rooms. */
class ChatSystem: NSObject, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var room = ""
    var name = "joel"
    var receiver: SocketMessageReceiver?

    init(startRoom: String, receiver: SocketMessageReceiver) {
        super.init()
        self.receiver = receiver
        room = startRoom
        var request = URLRequest(url: URL(string: chatWsUrl)!)
        request.timeoutInterval = 50000
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    func joinRoom(_ roomName: String) {
        let msg = ChatMessage(type: "join", name: name, room: roomName)
        socket.write(string: msg.toJson())
        room = roomName
    }

    func leaveRoom() {
        let msg = ChatMessage(type: "leave")
        socket.write(string: msg.toJson())
    }

    func sendChat(text: String) {
        let msg = ChatMessage(type: "chat", text: text)
        socket.write(string: msg.toJson())
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            joinRoom(room)
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            receiver?.receiveMessage(ChatMessage.self.fromJson(string))
        case .binary(let data):
            print("Received data: \(data.count)")
        case .error(let error):
            isConnected = false
            handleError(error)
        default: ()
        }
    }

    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
