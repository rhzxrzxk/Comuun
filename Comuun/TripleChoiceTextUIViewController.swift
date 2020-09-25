//
//  TripleChoiceTextUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/10.
//  Copyright © 2018年 田中尊. All rights reserved.
//



import UIKit



//TripleChoiceTextUIViewController内で使うもののうちclass内に定義できないもの
//キーボードの高さを保存するための変数
var firstTimeTripleChoiceKeyboardHeight:CGFloat = 0
//オフセットのための値を記憶していくための変数
var tripleChoiceFirstOffset :CGFloat = 0
var tripleChoiceSecondOffset :CGFloat = 0
//以下の関数で作成、設定されるボタンは、有効/無効が切り替わったりするので、class外に記入しておく
//サブヘッダーの透明なボタンのうち、「投稿ボタン」を作成するメソッド
func makeTripleChoiceButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
    button.addTarget(TripleChoiceTextUIViewController(), action: #selector(TripleChoiceTextUIViewController.postTripleChoice(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//「投稿ボタン」を作成しておく
let postTripleChoiceButton = makeTripleChoiceButton()



class TripleChoiceTextUIViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnPostTitleButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(TripleChoiceTextUIViewController.returnPostTitle(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーの「戻る」ボタンで実行するメソッド
    @objc func returnPostTitle(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //サブヘッダーの「投稿」ボタンで実行するメソッド
    @objc func postTripleChoice(_ sender:UIButton) {
        //投稿文の前後の空白、改行を削除する
        postText = tripleChoiceTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        postTextNameForServer = tripleChoiceTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //ここでサーバーに投稿登録をする
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
//                "deadline":postDeadline,
//                "remind":postRemindForServer,
                //                "attached":postAttachedForServer,
                //                "imageURL":
            ]
            let post2:[String:Any?] = [
                "id":postIdForServer,
                "org":postOrgNameForServer,
                "contrib":profileName,
                "title":postTitleNameForServer,
                "text":postTextNameForServer,
//                "deadline":postDeadline,
//                "remind":postRemindForServer,
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
            print("--------------")
            print("\(post)")
            print("----------")
            print("\(post2)")
            print("--------------")
        }
        
        
        
        
        
        postDeadline = nil
        
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: false)
    }
    //スクロールビューを設定
    var tripleChoiceScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-65)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        return scrollView
    }()
    //イメージビュー（コンテンツの影を表示するための領域）
    let tripleChoiceCardShadowRect:UIImageView = {
        let image = makeClearRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x:15, y:15)
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOpacity = 0.16
        return imageView
    }()
    //イメージビュー（コンテンツを表示するための領域）
    let tripleChoiceCardRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x:0, y:0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //イメージビュー（期限を設定と三者択一のプレビューの上線）を設定
    let setTripleChoiceDeadlineOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth - 30, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（期限を設定の下線）を設定
    let setTripleChoiceDeadlineUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:162, x1:screenWidth - 30, y1:162)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //「まる」の画像を設定
    let maruBlueIcon:UIImageView = {
        let image = UIImage(named: "maruBlue")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 38, y: 70, width: 44, height: 44)
        return imageView
    }()
    //「ばつ」の画像を設定
    let batsuRedIcon:UIImageView = {
        let image = UIImage(named: "batsuRed")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: (screenWidth-30)/2-22, y: 70, width: 44, height: 44)
        return imageView
    }()
    //「さんかく」の画像を設定
    let sankakuGreenIcon:UIImageView = {
        let image = UIImage(named: "sankakuGreen")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-112, y: 70, width: 44, height: 44)
        return imageView
    }()
    //"期限を設定"のラベル
    let setTripleChoiceDeadlineLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-200, y: 136, width: 130, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"期限を設定してください", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //"画像を変更"のラベル
    let changeTripleChoiceDeadlineLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-200, y: 136, width: 130, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:mainColor,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"期限を変更", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //画像選択の画像を設定
    let nextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-57.08, y: 136, width: 7.08, height: 12)
        return imageView
    }()
    //「期限を設定」の透明なボタンを作成するメソッド
    func makeSetTripleChoiceDeadlineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 137, width: screenWidth-30, height: 40)
        button.addTarget(TripleChoiceTextUIViewController(), action: #selector(TripleChoiceTextUIViewController.setTripleChoiceDeadline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //ボタンで実行される、回答期限を設定する関数
    @objc func setTripleChoiceDeadline(_ sender:UIButton) {
        
        
        
        
        
        
        
        
        //現状ではこの処理がないとエラーになる。ただこのままでは毎回nilにされるので、最終的には正しくない。
        posting1["remind"] = nil
        
        
        
        
        let nextVC = PostDeadlineUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //団体名
    let tripleChoiceOrgName:UILabel = {
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
    let tripleChoicePersonalName:UILabel = {
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
    let tripleChoiceTitle:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 172, width: screenWidth-50, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black
        ]
        let labelText = NSAttributedString(string:postTitle, attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //テキストビューを設定
    let tripleChoiceTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = clear
        textView.frame = CGRect(x: 25, y: 209 ,width: screenWidth-50, height: 34)
        textView.font = UIFont(name:"HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12)
        textView.textColor = black
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        return textView
    }()
    //プレースホルダーの代わりのラベルを設定
    let tripleChoicePlaceholder:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 220 ,width: screenWidth-50, height: 12)
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
                                               selector: #selector(TripleChoiceTextUIViewController.keyboardWillShow(_:)),
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
        self.view.addSubview(postTripleChoiceButton)
        postTripleChoiceButton.isEnabled = false
        //スクロールビューを配置
        self.view.addSubview(tripleChoiceScrollView)
        //カードと影を配置
        tripleChoiceScrollView.addSubview(tripleChoiceCardShadowRect)
        tripleChoiceCardShadowRect.addSubview(tripleChoiceCardRect)
        //"期限を設定"関係の部品を配置
        
        
        
        
        
        
        
        //deadlineの設定によって、表示を変更する
        
        
        tripleChoiceCardRect.addSubview(setTripleChoiceDeadlineOverline)
        tripleChoiceCardRect.addSubview(setTripleChoiceDeadlineUnderline)
        
        
        
        
        
        
        //「まる」「ばつ」「さんかく」のアイコン
        tripleChoiceCardRect.addSubview(maruBlueIcon)
        tripleChoiceCardRect.addSubview(batsuRedIcon)
        tripleChoiceCardRect.addSubview(sankakuGreenIcon)
        
        
        
        
        
        
        
        
        
        
        tripleChoiceCardRect.addSubview(nextGrayIcon)
        let setTripleChoiceDeadlineButton = makeSetTripleChoiceDeadlineButton()
        tripleChoiceScrollView.addSubview(setTripleChoiceDeadlineButton)
        //要素のラベルを配置
        tripleChoiceCardRect.addSubview(tripleChoiceOrgName)
        tripleChoiceCardRect.addSubview(tripleChoicePersonalName)
        tripleChoiceCardRect.addSubview(tripleChoiceTitle)
        //テキストビューを配置
        tripleChoiceScrollView.addSubview(tripleChoiceTextView)
        tripleChoiceTextView.delegate = self
        //プレースホルダーの代わりのラベルを配置
        tripleChoiceScrollView.addSubview(tripleChoicePlaceholder)
        //暫定の情報共有のカードの影のframeを指定
        tripleChoiceCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定の情報共有のカードのframeを指定
        tripleChoiceCardRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定のスクロールビューのサイズを指定
        tripleChoiceScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-65)
    }
    //キーボードが出現するときに実行される関数。キーボード変更時にも呼び出されることに要注意。つまり初期keyboardが日本語の場合、英語→日本語→keyboard出現で二回呼ばれる。そのあとは、Appearするたびにまず一度、出現したらもう一度呼ばれる。
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //キーボードの高さが他の場所でも使えるように、変数に入れておく
        if firstTimeTripleChoiceKeyboardHeight == 0 {
            firstTimeTripleChoiceKeyboardHeight = keyboardFrame.size.height
        }
        //スクロールビューの高さを調整
        let tripleChoiceScrollViewHeight = screenHeight-30 + firstTimeTripleChoiceKeyboardHeight
        //調整した高さを元にスクロールビューのサイズを指定
        tripleChoiceScrollView.contentSize = CGSize(width: screenWidth-30, height: tripleChoiceScrollViewHeight)
        //キャレットの位置を基準に考えて、キーボードと重なる場合に避ける
        let textRange: UITextRange = tripleChoiceTextView.selectedTextRange!
        let caretPosition: CGRect = tripleChoiceTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = tripleChoiceTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = tripleChoiceScrollView.contentOffset.y + screenHeight - firstTimeTripleChoiceKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            tripleChoiceFirstOffset = distance
            tripleChoiceScrollView.contentOffset.y = tripleChoiceFirstOffset
        }
    }
    //テキストビューの内容が変更された時に実行される関数
    func textViewDidChange(_ textView: UITextView) {
        //空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
        if textView.text.isEmpty {
            rightSubHeaderLabel.textColor = gray
            postTripleChoiceButton.isEnabled = false
            tripleChoicePlaceholder.isHidden = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            postTripleChoiceButton.isEnabled = true
            tripleChoicePlaceholder.isHidden = true
        }
        //カード、スクロールビューの高さを文量に合わせて変える
        //テキストビューの高さを文章が収まるくらいに調整する
        let textViewSize = textView.sizeThatFits(CGSize(width:screenWidth-50, height:0))
        //まずテキストの量によって、テキストビューの高さを変更する
        tripleChoiceTextView.frame = CGRect(x: 25, y: 209 ,width: screenWidth-50, height: textViewSize.height)
        //テキストビューが一定の高さを超えたとき、情報共有のカードの高さと、スクロールビューの高さを調整
        if tripleChoiceTextView.frame.height > screenHeight - 384 {
            //カード、その影の高さを調整
            let tripleChoiceCardHeight = screenHeight-170 + tripleChoiceTextView.frame.height - (screenHeight - 384)
            //キーボードの高さを調整
            let tripleChoiceScrollViewHeight = screenHeight-30 + tripleChoiceTextView.frame.height - (screenHeight - 384) + firstTimeTripleChoiceKeyboardHeight
            //調整後の情報共有のカードの影のframeを指定
            tripleChoiceCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:tripleChoiceCardHeight)
            //調整後の情報共有のカードのframeを指定
            tripleChoiceCardRect.frame.size = CGSize(width:screenWidth-30, height:tripleChoiceCardHeight)
            //調整した高さを元にスクロールビューのサイズを指定
            tripleChoiceScrollView.contentSize = CGSize(width: screenWidth-30, height: tripleChoiceScrollViewHeight)
        }
        //キャレットの位置と、キーボードの上部分を比較して差を埋める
        let textRange: UITextRange = tripleChoiceTextView.selectedTextRange!
        let caretPosition: CGRect = tripleChoiceTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = tripleChoiceTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = tripleChoiceScrollView.contentOffset.y + screenHeight - firstTimeTripleChoiceKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            tripleChoiceSecondOffset += distance
            tripleChoiceScrollView.contentOffset.y = tripleChoiceFirstOffset + tripleChoiceSecondOffset
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tripleChoiceCardRect.addSubview(setTripleChoiceDeadlineLabel)
        tripleChoiceCardRect.addSubview(changeTripleChoiceDeadlineLabel)
        if postDeadline == nil {
            changeTripleChoiceDeadlineLabel.isHidden = true
            setTripleChoiceDeadlineLabel.isHidden = false
        } else {
            changeTripleChoiceDeadlineLabel.isHidden = false
            setTripleChoiceDeadlineLabel.isHidden = true
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
