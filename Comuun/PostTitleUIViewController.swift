//
//  PostTitleUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/10.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PostTitleUIViewController内で使うもののうちclass内に定義できないもの



class PostTitleUIViewController: UIViewController, UITextFieldDelegate {
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
        let labelText = NSAttributedString(string:"件名を入力", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    let leftSubHeaderLabel:UILabel = {
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
    //サブヘッダーの画像を生成
    let eracePinkIcon:UIImageView = {
        let image = UIImage(named: "eracePink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-30, y: 35, width: 15, height: 15)
        return imageView
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnPostTypeButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostTitleUIViewController.returnPostType(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostType(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeErasePostTitleScreenButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostTitleUIViewController.erasePostTitleScreen(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func erasePostTitleScreen(_ sender:UIButton) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: false)
    }
    //イメージビュー（テキストフィールドの背景となる領域）を設定
    let postTitleRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（件名の上線）を設定
    let postTitleOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（件名の下線）を設定
    let postTitleUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //テキストフィールドを設定
    let postTitleTextField:UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 15, y: 80 ,width: screenWidth-30, height: 54)
        textField.backgroundColor = clear
        textField.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        textField.textColor = black
        if postAttached == nil {
            textField.text = "情報共有"
        } else if postAttached == Attached.tripleChoice {
            textField.text = "三者択一"
        } else if postAttached == Attached.questionnaire2 {
            textField.text = "アンケート"
        }
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //サブヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(eracePinkIcon)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnPostTypeButton = makeReturnPostTypeButton()
        self.view.addSubview(returnPostTypeButton)
        let erasePostTitleScreenButton = makeErasePostTitleScreenButton()
        self.view.addSubview(erasePostTitleScreenButton)
        //件名の領域、上線、下線を表示
        self.view.addSubview(postTitleRect)
        postTitleRect.addSubview(postTitleOverline)
        postTitleRect.addSubview(postTitleUnderline)
        //テキストフィールドを表示
        self.view.addSubview(postTitleTextField)
        postTitleTextField.delegate = self
    }
    //完了ボタンを押した時に呼び出される関数
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTitle = postTitleTextField.text
        postTitleNameForServer = postTitleTextField.text
        if postAttached == nil {
            let nextVC = InfoShareTextUIViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if postAttached == Attached.tripleChoice {
            postDeadline = nil
            let nextVC = TripleChoiceTextUIViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if postAttached == Attached.questionnaire2 {
            postDeadline = nil
            let nextVC = QuestionnaireTextUIViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
