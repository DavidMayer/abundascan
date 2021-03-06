//
//  loadingSpinner.h
//  BarcodeScanner
//
//  Created by David Mayer on 10/28/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loadingSpinner : UIView

@property UIActivityIndicatorView *spinner;
@property UILabel *messageLabel;

-(void)startWithMessage:(NSString *)message Dimensions:(CGRect)frame;
-(void)stop;
@end
