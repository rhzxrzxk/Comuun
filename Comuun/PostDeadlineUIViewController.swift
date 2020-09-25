//
//  PostDeadlineUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/20.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PostDeadlineUIViewController内で使うもののうちclass内に定義できないもの



class PostDeadlineUIViewController: UIViewController, UIPickerViewDelegate {
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
        let labelText = NSAttributedString(string:"期限を設定", attributes:labelTextAttr)
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
    func makeReturnPostTextButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostDeadlineUIViewController.returnPostText(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostText(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（回答期限を表示するための領域）を設定
    let postDeadlineHeaderRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（回答期限の上線）を設定
    let postDeadlineHeaderOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（回答期限の下線）を設定
    let postDeadlineHeaderUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //回答期限の題名を設定
    let leftPostDeadlineHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"回答期限", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //回答期限のドラムロールで電卓した日時を入れるためのラベル
    var rightPostDeadlineHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-175, y: 21, width: 160, height: 12)
        label.text = postDeadline
        label.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        label.textColor = red
        label.textAlignment = .right
        return label
    }()
    //回答期限のドラムロールを設定
    let postDeadlineDatePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: 134, width: screenWidth, height: 200)
        datePicker.timeZone = NSTimeZone.local
        //値が変わった際のイベントを登録する.
        datePicker.addTarget(self, action: #selector(PostDeadlineUIViewController.onDidChangeDate(_:)), for: UIControlEvents.valueChanged)
        return datePicker
    }()
    //ドラムロールの値が変更したときに呼ばれる関数
    @objc func onDidChangeDate(_ sender: UIDatePicker){
        // フォーマットを生成.
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        // 日付をフォーマットに則って取得.
        let selectedDate: NSString = dateFormatter.string(from: sender.date) as NSString
        //フォント関係を決める
        rightPostDeadlineHeaderLabel.text = selectedDate as String
        rightPostDeadlineHeaderLabel.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        rightPostDeadlineHeaderLabel.textColor = red
        rightPostDeadlineHeaderLabel.textAlignment = .right
        //回答期限について、変数への代入やローカル端末への保存（UIVCのpopの時に正しい表示ができるようにするため）
        postDeadline = rightPostDeadlineHeaderLabel.text
        postDeadlineForServer = rightPostDeadlineHeaderLabel.text
    }
    //イメージビュー（リマインドを表示するための領域）を設定
    let postRemindHeaderRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 334)
        return imageView
    }()
    //イメージビュー（リマインドの上線）を設定
    let postRemindHeaderOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（リマインドの下線）を設定
    let postRemindHeaderUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //リマインドの左側ラベルを設定
    let leftPostRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"リマインド", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //リマインドの右側ラベルを設定
    let rightPostNoneRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"しない", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostTenMinRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"10分前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostTweMinRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"20分前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostOneHourRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"1時間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostTwoHourRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"2時間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostOneDayRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"1日前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostTwoDayRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"2日前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    let rightPostOneWeekRemindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-135, y: 21, width: 100, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .right
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"1週間前", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //画像選択の画像を設定
    let nextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-22.08, y: 21, width: 7.08, height: 12)
        return imageView
    }()
    //リマインドの透明なボタンを作成するメソッド
    func makeSetPostRemindButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 334, width: Int(screenWidth), height: 54)
        button.addTarget(self, action: #selector(PostDeadlineUIViewController.setPostRemind(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //リマインドを選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func setPostRemind(_ sender:UIButton) {
        let nextVC = PostRemindUIViewController()
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
        subHeaderRect.addSubview(leftSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnPostTextButton = makeReturnPostTextButton()
        self.view.addSubview(returnPostTextButton)
        //回答期限の領域、上線、下線、画像、題名、ボタンを表示
        self.view.addSubview(postDeadlineHeaderRect)
        postDeadlineHeaderRect.addSubview(postDeadlineHeaderOverline)
        postDeadlineHeaderRect.addSubview(postDeadlineHeaderUnderline)
        postDeadlineHeaderRect.addSubview(leftPostDeadlineHeaderLabel)
        //日時を入れるラベル、ドラムロールを設置
        postDeadlineHeaderRect.addSubview(rightPostDeadlineHeaderLabel)
        self.view.addSubview(postDeadlineDatePicker)
        //リマインドの領域、下線、画像、題名、ボタンを表示
        self.view.addSubview(postRemindHeaderRect)
        postRemindHeaderRect.addSubview(postRemindHeaderOverline)
        postRemindHeaderRect.addSubview(postRemindHeaderUnderline)
        postRemindHeaderRect.addSubview(leftPostRemindHeaderLabel)
        postRemindHeaderRect.addSubview(rightPostNoneRemindHeaderLabel)
        postRemindHeaderRect.addSubview(nextGrayIcon)
        let setPostRemindButton = makeSetPostRemindButton()
        self.view.addSubview(setPostRemindButton)
    }
    //このViewが出てくる旅に呼び出される関数。いって戻ってきた時に呼び出したい時には、こちらに記入する。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if postRemind == nil {
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostNoneRemindHeaderLabel)
        } else if postRemind == Remind.tenMin {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostTenMinRemindHeaderLabel)
        } else if postRemind == Remind.tweMin {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostTweMinRemindHeaderLabel)
        } else if postRemind == Remind.oneHour {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostOneHourRemindHeaderLabel)
        } else if postRemind == Remind.twoHour {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostTwoHourRemindHeaderLabel)
        } else if postRemind == Remind.oneDay {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostOneDayRemindHeaderLabel)
        } else if postRemind == Remind.twoDay {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostOneWeekRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostTwoDayRemindHeaderLabel)
        } else if postRemind == Remind.oneWeek {
            rightPostNoneRemindHeaderLabel.removeFromSuperview()
            rightPostTenMinRemindHeaderLabel.removeFromSuperview()
            rightPostTweMinRemindHeaderLabel.removeFromSuperview()
            rightPostOneHourRemindHeaderLabel.removeFromSuperview()
            rightPostTwoHourRemindHeaderLabel.removeFromSuperview()
            rightPostOneDayRemindHeaderLabel.removeFromSuperview()
            rightPostTwoDayRemindHeaderLabel.removeFromSuperview()
            postRemindHeaderRect.addSubview(rightPostOneWeekRemindHeaderLabel)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
