//
//  LoginUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/29.
//  Copyright © 2018年 田中尊. All rights reserved.
//



import UIKit
import LineSDK
import FBSDKCoreKit
import FBSDKLoginKit



//LoginUIViewController内で使うもののうちclass内に定義できないもの
//ID系
var profileId: String! = String()
var profileIdForServer: String! = String()
//name系
var profileName: String! = String()
var profileNameForServer: String! = String()
//image系
var basicProfileImageView: UIImageView! = UIImageView()
var expandedProfileImageView: UIImageView! = UIImageView()
var acountProfileImageView: UIImageView! = UIImageView()
var profileImageViewForServer: UIImageView! = UIImageView()
//ディレクトリのURL
var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
var documentDirectoryFileURL2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
var documentDirectoryFileURL3 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]



class LoginUIViewController: UIViewController {
    //LINEのボタンを作成するメソッド
    func makeLineLoginButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth/2-123.6, y: screenHeight-165, width: 247.2, height: 40)
        let image = UIImage(named: "lineLogin")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(LoginUIViewController.lineLogin(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //LINEのボタンで実行するメソッド
    @objc func lineLogin(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
    }
    //Facebookのボタンを作成するメソッド
    func makeFbLoginButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth/2-123.6, y: screenHeight-90, width: 247.2, height: 40)
        let image = UIImage(named: "fbLogin")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(LoginUIViewController.fbLogin), for: UIControlEvents.touchUpInside)
        return button
    }
    //Facebookのボタンで実行するメソッド
    @objc func fbLogin() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            //エラーが無いかチェックして、処理を始める
            if error == nil {
                if result!.isCancelled {
                    //キャンセルされた場合の処理
                }else{
                    //ログインできる場合の処理
                    self.returnUserData()
                    //画面遷移
                    let nextVC = SettingUIViewController()
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    self.navigationController!.view.window?.layer.add(transition, forKey: nil)
                    self.navigationController?.pushViewController(nextVC, animated: false)
                }
            }else{
                //エラーした場合の処理
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        //lineLoginボタンを作成、配置
        let lineLoginButton = makeLineLoginButton()
        self.view.addSubview(lineLoginButton)
        //デリゲートを設定
        LineSDKLogin.sharedInstance().delegate = self
        //fbLoginボタンを作成、配置
        let fbLoginButton = makeFbLoginButton()
        self.view.addSubview(fbLoginButton)
        //Facebookログイン済みかチェック
        if let _ = FBSDKAccessToken.current() {
//            //既にFacebookログインが済んでいる場合の処理。
        }else{
            //まだFacebookログインしていない場合の処理
        }
    }
}



