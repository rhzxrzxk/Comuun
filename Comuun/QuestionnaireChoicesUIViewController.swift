//
//  QuestionnaireChoicesUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/22.
//  Copyright © 2018年 田中尊. All rights reserved.
//



import UIKit



//QuestionnaireChoicesUIViewController内で使うもののうちclass内に定義できないもの
//viewDidLoadのfor文の中で作成したものを保存していくための辞書を用意しておく
var choiceRects = [String:UIImageView]()
var choiceTextFields = [String:UITextField]()
var choiceAddGrayIcons = [String:UIImageView]()
var choiceAddButtons = [String:UIButton]()
//選択された時にキーボードに被らないようにする処理を行う時のために、テキストフィールドを入れる変数を用意しておく
var questionnaireChoicesTextField = UITextField()
//選択肢3追加のための透明なボタンを作成するメソッド
func makeAddChoice3Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 69, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice3(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice3Button = makeAddChoice3Button()
//選択肢4追加のための透明なボタンを作成するメソッド
func makeAddChoice4Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 123, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice4(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice4Button = makeAddChoice4Button()
//選択肢5追加のための透明なボタンを作成するメソッド
func makeAddChoice5Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 177, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice5(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice5Button = makeAddChoice5Button()
//選択肢6追加のための透明なボタンを作成するメソッド
func makeAddChoice6Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 231, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice6(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice6Button = makeAddChoice6Button()
//選択肢7追加のための透明なボタンを作成するメソッド
func makeAddChoice7Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 285, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice7(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice7Button = makeAddChoice7Button()
//選択肢8追加のための透明なボタンを作成するメソッド
func makeAddChoice8Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 339, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice8(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice8Button = makeAddChoice8Button()
//選択肢9追加のための透明なボタンを作成するメソッド
func makeAddChoice9Button() -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: screenWidth-60, y: 393, width: 60, height: 54)
    button.addTarget(QuestionnaireChoicesUIViewController(), action: #selector(QuestionnaireChoicesUIViewController.addChoice9(_:)), for: UIControlEvents.touchUpInside)
    return button
}
//この時点でボタンを作成しておく
let addChoice9Button = makeAddChoice9Button()



class QuestionnaireChoicesUIViewController: UIViewController, UITextFieldDelegate {
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
        let labelText = NSAttributedString(string:"回答を設定", attributes:labelTextAttr)
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
    func makeReturnQuestionnaireTextButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(QuestionnaireChoicesUIViewController.returnQuestionnaireText(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnQuestionnaireText(_ sender:UIButton) {
        //一旦postChoicesを空っぽにする
        postChoices = []
        //内容は、「もし選択肢1-9が存在するならば、そのテキストを変数に代入する」というもの
        if choiceTextFields["0"]?.text != "" {
            postChoices.append((choiceTextFields["0"]?.text)!)
            postChoicesForServer.append((choiceTextFields["0"]?.text)!)
        }
        if choiceTextFields["1"]?.text != "" {
            postChoices.append((choiceTextFields["1"]?.text)!)
            postChoicesForServer.append((choiceTextFields["1"]?.text)!)
        }
        if choiceTextFields["2"]?.text != "" {
            postChoices.append((choiceTextFields["2"]?.text)!)
            postChoicesForServer.append((choiceTextFields["2"]?.text)!)
        }
        if choiceTextFields["3"]?.text != "" {
            postChoices.append((choiceTextFields["3"]?.text)!)
            postChoicesForServer.append((choiceTextFields["3"]?.text)!)
        }
        if choiceTextFields["4"]?.text != "" {
            postChoices.append((choiceTextFields["4"]?.text)!)
            postChoicesForServer.append((choiceTextFields["4"]?.text)!)
        }
        if choiceTextFields["5"]?.text != "" {
            postChoices.append((choiceTextFields["5"]?.text)!)
            postChoicesForServer.append((choiceTextFields["5"]?.text)!)
        }
        if choiceTextFields["6"]?.text != "" {
            postChoices.append((choiceTextFields["6"]?.text)!)
            postChoicesForServer.append((choiceTextFields["6"]?.text)!)
        }
        if choiceTextFields["7"]?.text != "" {
            postChoices.append((choiceTextFields["7"]?.text)!)
            postChoicesForServer.append((choiceTextFields["7"]?.text)!)
        }
        if choiceTextFields["8"]?.text != "" {
            postChoices.append((choiceTextFields["8"]?.text)!)
            postChoicesForServer.append((choiceTextFields["8"]?.text)!)
        }
        //for文を使って、選択肢の数を判断
        var counter = 0
        for i in 0...8 {
            if choiceTextFields["\(i)"]?.text != "" {
                counter += 1
            }
            if counter >= 2 {
                numOfChoices = counter
                numOfChoicesForServer = counter
            } else {
                numOfChoices = 2
                numOfChoicesForServer = 2
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    //スクロールビューを設定
    var questionnaireScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-65)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        scrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-65)
        return scrollView
    }()
    //ボタンで実行される関数
    @objc func addChoice3(_ sender:UIButton) {
        choiceAddGrayIcons["1"]?.isHidden = true
        addChoice3Button.isHidden = true
        choiceRects["2"]?.isHidden = false
        choiceTextFields["2"]?.isHidden = false
        addChoice4Button.isHidden = false
        choiceTextFields["2"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
//        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-11)
//        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice4(_ sender:UIButton) {
        choiceAddGrayIcons["2"]?.isHidden = true
        addChoice4Button.isHidden = true
        choiceRects["3"]?.isHidden = false
        choiceTextFields["3"]?.isHidden = false
        addChoice5Button.isHidden = false
        choiceTextFields["3"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
//        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight+43)
//        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice5(_ sender:UIButton) {
        choiceAddGrayIcons["3"]?.isHidden = true
        addChoice5Button.isHidden = true
        choiceRects["4"]?.isHidden = false
        choiceTextFields["4"]?.isHidden = false
        addChoice6Button.isHidden = false
        choiceTextFields["4"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
//        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight+97)
//        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice6(_ sender:UIButton) {
        choiceAddGrayIcons["4"]?.isHidden = true
        addChoice6Button.isHidden = true
        choiceRects["5"]?.isHidden = false
        choiceTextFields["5"]?.isHidden = false
        addChoice7Button.isHidden = false
        choiceTextFields["5"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight-11)
        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice7(_ sender:UIButton) {
        choiceAddGrayIcons["5"]?.isHidden = true
        addChoice7Button.isHidden = true
        choiceRects["6"]?.isHidden = false
        choiceTextFields["6"]?.isHidden = false
        addChoice8Button.isHidden = false
        choiceTextFields["6"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight+43)
        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice8(_ sender:UIButton) {
        choiceAddGrayIcons["6"]?.isHidden = true
        addChoice8Button.isHidden = true
        choiceRects["7"]?.isHidden = false
        choiceTextFields["7"]?.isHidden = false
        addChoice9Button.isHidden = false
        choiceTextFields["7"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight+97)
        self.view.addSubview(questionnaireScrollView)
    }
    //ボタンで実行される関数
    @objc func addChoice9(_ sender:UIButton) {
        choiceAddGrayIcons["7"]?.isHidden = true
        addChoice9Button.isHidden = true
        choiceRects["8"]?.isHidden = false
        choiceTextFields["8"]?.isHidden = false
        choiceTextFields["8"]?.becomeFirstResponder()
        multipleChoiceRect.transform = multipleChoiceRect.transform.translatedBy(x: 0, y: 54)
        multipleChoiceSwitch.transform = multipleChoiceSwitch.transform.translatedBy(x: 0, y: 54)
        questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight+151)
        self.view.addSubview(questionnaireScrollView)
    }
    //イメージビュー（"複数選択を許可する"のテキストフィールドの背景となる領域）を設定
//    let multipleChoiceRect:UIImageView = {
//        let image = makeWhiteRect(width: screenWidth, height: 54)
//        let imageView = UIImageView(image:image)
//        imageView.frame.origin = CGPoint(x: 0, y: 123)
//        return imageView
//    }()
    let multipleChoiceRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 54)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 69 + (numOfChoices - 1) * 54)
        return imageView
    }()
    //イメージビュー（"複数選択を許可する"の下線）を設定
    let multipleChoiceUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //"複数選択を許可する"のラベルを設定
    let multipleChoiceLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 21, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"複数選択を許可する", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    // Swicthを作成する.
//    let multipleChoiceSwitch:UISwitch = {
//        let mySwitch = UISwitch()
//        mySwitch.frame.origin = CGPoint(x: screenWidth-66, y: 134.5)
//        mySwitch.addTarget(self, action: #selector(QuestionnaireChoicesUIViewController.onClickMySwitch), for: UIControlEvents.valueChanged)
//        if postMultiChoice {
//            mySwitch.setOn(true, animated: false)
//        } else {
//            mySwitch.setOn(false, animated: false)
//        }
//        return mySwitch
//    }()
    let multipleChoiceSwitch:UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.frame.origin = CGPoint(x: screenWidth-66, y: CGFloat(80.5 + Float((numOfChoices - 1) * 54)))
        mySwitch.addTarget(self, action: #selector(QuestionnaireChoicesUIViewController.onClickMySwitch), for: UIControlEvents.valueChanged)
        if postMultiChoice {
            mySwitch.setOn(true, animated: false)
        } else {
            mySwitch.setOn(false, animated: false)
        }
        return mySwitch
    }()
    //スイッチの値が変更した時に呼び出される関数
    @objc func onClickMySwitch(sender: UISwitch){
        if sender.isOn {
            postMultiChoice = true
            postMultiChoiceForServer = true
        }
        else {
            postMultiChoice = false
            postMultiChoiceForServer = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //キーボード出現時のオブザーバーを設置
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(QuestionnaireChoicesUIViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        //サブヘッダーの領域を表示
        self.view.addSubview(subHeaderRect)
        //サブヘッダーの下線を表示
        subHeaderRect.addSubview(subHeaderUnderline)
        //サブヘッダーのセンターラベルを表示
        subHeaderRect.addSubview(centerSubHeaderLabel)
        //サブヘッダーのサイドラベルを表示
        subHeaderRect.addSubview(leftSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnQuestionnaireTextButton = makeReturnQuestionnaireTextButton()
        self.view.addSubview(returnQuestionnaireTextButton)
        self.view.addSubview(questionnaireScrollView)
        for i in 1...9 {
            //イメージビュー（choiceのテキストフィールドの背景となる領域）を設定
            let choiceRect:UIImageView = {
                let image = makeWhiteRect(width: screenWidth, height: 54)
                let imageView = UIImageView(image:image)
                imageView.frame.origin = CGPoint(x: 0, y: 15+54*(i-1))
                return imageView
            }()
            //とりあえずは全部表示する。あとで（既に記入された個数）目以降は消す
            choiceRects["\(i-1)"] = choiceRect
            questionnaireScrollView.addSubview(choiceRects["\(i-1)"]!)
            if i == 1 {
                //イメージビュー（choice1の上線）を設定
                let choice1Overline:UIImageView = {
                    let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
                    let imageView = UIImageView(image: drawImage)
                    return imageView
                }()
                choiceRects["\(i-1)"]?.addSubview(choice1Overline)
            }
            //イメージビュー（choiceの下線）を設定
            let choiceUnderline:UIImageView = {
                let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
                let imageView = UIImageView(image: drawImage)
                return imageView
            }()
            choiceRects["\(i-1)"]?.addSubview(choiceUnderline)
            //choiceのテキストフィールドを設定
            let choiceTextField:UITextField = {
                let textField = UITextField()
                textField.frame = CGRect(x: 15, y: 15+54*(i-1) ,width: Int(screenWidth-75), height: 54)
                textField.backgroundColor = clear
                textField.font = UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
                textField.textColor = black
                switch i {
                case 1:
                    textField.placeholder = "回答1"
                case 2:
                    textField.placeholder = "回答2"
                case 3:
                    textField.placeholder = "回答3"
                case 4:
                    textField.placeholder = "回答4"
                case 5:
                    textField.placeholder = "回答5"
                case 6:
                    textField.placeholder = "回答6"
                case 7:
                    textField.placeholder = "回答7"
                case 8:
                    textField.placeholder = "回答8"
                case 9:
                    textField.placeholder = "回答9"
                default: break
                }
                textField.tag = i
                textField.returnKeyType = .done
                return textField
            }()
            //とりあえずは全部表示する。あとで（既に記入された個数）目以降は消す
            choiceTextFields["\(i-1)"] = choiceTextField
            questionnaireScrollView.addSubview(choiceTextFields["\(i-1)"]!)
            if i != 1 && i != 9 {
                //画像選択の画像を設定
                let choiceAddGrayIcon:UIImageView = {
                    let image = UIImage(named: "addGray")
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: screenWidth-40, y: 17, width: 20, height: 20)
                    return imageView
                }()
                choiceAddGrayIcons["\(i-1)"] = choiceAddGrayIcon
                choiceRects["\(i-1)"]?.addSubview(choiceAddGrayIcons["\(i-1)"]!)
            }
            //テキストビューがデリゲートに批准
            choiceTextFields["\(i-1)"]?.delegate = self
            if i >= numOfChoices + 1 {
                choiceRects["\(i-1)"]?.isHidden = true
                choiceTextFields["\(i-1)"]?.isHidden = true
            }
            if i <= numOfChoices - 1 {
                choiceAddGrayIcons["\(i-1)"]?.isHidden = true
            }
        }
        //ボタンの表示。add4以降は隠す
        choiceAddButtons["2"] = addChoice3Button
        choiceAddButtons["3"] = addChoice4Button
        choiceAddButtons["4"] = addChoice5Button
        choiceAddButtons["5"] = addChoice6Button
        choiceAddButtons["6"] = addChoice7Button
        choiceAddButtons["7"] = addChoice8Button
        choiceAddButtons["8"] = addChoice9Button
        questionnaireScrollView.addSubview(addChoice3Button)
        questionnaireScrollView.addSubview(addChoice4Button)
//        addChoice4Button.isHidden = true
        questionnaireScrollView.addSubview(addChoice5Button)
//        addChoice5Button.isHidden = true
        questionnaireScrollView.addSubview(addChoice6Button)
//        addChoice6Button.isHidden = true
        questionnaireScrollView.addSubview(addChoice7Button)
//        addChoice7Button.isHidden = true
        questionnaireScrollView.addSubview(addChoice8Button)
//        addChoice8Button.isHidden = true
        questionnaireScrollView.addSubview(addChoice9Button)
//        addChoice9Button.isHidden = true
        
        for i in 1...9 {
            if i <= numOfChoices - 1 {
                choiceAddButtons["\(i)"]?.isHidden = true
            }
        }
        //"複数選択を許可する"
        questionnaireScrollView.addSubview(multipleChoiceRect)
        multipleChoiceRect.addSubview(multipleChoiceUnderline)
        multipleChoiceRect.addSubview(multipleChoiceLabel)
        //switchも表示
        questionnaireScrollView.addSubview(multipleChoiceSwitch)
        //テキストビュー1をアクティブにする
        choiceTextFields["0"]?.becomeFirstResponder()
        //for文を使って、選択肢を埋める
        for i in 0...numOfChoices-1 {
            if postChoices != [] {
                if numOfChoices >= 3 {
                    choiceTextFields["\(i)"]?.text = postChoices[i]
                } else {
                    choiceTextFields["\(0)"]?.text = postChoices[0]
                    if postChoices.count == 2 {
                        choiceTextFields["\(1)"]?.text = postChoices[1]
                    }
                }
            }
        }
        if numOfChoices >= 6 {
            questionnaireScrollView.contentSize = CGSize(width: screenWidth-30, height: screenHeight - 11 + 54 * CGFloat((numOfChoices - 6)))
            self.view.addSubview(questionnaireScrollView)
        }
    }
    //テキストフィールドが選択されてから編集可能になるまでに実行される処理
    func textFieldShouldBeginEditing(_ textField:UITextField) -> Bool {
        questionnaireChoicesTextField = textField
        return true
    }
    //キーボードが出現するときに実行される関数。キーボード変更時にも呼び出されることに要注意。つまり初期keyboardが日本語の場合、英語→日本語→keyboard出現で二回呼ばれる。そのあとは、Appearするたびにまず一度、出現したらもう一度呼ばれる。
    var firstTimeInfoShareKeyboardHeight:CGFloat = 0
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //キーボードの高さが他の場所でも使えるように、変数に入れておく。キーボードの高さが場合によって変わってしまうので、今回は最初の高さを変数に入れることで、同じ値になるようにしている。
        if firstTimeInfoShareKeyboardHeight == 0 {
            firstTimeInfoShareKeyboardHeight = keyboardFrame.size.height
        }
        //キャレットの位置を基準に考えて、キーボードと重なる場合、重ならなくなるようにずらす
        let textRange: UITextRange = questionnaireChoicesTextField.selectedTextRange!
        let caretPosition: CGRect = questionnaireChoicesTextField.caretRect(for: textRange.start)
        let depthToCaretBottom = questionnaireChoicesTextField.frame.origin.y + caretPosition.maxY + 7
        let heightAboveKeyboardTop = questionnaireScrollView.contentOffset.y + screenHeight - firstTimeInfoShareKeyboardHeight - 80
        let distance = depthToCaretBottom - heightAboveKeyboardTop
        if distance > 0 {
            questionnaireScrollView.contentOffset.y = distance
        }
    }
    //完了ボタンを押した時に呼び出される関数
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
