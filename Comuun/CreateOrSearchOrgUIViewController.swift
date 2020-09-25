//
//  CreateOrSearchOrgUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/14.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//CreateOrSearchOrgUIViewController内で使うもののうちclass内に定義できないもの
// ActivityIndicator を用意
var activityIndicator: UIActivityIndicatorView!
//ID系
//var orgId: String! = String()
var orgIdForServer: String! = String()
//name系
var orgName: String! = String()
var orgNameForServer: String! = String()
//image系
var basicOrgImageViews: [String:UIImageView] = [:]
var expandedOrgImageViews: [String:UIImageView] = [:]
var acountOrgImageViews: [String:UIImageView] = [:]
var orgImageViewForServer: UIImageView! = UIImageView()
//ディレクトリのURL
var orgBasicDocumentDirectoryFileURLs: [String:URL] = [:]
var orgExpandedDocumentDirectoryFileURLs: [String:URL] = [:]
var orgAcountDocumentDirectoryFileURLs: [String:URL] = [:]
//member系
var member: [String:String] = [:]
//入力されたID
var enteredId = String()
//赤い長方形を描画する関数
func makeRedRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 1.0, green: 0.22, blue: 0.14, alpha: 1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//押された時の赤い長方形を描画する関数
func makeRedPressedRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 0.44, green: 0.1, blue: 0.06, alpha: 1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//緑の長方形を描画する関数
func makeGreenRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 0.27, green: 0.86, blue: 0.37, alpha: 1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//押された時の緑の長方形を描画する関数
func makeGreenPressedRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 0.12, green: 0.38, blue: 0.16, alpha: 1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}



