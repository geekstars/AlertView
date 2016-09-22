//
//  ViewController.swift
//  AlertView
//
//  Created by Hoàng Minh Thành on 9/21/16.
//  Copyright © 2016 Hoàng Minh Thành. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator()
        createAlert()
    }
    
    func createAlert()
    {
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        alertView.alpha = 0
        
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10.0
        
        //Tạo button tắt
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        //Tạo dòng chữ
        let rectLable = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLable)
        label.numberOfLines = 0
        label.font.withSize(18)
        label.text = "Xin chào các bạn"
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        //Tạo nút OK
        let btnok = UIButton()
        btnok.frame = CGRect(x: 30, y: 90, width: buttonWidth, height: buttonWidth)
        btnok.setTitle("OK", for: .normal)
        btnok.setTitleColor(UIColor(red: 21/255, green: 126/255, blue: 251/255,alpha: 1.0), for: .normal)
        btnok.addTarget(self, action: #selector(action_ok), for: .touchUpInside)
        
        //Tạo nút Cancel
        let btncancel = UIButton(type: .custom)
        btncancel.frame = CGRect(x: 155, y: 90, width: 60, height: 40)
        btncancel.setTitle("Cancel", for: .normal)
        btncancel.setTitleColor(UIColor(red: 21/255, green: 126/255, blue: 251/255,alpha: 1.0), for: .normal)
        
        btncancel.addTarget(self, action: #selector(action_cancel), for: .touchUpInside)
        
        
        alertView.addSubview(label)
        alertView.addSubview(button)
        alertView.addSubview(btnok)
        alertView.addSubview(btncancel)
        view.addSubview(alertView)
    }
    
    func action_ok()
    {
        print("OK")
    }
    
    func action_cancel()
    {
        dismissAlert()
    }
    
    func dismissAlert()
    {
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0
        }) { (finished) in
            self.alertView.removeFromSuperview()
            self.alertView = nil
        }
    }
    
    
    @IBAction func showAlertView(_ sender: UIButton) {
        showAlert()
    }
    
    func showAlert()
    {
        if alertView == nil
        {
            createAlert()
        }
        createGestureRecognizer()
        
        animator.removeAllBehaviors()
        
        alertView.alpha = 1.0
        let snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        
        animator.addBehavior(snapBehavior)
    }
    
    func createGestureRecognizer()
    {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    func handlePan(sender : UIPanGestureRecognizer)
    {
        if alertView != nil
        {
            let panLocationInView = sender.location(in: self.view)
            let panLocationInAlertView = sender.location(in: self.alertView)
            
            if sender.state == .began
            {
                let offSet = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY)
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offSet, attachedToAnchor: panLocationInView)
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == .changed
            {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == .ended
            {
                animator.removeAllBehaviors()
                snapBehavior = UISnapBehavior(item: alertView, snapTo: self.view.center)
                animator.addBehavior(snapBehavior)
                if sender.translation(in: view).y > 300
                {
                    dismissAlert()
                }
            }
        }
    }
}

