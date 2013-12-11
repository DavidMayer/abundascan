//
//  DAMViewController.m
//  BarcodeScanner
//
//  Created by David Mayer on 8/15/12.
//  Copyright (c) 2012 David Mayer. All rights reserved.
//

#import "DAMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "loadingSpinner.h"
#import "DAMAppDelegate.h"
#import "DAMLoginViewController.h"
#import "DAMSettingsViewController.h"

@interface DAMViewController ()

@end


@implementation DAMViewController
@synthesize myResultImageView;
@synthesize myResultTextView;
@synthesize apiConnection;
@synthesize apiData;
@synthesize myResultUPCLabel;
@synthesize myResultTitleLabel;
@synthesize myResultPriceLabel;
@synthesize myScanButton;
@synthesize originalImageViewFrame;
@synthesize noImageLabel;
@synthesize myNavigationBar;
@synthesize myNavigationTitle;
@synthesize roundedRectView;
@synthesize infoView;
@synthesize iphone4View;
@synthesize shouldUpdateView;
@synthesize myAddButton;
@synthesize myLeftButton;
@synthesize symbol;
@synthesize reader;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //determine which device view to present
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            //iPhone 4
            roundedRectView = [[UIView alloc]initWithFrame:CGRectMake(14, 52, 292, 244)];
            iphone4View.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [iphone4View addSubview:roundedRectView];
            [iphone4View sendSubviewToBack:roundedRectView];
        }
        if(result.height == 568)
        {
            // iPhone 5
            roundedRectView = [[UIView alloc]initWithFrame:CGRectMake(14, 62 - 44, 292, 244)];
            self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [self.view addSubview:roundedRectView];
            [self.view sendSubviewToBack:roundedRectView];
        }
    }
    
    //set up ZBar scanner
    
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_EAN13
                   config:ZBAR_CFG_ENABLE
                       to:1];
    [scanner setSymbology:ZBAR_UPCA
                   config:ZBAR_CFG_ENABLE
                       to:1];
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [scanner setSymbology: ZBAR_QRCODE
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    /*if(TARGET_IPHONE_SIMULATOR) {
      ZBarCameraSimulator *cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
        cameraSim.readerView =  readerView;
    }*/
    
    
    //Sets up view
    
    originalImageViewFrame = myResultImageView.frame;
    noImageLabel.hidden = YES;
    myScanButton.titleLabel.textColor = [UIColor darkGrayColor];
    roundedRectView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    roundedRectView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    roundedRectView.layer.borderWidth = 2;
    roundedRectView.layer.cornerRadius = 10;
    
    
    //presents first time instructions alert
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasStartedApp"]) {
        [[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"You can scan any CD, DVD, Video Game, or Book and get a real time offer from AbundaTrade.com.  Simply hold your phone about 4 inches from any barcode and wait a couple seconds for the value to be captured.  If you like the value and want to add it to your list to submit to AbundaTrade.com simply hit the + button and it will populate your list for sale on your account at AbundaTrade.com.  Please contact us at Trade@AbundaTrade.com if you have any further questions. You can review these instructions any time you want from your settings."/*@"AbundaScan now allows you to add scanned items to your AbundaTrade.com list! Just click the plus button in the top right corner after you've scanned an item." */delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"hasStartedApp"];
    }
    
    
}