class CreateOrSearchOrgUIViewController: UIViewController, UITextFieldDelegate {
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
        let labelText = NSAttributedString(string:"グループ作成/参加", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの画像を生成
    let previousGrayIcon:UIImageView = {
        let image = UIImage(named: "previousGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 35, width: 7.85, height: 15)
        return imageView
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(CreateOrSearchOrgUIViewController.returnOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnOrg(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（テキストフィールドの背景となる領域）を設定
    let orgIdRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 80)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（イメージビューの上線）を設定
    let orgIdOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（イメージビューの下線）を設定
    let orgIdUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //テキストフィールドを設定
    let orgIdTextField:UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 15, y: 105 ,width: screenWidth-30, height: 12)
        textField.backgroundColor = clear
        textField.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        textField.textColor = black
        textField.placeholder = "ID"
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        return textField
    }()
    //説明文のラベル
    var orgIdExplanation:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 43, width: screenWidth-30, height: 10)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
            .foregroundColor:gray,
            ]
        let labelText = NSAttributedString(string:"作成したいもしくは参加したいグループのIDを入力してください。", attributes:labelTextAttr)
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
        //サブヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(previousGrayIcon)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnOrgButton = makeReturnOrgButton()
        self.view.addSubview(returnOrgButton)
        //テキストフィールドを配置して行く
        self.view.addSubview(orgIdRect)
        orgIdRect.addSubview(orgIdOverline)
        orgIdRect.addSubview(orgIdUnderline)
        orgIdRect.addSubview(orgIdExplanation)
        self.view.addSubview(orgIdTextField)
        //デリゲートを設定
        orgIdTextField.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //完了ボタンを押した時に呼び出される関数
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.showIndicator()
        enteredId = textField.text!
        if (serverOrgs[enteredId] != nil) {
            activityIndicator.stopAnimating()
            self.setJoinOrgButton()
        } else {
            activityIndicator.stopAnimating()
            self.setCreateOrgButton()
        }
        return true
    }
    //団体に参加するの方になった場合の処理
    func setJoinOrgButton(){
        //説明ラベルを変更して再配置する
        orgIdExplanation.removeFromSuperview()
        orgIdExplanation = {
            let label = UILabel()
            label.frame = CGRect(x: 15, y: 43, width: screenWidth-30, height: 10)
            let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                .foregroundColor:green,
                ]
            let labelText = NSAttributedString(string:"このIDのグループは既に存在します。", attributes:labelTextAttr)
            label.attributedText = labelText
            return label
        }()
        orgIdRect.addSubview(orgIdExplanation)
        //団体参加ボタンを作成
        let rectOfJoinOrg = makeGreenRect(width: 144, height: 36)
        let pressedRectOfJoinOrg = makeGreenPressedRect(width: 144, height: 36)
        func makeMoveToJoinOrgButton() -> UIButton {
            let button = UIButton()
            button.frame = CGRect(x: screenWidth/2-72, y: 180, width: 144, height: 36)
            button.setBackgroundImage(rectOfJoinOrg, for: .normal)
            button.setBackgroundImage(pressedRectOfJoinOrg, for: .highlighted)
            button.addTarget(self, action: #selector(CreateOrSearchOrgUIViewController.moveToJoinOrg(_:)), for: UIControlEvents.touchUpInside)
            return button
        }
        let moveToJoinOrgButton = makeMoveToJoinOrgButton()
        self.view.addSubview(moveToJoinOrgButton)
        let joinOrgLabel:UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 12, width: 144, height: 12)
            let labelTextPar = NSMutableParagraphStyle()
            labelTextPar.alignment = .center
            let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor:white,
                .paragraphStyle:labelTextPar
            ]
            let labelText = NSAttributedString(string:"グループに参加する", attributes:labelTextAttr)
            label.attributedText = labelText
            return label
        }()
        moveToJoinOrgButton.addSubview(joinOrgLabel)
    }
    //団体参加ボタンで実行するメソッド
    @objc func moveToJoinOrg(_ sender:UIButton) {
//        orgId = enteredId
        orgIdForServer = enteredId
        let nextVC = JoinOrgUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //団体を作成するになった場合の処理
    func setCreateOrgButton(){
        //説明ラベルを変更して再配置する
        orgIdExplanation.removeFromSuperview()
        orgIdExplanation = {
            let label = UILabel()
            label.frame = CGRect(x: 15, y: 43, width: screenWidth-30, height: 10)
            let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                .foregroundColor:red,
                ]
            let labelText = NSAttributedString(string:"このIDのグループはまだ存在しません。", attributes:labelTextAttr)
            label.attributedText = labelText
            return label
        }()
        orgIdRect.addSubview(orgIdExplanation)
        //団体作成ボタンを作成
        let rectOfCreateOrg = makeRedRect(width: 144, height: 36)
        let pressedRectOfCreateOrg = makeRedPressedRect(width: 144, height: 36)
        func makeMoveToCreateOrgButton() -> UIButton {
            let button = UIButton()
            button.frame = CGRect(x: screenWidth/2-72, y: 180, width: 144, height: 36)
            button.setBackgroundImage(rectOfCreateOrg, for: .normal)
            button.setBackgroundImage(pressedRectOfCreateOrg, for: .highlighted)
            button.addTarget(self, action: #selector(CreateOrSearchOrgUIViewController.moveToCreateOrg(_:)), for: UIControlEvents.touchUpInside)
            return button
        }
        let moveToCreateOrgButton = makeMoveToCreateOrgButton()
        self.view.addSubview(moveToCreateOrgButton)
        let createOrgLabel:UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 12, width: 144, height: 12)
            let labelTextPar = NSMutableParagraphStyle()
            labelTextPar.alignment = .center
            let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor:white,
                .paragraphStyle:labelTextPar
            ]
            let labelText = NSAttributedString(string:"グループを作成する", attributes:labelTextAttr)
            label.attributedText = labelText
            return label
        }()
        moveToCreateOrgButton.addSubview(createOrgLabel)
    }
    //団体作成ボタンで実行するメソッド
    @objc func moveToCreateOrg(_ sender:UIButton) {
//        orgId = enteredId
        orgIdForServer = enteredId
        let nextVC = CreateOrgUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //Indicatorを始めるときの処理
    func showIndicator(){
        //Indicatorを作成
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: screenWidth/2-72, y: 180, width: 144, height: 36)
        //Indicatorの状態を管理
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //クルクルを開始
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
}
