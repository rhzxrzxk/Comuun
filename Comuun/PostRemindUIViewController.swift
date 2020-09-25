//
//  PostReminderUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/20.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PostRemindUIViewController内で使うもののうちclass内に定義できないもの



class PostRemindUIViewController: UIViewController {
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
        let labelText = NSAttributedString(string:"リマインドを設定", attributes:labelTextAttr)
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
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnPostDeadlineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostRemindUIViewController.returnPostDeadline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostDeadline(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（「なし」を表示するための領域）を設定
    let noneRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（「なし」の上線）を設定
    let noneRemindOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（「なし」の下線）を設定
    let noneRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //「なし」の題名を設定
    let noneRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"しない", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let noneRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 101)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //「なし」の透明なボタンを作成するメソッド
    func makeSetNoneRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 80, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setNoneRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //「なし」を選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func setNoneRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = nil
        postRemindForServer = nil
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(noneRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（10分前を表示するための領域）を設定
    let tenMinRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 164)
        return imageView
    }()
    //イメージビュー（10分前の上線）を設定
    let tenMinRemindOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（10分前の下線）を設定
    let tenMinRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //10分前の題名を設定
    let tenMinRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"10分前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let tenMinRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 185)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //10分前の透明なボタンを作成するメソッド
    func makeSetTenMinRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 164, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setTenMinRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //10分前を選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func setTenMinRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.tenMin
        postRemindForServer = Remind.tenMin
        noneRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(tenMinRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（20分前を表示するための領域）を設定
    let tweMinRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 218)
        return imageView
    }()
    //イメージビュー（20分前の下線）を設定
    let tweMinRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //20分前の題名を設定
    let tweMinRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"20分前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let tweMinRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 239)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //20分前の透明なボタンを作成するメソッド
    func makeSetTweMinRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 218, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setTweMinRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //20分前のメソッド
    @objc func setTweMinRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.tweMin
        postRemindForServer = Remind.tweMin
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(tweMinRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（1時間前を表示するための領域）を設定
    let oneHourRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 272)
        return imageView
    }()
    //イメージビュー（1時間前の下線）を設定
    let oneHourRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //1時間前の題名を設定
    let oneHourRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"1時間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let oneHourRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 293)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //1時間前の透明なボタンを作成するメソッド
    func makeSetOneHourRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 272, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setOneHourRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //1時間目のメソッド
    @objc func setOneHourRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.oneHour
        postRemindForServer = Remind.oneHour
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(oneHourRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（2時間前を表示するための領域）を設定
    let twoHourRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 326)
        return imageView
    }()
    //イメージビュー（2時間前の下線）を設定
    let twoHourRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //2時間前の題名を設定
    let twoHourRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"2時間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let twoHourRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 347)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //2時間前の透明なボタンを作成するメソッド
    func makeSetTwoHourRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 326, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setTwoHourRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //2時間前のメソッド
    @objc func setTwoHourRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.twoHour
        postRemindForServer = Remind.twoHour
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(twoHourRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（1日前を表示するための領域）を設定
    let oneDayRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 380)
        return imageView
    }()
    //イメージビュー（1日前の下線）を設定
    let oneDayRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //1日前の題名を設定
    let oneDayRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"1日前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let oneDayRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 401)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //1日前の透明なボタンを作成するメソッド
    func makeSetOneDayRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 380, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setOneDayRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //1日前のメソッド
    @objc func setOneDayRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.oneDay
        postRemindForServer = Remind.oneDay
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(oneDayRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（2日前を表示するための領域）を設定
    let twoDayRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 434)
        return imageView
    }()
    //イメージビュー（2日前の下線）を設定
    let twoDayRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //2日前の題名を設定
    let twoDayRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"2日前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let twoDayRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 455)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //2日前の透明なボタンを作成するメソッド
    func makeSetTwoDayRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 434, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setTwoDayRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //2日前の関数
    @objc func setTwoDayRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.twoDay
        postRemindForServer = Remind.twoDay
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        oneWeekRemindCheckmark.removeFromSuperview()
        self.view.addSubview(twoDayRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（1週間前を表示するための領域）を設定
    let oneWeekRemindRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 488)
        return imageView
    }()
    //イメージビュー（1週間前の下線）を設定
    let oneWeekRemindUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //1週間前の題名を設定
    let oneWeekRemindLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"1週間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //チェックマークは、表示はせずに設定だけしておく
    let oneWeekRemindCheckmark:UIImageView = {
        let image = UIImage(named: "checkRed")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 18, y: 509)
        imageView.frame.size = CGSize(width: 13.51, height: 12)
        return imageView
    }()
    //1週間前の透明なボタンを作成するメソッド
    func makeSetOneWeekRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 488, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostRemindUIViewController.setOneWeekRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //1週間前のメソッド
    @objc func setOneWeekRemind(_ sender:UIButton) {
        //リマインドについて、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postRemind = Remind.oneWeek
        postRemindForServer = Remind.oneWeek
        noneRemindCheckmark.removeFromSuperview()
        tenMinRemindCheckmark.removeFromSuperview()
        tweMinRemindCheckmark.removeFromSuperview()
        oneHourRemindCheckmark.removeFromSuperview()
        twoHourRemindCheckmark.removeFromSuperview()
        oneDayRemindCheckmark.removeFromSuperview()
        twoDayRemindCheckmark.removeFromSuperview()
        self.view.addSubview(oneWeekRemindCheckmark)
        self.navigationController?.popViewController(animated: true)
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
        //サブヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(leftSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnPostDeadlineButton = makeReturnPostDeadlineButton()
        self.view.addSubview(returnPostDeadlineButton)
        //「なし」の領域、上線、下線、画像、題名、ボタンを表示
        self.view.addSubview(noneRemindRect)
        noneRemindRect.addSubview(noneRemindOverline)
        noneRemindRect.addSubview(noneRemindUnderline)
        noneRemindRect.addSubview(noneRemindLabel)
        let noneButton = makeSetNoneRemindButton()
        self.view.addSubview(noneButton)
        //10分前の領域、上線、下線、画像、題名、ボタンを表示
        self.view.addSubview(tenMinRemindRect)
        tenMinRemindRect.addSubview(tenMinRemindOverline)
        tenMinRemindRect.addSubview(tenMinRemindUnderline)
        tenMinRemindRect.addSubview(tenMinRemindLabel)
        let tenMinButton = makeSetTenMinRemindButton()
        self.view.addSubview(tenMinButton)
        //20分前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(tweMinRemindRect)
        tweMinRemindRect.addSubview(tweMinRemindUnderline)
        tweMinRemindRect.addSubview(tweMinRemindLabel)
        let tweMinButton = makeSetTweMinRemindButton()
        self.view.addSubview(tweMinButton)
        //1時間前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(oneHourRemindRect)
        oneHourRemindRect.addSubview(oneHourRemindUnderline)
        oneHourRemindRect.addSubview(oneHourRemindLabel)
        let oneHourButton = makeSetOneHourRemindButton()
        self.view.addSubview(oneHourButton)
        //2時間前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(twoHourRemindRect)
        twoHourRemindRect.addSubview(twoHourRemindUnderline)
        twoHourRemindRect.addSubview(twoHourRemindLabel)
        let twoHourButton = makeSetTwoHourRemindButton()
        self.view.addSubview(twoHourButton)
        //1日前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(oneDayRemindRect)
        oneDayRemindRect.addSubview(oneDayRemindUnderline)
        oneDayRemindRect.addSubview(oneDayRemindLabel)
        let oneDayButton = makeSetOneDayRemindButton()
        self.view.addSubview(oneDayButton)
        //2日前前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(twoDayRemindRect)
        twoDayRemindRect.addSubview(twoDayRemindUnderline)
        twoDayRemindRect.addSubview(twoDayRemindLabel)
        let twoDayButton = makeSetTwoDayRemindButton()
        self.view.addSubview(twoDayButton)
        //1週間前の領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(oneWeekRemindRect)
        oneWeekRemindRect.addSubview(oneWeekRemindUnderline)
        oneWeekRemindRect.addSubview(oneWeekRemindLabel)
        let oneWeekButton = makeSetOneWeekRemindButton()
        self.view.addSubview(oneWeekButton)
        if postRemind == nil {
            self.view.addSubview(noneRemindCheckmark)
        } else if postRemind == Remind.tenMin {
            self.view.addSubview(tenMinRemindCheckmark)
        } else if postRemind == Remind.tweMin {
            self.view.addSubview(tweMinRemindCheckmark)
        } else if postRemind == Remind.oneHour {
            self.view.addSubview(oneHourRemindCheckmark)
        } else if postRemind == Remind.twoHour {
            self.view.addSubview(twoHourRemindCheckmark)
        } else if postRemind == Remind.oneDay {
            self.view.addSubview(oneDayRemindCheckmark)
        } else if postRemind == Remind.twoDay {
            self.view.addSubview(twoDayRemindCheckmark)
        } else if postRemind == Remind.oneWeek {
            self.view.addSubview(oneWeekRemindCheckmark)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
