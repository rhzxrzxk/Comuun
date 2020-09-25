//
//  CreateOrgUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/15.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//CreateOrgUIViewController内で使うもののうちclass内に定義できないもの
//localの画像保存用の変数
var localOrgImage: UIImage = UIImage()


//画像が存在するかを判別する
var orgImageExist: Bool = false
//画像を入れていく変数
var orgImageView:UIImageView? = nil
var orgImageView2:UIImageView? = nil


//var orgImageView3:UIImageView? = nil
//var orgImageView4:UIImageView? = nil


//以下の関数で作成、設定されるボタンは、有効/無効が切り替わったりするので、class外に記入しておく
//サブヘッダーの透明なボタンのうち、「投稿ボタン」を作成するメソッド
func makeCreateOrgButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
    button.addTarget(CreateOrgUIViewController(), action: #selector(CreateOrgUIViewController.createOrg(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let createOrgButton = makeCreateOrgButton()
//「画像選択」の透明なボタンを作成するメソッド
func makeOpenCameraRollToAddOrgImageButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: 15, y: 90, width: 60, height: 60)
    button.addTarget(CreateOrgUIViewController(), action: #selector(CreateOrgUIViewController.openCameraRollToAddOrgImage(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let openCameraRollToAddOrgImageButton = makeOpenCameraRollToAddOrgImageButton()
//「画像再選択」の透明なボタンを作成するメソッド
func makeOpenActionSheetToChangeOrRemoveOrgImageButton() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: 15, y: 90, width: 60, height: 60)
    button.addTarget(CreateOrgUIViewController(), action: #selector(CreateOrgUIViewController.openActionSheetToChangeOrRemoveOrgImage(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let openActionSheetToChangeOrRemoveOrgImageButton = makeOpenActionSheetToChangeOrRemoveOrgImageButton()



class CreateOrgUIViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        let labelText = NSAttributedString(string:"グループを作成する", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    var leftSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 35, width: 80, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor
        ]
        let labelText = NSAttributedString(string:"キャンセル", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    let rightSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-50, y: 35, width: 35, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"作成", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnCreateOrgSearchOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 80, height: 25)
        button.addTarget(self, action: #selector(CreateOrgUIViewController.returnCreateOrSearchOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーの「キャンセル」ボタンで実行するメソッド
    @objc func returnCreateOrSearchOrg(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //サブヘッダーの「作成」ボタンで実行するメソッド
    @objc func createOrg(_ sender:UIButton) {
        orgNameForServer = orgNameTextView.text
        var int = Int()
        //画像をlocalに保存して行く
        func createLocalDataFile() {
            // 作成するテキストファイルの名前
            let fileName = "basicOrgImage\(orgIdForServer!)"
            let fileName2 = "expandedOrgImage\(orgIdForServer!)"
            let fileName3 = "acountOrgImage\(orgIdForServer!)"
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let path = documentDirectoryFileURL.appendingPathComponent(fileName)
            let path2 = documentDirectoryFileURL.appendingPathComponent(fileName2)
            let path3 = documentDirectoryFileURL.appendingPathComponent(fileName3)
            //パスを一旦配列へ入れる
            orgBasicDocumentDirectoryFileURLs["\(orgIdForServer!)"] = path
            orgExpandedDocumentDirectoryFileURLs["\(orgIdForServer!)"] = path2
            orgAcountDocumentDirectoryFileURLs["\(orgIdForServer!)"] = path3
        }
        createLocalDataFile()
        func saveImage() {
            //pngで保存する場合
            let pngImageData = UIImagePNGRepresentation(localOrgImage)
            //            // jpgで保存する場合
            //            let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
            do {
                try pngImageData!.write(to: orgBasicDocumentDirectoryFileURLs[orgIdForServer]!)
                try pngImageData!.write(to: orgExpandedDocumentDirectoryFileURLs[orgIdForServer]!)
                try pngImageData!.write(to: orgAcountDocumentDirectoryFileURLs[orgIdForServer]!)
            } catch {
                //エラー処理
            }
        }
        saveImage()
        //ここでサーバーに団体登録をする
        if (serverOrgs[orgIdForServer] == nil) {
            let org:[String:Any?] = [
                "id":orgIdForServer,
                "name":orgNameForServer,
                "member":[profileId:profileName]
            ]
            let orgImageView :URL = orgBasicDocumentDirectoryFileURLs[orgIdForServer]!
            userDefault.set(orgImageView, forKey: "orgBasic\(orgIdForServer!)")
            let orgImageView2 :URL = orgExpandedDocumentDirectoryFileURLs[orgIdForServer]!
            userDefault.set(orgImageView2, forKey: "orgExpanded\(orgIdForServer!)")
            let orgImageView3 :URL = orgAcountDocumentDirectoryFileURLs[orgIdForServer]!
            userDefault.set(orgImageView3, forKey: "orgAcount\(orgIdForServer!)")
            let org2:[String:Any?] = [
                "id":orgIdForServer,
                "name":orgNameForServer,
                "imageView":orgImageViewForServer,
                "member":[profileId:profileName]
            ]
            //まずはサーバー登録を完了させる。ローカルに保存して行くのは、画像データをそのままuserdefaltに保存できないため、別の作業になる
            serverOrgs[orgIdForServer] = org2
            if UserDefaults.standard.array(forKey: "belongingOrgs") == nil {
                var belongingOrgs: [[String:Any?]] = []
                belongingOrgs.append(org)
                userDefault.set(belongingOrgs, forKey: "belongingOrgs")
            } else {
                var belongingOrgs = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
                belongingOrgs.append(org)
                userDefault.set(belongingOrgs, forKey: "belongingOrgs")
            }
        }
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: false)
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
    //テキストビューを設定
    let orgNameTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = clear
        textView.frame = CGRect(x: 85, y: 103 ,width: screenWidth-90, height: 34)
        textView.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        textView.textColor = black
        textView.isScrollEnabled = false
        textView.returnKeyType = .done
        textView.becomeFirstResponder()
        return textView
    }()
    //プレースホルダーの代わりのラベルを設定
    let orgNamePlaceholder:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 90, y: 114 ,width: screenWidth-90, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:gray
        ]
        let labelText = NSAttributedString(string:"グループ名", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //画像選択の画像を設定
    let addGrayIcon:UIImageView = {
        let image = UIImage(named: "addGray2")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 10, width: 60, height: 60)
        return imageView
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
        subHeaderRect.addSubview(leftSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnCreateOrSearchOrgButton = makeReturnCreateOrgSearchOrgButton()
        self.view.addSubview(returnCreateOrSearchOrgButton)
        //サブヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(rightSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        self.view.addSubview(createOrgButton)
        createOrgButton.isEnabled = false
        //テキストビューの周辺を配置して行く
        self.view.addSubview(orgIdRect)
        orgIdRect.addSubview(orgIdOverline)
        orgIdRect.addSubview(orgIdUnderline)
        self.view.addSubview(orgNameTextView)
        self.view.addSubview(orgNamePlaceholder)
        //デリゲートを設定
        orgNameTextView.delegate = self
        orgIdRect.addSubview(addGrayIcon)
        self.view.addSubview(openCameraRollToAddOrgImageButton)
    }
    //「画像選択」ボタンで実行される、カメラロールを開く関数
    @objc func openCameraRollToAddOrgImage(_ sender:UIButton) {
        let album = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(album) {
            let album = UIImagePickerController()
            album.delegate = self
            album.sourceType = UIImagePickerControllerSourceType.photoLibrary
            album.allowsEditing = true
            self.present(album, animated: true, completion: nil)
        }
    }
    //「画像再選択」ボタンで実行される、アクションシートを作成する関数
    @objc func openActionSheetToChangeOrRemoveOrgImage(_ sender:UIButton) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //選択肢1
        let action1 = UIAlertAction(title: "写真を選択", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            //先ずは既存の画像を削除
            orgImageView!.removeFromSuperview()
            //ここで再選択ボタンも一旦削除
            openActionSheetToChangeOrRemoveOrgImageButton.removeFromSuperview()
            //カメラロールを開く
            let album = UIImagePickerControllerSourceType.photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(album) {
                let album = UIImagePickerController()
                album.delegate = self
                album.sourceType = UIImagePickerControllerSourceType.photoLibrary
                album.allowsEditing = true
                self.present(album, animated: true, completion: nil)
            }
        })
        //選択肢2
        let action2 = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
            (action: UIAlertAction!) in
            //画像がなくなったことを判別
            orgImageExist = false
            //既存の画像を削除
            orgImageView!.removeFromSuperview()
            //ここで再選択ボタンも削除
            openActionSheetToChangeOrRemoveOrgImageButton.removeFromSuperview()
            //選択ボタンを追加
            self.view.addSubview(openCameraRollToAddOrgImageButton)
            //消していた"画像を選択"関係の表示を表示し、"画像を変更"のラベルを消す
            self.addGrayIcon.isHidden = false
            //空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
            if self.orgNameTextView.text.isEmpty || orgImageExist == false {
                self.rightSubHeaderLabel.textColor = gray
                createOrgButton.isEnabled = false
            } else {
                self.rightSubHeaderLabel.textColor = mainColor
                createOrgButton.isEnabled = true
            }
        })
        //選択肢3
        let action3 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        // アクションを追加.
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        self.present(alertSheet, animated: true, completion: nil)
    }
    // 写真を選択した後に、自動的に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //まずは画像が存在することを判別
        orgImageExist = true
        //選択ボタンを無効にする
        openCameraRollToAddOrgImageButton.removeFromSuperview()
        //画像の上に再選択ボタンを重ねる
        self.view.addSubview(openActionSheetToChangeOrRemoveOrgImageButton)
        //"画像を選択"関係の表示を表示し、"画像を変更"のラベルを消す
        addGrayIcon.isHidden = true
        //取得した画像を表示する
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        orgImageView = UIImageView(image: image)
        orgImageView?.frame = CGRect(x: 15, y: 90, width: 60, height: 60)
        orgImageView?.layer.cornerRadius = 60 * 0.5
        orgImageView?.clipsToBounds = true
        self.view.addSubview(orgImageView!)
        //作成中の団体に画像を設定
        localOrgImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        basicOrgImageView = orgImageView!
        //サーバー用の画像を設定
        orgImageView2 = UIImageView(image: image)
        orgImageViewForServer = orgImageView2!
        //空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
        if orgNameTextView.text.isEmpty || orgImageExist == false {
            rightSubHeaderLabel.textColor = gray
            createOrgButton.isEnabled = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            createOrgButton.isEnabled = true
        }
        // 写真を選択するためのビューを下ろす
        self.dismiss(animated: true)
    }
    //テキストビューの内容が変更された時に実行される関数
    func textViewDidChange(_ textView: UITextView) {
        //空かどうかによって「"本文を入力"のラベルを表示するか」、「"投稿"の色」を分岐
        if textView.text.isEmpty {
            orgNamePlaceholder.isHidden = false
        } else {
            orgNamePlaceholder.isHidden = true
        }
        if textView.text.isEmpty || orgImageExist == false {
            rightSubHeaderLabel.textColor = gray
            createOrgButton.isEnabled = false
        } else {
            rightSubHeaderLabel.textColor = mainColor
            createOrgButton.isEnabled = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
