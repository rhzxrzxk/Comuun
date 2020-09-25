//
//  PostTypeUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/09.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PostTypeUIViewController内で使うもののうちclass内に定義できないもの



class PostTypeUIViewController: UIViewController {
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
        let labelText = NSAttributedString(string:"タイプを選択", attributes:labelTextAttr)
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
    func makeReturnPostOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostTypeUIViewController.returnPostOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostOrg(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeErasePostTypeScreenButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostTypeUIViewController.erasePostTypeScreen(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func erasePostTypeScreen(_ sender:UIButton) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: false)
    }
    //イメージビュー（情報共有を表示するための領域）を設定
    let infoShareRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（情報共有の上線）を設定
    let infoShareOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（情報共有の下線）を設定
    let infoShareUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //情報共有の題名を設定
    let infoShareLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"情報共有", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let infoShareCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 101)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //情報共有の透明なボタンを作成するメソッド
    func makeInfoShareButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 80, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostTypeUIViewController.infoShare(_:)), for: UIControlEvents.touchUpInside)
        button.tag = 1
        return button
    }
    //情報共有を選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func infoShare(_ sender:UIButton) {
//        posting1["attached"] = nil
        postAttached = nil
        postAttachedForServer = nil
        tripleChoiceCheckmark.removeFromSuperview()
        questionnaireCheckmark.removeFromSuperview()
        self.view.addSubview(infoShareCheckmark)
        let nextVC = PostTitleUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（三者択一を表示するための領域）を設定
    let tripleChoiceRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 134)
        return imageView
    }()
    //イメージビュー（三者択一の下線）を設定
    let tripleChoiceUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //三者択一の題名を設定
    let tripleChoiceLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"三者択一", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let tripleChoiceCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 155)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //三者択一の透明なボタンを作成するメソッド
    func makeTripleChoiceButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 134, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostTypeUIViewController.tripleChoice(_:)), for: UIControlEvents.touchUpInside)
        button.tag = 2
        return button
    }
    //三者択一を選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func tripleChoice(_ sender:UIButton) {
//        posting1["attached"] = Attached.tripleChoice
        postAttached = Attached.tripleChoice
        postAttachedForServer = Attached.tripleChoice
        infoShareCheckmark.removeFromSuperview()
        questionnaireCheckmark.removeFromSuperview()
        self.view.addSubview(tripleChoiceCheckmark)
        let nextVC = PostTitleUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（アンケートを表示するための領域）を設定
    let questionnaireRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 188)
        return imageView
    }()
    //イメージビュー（アンケートの下線）を設定
    let questionnaireUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //アンケートの題名を設定
    let questionnaireLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"アンケート", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let questionnaireCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 209)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //アンケートの透明なボタンを作成するメソッド
    func makeQuestionnaireButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 188, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostTypeUIViewController.questionnaire(_:)), for: UIControlEvents.touchUpInside)
        button.tag = 3
        return button
    }
   //アンケートを選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func questionnaire(_ sender:UIButton) {
//        posting1["attached"] = Attached.questionnaire2
        postAttached = Attached.questionnaire2
        postAttachedForServer = Attached.questionnaire2
        infoShareCheckmark.removeFromSuperview()
        tripleChoiceCheckmark.removeFromSuperview()
        self.view.addSubview(questionnaireCheckmark)
        let nextVC = PostTitleUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
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
        let returnPostOrgButton = makeReturnPostOrgButton()
        self.view.addSubview(returnPostOrgButton)
        let erasePostTypeScreenButton = makeErasePostTypeScreenButton()
        self.view.addSubview(erasePostTypeScreenButton)
        //情報共有の領域、上線、下線、画像、題名、ボタンを表示
        self.view.addSubview(infoShareRect)
        infoShareRect.addSubview(infoShareOverline)
        infoShareRect.addSubview(infoShareUnderline)
        infoShareRect.addSubview(infoShareLabel)
        let infoShareButton = makeInfoShareButton()
        self.view.addSubview(infoShareButton)
        //三者択一の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(tripleChoiceRect)
        tripleChoiceRect.addSubview(tripleChoiceUnderline)
        tripleChoiceRect.addSubview(tripleChoiceLabel)
        let tripleChoiceButton = makeTripleChoiceButton()
        self.view.addSubview(tripleChoiceButton)
        //アンケートの領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(questionnaireRect)
        questionnaireRect.addSubview(questionnaireUnderline)
        questionnaireRect.addSubview(questionnaireLabel)
        let questionnaireButton = makeQuestionnaireButton()
        self.view.addSubview(questionnaireButton)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
