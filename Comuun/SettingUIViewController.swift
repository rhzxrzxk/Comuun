//
//  SttingUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/07.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//SettingUIViewController内で使うもののうちclass内に定義できないもの



class SettingUIViewController: UIViewController {
    //イメージビュー（メインヘッダーを表示するための領域）を設定
    let mainHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfMainHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        return imageView
    }()
    //イメージビュー（メインヘッダーの下線）を設定
    let mainHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfMainHeader)
        return imageView
    }()
    //メインヘッダーの画像を生成
    let settingPinkIcon:UIImageView = {
        let image = UIImage(named: "settingPink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2-15.23, y: 30, width: 30.45, height: 30)
        return imageView
    }()
    let orgGrayIcon:UIImageView = {
        let image = UIImage(named: "orgGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-29.9, y: 32.5, width: 14.9, height: 25)
        return imageView
    }()
    //ヘッダーの透明なボタンを作成するメソッド
    func makeMoveToOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(SettingUIViewController.moveToOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //ヘッダーのボタンで実行するメソッド
    @objc func moveToOrg(_ sender:UIButton) {
        let nextVC = OrgUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //長方形を用意しておく
    let rectOfOrgIndex = makeWhiteRect(width: screenWidth, height: 54)
    //長方形を用意しておく
    let rectOfOrgIndexPressed = makeGrayRect(width: screenWidth, height: 54)
    //Comuunについてのボタンを作成する
    func makeMoveToAboutComuunButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 80, width: screenWidth, height: 54)
        button.setBackgroundImage(rectOfOrgIndex, for: .normal)
        button.setBackgroundImage(rectOfOrgIndexPressed, for: .highlighted)
        button.addTarget(self, action: #selector(SettingUIViewController.moveToAboutComuun(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //Comuunについてのボタンで実行するメソッド
    @objc func moveToAboutComuun(_ sender:UIButton) {
        print("Comuunについてに移動するよ")
    }
    //イメージビュー（「Comuunについて」の上線）を設定
    let aboutComuunOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（「Comuunについて」の下線）を設定
    let aboutComuunUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //「Comuunについて」のアイコンを設定
    let aboutComuunGrayIcon:UIImageView = {
        let image = UIImage(named: "aboutComuunGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 20, y: 17, width: 20, height: 20)
        return imageView
    }()
    //「Comuunについて」の題名を設定
    let aboutComuunLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"Comuunについて", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //右矢印のアイコンを設定
    let nextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-29, y: 20, width: 7.32, height: 14)
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextVC = OrgUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
        let afterNextVC = TimelineUIViewController()
        self.navigationController?.pushViewController(afterNextVC, animated: false)
        //ナビゲーションバーを消す(画面遷移に左右へのスライドを使うためにnavigationControllerを利用したが、バーやボタンは自分で作成している)
        self.navigationController?.isNavigationBarHidden = true
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        // ヘッダーの領域を表示
        self.view.addSubview(mainHeaderRect)
        //ヘッダーの下線を表示
        mainHeaderRect.addSubview(mainHeaderUnderline)
        //ヘッダーのアイコンを表示
        mainHeaderRect.addSubview(settingPinkIcon)
        mainHeaderRect.addSubview(orgGrayIcon)
        //ヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let moveToMemberButton = makeMoveToOrgButton()
        self.view.addSubview(moveToMemberButton)
        //コミューンについての領域、上線、下線、アイコン、題名を表示
        let moveToAboutComuunButton = makeMoveToAboutComuunButton()
        self.view.addSubview(moveToAboutComuunButton)
        moveToAboutComuunButton.addSubview(aboutComuunOverline)
        moveToAboutComuunButton.addSubview(aboutComuunUnderline)
        moveToAboutComuunButton.addSubview(aboutComuunGrayIcon)
        moveToAboutComuunButton.addSubview(aboutComuunLabel)
        moveToAboutComuunButton.addSubview(nextGrayIcon)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
