//
//  RandomInputView.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/7/21.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol RandomInputViewDataSource: class {
    func randomInputTextForRandoming(_ randomInputView: RandomInputView) -> String?
}

protocol RandomInputViewDelegate: class {
    func randomInputViewDidBeginInputting(_ randomInputView: RandomInputView)
    func randomInputViewDidEndInputting(_ randomInputView: RandomInputView)
    
}

class RandomInputView: UIView {

    weak var dataSource: RandomInputViewDataSource?
    
    weak var delegate: RandomInputViewDelegate?
    
    var placeholder: String? = nil {
        didSet {
            textFiled?.placeholder = placeholder
        }
    }
    
    var font: UIFont = UIFont.size15 {
        didSet {
            textFiled?.font = font
        }
    }
    
    var textColor: UIColor = R.clr.appColor._844501() {
        didSet {
            textFiled?.textColor = textColor
        }
    }
    
    var text: String? = nil {
        didSet {
            textFiled?.text = text
        }
    }
    
    private weak var textFiled: UITextField?
    private weak var randomButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textFiled = UITextField().addTo(superView: self).configure({ (textFiled) in
            textFiled.placeholder = placeholder
            textFiled.font = font
            textFiled.textColor = textColor
            textFiled.leftViewMode = .always
            textFiled.borderStyle = .roundedRect
            textFiled.delegate = self
            textFiled.leftView = UIView().addTo(superView: textFiled).layout(snapKitMaker: { (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(10)
            })
        }).layout(snapKitMaker: { (make) in
            make.edges.equalToSuperview()
        })
        
        randomButton = UIButton().addTo(superView: self).configure({ (button) in
            button.setBackgroundImage(R.image.profile_random(), for: .normal)
            button.addTarget(self, action: #selector(randomButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 34, height: 34))
            make.right.equalToSuperview().inset(2)
            make.centerY.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resignFirstResponder() -> Bool {
        textFieldDidEndEditing(textFiled!)
        return super.resignFirstResponder()
    }
    
    @objc private func randomButtonClicked() {
        textFiled?.text = dataSource?.randomInputTextForRandoming(self)
    }
}

extension RandomInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        text = textField.text
        delegate?.randomInputViewDidBeginInputting(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        text = textField.text
        delegate?.randomInputViewDidEndInputting(self)
    }
}
