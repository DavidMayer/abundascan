//
//  DAMLoginViewController.h
//  AbundaScan
//
//  Created by David Mayer on 1/27/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *myUserNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *myPasswordTextField;
- (IBAction)clickMyLoginButton:(id)sender;

@end
