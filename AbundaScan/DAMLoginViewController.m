//
//  DAMLoginViewController.m
//  AbundaScan
//
//  Created by David Mayer on 1/27/13.
//  Copyright (c) 2013 David Mayer. All rights reserved.
//

#import "DAMLoginViewController.h"
#import "DAMAppDelegate.h"
#import "DAMViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface DAMLoginViewController ()

@end

@implementation DAMLoginViewController
@synthesize myPasswordTextField;
@synthesize myUserNameTextField;
@synthesize apiConnection;
@synthesize apiData;

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
    myPasswordTextField.delegate = self;
    myUserNameTextField.delegate = self;
    myUserNameTextField.returnKeyType = UIReturnKeyNext;
    myPasswordTextField.returnKeyType = UIReturnKeyDone;
    myPasswordTextField.secureTextEntry = YES;
    self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"edit");
    //currentTextField = textField;
    //gesutreRecognizer.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == myUserNameTextField)
    {
        [myPasswordTextField becomeFirstResponder];
    }
    else
    {
        [myPasswordTextField resignFirstResponder];
    }
    
    NSLog(@"return");
    return YES;
}



- (IBAction)clickMyLoginButton:(id)sender {
    
    NSString *username = myUserNameTextField.text;
    NSString *password = myPasswordTextField.text;
    NSString *md5 = [self stringToMD5:password];
    
    
    NSString *urlString = [[[[@"http://abundatrade.com/trade/process/user/login/?user=" stringByAppendingString:username] stringByAppendingString: @"&password="] stringByAppendingString:md5] stringByAppendingString:@"&callback=j&mobile_scan=true"];
    
    NSLog(@"%@", urlString);

        
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.spinner startWithMessage:@"Signing in..."];
    
    if (self.apiConnection)
    {
        [self.apiConnection cancel];
    }
    
    self.apiData = [NSMutableData dataWithCapacity:1000];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.apiConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (IBAction)clickMySkipButton:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Are you sure you don't want to log in?" message:@"Logging in to your AbundaTrade.com account allows you to add the items you scan to your AbundaTrade list for online submission." delegate:self cancelButtonTitle:@"Not this time" otherButtonTitles:@"I'd like to sign in", nil] show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 && [alertView.title isEqualToString:@"Are you sure you don't want to log in?"]) {
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"token"];
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.navController popToRootViewControllerAnimated:NO];
    }
}

- (NSString *) stringToMD5:(NSString *)inStr {
    const char *cStr = [inStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *md5 =  [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ];
    NSString *md5LowerCase = [md5 lowercaseString];
    return md5LowerCase;
}

#pragma mark -NSURL Connections

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"wut");
    if (self.apiConnection == connection)
    {
        [self.apiData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We encountered a loading error. Please make sure you have service, then try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        
        if ([apiData length])
        {
            NSString *stringDataFromServer = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
            NSLog(@"data from server: %@", stringDataFromServer);

            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:apiData options:NSJSONReadingMutableLeaves error:nil];
            NSString *isError = [myDict objectForKey:@"error"];
            NSLog(@"myDict = %@", myDict);
            NSLog(@"isError = %@", isError);
            
            //if ([isError isEqualToString:@"false"] ){
            if (!isError) {
                NSString *token = [myDict objectForKey:@"key"];
                //[[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:@"ea823aa9aa86ac7fdcdd204a40e5f153" forKey:@"token"];
                
                NSLog(@"Token = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
                
                DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.navController popToRootViewControllerAnimated:NO];
            }
            /*myResultPriceLabel.text = [@"$ " stringByAppendingString:(NSString *) [myDict objectForKey:@"price"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[myDict objectForKey:@"imagel"]]];
            UIImage *myImage = [UIImage imageWithData:imageData];
            
            [self sizeImageView:myResultImageView AndPlaceImage:myImage];*/
            
            else if ([isError isEqualToString:@"false"] ){
            [[[UIAlertView alloc]initWithTitle:@"Unable to log in" message:@"Your username and password combination was incorrect. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
            
        }
    }
}

@end
