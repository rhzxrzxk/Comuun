//
//  ProfileModalUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/21.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//プロフィール画像配置用の長方形を用意
let rectOfExpandedProfileImage = makeWhiteRect(width: 270, height: 390)



class ProfileModalUIViewController: UIViewController {
    //周辺にあるモーダルを消すボタンを作成するメソッド
    func makeReturnToOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        button.addTarget(self, action: #selector(ProfileModalUIViewController.returnToOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //周辺にあるモーダルを消すボタンで実行するメソッド
    @objc func returnToOrg(_ sender:UIButton) {
        dismiss(animated: true, completion: {})
    }
    //UIViewを設定する
    let profileModalUIView:UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: screenWidth/2-135, y: screenHeight/2-195, width: 270, height: 390)
        return uiView
    }()
    //イメージビュー（プロフィール画像を表示するための領域）
    let expandedProfileImageRect:UIImageView = {
        let imageView = UIImageView(image:rectOfExpandedProfileImage)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //個人名を設定
    let profileNameLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 135-60, y: 280, width: 120, height: 10)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 10) ?? UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor:black,
            .paragraphStyle:labelTextPar
            ]
        let labelText = NSAttributedString(string:"\(profileName as String)", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //自分の投稿ボタンを作成するメソッド
    func makeMoveToMyPostButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 310, width: 135, height: 80)
        button.addTarget(self, action: #selector(ProfileModalUIViewController.moveToOrgMgmt(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //自分の投稿ボタンで実行するメソッド
    @objc func moveToOrgMgmt(_ sender:UIButton) {
        let nextVC = MyPostUIViewController()
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nextVC, animated: false )
    }
    //自分の投稿の画像を生成
    let myPostGrayIcon:UIImageView = {
        let image = UIImage(named: "myPostGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 40.5, y: 20, width: 54, height: 40)
        return imageView
    }()
    //アカウント管理ボタンを作成するメソッド
    func makeMoveToAccountMgmtButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 135, y: 310, width: 135, height: 80)
        button.addTarget(self, action: #selector(ProfileModalUIViewController.moveToAccountMgmt(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //アカウント管理ボタンで実行するメソッド
    @objc func moveToAccountMgmt(_ sender:UIButton) {
        let nextVC = AcountMgmtUIViewController()
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nextVC, animated: false )
    }
    //アカウント管理の画像を生成
    let acountMgmtGrayIcon:UIImageView = {
        let image = UIImage(named: "acountMgmtGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 29.5, y: 21.24, width: 76, height: 37.53)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーを消す(画面遷移に左右へのスライドを使うためにnavigationControllerを利用したが、バーやボタンは自分で作成している)
        self.navigationController?.isNavigationBarHidden = true
        let returnToOrgButton = makeReturnToOrgButton()
        self.view.addSubview(returnToOrgButton)
        //UIViewを配置
        self.view.addSubview(profileModalUIView)
        //画像用の長方形を配置
        profileModalUIView.addSubview(expandedProfileImageRect)
        //画像を配置
        expandedProfileImageView.frame = CGRect(x: 0, y: 0, width: 270, height: 270)
        expandedProfileImageRect.addSubview(expandedProfileImageView)
        //その他を配置していく
        expandedProfileImageRect.addSubview(profileNameLabel)
        let moveToMyPostButton = makeMoveToMyPostButton()
        profileModalUIView.addSubview(moveToMyPostButton)
        moveToMyPostButton.addSubview(myPostGrayIcon)
        let moveToAccountMgmtButton = makeMoveToAccountMgmtButton()
        profileModalUIView.addSubview(moveToAccountMgmtButton)
        moveToAccountMgmtButton.addSubview(acountMgmtGrayIcon)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
