//
//  LoginViewController.swift
//  BookSpot
//
//  Created by MacBook on 2/23/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import Foundation

class LoginViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "loginbg"))
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        logInView!.insertSubview(backgroundImage, at: 0)
        
        //remove parse default logo
        let logo = UILabel()
        logo.text = "BookSpot"
        logo.textColor = UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 1)
        logo.font = UIFont(name: "HelveticaNeue-Medium", size: 70)
        logo.shadowColor = UIColor.black
        logo.shadowOffset = CGSize.init(width: 2, height: 2)
        logInView?.logo = logo
        
        //change color of forgotten pass button
        logInView?.passwordForgottenButton?.setTitleColor(UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 1), for: .normal)
        
        // make the background of the login button pop more
        logInView?.logInButton?.setBackgroundImage(nil, for: .normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 0.8)
        
        // make the buttons classier
        customizeButton(button: logInView?.signUpButton!)
        
        //implement signup window customization
        self.signUpController = SignUpViewController()

    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white as! CGColor
    
        func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // stretch background image to fill screen
        backgroundImage.frame = CGRect.init(x: 0, y: 0, width: logInView!.frame.width, height: logInView!.frame.height)
        
        // position logo at top with larger frame
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRect.init(x: logoFrame.origin.x, y: logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, width: logInView!.frame.width, height: logoFrame.height)
        }
    }
}
