//
//  FBSignupViewController.h
//  DemoAfeez
//
//  Created by Developer on 16/09/14.
//  Copyright (c) 2014 Modius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

FOUNDATION_EXPORT NSString *const kEmailRegularExpression;

@interface FBSignupViewController : UIViewController<FBLoginViewDelegate>
@property (nonatomic, strong) id <FBGraphUser> fbUserData;

@end
