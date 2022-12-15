//
//  ViewController.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/13.
//


import UIKit
import RxSwift
import RxCocoa

class RegisterVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var nameTextField = UITextField()
    var passwordTextField = UITextField()
    var checkBtn = UIButton()
    
    var confirmBtn = UIButton()
    
    
    var nameWarnningLabel = UILabel()
    var passwordWarnningLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        
        self.drawView()
        self.setTextField()
        
        
    }
    
    func drawView(){
        let fieldWidth = self.view.frame.size.width/2
        let fieldHeight = (100/500)*fieldWidth
        
        self.nameTextField = {
            let field = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            field.center.x = self.view.center.x
            field.center.y = self.view.center.y - fieldHeight*2
//            field.backgroundColor = .yellow
            field.borderStyle = .bezel
            field.textColor = .black
            field.placeholder = "닉네임"
            return field
        }()
        self.view.addSubview(self.nameTextField)
        
        let nameEndPosY = self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height
        
        self.nameWarnningLabel = {
            let lb = UILabel()
            lb.textColor = .red
            lb.text = "닉네임 글자 수 지켜~!~!"
            lb.font = UIFont.systemFont(ofSize: fieldHeight/4)
            lb.sizeToFit()
            lb.frame.origin.x = self.nameTextField.frame.origin.x
            lb.frame.origin.y = nameEndPosY
            lb.isHidden = true
            return lb
        }()
        self.view.addSubview(self.nameWarnningLabel)
        
        self.passwordTextField = {
            let field = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            field.center.x = self.view.center.x
            field.frame.origin.y = nameEndPosY + fieldHeight
//            field.backgroundColor = .
            field.borderStyle = .bezel
            field.textColor = .black
            field.placeholder = "비밀번호"
            return field
        }()
        self.view.addSubview(self.passwordTextField)
        
        let pwEndPosY = self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height
        
        self.passwordWarnningLabel = {
            let lb = UILabel()
            lb.textColor = .red
            lb.text = "비밀번호 글자 수 지켜~!~!"
            lb.font = UIFont.systemFont(ofSize: fieldHeight/4)
            lb.sizeToFit()
            lb.frame.origin.x = self.passwordTextField.frame.origin.x
            lb.frame.origin.y = pwEndPosY
            lb.isHidden = true
            return lb
        }()
        self.view.addSubview(self.passwordWarnningLabel)
        
        let btnHeight = fieldHeight/2
        let btnWidth = btnHeight
        self.checkBtn = {
            
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: self.passwordTextField.frame.origin.x, y: pwEndPosY + btnHeight), size: CGSize(width: btnWidth, height: btnHeight)))
            btn.backgroundColor = .lightGray
            return btn
        }()
        self.view.addSubview(self.checkBtn)
        
        let checkBtnLabel: UILabel = {
            let lb = UILabel()
            lb.text = "모두 동의합니다."
            lb.textColor = .black
            lb.font = UIFont.systemFont(ofSize: btnHeight*0.8)
            lb.sizeToFit()
            lb.frame.origin.x = self.checkBtn.frame.origin.x + btnWidth + btnWidth/2
            lb.center.y = self.checkBtn.center.y
            return lb
        }()
        self.view.addSubview(checkBtnLabel)
         
        self.confirmBtn = {
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            btn.backgroundColor = .lightGray
            btn.setTitle("회원가입", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.setTitleColor(.black, for: .selected)
            btn.center.x = self.passwordTextField.center.x
            btn.frame.origin.y = pwEndPosY + fieldHeight*2
            return btn
        }()
        self.view.addSubview(self.confirmBtn)
        
    }
    
    
    func setTextField(){
        
        let nameObservable = self.nameTextField.rx.text.map{$0?.count ?? 0}
        nameObservable
            .bind(with: self.nameWarnningLabel, onNext: { label, count in
            label.isHidden = count > 5 ? false : true
        })
            .disposed(by: disposeBag)
        
        
        let pwObservable = self.passwordTextField.rx.text.map{$0?.count ?? 0}
        pwObservable
            .bind(with: self.passwordWarnningLabel, onNext: { label, count in
            label.isHidden = count > 5 ? false : true
        })
            .disposed(by: disposeBag)
        
        let isSelectedObservable = self.checkBtn.rx.tap.map({self.checkBtn.isSelected})
        let checkBtnObservable = self.checkBtn.rx.tap
        self.checkBtn.rx.tap
            .bind { _ in
            self.checkBtn.isSelected = !self.checkBtn.isSelected
            self.checkBtn.backgroundColor = self.checkBtn.isSelected ? .black : .lightGray
        }
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(nameObservable, pwObservable, isSelectedObservable){ nameCount, pwCount, isSelected in
                if isSelected{
                    if nameCount > 5 || pwCount > 5{
                        print("글자수 초과")
                        return false
                    }else if nameCount < 2 || pwCount < 2{
                        print("글자수 너무 적음")
                        return false
                    }else{
                        print("글자수 통과")
                        return true
                    }
                }else{
                    return false
                }
            }
        .bind(to: self.confirmBtn.rx.isSelected)
        .disposed(by: disposeBag)
    }
}


//self.passwordTextField.rx
//    .controlEvent([.editingDidBegin])
//    .bind {
//
//                self.passwordTextField.backgroundColor = .cyan
//    }.disposed(by: disposeBag)
//
//self.passwordTextField.rx.controlEvent([.editingDidEnd])
//    .bind {
//                self.passwordTextField.backgroundColor = .yellow
//    }.disposed(by: disposeBag)



//        let isSelectRelay = PublishRelay<Bool>()
//            isSelectRelay.accept(self.checkBtn.isSelected)
