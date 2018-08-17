//
//  BMAlertController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/16.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import SnapKit

final class AlertController: UIViewController {

    typealias AlertButtonClickCallBack = (AlertController) -> Void
    
    var alertTitle: String? {
        didSet {
            alertTitleLabel?.text = alertTitle
        }
    }
    
    var alertMessage: String? {
        didSet {
            alertMessageLabel?.text = alertMessage
        }
    }
    
    private enum ButtonTag: Int {
        case cancel
        case done
    }
    
    private var showCancelButton: Bool = false
    
    private weak var alertTitleLabel: UILabel?
    private weak var alertMessageLabel: UILabel?
    private weak var alertDoneButton: UIButton?
    private weak var alertCancelButton: UIButton?
    private var alertTitleLabelTopToSuperConstraint: Constraint?
    private var alertTitleLabelCenterYToSuperConstraint: Constraint?
    private var alertDoneButtonCenterXToSuperConstraint: Constraint?
    
    private var doneCallBack: AlertButtonClickCallBack?
    private var cancelCallBack: AlertButtonClickCallBack?
    
    required init(title: String?, message: String?, showCancelButton: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        
        alertTitle = title
        self.showCancelButton = showCancelButton
        self.alertMessage = message
        modalPresentationStyle = .custom
        transitioningDelegate = ModalTransitionController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }.configure { (containView) in
            containView.isUserInteractionEnabled = true
        }
        
        let contentContainView = UIView().addTo(superView: containView).configure { (containView) in
            containView.backgroundColor = R.clr.appColor._eed5a0()
            containView.layer.cornerRadius = 12
            containView.clipsToBounds = true
        }.layout { (make) in
            make.left.right.top.equalToSuperview().inset(20)
        }
        
        alertTitleLabel = UILabel().addTo(superView: contentContainView).configure({ (label) in
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.boldSize15
            label.numberOfLines = 0
            label.text = self.alertTitle
            label.textAlignment = .center
        }).layout(snapKitMaker: { (make) in
            self.alertTitleLabelTopToSuperConstraint = make.top.equalToSuperview().offset(20).priority(900).constraint
            self.alertTitleLabelCenterYToSuperConstraint = make.centerY.equalToSuperview().priority(500).constraint
            make.left.right.equalToSuperview().inset(10)
        })
        
        alertMessageLabel = UILabel().addTo(superView: contentContainView).configure({ (label) in
            label.numberOfLines = 0
            label.attributedText = self.alertAttributedMessage(self.alertMessage)
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(alertTitleLabel!.snp.bottom).offset(24)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        })
        
        contentContainView.layout { (make) in
            make.bottom.equalTo(alertMessageLabel!.snp.bottom).offset(20)
        }
        
        alertDoneButton = UIButton().addTo(superView: containView).configure { (button) in
            button.setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
            button.titleLabel?.font = UIFont.size14
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle(R.string.localizable.done(), for: .normal)
            button.tag = ButtonTag.done.rawValue
            button.addTarget(self, action: #selector(buttonClickCallBack(_:)), for: .touchUpInside)
        }.layout { (make) in
            make.top.equalTo(contentContainView.snp.bottom).offset(10)
            make.height.equalTo(42)
            make.width.equalTo(contentContainView).multipliedBy(0.48)
        }
        
        if showCancelButton {
            alertDoneButton?.layout(snapKitMaker: { (make) in
                make.right.equalTo(contentContainView)
            })
            
            /// cancel button
            alertCancelButton = UIButton().addTo(superView: containView).configure { (button) in
                button.setBackgroundImage(R.image.general_button_background_normal(), for: .normal)
                button.titleLabel?.font = UIFont.size14
                button.setTitleColor(R.clr.appColor._b17f63(), for: .normal)
                button.setTitle(R.string.localizable.common_cancel(), for: .normal)
                button.tag = ButtonTag.cancel.rawValue
                button.addTarget(self, action: #selector(buttonClickCallBack(_:)), for: .touchUpInside)
            }.layout(snapKitMaker: { (make) in
                make.top.height.width.equalTo(alertDoneButton!)
                make.left.equalTo(contentContainView)
            })
        }else {
            alertDoneButton?.layout(snapKitMaker: { (make) in
                make.centerX.equalToSuperview()
            })
        }

        containView.layout { (make) in
            make.bottom.equalTo(alertDoneButton!.snp.bottom).offset(20)
        }
    }
    
    /// 如果当前controller弹出的alert还没dismiss，再次调用此函数，会返回nil
    @discardableResult
    static func alert(title: String?, message: String?, from controller: UIViewController, showCancelButton: Bool = false) -> AlertController? {
        guard AlertController.presentingControllerOfAlert != controller else {return nil} /// 防止同个controller重复present alert
        
        let alertController = AlertController(title: title, message: message, showCancelButton: showCancelButton)
        controller.present(alertController, animated: false, completion: nil)
        return alertController
    }
    
    @discardableResult
    func setDoneTitle(_ doneTitle: String?) -> AlertController {
        alertDoneButton?.setTitle(doneTitle, for: .normal)
        return self
    }
    
    @discardableResult
    func setCancelTitle(_ cancelTitle: String?) -> AlertController {
        alertCancelButton?.setTitle(cancelTitle, for: .normal)
        return self
    }
    
    @discardableResult
    func done(completion: @escaping (AlertController) -> Void) -> AlertController {
        doneCallBack = completion
        return self
    }
    
    @discardableResult
    func cancel(completion: @escaping (AlertController) -> Void) -> AlertController {
        cancelCallBack = completion
        return self
    }
    
    private func alertAttributedMessage(_ message: String?) -> NSAttributedString? {
        guard let message = message else {return nil}
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        paraStyle.lineSpacing = 10
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : R.clr.appColor._a36b2e(), NSAttributedStringKey.font : UIFont.size12, NSAttributedStringKey.paragraphStyle : paraStyle]
        return NSAttributedString(string: message, attributes: attributes)
    }
    
    @objc private func buttonClickCallBack(_ sender: UIButton) {
        AlertController.presentingControllerOfAlert = nil
        dismiss(animated: false) {
            sender.tag == ButtonTag.done.rawValue ? self.doneCallBack?(self) : self.cancelCallBack?(self)
        }
    }
}

private extension AlertController {
    private static var presentingControllerOfAlertKey: CChar = CChar.init(0)
    
    private static var presentingControllerOfAlert: UIViewController? {
        set {
            objc_setAssociatedObject(self, &(AlertController.presentingControllerOfAlertKey), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(AlertController.presentingControllerOfAlertKey)) as? UIViewController
        }
    }
}
