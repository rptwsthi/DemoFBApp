//
//  CLAHomeViewController.m
//  DemoAfeez
//
//  Created by Technologies33 on 27/07/14.
//  Copyright (c) 2014 Modius. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "LandingViewController.h"
#import "SVProgressHUD.h"
#import "FBSignupViewController.h"

@interface LandingViewController ()
@end

@implementation LandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)facebookLoginButtonTouched:(id)sender {
//    [sender setUserInteractionEnabled:NO];

    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         NSLog(@"error = %@", error);
         if (error) {
             
         }else{
             [self requestUserInfo];
         }
         [sender setUserInteractionEnabled:YES];
     }];
}


// ------------> Code for requesting user information starts here <------------

/*
 This function asks for the user's public profile and birthday.
 It first checks for the existence of the public_profile and user_birthday permissions
 If the permissions are not present, it requests them
 If/once the permissions are present, it makes the user info request
 */
- (void)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    //    NSArray *permissionsNeeded = @[@"public_profile"];
    
    // Request the permissions the user currently has
    [SVProgressHUD showWithStatus:NSLocalizedString(@"PLEASE_WAIT", nil) maskType:SVProgressHUDMaskTypeBlack];

    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  [self makeRequestForUserData];
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
}

- (void) makeRequestForUserData {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            [self performSegueWithIdentifier:@"SegueLoginToFBSignUp" sender:result];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", nil)];
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];
}


#pragma mark - Prepare for segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SegueLoginToFBSignUp"]) {
        FBSignupViewController *viewController = (FBSignupViewController *) [segue destinationViewController];
        viewController.fbUserData = sender;
    }
}


@end
