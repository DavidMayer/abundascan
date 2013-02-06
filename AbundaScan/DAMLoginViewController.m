//
//  DAMLoginViewController.m
//  AbundaScan
//
//  Created by David Mayer on 1/27/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import "DAMLoginViewController.h"

@interface DAMLoginViewController ()

@end

@implementation DAMLoginViewController
@synthesize myPasswordTextField;
@synthesize myUserNameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickMyLoginButton:(id)sender {
}
@end
