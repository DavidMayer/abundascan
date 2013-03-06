//
//  DAMViewController.h
//  BarcodeScanner
//
//  Created by David Mayer on 8/15/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZbarSDK.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DAMViewController : UIViewController<ZBarReaderDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet UIView *iphone4View;
@property (strong, nonatomic) IBOutlet UIImageView *myResultImageView;
@property (strong, nonatomic) IBOutlet UITextView *myResultTextView;
@property (strong, nonatomic) NSURLConnection *apiConnection;
@property (strong, nonatomic) NSMutableData *apiData;
@property (strong, nonatomic) IBOutlet UILabel *myResultTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *myResultUPCLabel;
@property (strong, nonatomic) IBOutlet UILabel *myResultPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *myScanButton;
@property (strong, nonatomic) IBOutlet UILabel *noImageLabel;
@property CGRect originalImageViewFrame;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *myNavigationTitle;
@property (strong, nonatomic) UIView *roundedRectView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property BOOL shouldUpdateView;
@property (strong, nonatomic) ZBarSymbol *symbol;
@property UIBarButtonItem *myAddButton;
@property UIBarButtonItem *myLeftButton;




- (IBAction)clickMyScanButton:(id)sender;
-(void)addButtonTapped;
-(void)settingsButtonTapped;
-(void)loginButtonTapped;

@end
