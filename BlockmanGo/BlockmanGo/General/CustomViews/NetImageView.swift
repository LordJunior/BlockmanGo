//
//  NetImageView.swift
//  BlockyModes
//
//  Created by KiBen on 2017/10/23.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import UIKit
import Kingfisher

protocol NetImageViewDelegate: class {
    func netImageViewDidTap(_ imageView: NetImageView)
}

extension NetImageViewDelegate {
    func netImageViewDidTap(_ imageView: NetImageView) {}
}

class NetImageView: UIImageView {

    public weak var delegate: NetImageViewDelegate?
    
    public func enableUserInteraction() {
        isUserInteractionEnabled = true
        
        gestureRecognizers?.removeAll()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        addGestureRecognizer(tap)
    }
    
    public func imageWithUrlString(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard let url = urlString else {
            if placeHolder != nil {
                self.image = placeHolder
            }
            return
        }
        
        self.kf.setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }

    @objc private func tapRecognized() {
        delegate?.netImageViewDidTap(self)
    }
}