- (void)viewDidUnload
{
    [self setMyResultImageView:nil];
    [self setMyResultTextView:nil];
    [self setMyResultTitleLabel:nil];
    [self setMyResultUPCLabel:nil];
    [self setMyResultPriceLabel:nil];
    [self setMyScanButton:nil];
    [self setMyScanButton:nil];
    [self setNoImageLabel:nil];
    [self setMyNavigationBar:nil];
    [self setMyNavigationTitle:nil];
    [self setInfoView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)viewDidAppear:(BOOL)animated{
    
    //sets up nav controller
    
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.navController.navigationBarHidden = NO;
    appDelegate.navController.navigationBar.tintColor = UIColorFromRGB(0x005796);
    
    
    UIImage *plus = [UIImage imageNamed:@"plus.png"];
    NSLog(@"plus height: %f", plus.size.height);
    NSLog(@"plus width: %f", plus.size.width);
    myAddButton = [[UIBarButtonItem alloc]initWithImage:plus style:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    NSLog(@"plus height: %f", plus.size.height);
    NSLog(@"plus width: %f", plus.size.width);
    self.navigationItem.rightBarButtonItem = myAddButton;
    if ([myResultTitleLabel.text isEqualToString:@""] || [myResultTitleLabel.text isEqualToString:@"Unknown"])
        myAddButton.enabled = NO;
    
        UIImage *gear = [UIImage imageNamed:@"gear.png"];
        
        NSLog(@"gear height: %f", gear.size.height);
        NSLog(@"gear width: %f", gear.size.width);
        
        myLeftButton = [[UIBarButtonItem alloc]initWithImage:gear style:UIBarButtonSystemItemAdd target:self action:@selector(settingsButtonTapped)];
        
        NSLog(@"gear height: %f", gear.size.height);
        NSLog(@"gear width: %f", gear.size.width);

    self.navigationItem.leftBarButtonItem = myLeftButton;
    
    self.navigationItem.leftBarButtonItem = myLeftButton;
    self.title = @"AbundaScan";
}

-(void)addButtonTapped{
    
    NSLog(@"add");
    
    //if the user is logged in
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        
        //add the item to the Abundatrade calculator list
        shouldUpdateView = NO;
            NSString *urlString = [[[@"http://abundatrade.com/trade/process/request.php?action=lookup_item&product_code=" stringByAppendingString:myResultUPCLabel.text] stringByAppendingString:@"&product_qty=1&mobile_scan=true&sync_key="] stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        
        NSLog(@"%@", urlString);
            
            DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        [appDelegate.spinner startWithMessage:@"Adding to your AbundaTrade.com list..." Dimensions:CGRectMake((bounds.size.width - 200) / 2, (bounds.size.height - 125) / 2, 200, 120)];
        
            if (self.apiConnection)
            {
                [self.apiConnection cancel];
            }
            
            self.apiData = [NSMutableData dataWithCapacity:1000];
            
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            self.apiConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        
        //if it is the first time a user has added to a list, alert user to the autoscan feature
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasAddedToList"]) {
            [[[UIAlertView alloc]initWithTitle:@"Auto-Scan" message:@"If you don't like manually adding items to your list, check out our Auto-Scan feature. Each item you scan will automatically be added to your AbundaTrade.com list. You can find it in your settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil] show];
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"hasAddedToList"];
        }
            
        }
    
    //if user is not logged in, prompt them to log in
    
    else{
        [[[UIAlertView alloc]initWithTitle:@"Login Required" message:@"To add to your list, you must be logged in to your AbundaTrade.com account. Visit AbundaTrade.com to register if you don't have one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

    
}

-(void)settingsButtonTapped{
    
    //present settings view
    
    DAMSettingsViewController *settingsVC = [[DAMSettingsViewController alloc]initWithNibName:@"DAMSettingsViewController" bundle:nil];
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStyleBordered
                                   target:nil
                                   action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [appDelegate.navController pushViewController:settingsVC animated:YES];
    
    
}

-(void)loginButtonTapped{
    
    //unused method (?) to launch the log in view
    
    DAMLoginViewController *loginVC = [[DAMLoginViewController alloc] initWithNibName:@"DAMLoginViewController" bundle:nil];
    DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navController pushViewController:loginVC animated:NO];
    appDelegate.navController.navigationBarHidden = YES;
}

- (IBAction)clickMyScanButton:(id)sender {
    
    noImageLabel.hidden = YES;

    
    // present the reader controller
    [self presentViewController: reader
                            animated: YES completion:nil];
    roundedRectView.layer.backgroundColor = UIColorFromRGB(0x005796).CGColor;
    infoView.hidden = YES;
    myAddButton.enabled = NO;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Depending on the alert view loaded, perform the correct action when the button is pressed
    
    if (buttonIndex == 1 && [alertView.title isEqualToString:@"Auto-Scan"])
        [self settingsButtonTapped];
    else if (buttonIndex == 1 && [alertView.title isEqualToString:@"Loading Error"]){
        [self getProductFromServerWithNumber:symbol.data];
    }
}

- (void) imagePickerController: (UIImagePickerController*) dismissedReader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // Once a barcode has been recognized
    
    
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];

    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    //dismiss the reader view
    
    [dismissedReader dismissViewControllerAnimated:YES completion:nil];
    
    //grab the UPC Code
    
    shouldUpdateView = YES;
    NSString *upcCode = symbol.data;
    
   /* NSString *zeroChecker = [upcCode substringWithRange:NSMakeRange(0, 2)];
    
    if ([zeroChecker isEqualToString:@"00"]) {
        upcCode = [upcCode substringFromIndex:2];
    } */
    
      myResultTextView.text = upcCode;
    
    //And get the correct product from the server
    
    [self getProductFromServerWithNumber: upcCode];
    
}

-(void)getProductFromServerWithNumber: (NSString *)productNumber{
    
    
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    NSNumber *myNumericChecker = [format numberFromString:productNumber];
    
    //If the upc isn't all numeric (maybe never happens?)
    if (myNumericChecker == nil) {
        [[[UIAlertView alloc]initWithTitle:@"Invalid UPC" message:@"Please scan a valid UPC code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    //if it is all numeric
    else{
        NSString *urlString;
        
            urlString = [@"http://abundatrade.com/trade/process/request.php?product_code=" stringByAppendingString:productNumber];
        
        myResultUPCLabel.text = productNumber;
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        [appDelegate.spinner startWithMessage:@"Searching for real time prices..." Dimensions:CGRectMake((bounds.size.width - 200) / 2, (bounds.size.height - 125) / 2, 200, 120)];
        
        if (self.apiConnection)
        {
            [self.apiConnection cancel];
        }
        
        self.apiData = [NSMutableData dataWithCapacity:1000];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        self.apiConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    }
}


#pragma mark -NSURL Connections

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
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
        [[[UIAlertView alloc]initWithTitle:@"Loading Error" message:@"We encountered a loading error. Please make sure you have service, then try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Try Again?", nil] show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.apiConnection == connection)
    {
        
        DAMAppDelegate *appDelegate = (DAMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.spinner stop];
        
        if ([apiData length] && shouldUpdateView)
        {
            NSString *stringDataFromServer = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
            NSLog(@"data from server: %@", stringDataFromServer);
            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:apiData options:NSJSONReadingMutableLeaves error:nil];
            myResultTitleLabel.text = [myDict objectForKey:@"title"];
            myResultPriceLabel.text = [@"$ " stringByAppendingString:(NSString *) [myDict objectForKey:@"price"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[myDict objectForKey:@"imagel"]]];
            UIImage *myImage = [UIImage imageWithData:imageData];
            
            if ([myResultTitleLabel.text isEqualToString:@""] || [myResultTitleLabel.text isEqualToString:@"Unknown"])
                myAddButton.enabled = NO;
            else {
                myAddButton.enabled = YES;
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"autoscan"]) 
                    [self addButtonTapped];
            }
            
            [self sizeImageView:myResultImageView AndPlaceImage:myImage];
            
            
        }
    }
}

-(void)sizeImageView:(UIImageView *)view AndPlaceImage: (UIImage *)image{
    
    myResultImageView.frame = originalImageViewFrame;
    
    NSLog(@"Original Frame height: %f", myResultImageView.frame.size.height);
    NSLog(@"Original Frame width: %f", myResultImageView.frame.size.width);
    
    if (!image) {
        //display default no image text
        noImageLabel.hidden = NO;
        
    }
    else{
        
        if (image.size.height >= image.size.width) {
            double ratio = view.frame.size.height / image.size.height;
            double newHeight = view.frame.size.height;
            double newWidth = image.size.width * ratio;
            view.frame = CGRectMake( view.frame.origin.x + ( myResultImageView.frame.size.width - newWidth )/2, view.frame.origin.y, newWidth, newHeight);
        }
        else{
            double ratio = view.frame.size.width / image.size.width;
            double newWidth = view.frame.size.width;
            double newHeight = image.size.height * ratio;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + (myResultImageView.frame.size.height - newHeight )/2, newWidth, newHeight);
        }
    }
    
    NSLog(@"image frame height: %f", image.size.height);
    NSLog(@"image frame width: %f", image.size.width);
    NSLog(@"Final Frame height: %f", view.frame.size.height);
    NSLog(@"Final Frame width: %f", view.frame.size.width);
    
    myResultImageView.image = image;
    
}
@end