//MARK: - LineSDKLoginDelegate
//アクセストークンが有効もしくは更新可能な場合はログインが要求されることはない。
extension LoginUIViewController: LineSDKLoginDelegate {
    func didLogin(_ login: LineSDKLogin,
                  credential: LineSDKCredential?,
                  profile: LineSDKProfile?,
                  error: Error?) {
        if error != nil {
        //キャンセルあるいは設定ミスなどによりログインできなかった場合の処理
            return
        }
        //アクセストークンがある場合に処理を記入する
        if ((credential?.accessToken) != nil) {
            //LINEでの表示名がある場合、取得し、その表示名で実行したい処理を記入する
            if let name = profile?.displayName {
                profileName = name
                profileNameForServer = name
            }
            //LINEでの「プロフィール写真のURL」がある場合、取得し、その「プロフィール写真のURL」で実行したい処理を記入する
            //localの画像保存用の変数
            var localProfileImage: UIImage = UIImage()
            if let pictureURL = profile?.pictureURL {
                let lineProfileImage:UIImageView = {
                    let url: NSURL = NSURL(string: "\(pictureURL)")!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    localProfileImage = UIImage(data: data! as Data)!
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                basicProfileImageView = lineProfileImage
                let lineProfileImage2:UIImageView = {
                    let url: NSURL = NSURL(string: "\(pictureURL)")!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                expandedProfileImageView = lineProfileImage2
                let lineProfileImage3:UIImageView = {
                    let url: NSURL = NSURL(string: "\(pictureURL)")!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                acountProfileImageView = lineProfileImage3
                let lineProfileImage4:UIImageView = {
                    let url: NSURL = NSURL(string: "\(pictureURL)")!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                profileImageViewForServer = lineProfileImage4
            }
            //ここでサーバーにユーザー登録をする
            if ((profile?.userID) != nil) {
                profileIdForServer = "line" + (profile?.userID)!
                profileId = "line" + (profile?.userID)!
                if (serverUsers[profileIdForServer] == nil) {
                    let user:[String:Any?] = [
                        "id":profileIdForServer,
                        "name":profileNameForServer,
                        "imageView":profileImageViewForServer
                    ]
                    serverUsers[profileIdForServer] = user
                }
            }
            //local端末にデータを保存
            userDefault.set(profileId, forKey: "profileId")
            userDefault.set(profileName, forKey: "profileName")
            //画像をlocalに保存して行く
            func createLocalDataFile() {
                // 作成するテキストファイルの名前
                let fileName = "basicProfileImage"
                let fileName2 = "expandedProfileImage"
                let fileName3 = "acountProfileImage"
                // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
                let path = documentDirectoryFileURL.appendingPathComponent(fileName)
                let path2 = documentDirectoryFileURL.appendingPathComponent(fileName2)
                let path3 = documentDirectoryFileURL.appendingPathComponent(fileName3)
                documentDirectoryFileURL = path
                documentDirectoryFileURL2 = path2
                documentDirectoryFileURL3 = path3
            }
            createLocalDataFile()
            func saveImage() {
                //pngで保存する場合
                let pngImageData = UIImagePNGRepresentation(localProfileImage)
//                // jpgで保存する場合
//                let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
                do {
                    try pngImageData!.write(to: documentDirectoryFileURL)
                    try pngImageData!.write(to: documentDirectoryFileURL2)
                    try pngImageData!.write(to: documentDirectoryFileURL3)
                    //local端末にデータを保存
                    userDefault.set(documentDirectoryFileURL, forKey: "filePath")
                    userDefault.set(documentDirectoryFileURL2, forKey: "filePath2")
                    userDefault.set(documentDirectoryFileURL3, forKey: "filePath3")
                } catch {
                    //エラー処理
                }
            }
            saveImage()
            //初回起動時か判定する値をfalseに変更する
            userDefault.set(false, forKey: "beforeLoginLaunch")
            //画面遷移
            let nextVC = SettingUIViewController()
            let transition = CATransition()
            transition.type = kCATransitionFade
            self.navigationController!.view.window?.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
}



//MARK: - FBSDKLoginButtonDelegate
extension LoginUIViewController {
//    //ログアウトのコールバックをする関数
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//    }
    //ユーザー情報を取得するための処理
    func returnUserData() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "id, name, picture.type(large)"])
        graphRequest.start(completionHandler: {(connection, result, error) -> Void in
            if ((error) != nil) {
                //エラーの場合の処理を記入
            } else {
                //プロフィール情報をディクショナリに入れる
                let userProfile = result as! NSDictionary
                let fbProfileImage:UIImageView = {
                    //プロフィール画像の取得
                    let string: String = ((userProfile.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as! String
                    let url: NSURL = NSURL(string: string)!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                basicProfileImageView = fbProfileImage
                let fbProfileImage2:UIImageView = {
                    //プロフィール画像の取得
                    let string: String = ((userProfile.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as! String
                    let url: NSURL = NSURL(string: string)!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                expandedProfileImageView = fbProfileImage2
                let fbProfileImage3:UIImageView = {
                    //プロフィール画像の取得
                    let string: String = ((userProfile.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as! String
                    let url: NSURL = NSURL(string: string)!
                    let data = NSData(contentsOf: url as URL)
                    let image = UIImage(data: data! as Data)
                    let imageView = UIImageView(image: image)
                    return imageView
                }()
                acountProfileImageView = fbProfileImage3
                //名前を取得
                profileName = userProfile.object(forKey: "name") as? String
                profileNameForServer = userProfile.object(forKey: "name") as? String
                //ここでサーバーにユーザー登録をする
                if ((userProfile.object(forKey: "id")) != nil) {
                    profileIdForServer = "fb" + (userProfile.object(forKey: "id") as! String)
                    if (serverUsers[profileIdForServer] == nil) {
                        let user:[String:Any?] = [
                            "id":profileIdForServer,
                            "name":profileNameForServer,
                            "imageView":profileImageViewForServer
                        ]
                        serverUsers[profileIdForServer] = user
                    }
                }
                //local端末にデータを保存
                userDefault.set(profileName, forKey: "profileName")
                //初回起動時か判定する値をfalseに変更する
                userDefault.set(false, forKey: "beforeLoginLaunch")
            }
        })
        return
    }
}
