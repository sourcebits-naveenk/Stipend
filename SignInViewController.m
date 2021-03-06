//
//  SignInViewController.m
//  Stipend
//
//  Created by Naveen Katari on 30/11/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "SignInViewController.h"
#import "EmailAddressCell.h"
#import "ForgotPasswordViewController.h"
#import "Validations.h"
#import "UserStatusViewController.h"
#import "APIClient.h"
#import "APIClient+SignInAPI.h"
#import "ActivityIndicatorView.h"
#import "UserDetails.h"
#import "UIColor+Additions.h"
#import "NetworkUtility.h"


@interface SignInViewController ()
{
    Validations *validations;
}

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UserDetails *userDetails = [UserDetails sharedUserDetails];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     self.navigationItem.title = @"Sign In";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EmailAddressCell" bundle:nil] forCellReuseIdentifier:@"EmailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PasswordCell" bundle:nil] forCellReuseIdentifier:@"PasswordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ForgotPasswordCell" bundle:nil] forCellReuseIdentifier:@"ForgotPasswordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SignInButtonCell" bundle:nil] forCellReuseIdentifier:@"SignInCell"];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self setEmailTextFieldFirstResponder];
}
#pragma mark - TableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  90.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier1 = @"EmailCell";
        EmailAddressCell *cell = (EmailAddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cell.emailAddressTextfield.tag = indexPath.row;
        __weak SignInViewController *weakSelf = self;
        cell.checkEmailTextFieldLength = ^{
            [weakSelf enableDisableSignInButton];
        };
        return cell;
    } else if (indexPath.row == 1)
    {
       static NSString *CellIdentifier2 = @"PasswordCell";
        PasswordCell *cell = (PasswordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        cell.passwordTextField.tag = indexPath.row;
        __weak SignInViewController *weakSelf = self;
        cell.checkPasswordTextFieldLength = ^{
            [weakSelf enableDisableSignInButton];
        };
        return  cell;
    }
    else if (indexPath.row == 2)
    {
       static NSString *CellIdentifier3 = @"ForgotPasswordCell";
        ForgotPasswordCell *cell = (ForgotPasswordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
        
        __weak SignInViewController *weakSelf = self;
        cell.forgotPasswordBlock = ^{
            [weakSelf forgetPasswordAction];
        };
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier4 = @"SignInCell";
        SignInButtonCell *cell = (SignInButtonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
        __weak SignInViewController *weakSelf = self;
        
        cell.signActionBlock = ^{
            [weakSelf signInAction];
        };
        return cell;
    }
    return nil;
}
#pragma mark - signin button action
-(void) signInAction
{
    validations = [[Validations alloc]init];
    EmailAddressCell *emailCell = (EmailAddressCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PasswordCell *passwordCell = (PasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *emailID = emailCell.emailAddressTextfield.text;
    NSString *password = passwordCell.passwordTextField.text;
    
    //Email Validation
    if(![validations validateEmail:emailID])
    {
        emailCell.emailAddressLabel.text = @"ENTER VALID EMAIL ADDRESS";
        emailCell.emailAddressLabel.textColor = [UIColor redColor];
    }
    
   //Password validation
  else if(![validations validatePassword:password])
    {
        passwordCell.passwordLabel.text = @"ENTER CORRECT PASSWORD";
        passwordCell.passwordLabel.textColor = [UIColor redColor];
    }
    else
    {
        NSMutableDictionary *userSignInDetailsDictionary = [[NSMutableDictionary alloc]init];
        [userSignInDetailsDictionary setObject:emailCell.emailAddressTextfield.text forKey:@"emailId"];
        [userSignInDetailsDictionary setObject:passwordCell.passwordTextField.text forKey:@"password"];
        emailCell.emailAddressLabel.text = @"";
        passwordCell.passwordLabel.text =@"";
        [self getSigninResponseFromServer: @"POST" withParameters:userSignInDetailsDictionary];
    }
}
#pragma mark - connecting to server
-(void) getSigninResponseFromServer:(NSString *)method withParameters:(NSMutableDictionary *)parameters
{
    //Adding acitivity indicator when hitting the server
   ActivityIndicatorView *activityView = [[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorView" owner:self options:nil][0];
    [self.view addSubview:activityView];
    activityView.center = self.view.center;
    
    //Connecting to server and getting response back, interacting with UI is disabled
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[APIClient sharedAPIClient] loginWithUserDetails:parameters WithCompletionHandler:^(NSDictionary *responseData, NSURLResponse *response, NSError *error) {
        if ( [[responseData objectForKey:@"ErrorCode" ]  isEqualToNumber:[ NSNumber numberWithLong:0 ] ] ) {
            UserStatusViewController *userStatusVC= [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserStatusVC"];
            userStatusVC.successStatus = @"SignIn";
            [self.navigationController pushViewController:userStatusVC animated:YES];
        }
        else
        {
            ForgotPasswordCell *cell = (ForgotPasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [cell.signInStatusLabel setHidden:NO];
            cell.signInStatusLabel.text = @"NOT VALID EMAILID AND PASSWORD";
        }
        
        //After hitting the server activity indicator is hidden and interacting with UI is enabled
        NSLog(@"response data %@", responseData);
        [activityView setHidden:YES];
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        [UserDetails sharedUserDetails].userFirstName = responseData[@"firstName"];
        [UserDetails sharedUserDetails].userLastName = responseData[@"lastName"];
    }];
}
#pragma mark - additional methods
-(void) forgetPasswordAction
{
    ForgotPasswordViewController *viewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordVcIdentifier"];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void) setEmailTextFieldFirstResponder
{
    EmailAddressCell *emailCell = (EmailAddressCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [emailCell.emailAddressTextfield becomeFirstResponder];
}
-(void) enableDisableSignInButton
{
    EmailAddressCell *emailCell = (EmailAddressCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PasswordCell *passwordCell = (PasswordCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    SignInButtonCell *signInButtonCell = (SignInButtonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if ([emailCell.emailAddressTextfield.text length] != 0 && [passwordCell.passwordTextField.text length] != 0) {
        [signInButtonCell.signInButton setEnabled:YES];
        signInButtonCell.signInButton.backgroundColor = [UIColor CHActiveBlueColor];
    }
        else
        {
            [signInButtonCell.signInButton setEnabled:NO];
            signInButtonCell.signInButton.backgroundColor = [UIColor CHInactiveBlueColor];
        }
    }

@end
