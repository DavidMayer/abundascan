//
//  DAMAppDelegate.h
//  BarcodeScanner
//
//  Created by David Mayer on 8/15/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loadingSpinner.h"

@interface DAMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) loadingSpinner *spinner;

@end
