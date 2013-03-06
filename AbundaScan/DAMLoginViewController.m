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
@synthesize myTableView;
@synthesize keyboardIsUp;
@synthesize currentTextField;
@synthesize gestureRecognizer;
@synthesize spinnerIsDown;

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
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    myUserNameTextField.returnKeyType = UIReturnKeyNext;
    myPasswordTextField.returnKeyType = UIReturnKeyDone;
    myPasswordTextField.secureTextEntry = YES;
    self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
    spinnerIsDown = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.accessoryView = myUserNameTextField;
            
            //[cell addSubview:myUserNameTextField];
            //myUserNameTextField.frame = CGRectMake(0, 0, myUserNameTextField.frame.size.width, myUserNameTextField.frame.size.height);
           // NSLog(@"myUserNameTextField x = %d y = %d", myUserNameTextField.frame.origin.x, myUserNameTextField.frame.origin.y);
           // NSLog(@"cell x = %d, y = %d", cell.frame.origin.x, cell.frame.origin.y);
            break;
            
        case 1:
            cell.accessoryView = myPasswordTextField;
            //[cell addSubview:myPasswordTextField];
            //myPasswordTextField.frame = CGRectMake(0, 0, myPasswordTextField.frame.size.width, myPasswordTextField.frame.size.width);
            //NSLog(@"myPassword x = %d y = %d", myPasswordTextField.frame.origin.x, myPasswordTextField.frame.origin.y);
            //NSLog(@"cell x = %d, y = %d", cell.frame.origin.x, cell.frame.origin.y);
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            currentTextField = myUserNameTextField;
            break;
            
        case 1:
            currentTextField = myPasswordTextField;
            break;
            
        default:
            break;
    }
}

-(void)animateView{
    if (keyboardIsUp) {
        
        [UIView beginAnimations:@"move down" context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.transform = CGAffineTransformMakeTranslation(0,0);
        
        [UIView commitAnimations];
        
        
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    else{
        
        [UIView beginAnimations:@"move up" context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.transform = CGAffineTransformMakeTranslation(0,-200);
        
        [UIView commitAnimations];
        
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
    keyboardIsUp = !keyboardIsUp;
}

- (IBAction)tapOccured:(id)sender {
    
    NSLog(@"tapping?");
    
    CGPoint tapLocation = [sender locationInView:self.view];
    
    UIView *tappedView = [self.view hitTest:tapLocation withEvent:nil];
    if ([tappedView isKindOfClass:[UIButton class]]) {
        UIButton *button = [[UIButton alloc]init];
        button = (UIButton *)tappedView;
        if ([button.titleLabel.text isEqualToString:@"Sign In"]){
            [currentTextField resignFirstResponder];
            [self clickMyLoginButton:sender];
        }
        else if ([button.titleLabel.text isEqualToString:@"No Thanks"]){
            [currentTextField resignFirstResponder];
            [self clickMySkipButton:sender];
        }
        else{
            currentTextField.text = @"";
        }
    }
    
    else{
        if (keyboardIsUp) {
        [self animateView];
        [currentTextField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.3];
        gestureRecognizer.enabled = NO;
        }
    }
}


#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.view.frame.origin.y == 0) {

    [self performSelector:@selector(animateView) withObject:nil afterDelay:0.3];
    }

    currentTextField = textField;
    gestureRecognizer.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == myUserNameTextField)
    {
        [myPasswordTextField becomeFirstResponder];
    }
    else
    {
        //[myPasswordTextField resignFirstResponder];
        [self animateView];
        [myPasswordTextField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.3];
        
    }
    
    gestureRecognizer.enabled = NO;
    
    NSLog(@"return");
    return YES;  
}

/*-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //if the spinner is up, the keyboard will lose focus because user interaction is disabled. This way, it will not be dismissable during spinner view
    
    return spinnerIsDown;
}*/



- (IBAction)clickMyLoginButton:(id)sender {
    
    NSString *username = myUserNameTextField.text;
    NSString *password = myPasswordTextField.text;
    NSString *md5 = [self stringToMD5:password];
    
    
    NSString *urlString = [[[[@"http://abundatrade.com/trade/process/user/login/?user=" stringByAppendingString:username] stringByAppendingString: @"&password="] stringByAppendingString:md5] stringByAppendingString:@"&mobile_scan=true"];
    
    NSLog(@"%@", urlString);

        
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    spinnerIsDown = NO;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self animateView];
    [currentTextField resignFirstResponder];
  
    if (keyboardIsUp){
    [appDelegate.spinner startWithMessage:@"Signing in..." Dimensions:CGRectMake((bounds.size.width - 200) / 2, (bounds.size.height) / 2, 200, 120)];
    }
    
    else{
        [appDelegate.spinner startWithMessage:@"Signing in..." Dimensions:CGRectMake((bounds.size.width - 200) / 2, (bounds.size.height - 125) / 2, 200, 120)];
    }
    
    
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
        spinnerIsDown = YES;
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We encountered a loading error. Please make sure you have service, then try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        spinnerIsDown = YES;
        
        if ([apiData length])
        {
            NSString *stringDataFromServer = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
            NSLog(@"data from server: %@", stringDataFromServer);

            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:apiData options:NSJSONReadingMutableLeaves error:nil];
            BOOL isError = (bool)[myDict objectForKey:@"error"];
            NSLog(@"myDict = %@", myDict);
            NSLog(@"isError = %c", isError);
            
            if ([myDict objectForKey:@"key"]){
            //if (!isError) {
                NSString *token = [myDict objectForKey:@"key"];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                //[[NSUserDefaults standardUserDefaults] setObject:@"ea823aa9aa86ac7fdcdd204a40e5f153" forKey:@"token"];
                
                NSLog(@"Token = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
                
                DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.navController popToRootViewControllerAnimated:NO];
            }
            /*myResultPriceLabel.text = [@"$ " stringByAppendingString:(NSString *) [myDict objectForKey:@"price"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[myDict objectForKey:@"imagel"]]];
            UIImage *myImage = [UIImage imageWithData:imageData];
            
            [self sizeImageView:myResultImageView AndPlaceImage:myImage];*/
            
            else if (isError == YES){
            [[[UIAlertView alloc]initWithTitle:@"Unable to log in" message:@"Your username and password combination was incorrect. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
            
        }
    }
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setGestureRecognizer:nil];
    [super viewDidUnload];
}
@end
