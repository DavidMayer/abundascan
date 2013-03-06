//
//  DAMLoginViewController.h
//  AbundaScan
//
//  Created by David Mayer on 1/27/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMLoginViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSURLConnection *apiConnection;
@property (strong, nonatomic) NSMutableData *apiData;
@property (strong, nonatomic) IBOutlet UITextField *myUserNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *myPasswordTextField;
- (IBAction)clickMyLoginButton:(id)sender;
- (IBAction)clickMySkipButton:(id)sender;
- (IBAction)tapOccured:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property BOOL keyboardIsUp;
@property BOOL spinnerIsDown;
@property UITextField *currentTextField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;

@end
