//
//  AcountMgmtUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/22.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//MyPostUIViewController内で使うもののうちclass内に定義できないもの



class AcountMgmtUIViewController: UIViewController {
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
        let labelText = NSAttributedString(string:"アカウント", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの画像を生成(サイド)
    let eraceGrayIcon:UIImageView = {
        let image = UIImage(named: "eraceGray")
        let imageView = UIImageView(image: image)
        imageView.frame.origin = CGPoint(x: 15, y: 35)
        imageView.frame.size = CGSize(width: 15, height: 15)
        return imageView
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnProfileModalButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(AcountMgmtUIViewController.returnProfileModal(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnProfileModal(_ sender:UIButton) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    //イメージビュー（ラベルの背景となる領域）を設定
    let profileRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 80)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（件名の上線）を設定
    let profileOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（件名の下線）を設定
    let profileUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //個人名を設定
    let profileNameLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 90, y: 34 ,width: screenWidth-90, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black
        ]
        let labelText = NSAttributedString(string:"\(profileName as String)", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //長方形を用意しておく
    let rectOfDeleteAcountOrLogout = makeWhiteRect(width: screenWidth, height: 54)
    //長方形を用意しておく
    let rectOfDeleteAcountOrLogoutPressed = makeGrayRect(width: screenWidth, height: 54)
    //アカウントを削除の透明なボタンを作成するメソッド
    func makeDeleteAcountButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 190, width: Int(screenWidth), height: 54)
        button.setBackgroundImage(rectOfDeleteAcountOrLogout, for: .normal)
        button.setBackgroundImage(rectOfDeleteAcountOrLogoutPressed, for: .highlighted)
        button.addTarget(self, action: #selector(AcountMgmtUIViewController.moveToDeleteAcount(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //アカウントを削除を選択した時に実行するメソッド
    @objc func moveToDeleteAcount(_ sender:UIButton) {
        let nextVC = DeleteAcountUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（アカウントを削除の上線）を設定
    let deleteAcountOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（アカウントを削除の下線）を設定
    let deleteAcountUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //アカウントを削除の左側ラベルを設定
    let deleteAcountLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"アカウントを削除", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //右矢印のアイコンを設定
    let nextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-22.08, y: 21, width: 7.08, height: 12)
        return imageView
    }()
    //ログアウトの透明なボタンを作成するメソッド
    func makeLogoutButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 244, width: Int(screenWidth), height: 54)
        button.setBackgroundImage(rectOfDeleteAcountOrLogout, for: .normal)
        button.setBackgroundImage(rectOfDeleteAcountOrLogoutPressed, for: .highlighted)
        button.addTarget(self, action: #selector(AcountMgmtUIViewController.logout(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //ログアウトを選択した時に実行するメソッド
    @objc func logout(_ sender:UIButton) {
        print("ログアウトするよ")
    }
    //イメージビュー（ログアウトの下線）を設定
    let logoutUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //ログアウトの左側ラベルを設定
    let logoutLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 21, width: screenWidth, height: 12)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:red,
            .paragraphStyle:labelTextPar
            ]
        let labelText = NSAttributedString(string:"ログアウト", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
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
        subHeaderRect.addSubview(eraceGrayIcon)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnProfileModalButton = makeReturnProfileModalButton()
        self.view.addSubview(returnProfileModalButton)
        //プロフィール用の長方形などを配置していく
        self.view.addSubview(profileRect)
        profileRect.addSubview(profileOverline)
        profileRect.addSubview(profileUnderline)
        profileRect.addSubview(profileNameLabel)
        //プロフィール画像を設定する
        acountProfileImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        acountProfileImageView.layer.cornerRadius = 60 * 0.5
        acountProfileImageView.clipsToBounds = true
        profileRect.addSubview(acountProfileImageView)
        //アカウントを削除関係を配置
        let deleteAcountButton = makeDeleteAcountButton()
        self.view.addSubview(deleteAcountButton)
        deleteAcountButton.addSubview(deleteAcountOverline)
        deleteAcountButton.addSubview(deleteAcountUnderline)
        deleteAcountButton.addSubview(deleteAcountLabel)
        deleteAcountButton.addSubview(nextGrayIcon)
        //ログアウト関係を配置
        let logoutButton = makeLogoutButton()
        self.view.addSubview(logoutButton)
        logoutButton.addSubview(logoutUnderline)
        logoutButton.addSubview(logoutLabel)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
