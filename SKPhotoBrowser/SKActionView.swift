//
//  SKOptionalActionView.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/19.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import UIKit

class SKActionView: UIView {
    internal weak var browser: SKPhotoBrowser?
    internal var closeButton: SKCloseButton!
    internal var deleteButton: SKDeleteButton!
    internal var shareButton: SKShareButton!

    private var extraMargin: CGFloat = SKMesurement.isPhoneX ? 40 : 0

    // Action
    fileprivate var cancelTitle = "Cancel"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
//        self.frame = frame
        self.frame = CGRect(x: 0, y: extraMargin, width: frame.width, height: 100)//custom layout
        self.browser = browser

        configureCloseButton()
        configureDeleteButton()
        configureShareButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if closeButton.frame.contains(point) || deleteButton.frame.contains(point) || shareButton.frame.contains(point) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
//        self.frame = frame
        self.frame = CGRect(x: 0, y: extraMargin, width: frame.width, height: 100)//custom layout
        setNeedsDisplay()
    }

    func updateCloseButton(image: UIImage, size: CGSize? = nil) {
        configureCloseButton(image: image, size: size)
    }
    
    func updateDeleteButton(image: UIImage, size: CGSize? = nil) {
        configureDeleteButton(image: image, size: size)
    }

    func updateShareButton(image: UIImage, size: CGSize? = nil) {
        configureShareButton(image: image, size: size)
    }
    
    func animate(hidden: Bool) {
//        let closeFrame: CGRect = hidden ? closeButton.hideFrame : closeButton.showFrame
//        let deleteFrame: CGRect = hidden ? deleteButton.hideFrame : deleteButton.showFrame

        if SKPhotoBrowserOptions.displayCloseButton {
            self.closeButton.frame = closeButton.showFrame
            self.closeButton.center = CGPoint(x: self.closeButton.frame.origin.x + (self.closeButton.frame.size.width / 2), y: frame.height / 2)
        }

        if SKPhotoBrowserOptions.displayDeleteButton {
            self.deleteButton.frame = deleteButton.showFrame
            self.deleteButton.center = CGPoint(x: self.deleteButton.frame.origin.x + (self.deleteButton.frame.size.width / 2), y: frame.height / 2)
        }

        if SKPhotoBrowserOptions.displayShareButton {
            self.shareButton.frame = shareButton.showFrame
            self.shareButton.center = CGPoint(x: self.shareButton.frame.origin.x + (self.shareButton.frame.size.width / 2), y: frame.height / 2)
        }

        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in
                        let alpha: CGFloat = hidden ? 0.0 : 1.0

                        if SKPhotoBrowserOptions.displayCloseButton {
                            self.closeButton.alpha = alpha
//                            self.closeButton.frame = closeFrame
                        }
                        if SKPhotoBrowserOptions.displayDeleteButton {
                            self.deleteButton.alpha = alpha
//                            self.deleteButton.frame = deleteFrame
                        }

                        if SKPhotoBrowserOptions.displayShareButton {
                            self.shareButton.alpha = alpha
//                            self.shareButton.frame = deleteFrame
                        }
        }, completion: nil)
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        browser?.determineAndClose()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        guard let browser = self.browser else { return }
        
        browser.delegate?.removePhoto?(browser, index: browser.currentPageIndex) { [weak self] in
            self?.browser?.deleteImage()
        }
    }

    @objc func shareButtonPressed(_ sender: UIButton) {
        browser?.popupSaveImage()
    }
}

extension SKActionView {
    func configureCloseButton(image: UIImage? = nil, size: CGSize? = nil) {
        if closeButton == nil {
            closeButton = SKCloseButton(frame: .zero)
            closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
            closeButton.isHidden = !SKPhotoBrowserOptions.displayCloseButton
            closeButton.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            
            addSubview(closeButton)
        }

        guard let size = size else { return }
        closeButton.setFrameSize(size)

        guard let image = image else { return }
        closeButton.setImage(image, for: UIControlState())
    }
    
    func configureDeleteButton(image: UIImage? = nil, size: CGSize? = nil) {
        if deleteButton == nil {
            deleteButton = SKDeleteButton(frame: .zero)
            deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            deleteButton.isHidden = !SKPhotoBrowserOptions.displayDeleteButton
            deleteButton.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addSubview(deleteButton)
        }

        guard let size = size else { return }
        deleteButton.setFrameSize(size)
        
        guard let image = image else { return }
        deleteButton.setImage(image, for: UIControlState())
    }

    func configureShareButton(image: UIImage? = nil, size: CGSize? = nil) {
        if shareButton == nil {
            shareButton = SKShareButton(frame: .zero)
            shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
            shareButton.isHidden = !SKPhotoBrowserOptions.displayShareButton
            shareButton.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addSubview(shareButton)
        }

        guard let size = size else { return }
        shareButton.setFrameSize(size)

        guard let image = image else { return }
        shareButton.setImage(image, for: UIControlState())
    }
}
