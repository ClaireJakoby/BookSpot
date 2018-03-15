//
//  SignupViewController.swift
//  BookSpot
//
//  Created by MacBook on 2/23/16.
//  Copyright © 2016 Clair&Sida. All rights reserved.
//

import Foundation

class SignUpViewController : PFSignUpViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "loginbg"))
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        signUpView!.insertSubview(backgroundImage, at: 0)
        
        // remove the parse Logo
        let logo = UILabel()
        logo.text = "BookSpot"
        logo.textColor = UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 1)
        logo.font = UIFont(name: "HelveticaNeue-Medium", size: 70)
        logo.shadowColor = UIColor.black
        logo.shadowOffset = CGSize.init(width: 2, height: 2)
        signUpView?.logo = logo
        
        //change signup button bg color
        signUpView?.signUpButton!.setBackgroundImage(nil, for: .normal)
        signUpView?.signUpButton!.backgroundColor = UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 0.8)
        
        // change dismiss button "X" to say 'Already signed up?'
        signUpView?.dismissButton!.setTitle("Already signed up?", for: .normal)
        signUpView?.dismissButton!.setImage(nil, for: .normal)
        signUpView?.dismissButton!.setTitleColor(UIColor(red: 46/255, green: 174/255, blue: 170/255, alpha: 1), for: .normal)
        
        //smooth transition b/w controllers
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // stretch background image to fill screen
        backgroundImage.frame = CGRect.init(x: 0, y: 0, width: signUpView!.frame.width, height: signUpView!.frame.height)
        
        
        // position logo at top with larger frame
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRect.init(x: logoFrame.origin.x, y: signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, width: signUpView!.frame.width, height: logoFrame.height)
        
        // re-layout out dismiss button to be below sign
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton!.frame = CGRect.init(x: 0, y: signUpView!.signUpButton!.frame.origin.y + 16.0, width: signUpView!.frame.width, height: dismissButtonFrame.height)

    }
    
}
