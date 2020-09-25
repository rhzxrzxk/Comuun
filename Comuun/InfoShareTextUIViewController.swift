//
//  InfoShareMainText.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/10.
//  Copyright © 2018年 田中尊. All rights reserved.
//



import UIKit



//InfoShareTextUIViewController内で使うもののうちclass内に定義できないもの
//キーボードの高さを保存するための変数
var firstTimeInfoShareKeyboardHeight:CGFloat = 0
//オフセットのための値を記憶していくための変数
var infoShareFirstOffset :CGFloat = 0
var infoShareSecondOffset :CGFloat = 0
//以下の関数で作成、設定されるボタンは、有効/無効が切り替わったりするので、class外に記入しておく
//サブヘッダーの透明なボタンのうち、「投稿ボタン」を作成するメソッド
func makePostInfoShareButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
    button.addTarget(InfoShareTextUIViewController(), action: #selector(InfoShareTextUIViewController.postInfoShare(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let postInfoShareButton = makePostInfoShareButton()
//「画像選択」の透明なボタンを作成するメソッド
func makeOpenCameraRollToAddImageButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: 15, y: 69, width: screenWidth-30, height: 54)
    button.addTarget(InfoShareTextUIViewController(), action: #selector(InfoShareTextUIViewController.openCameraRollToAddImage(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let openCameraRollToAddImageButton = makeOpenCameraRollToAddImageButton()
//「画像再選択」の透明なボタンを作成するメソッド
func makeOpenActionSheetToChangeOrRemoveImageButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: 15, y: 69, width: screenWidth-30, height: 54)
    button.addTarget(InfoShareTextUIViewController(), action: #selector(InfoShareTextUIViewController.openActionSheetToChangeOrRemoveImage(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let openActionSheetToChangeOrRemoveImageButton = makeOpenActionSheetToChangeOrRemoveImageButton()



class InfoShareTextUIViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //イメージビュー（サブヘッダーを表示するための領域）を設定
    let subHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfSubHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        return imageView
    }()
    //イメージビュー（サブヘッダーの下線）を設定
    let subHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfSubHeader)
        return imageView
    }()
    //サブヘッダーのラベルを生成(センター)
    let centerSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: screenWidth-100, height: 15)
        label.center = CGPoint(x: screenWidth/2, y: 42.5)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:black,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"本文を入力", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    var leftSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 35, width: 35, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor
        ]
        let labelText = NSAttributedString(string:"戻る", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-50, y: 35, width: 35, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"投稿", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの透明なボタンにうち、「戻る」ボタンを作成するメソッド
    func makeReturnPostTitleButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(InfoShareTextUIViewController.returnPostTitle(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostTitle(_ sender:UIButton) {self.navigationController?.popViewController(animated: true)
    }
    //「投稿」ボタンはテキストの有無で有効/無効を変更するためにclass外に記入済み
    //サブヘッダーのボタンで実行するメソッド
    @objc func postInfoShare(_ sender:UIButton) {
        //投稿文の前後の空白、改行を削除する
        postText = infoShareTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        postTextNameForServer = infoShareTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //ここでサーバーに投稿の登録をする
        //投稿のIDを作成する関数
        func generate(length: Int) -> String {
            let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var randomString: String = ""
            for _ in 0..<length {
                let randomValue = arc4random_uniform(UInt32(base.count))
                randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
            }
            return randomString
        }
        postId = generate(length: 32)
        postIdForServer = postId
        if (serverPosts[postId] == nil) {
            let post:[String:Any?] = [
                "id":postIdForServer,
                "org":postOrgNameForServer,
                "contrib":profileName,
                "title":postTitleNameForServer,
                "text":postTextNameForServer,
//                "attached":postAttachedForServer,
//                "imageURL":
            ]
            let post2:[String:Any?] = [
                "id":postIdForServer,
                "org":postOrgNameForServer,
                "contrib":profileName,
                "title":postTitleNameForServer,
                "text":postTextNameForServer,
//                "attached":postAttachedForServer,
//                "imageURL":
            ]
            serverPosts[postId] = post2
            if UserDefaults.standard.array(forKey: "posts") == nil {
                var posts: [[String:Any?]] = []
                posts.append(post)
                userDefault.set(posts, forKey: "posts")
            } else {
                var posts = UserDefaults.standard.array(forKey: "posts") as! [[String : Any?]]
                posts.append(post)
                userDefault.set(posts, forKey: "posts")
            }
        }
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: false)
    }
    //スクロールビューを設定
    var infoShareScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-65)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        return scrollView
    }()
    //イメージビュー（コンテンツの影を表示するための領域）
    let infoShareCardShadowRect:UIImageView = {
        let image = makeClearRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x:15, y:15)
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOpacity = 0.16
        return imageView
    }()
    //イメージビュー（コンテンツを表示するための領域）
    let infoShareCardRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x:0, y:0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //イメージビュー（画像追加の上線）を設定
    let addImageOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth - 30, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（画像追加の下線）を設定
    let addImageUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:108, x1:screenWidth - 30, y1:108)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //"画像を選択"のラベル
    let addImageLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 75, width: 100, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"写真を選択", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //"画像を変更"のラベル
    let changeImageLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 75, width: 100, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"写真を変更", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //画像選択の画像を設定
    let addGrayIcon:UIImageView = {
        let image = UIImage(named: "addGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-70, y: 71, width: 20, height: 20)
        return imageView
    }()
    //「画像選択」ボタンで実行される、カメラロールを開く関数
    @objc func openCameraRollToAddImage(_ sender:UIButton) {
        let album = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(album) {
            let album = UIImagePickerController()
            album.delegate = self
            album.sourceType = UIImagePickerControllerSourceType.photoLibrary
            album.allowsEditing = true
            self.present(album, animated: true, completion: nil)
        }
    }
    //「画像再選択」ボタンで実行される、アクションシートを作成する関数
    @objc func openActionSheetToChangeOrRemoveImage(_ sender:UIButton) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //選択肢1
        let action1 = UIAlertAction(title: "写真を選択", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            //先ずは既存の画像を削除
            attachedImage!.removeFromSuperview()
            //ここで再選択ボタンも一旦削除
            openActionSheetToChangeOrRemoveImageButton.removeFromSuperview()
            //カメラロールを開く
            let album = UIImagePickerControllerSourceType.photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(album) {
                let album = UIImagePickerController()
                album.delegate = self
                album.sourceType = UIImagePickerControllerSourceType.photoLibrary
                album.allowsEditing = true
                self.present(album, animated: true, completion: nil)
            }
        })
        //選択肢2
        let action2 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
            (action: UIAlertAction!) in
            //先ずは既存の画像を削除
            attachedImage!.removeFromSuperview()
            //ここで再選択ボタンも削除
            openActionSheetToChangeOrRemoveImageButton.removeFromSuperview()
            //選択ボタンを追加
            self.infoShareScrollView.addSubview(openCameraRollToAddImageButton)
            //消していた"画像を選択"関係の表示を表示し、"画像を変更"のラベルを消す
            self.addImageLabel.isHidden = false
            self.changeImageLabel.isHidden = true
            self.addGrayIcon.isHidden = false
        })
        //選択肢3
        let action3 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        // アクションを追加.
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        self.present(alertSheet, animated: true, completion: nil)
    }
    // 写真を選択した後に、自動的に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //選択ボタンを無効にする
        openCameraRollToAddImageButton.removeFromSuperview()
        //画像の上に再選択ボタンを重ねる
        infoShareScrollView.addSubview(openActionSheetToChangeOrRemoveImageButton)
        //"画像を選択"関係の表示を表示し、"画像を変更"のラベルを消す
        addImageLabel.isHidden = true
        self.changeImageLabel.isHidden = false
        addGrayIcon.isHidden = true
        //取得した画像を表示する
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        attachedImage = UIImageView(image: image)
        attachedImage?.frame = CGRect(x: screenWidth-90, y: 61, width: 40, height: 40)
        infoShareCardRect.addSubview(attachedImage!)
        
        
        
        
        
        //この辺に画像を取得する処理を記入
        
        
        
        
        
        // 写真を選択するためのビューを下ろす
        self.dismiss(animated: true)
    }
    //団体名
    let infoShareOrgName:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 56, y: 14, width: 150, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black
        ]
        let labelText = NSAttributedString(string:postOrgName, attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //投稿者名
    let infoSharePersonalName:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 56, y: 32, width: 160, height: 10)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"\(profileName as String)", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //題名
    let infoShareTitle:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 118, width: screenWidth-50, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black
        ]
        let labelText = NSAttributedString(string:postTitle, attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //テキストビューを設定
    let infoShareTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = clear
        textView.frame = CGRect(x: 25, y: 155 ,width: screenWidth-50, height: 34)
        textView.font = UIFont(name:"HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12)
        textView.textColor = black
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        return textView
    }()
    //プレースホルダーの代わりのラベルを設定
    let infoSharePlaceholder:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 166 ,width: screenWidth-50, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
        .font:UIFont(name:"HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12),
        .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"本文を入力", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //キーボード出現時のオブザーバーを設置
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InfoShareTextUIViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        //サブヘッダーの領域を表示
        self.view.addSubview(subHeaderRect)
        //サブヘッダーの下線を表示
        subHeaderRect.addSubview(subHeaderUnderline)
        //サブヘッダーのラベルを表示
        subHeaderRect.addSubview(centerSubHeaderLabel)
        //サブヘッダーのサイドラベルを表示
        subHeaderRect.addSubview(leftSubHeaderLabel)
        subHeaderRect.addSubview(rightSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnPostTitleButton = makeReturnPostTitleButton()
        self.view.addSubview(returnPostTitleButton)
        self.view.addSubview(postInfoShareButton)
        postInfoShareButton.isEnabled = false
        //スクロールビューを配置
        self.view.addSubview(infoShareScrollView)
        //カードと影を配置
        infoShareScrollView.addSubview(infoShareCardShadowRect)
        infoShareCardShadowRect.addSubview(infoShareCardRect)
        //"画像を選択"、"画像を再選択"関係の部品を配置、"画像を再選択"は非表示にする
        infoShareCardRect.addSubview(addImageOverline)
        infoShareCardRect.addSubview(addImageUnderline)
        infoShareCardRect.addSubview(addImageLabel)
        infoShareCardRect.addSubview(changeImageLabel)
        changeImageLabel.isHidden = true
        infoShareCardRect.addSubview(addGrayIcon)
        infoShareScrollView.addSubview(openCameraRollToAddImageButton)
        //要素のラベルを配置
        infoShareCardRect.addSubview(infoShareOrgName)
        infoShareCardRect.addSubview(infoSharePersonalName)
        infoShareCardRect.addSubview(infoShareTitle)
        //テキストビューを配置
        infoShareScrollView.addSubview(infoShareTextView)
        infoShareTextView.delegate = self
        //プレースホルダーの代わりのラベルを配置
        infoShareScrollView.addSubview(infoSharePlaceholder)
        //暫定の情報共有のカードの影のframeを指定
        infoShareCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定の情報共有のカードのframeを指定
        infoShareCardRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定のスクロールビューのサイズを指定
        infoShareScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-65)
    }
    //キーボードが出現するときに実行される関数。キーボード変更時にも呼び出されることに要注意。つまり初期keyboardが日本語の場合、英語→日本語→keyboard出現で二回呼ばれる。そのあとは、Appearするたびにまず一度、出現したらもう一度呼ばれる。
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //キーボードの高さが他の場所でも使えるように、変数に入れておく。キーボードの高さが場合によって変わってしまうので、今回は最初の高さを変数に入れることで、同じ値になるようにしている。
        if firstTimeInfoShareKeyboardHeight == 0 {
            firstTimeInfoShareKeyboardHeight = keyboardFrame.size.height
        }
        //スクロールビューの高さを調整
        let infoShareScrollViewHeight:CGFloat = screenHeight-30 + firstTimeInfoShareKeyboardHeight
        //調整した高さを元にスクロールビューのサイズを指定
        infoShareScrollView.contentSize = CGSize(width: screenWidth-30, height: infoShareScrollViewHeight)
        //キャレットの位置を基準に考えて、キーボードと重なる場合、重ならなくなるようにずらす
        let textRange: UITextRange = infoShareTextView.selectedTextRange!
        let caretPosition: CGRect = infoShareTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = infoShareTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = infoShareScrollView.contentOffset.y + screenHeight - firstTimeInfoShareKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            infoShareFirstOffset = distance
            infoShareScrollView.contentOffset.y = infoShareFirstOffset
        }
    }
    //テキストビューの内容が変更された時に実行される関数
    func textViewDidChange(_ textView: UITextView) {
        //空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
        if textView.text.isEmpty {
            rightSubHeaderLabel.textColor = gray
            postInfoShareButton.isEnabled = false
            infoSharePlaceholder.isHidden = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            postInfoShareButton.isEnabled = true
            infoSharePlaceholder.isHidden = true
        }
        //カード、スクロールビューの高さを文量に合わせて変える
        //テキストビューの高さを文章が収まるくらいに調整する
        let textViewSize = textView.sizeThatFits(CGSize(width:screenWidth-50, height:0))
        //まずテキストの量によって、テキストビューの高さを変更する
        infoShareTextView.frame = CGRect(x: 25, y: 155 ,width: screenWidth-50, height: textViewSize.height)
        //テキストビューが一定値を超えた場合に、情報共有のカードの高さと、スクロールビューの高さを調整
        if infoShareTextView.frame.height > screenHeight - 330 {
            //カード、その影の高さを調整
            let infoShareCardHeight = screenHeight-170 + infoShareTextView.frame.height - (screenHeight - 330)
            //スクロールビューの高さを調整
            let infoShareScrollViewHeight:CGFloat = screenHeight-30 + infoShareTextView.frame.height - (screenHeight - 330) + firstTimeInfoShareKeyboardHeight
            //調整後の情報共有のカードの影のframeを指定
            infoShareCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:infoShareCardHeight)
            //調整後の情報共有のカードのframeを指定
            infoShareCardRect.frame.size = CGSize(width:screenWidth-30, height:infoShareCardHeight)
            //調整した高さを元にスクロールビューのサイズを指定
            infoShareScrollView.contentSize = CGSize(width: screenWidth-30, height: infoShareScrollViewHeight)
        }
        //キャレットの位置と、キーボードの上部分を比較して差を埋める
        let textRange: UITextRange = infoShareTextView.selectedTextRange!
        let caretPosition: CGRect = infoShareTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = infoShareTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = infoShareScrollView.contentOffset.y + screenHeight - firstTimeInfoShareKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            infoShareSecondOffset += distance
            infoShareScrollView.contentOffset.y = infoShareFirstOffset + infoShareSecondOffset
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


