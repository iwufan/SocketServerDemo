//
//  ViewController.swift
//  SocketDemo
//
//  Created by David Jia on 13/9/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController {

    var portField: UITextField!         // 端口号
    var messageField: UITextField!      // 消息输入框
    var logView: UITextView!            // 日志
    var serverSocket: GCDAsyncSocket!   // 服务器socket
    var clientSocket: GCDAsyncSocket!   // 客户端socket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
}

extension ViewController {

    func addViews() {
        
        // 端口
        let portLabel = UILabel(title: "端口", fontSize: 15, color: MW_BLACK_COLOR)
        portLabel.frame = CGRect(x: 50, y: 80, width: 30, height: 15)
        // 端口
        portField = UITextField(placeholder: "请输入端口号", placeholderColor: UIColor.lightGray, placeholderFontSize: 13, textColor: MW_BLACK_COLOR, textFontSize: 13)
        
        portField.frame = CGRect(x: 90, y: 80, width: 150, height: 20)
        portField.keyboardType = .numberPad
        portField.layer.borderWidth = 1
        portField.layer.borderColor = UIColor.lightGray.cgColor
        portField.layer.cornerRadius = 4
        // 开始监听
        let startListen = UIButton(title: "开始监听", fontSize: 14, titleColor: UIColor.blue)
        startListen.setTitle("停止监听", for: .selected)
        
        startListen.addTarget(self, action: #selector(clickListen(button:)), for: .touchUpInside)
        
        startListen.frame = CGRect(x: 300, y: 80, width: 90, height: 20)
        startListen.layer.borderWidth = 1
        startListen.layer.borderColor = UIColor.blue.cgColor
        startListen.layer.cornerRadius = 4
        // 端口
        messageField = UITextField(placeholder: "请输入消息内容", placeholderColor: UIColor.lightGray, placeholderFontSize: 13, textColor: MW_BLACK_COLOR, textFontSize: 13)
        
        messageField.frame = CGRect(x: 90, y: 180, width: 150, height: 20)
        messageField.layer.borderWidth = 1
        messageField.layer.borderColor = UIColor.lightGray.cgColor
        messageField.layer.cornerRadius = 4
        // 发送消息
        let sendMsgBtn = UIButton(title: "发送消息", fontSize: 14, titleColor: UIColor.blue)
        
        sendMsgBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        sendMsgBtn.frame = CGRect(x: 300, y: 180, width: 90, height: 20)
        sendMsgBtn.layer.borderWidth = 1
        sendMsgBtn.layer.borderColor = UIColor.blue.cgColor
        sendMsgBtn.layer.cornerRadius = 4
        // 显示日志
        logView = UITextView(textColor: UIColor.gray, textFontSize: 15)
        logView.backgroundColor = UIColor.yellow
        
        logView.frame = CGRect(x: 50, y: 280, width: MW_SCREEN_WIDTH() - 100, height: 300)
        
        view.addSubview(portLabel)
        view.addSubview(portField)
        view.addSubview(startListen)
        view.addSubview(messageField)
        view.addSubview(sendMsgBtn)
        view.addSubview(logView)
    }
}

extension ViewController {
    // 发消息
    @objc func sendMessage() {
        
        view.endEditing(true)
        
        let data = messageField.text?.data(using: .utf8)
        
        clientSocket.write(data!, withTimeout: -1, tag: 0)
    }
    // 点击监听
    @objc func clickListen(button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        button.isSelected ? startReceive() : stopListen()
    }
    
    // 停止监听
    func stopListen() {
        
        serverSocket.disconnect()
        showMessage("停止监听")
    }
    // 开始监听
    func startReceive() {
    
        view.endEditing(true)
        
        let ports = portField.text ?? ""
        guard let port = UInt16(ports) else {
            
            showMessage("端口号有问题")
            return
        }
        
        do {
            try serverSocket.accept(onPort: port)
            showMessage("正在监听...")
        } catch {
            showMessage("启动失败")
        }
    }
    // 接受消息，socket是客户端的socket，表示从哪一个客户端读取消息
    func receiveMessage() {
        
        view.endEditing(true)
        
        clientSocket.readData(withTimeout: 11, tag: 0)
    }
    // 显示消息
    func showMessage(_ str: String) {
        
        logView.text = logView.text.appendingFormat("%@\n", str)
    }
}

extension ViewController: GCDAsyncSocketDelegate {
    // 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        showMessage("服务器端-已断开连接")
        clientSocket.disconnect()
    }
    // 连接成功
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        
        // 保存客户端的socket
        clientSocket = newSocket
        
        showMessage("连接成功")

        let address = "服务器地址：" + "\(newSocket.connectedHost ?? " ")" + " -端口：" + "\(newSocket.connectedPort)"

        showMessage(address)
        
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    // 接收到消息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let text = String(data: data, encoding: .utf8)

        showMessage(text!)
        
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
}
