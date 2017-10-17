# SocketServerDemo
This is a Server-side socket demo built by CocoaAsyncSocket framework written in Swift4.
You can download and run it directly.

# Usage
![image](https://github.com/iwufan/Resources/blob/master/Images/Socket/Server-side.gif)

## 1. Input a port(it can be any number, client will use this port to connect server.)
## 2. Click "开始监听".

After the server is connected with a client successfully, it can send messages to the client and receive messages from the client.

# Error
I you occur the error "No such module 'CocoaAsyncSocket'" as below.

![image](https://github.com/iwufan/Resources/blob/master/Images/Socket/CocaAsyncSocket_error.png)

You should know the project can run normally even this error exists.

Here are the methods to solve this error.

First, you should check whether you have installed CocaAsyncSocket framework through cocoapods.
If you have CocaAsyncSocket framework in you project, the solution will be very simple, just delete the words 'import CocaAsyncSocket' and type them again. 
Build the project and the error will disappear.

# Other
It's just a basic version. I will add more functions in future.

Enjoy, thanks.
