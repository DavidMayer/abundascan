//
//  loadingSpinner.m
//  BarcodeScanner
//
//  Created by David Mayer on 10/28/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import "loadingSpinner.h"
#import "DAMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation loadingSpinner

@synthesize messageLabel;
@synthesize spinner;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"1 %@", NSStringFromCGRect(frame));
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor blackColor];
        
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width - 50) / 2, 20, 50, 50)];
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 40)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = UITextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        
        NSLog(@"2");

        
        [self addSubview:spinner];
        [self addSubview:messageLabel];
    }
    
    return self;
}



- (void)stop
{
    [spinner stopAnimating];
    
    [UIView animateWithDuration:0.2
                     animations:^
     {
         self.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             self.alpha = 0.0f;
             self.hidden = YES;
             [self.window sendSubviewToBack:self];
         }
     }];
    
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.userInteractionEnabled = YES;
}

- (void)startWithMessage:(NSString *)message Dimensions:(CGRect )frame
{
    messageLabel.text = message;
    [spinner startAnimating];
    
    self.alpha = 0.0f;
    self.hidden = NO;
    [self.window bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.2
                     animations:^
     {
         self.alpha = 1.0f;
     }
                     completion:^(BOOL finished)
     {
         self.alpha = 1.0f;
     }];
    
    [self initWithFrame:frame];
    
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.userInteractionEnabled = NO;
}
@end
