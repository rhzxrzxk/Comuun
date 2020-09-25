//
//  QuestionnaireTextUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/10.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//QuestionnaireTextUIViewController内で使うもののうちclass内に定義できないもの
//キーボードの高さを保存するための変数
var firstTimeQuestionnaireKeyboardHeight:CGFloat = 0
//オフセットのための値を記憶していくための変数
var questionnaireFirstOffset :CGFloat = 0
var questionnaireSecondOffset :CGFloat = 0
//以下の関数で作成、設定されるボタンは、有効/無効が切り替わったりするので、class外に記入しておく
//サブヘッダーの透明なボタンのうち、「投稿ボタン」を作成するメソッド
func makeQuestionnaireButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
    button.addTarget(QuestionnaireTextUIViewController(), action: #selector(QuestionnaireTextUIViewController.postQuestionnaire(_:)), for: UIControlEvents.touchUpInside)
    return button
}
let postQuestionnaireButton = makeQuestionnaireButton()



class QuestionnaireTextUIViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostTitle(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func postQuestionnaire(_ sender:UIButton) {
        //投稿文の前後の空白、改行を削除する
        posting1["content"] = questionnaireTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: false)
    }
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnPostTitleButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(TripleChoiceTextUIViewController.returnPostTitle(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //スクロールビューを設定
    var questionnaireScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-65)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        return scrollView
    }()
    //イメージビュー（コンテンツの影を表示するための領域）
    let questionnaireCardShadowRect:UIImageView = {
        let regionOfQuestionnaireCardShadow = makeClearRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:regionOfQuestionnaireCardShadow)
        imageView.frame.origin = CGPoint(x:15, y:15)
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOpacity = 0.16
        return imageView
    }()
    //イメージビュー（コンテンツを表示するための領域）
    let questionnaireCardRect:UIImageView = {
        let regionOfQuestionnaireCard = makeWhiteRect(width: screenWidth-30, height: 100)
        let imageView = UIImageView(image:regionOfQuestionnaireCard)
        imageView.frame.origin = CGPoint(x:0, y:0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //イメージビュー（選択肢/期限を設定の上線）を設定
    let setQuestionnaireDeadlineOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth - 30, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（選択肢/期限を設定の下線）を設定
    let setQuestionnaireDeadlineUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:162, x1:screenWidth - 30, y1:162)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //"選択肢を設定"のラベル
    let setQuestionnaireChoicesLabel:UILabel = {let label = UILabel()
        label.frame = CGRect(x: screenWidth-220, y: 75, width: 150, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"回答を設定してください", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //"選択肢を変更"のラベル
    let changeQuestionnaireChoicesLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-220, y: 75, width: 150, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:mainColor,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"回答を変更", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //「選択肢」の方のアイコン画像を設定
    let firstNextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-57.08, y: 75, width: 7.08, height: 12)
        return imageView
    }()
    //「選択肢を設定」の透明なボタンを作成するメソッド
    func makeSetQuestionnaireChoicesButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 69, width: screenWidth-30, height: 54)
        button.addTarget(QuestionnaireTextUIViewController(), action: #selector(QuestionnaireTextUIViewController.setQuestionnaireChoices(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //「選択肢を設定」ボタンで実行される、カメラロールを開く関数
    @objc func setQuestionnaireChoices(_ sender:UIButton) {
        print("表示するnumOfChoices：\(numOfChoices)")
        let nextVC = QuestionnaireChoicesUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //"期限を設定"のラベル
    let setQuestionnaireDeadlineLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-200, y: 129, width: 130, height: 12)
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
    //"期限を変更"のラベル
    let changeQuestionnaireDeadlineLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-200, y: 129, width: 130, height: 12)
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
    let secondNextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-57.08, y: 129, width: 7.08, height: 12)
        return imageView
    }()
    //「期限を設定」の透明なボタンを作成するメソッド
    func makeSetQuestionnaireDeadlineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 123, width: screenWidth-30, height: 54)
        button.addTarget(QuestionnaireTextUIViewController(), action: #selector(QuestionnaireTextUIViewController.setQuestionnaireDeadline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //「期限を設定」ボタンで実行される関数
    @objc func setQuestionnaireDeadline(_ sender:UIButton) {
        //現状ではこの処理がないとエラーになる。ただこのままでは毎回nilにされるので、最終的には正しくない。
        posting1["remind"] = nil
        let nextVC = PostDeadlineUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //団体名
    let questionnaireOrgName:UILabel = {
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
    let questionnairePersonalName:UILabel = {
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
    let questionnaireTitle:UILabel = {
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
    let questionnaireTextView:UITextView = {
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
    let questionnairePlaceholder:UILabel = {
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
                                               selector: #selector(QuestionnaireTextUIViewController.keyboardWillShow(_:)),
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
        self.view.addSubview(postQuestionnaireButton)
        postTripleChoiceButton.isEnabled = false
        //スクロールビューを配置
        self.view.addSubview(questionnaireScrollView)
        //カードと影を配置
        questionnaireScrollView.addSubview(questionnaireCardShadowRect)
        questionnaireCardShadowRect.addSubview(questionnaireCardRect)
        //"選択肢を設定"、"期限を設定"関係の部品を配置
        questionnaireCardRect.addSubview(setQuestionnaireDeadlineOverline)
        questionnaireCardRect.addSubview(setQuestionnaireDeadlineUnderline)
        //"選択肢を設定"関係
//        questionnaireCardRect.addSubview(setQuestionnaireChoicesLabel)
//        questionnaireCardRect.addSubview(changeQuestionnaireChoicesLabel)
//        changeQuestionnaireChoicesLabel.isHidden = true
        questionnaireCardRect.addSubview(firstNextGrayIcon)
        let setQuestionnaireChoicesButton = makeSetQuestionnaireChoicesButton()
        questionnaireScrollView.addSubview(setQuestionnaireChoicesButton)
        //"期限を設定"関係
//        questionnaireCardRect.addSubview(setQuestionnaireDeadlineLabel)
//        questionnaireCardRect.addSubview(changeQuestionnaireDeadlineLabel)
//        changeQuestionnaireDeadlineLabel.isHidden = true
        questionnaireCardRect.addSubview(secondNextGrayIcon)
        let setQuestionnaireDeadlineButton = makeSetQuestionnaireDeadlineButton()
        questionnaireScrollView.addSubview(setQuestionnaireDeadlineButton)
        //要素のラベルを配置
        questionnaireCardRect.addSubview(questionnaireOrgName)
        questionnaireCardRect.addSubview(questionnairePersonalName)
        questionnaireCardRect.addSubview(questionnaireTitle)
        //テキストビューを配置
        questionnaireScrollView.addSubview(questionnaireTextView)
        questionnaireTextView.delegate = self
        //プレースホルダーの代わりのラベルを配置
        questionnaireScrollView.addSubview(questionnairePlaceholder)
        //暫定の情報共有のカードの影のframeを指定
        questionnaireCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定の情報共有のカードのframeを指定
        questionnaireCardRect.frame.size = CGSize(width:screenWidth-30, height:screenHeight-170)
        //暫定のスクロールビューのサイズを指定
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-65)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //選択肢の個数、本文の有無によって、投稿ボタンの表示・非表示を切り替える
        if questionnaireTextView.text.isEmpty || postChoices.count < 2 {
            rightSubHeaderLabel.textColor = gray
            postQuestionnaireButton.isEnabled = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            postQuestionnaireButton.isEnabled = true
        }
        
        
        
        
        questionnaireCardRect.addSubview(setQuestionnaireDeadlineLabel)
        questionnaireCardRect.addSubview(changeQuestionnaireDeadlineLabel)
        
        if postDeadline == nil {
            changeQuestionnaireDeadlineLabel.isHidden = true
            setQuestionnaireDeadlineLabel.isHidden = false
        } else {
            changeQuestionnaireDeadlineLabel.isHidden = false
            setQuestionnaireDeadlineLabel.isHidden = true
        }
        
        questionnaireCardRect.addSubview(setQuestionnaireChoicesLabel)
        questionnaireCardRect.addSubview(changeQuestionnaireChoicesLabel)
        if postChoices.count >= 1 {
            changeQuestionnaireChoicesLabel.isHidden = false
            setQuestionnaireChoicesLabel.isHidden = true
        } else {
            changeQuestionnaireChoicesLabel.isHidden = true
            setQuestionnaireChoicesLabel.isHidden = false
        }
    }
    //キーボードが出現するときに実行される関数。キーボード変更時にも呼び出されることに要注意。つまり初期keyboardが日本語の場合、英語→日本語→keyboard出現で二回呼ばれる。そのあとは、Appearするたびにまず一度、出現したらもう一度呼ばれる。
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //キーボードの高さが他の場所でも使えるように、変数に入れておく
        if firstTimeQuestionnaireKeyboardHeight == 0 {
            firstTimeQuestionnaireKeyboardHeight = keyboardFrame.size.height
        }
        //スクロールビューの高さを調整
        let questionnaireScrollViewHeight = screenHeight-30 + firstTimeQuestionnaireKeyboardHeight
        //調整した高さを元にスクロールビューのサイズを指定
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: questionnaireScrollViewHeight)
        //キャレットの位置を基準に考えて、キーボードと重なる場合に避ける
        let textRange: UITextRange = questionnaireTextView.selectedTextRange!
        let caretPosition: CGRect = questionnaireTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = questionnaireTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = questionnaireScrollView.contentOffset.y + screenHeight - firstTimeQuestionnaireKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            questionnaireFirstOffset = distance
            questionnaireScrollView.contentOffset.y = questionnaireFirstOffset
        }
    }
    //テキストビューの内容が変更された時に実行される関数
    func textViewDidChange(_ textView: UITextView) {//空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
        if textView.text.isEmpty {
            questionnairePlaceholder.isHidden = false
        } else {
            questionnairePlaceholder.isHidden = true
        }
        if textView.text.isEmpty || postChoices.count < 2 {
            rightSubHeaderLabel.textColor = gray
            postQuestionnaireButton.isEnabled = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            postQuestionnaireButton.isEnabled = true
        }
        //カード、スクロールビューの高さを文量に合わせて変える
        //テキストビューの高さを文章が収まるくらいに調整する
        let textViewSize = textView.sizeThatFits(CGSize(width:screenWidth-50, height:0))
        //まずテキストの量によって、テキストビューの高さを変更する
        questionnaireTextView.frame = CGRect(x: 25, y: 209 ,width: screenWidth-50, height: textViewSize.height)
        //テキストビューが一定の高さを超えたとき、情報共有のカードの高さと、スクロールビューの高さを調整
        if questionnaireTextView.frame.height > screenHeight - 384 {
            //カード、その影の高さを調整
            let questionnaireCardHeight = screenHeight-170 + questionnaireTextView.frame.height - (screenHeight - 384)
            //スクロールビューのベースの高さを調整
            let questionnaireScrollViewHeight = screenHeight-30 + questionnaireTextView.frame.height - (screenHeight - 384) + firstTimeQuestionnaireKeyboardHeight
            //調整後の情報共有のカードの影のframeを指定
            questionnaireCardShadowRect.frame.size = CGSize(width:screenWidth-30, height:questionnaireCardHeight)
            //調整後の情報共有のカードのframeを指定
            questionnaireCardRect.frame.size = CGSize(width:screenWidth-30, height:questionnaireCardHeight)
            //調整した高さを元にスクロールビューのサイズを指定
            questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: questionnaireScrollViewHeight)
        }
        //キャレットの位置と、キーボードの上部分を比較して差を埋める
        let textRange: UITextRange = questionnaireTextView.selectedTextRange!
        let caretPosition: CGRect = questionnaireTextView.caretRect(for: textRange.start)
        let depthToCaretBottom = questionnaireTextView.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = questionnaireScrollView.contentOffset.y + screenHeight - firstTimeQuestionnaireKeyboardHeight - 65
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            questionnaireSecondOffset += distance
            questionnaireScrollView.contentOffset.y = questionnaireFirstOffset + questionnaireSecondOffset
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
