//
//  FBSignupViewController.m
//  DemoAfeez
//
//  Created by Developer on 16/09/14.
//  Copyright (c) 2014 Modius. All rights reserved.
//

#import "FBSignupViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

NSString *const kEmailRegularExpression = @"[A-Z0-9a-z]+[A-Z0-9a-z._]+[A-Z0-9a-z]@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

@interface FBSignupViewController (){
    UITextField *activeTextField;
}

@property (strong, nonatomic) IBOutlet UIImageView *profileImagView;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property BOOL shouldCallWebServiceFromUploadDelegate;

@end

@implementation FBSignupViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    _emailTextField.text = _fbUserData[@"email"];
    _firstNameTextField.text = _fbUserData[@"first_name"];
    _middleNameTextField.text = _fbUserData[@"middle_name"];
    _lastNameTextField.text = _fbUserData[@"last_name"];

    NSString *imageUrlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", _fbUserData[@"id"]];
    [_profileImagView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"userPlaceHolder.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated{
    //    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:110.0f/255.0f green:183.0f/255.0f blue:174.0f/255.0f alpha:1.0f]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Support
-(BOOL)checkRegisterFields {
    if ([_firstNameTextField.text length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Enter first name.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alertView show];
        [_firstNameTextField becomeFirstResponder];
        return FALSE;
    }
    
    if ([_lastNameTextField.text length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Enter last name.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alertView show];
        [_lastNameTextField becomeFirstResponder];
        return FALSE;
    }
    
    if ([_emailTextField.text length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Enter email.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alertView show];
        [_emailTextField becomeFirstResponder];
        return FALSE;
    }
    else
    {
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kEmailRegularExpression];
        if ([emailTest evaluateWithObject:_emailTextField.text] == FALSE)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Enter correct email.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
            [alertView show];
            [_emailTextField becomeFirstResponder];
            return FALSE;
        }
    }
    
    return TRUE;
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{           // became first responder
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{             // may be called if forced even if
    activeTextField = nil;
}

- (IBAction)returnTapped:(id)sender {
    UITextField *textField = (UITextField *) sender;
    [textField resignFirstResponder];
}

- (IBAction)fbSignup:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)saveButtonTouched:(id)sender {
    [self.view endEditing:YES];
}


- (UIImage *) cropImageInCircle : (UIImage *) image{
//    CGFloat scale  = [[self.profileImagView.window screen] scale];
    CGFloat radius = image.size.height / 2;
    CGPoint center = CGPointMake(image.size.width / 2, image.size.height / 2);
    
    CGRect frame = CGRectMake(center.x - radius,
                              center.y - radius,
                              radius * 2.0,
                              radius * 2.0);
    
    // temporarily remove the circleLayer
    
    // render the clipped image
    
    UIGraphicsBeginImageContextWithOptions(self.profileImagView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([self.profileImagView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        // if iOS 7, just draw it
        [self.profileImagView drawViewHierarchyInRect:self.profileImagView.bounds afterScreenUpdates:YES];
    }
    else
    {
        // if pre iOS 7, manually clip it
        CGContextAddArc(context, image.size.width / 2, image.size.height / 2, radius, 0, M_PI * 2.0, YES);
        CGContextClip(context);
        [self.profileImagView.layer renderInContext:context];
    }
    
    // capture the image and close the context
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add the circleLayer back
    
//    [self.profileImagView.layer addSublayer:circleLayer];
    
    // crop the image
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    return [UIImage imageWithCGImage:imageRef];
}


@end
