//
//  StarscreamRTM.swift
//
// Copyright © 2017 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if os(macOS) || os(iOS) || os(tvOS)
import Foundation
#if !COCOAPODS
import SKCore
#endif
import Starscream

public class StarscreamRTM: RTMWebSocket, WebSocketDelegate {
    public weak var delegate: RTMDelegate?
    private var webSocket: WebSocket?

    public required init() {}

    // MARK: - RTM
    public func connect(url: URL) {
        self.webSocket = WebSocket(request: URLRequest(url: url))
        self.webSocket?.delegate = self
        self.webSocket?.connect()
    }

    public func disconnect() {
        webSocket?.disconnect()
    }

    public func sendMessage(_ message: String) throws {
        guard webSocket != nil else {
            throw SlackError.rtmConnectionError
        }
        webSocket?.write(string: message)
    }

    public func ping() {
        webSocket?.write(ping: Data())
    }

    // MARK: - WebSocketDelegate
    
    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected:
            delegate?.didConnect()
        case .disconnected:
            webSocket = nil
            delegate?.disconnected()
        case .text(let text):
            delegate?.receivedMessage(text)
        case .binary:
            break // unhandled
        case .pong:
            break // unhandled
        case .ping:
            break // unhandled
        case .error:
            break // unhandled
        case .viabilityChanged:
            break // unhandled
        case .reconnectSuggested:
            break // unhandled
        case .cancelled:
            break // unhandled
        case .peerClosed:
            break // unhandled
        }
    }
}

#endif
