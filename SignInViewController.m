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

@interface SignInViewController ()
{
    Validations *validations;
}

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.signInTableView registerNib:[UINib nibWithNibName:@"EmailAddressCell" bundle:nil] forCellReuseIdentifier:@"EmailCell"];
    [self.signInTableView registerNib:[UINib nibWithNibName:@"PasswordCell" bundle:nil] forCellReuseIdentifier:@"PasswordCell"];
    [self.signInTableView registerNib:[UINib nibWithNibName:@"ForgotPasswordCell" bundle:nil] forCellReuseIdentifier:@"ForgotPasswordCell"];
    [self.signInTableView registerNib:[UINib nibWithNibName:@"SignInButtonCell" bundle:nil] forCellReuseIdentifier:@"SignInCell"];
     _signInTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
         cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak SignInViewController *weakSelf = self;
        cell.emailTextFieldActionBlock = ^{
            [weakSelf emailTextFieldAction];
        };
        return cell;
    } else if (indexPath.row == 1)
    {
       static NSString *CellIdentifier2 = @"PasswordCell";
        PasswordCell *cell = (PasswordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
         cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak SignInViewController *weakSelf = self;
        cell.passwordTextFieldActionBlock = ^{
            [weakSelf passwordTextFieldAction];
        };
        return  cell;
    }
    else if (indexPath.row == 2)
    {
       static NSString *CellIdentifier3 = @"ForgotPasswordCell";
        ForgotPasswordCell *cell = (ForgotPasswordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak SignInViewController *weakSelf = self;
        
        cell.signActionBlock = ^{
            [weakSelf signInAction];
        };
        return cell;
    }

    return nil;
}
-(void) emailTextFieldAction
{
    EmailAddressCell *emailCell = (EmailAddressCell *)[self.signInTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    emailCell.emailIDSeparatorView.backgroundColor = [UIColor colorWithRed:78.0f/255.0f green:208.0f/255.0f blue:225.0f/255.0f alpha:1];
}
-(void) passwordTextFieldAction
{
    
    PasswordCell *passwordCell = (PasswordCell *)[self.signInTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    passwordCell.passwordSeparatorView.backgroundColor = [UIColor colorWithRed:78.0f/255.0f green:208.0f/255.0f blue:225.0f/255.0f alpha:1];
    
}

-(void) signInAction
{
    validations = [[Validations alloc]init];
    EmailAddressCell *emailCell = (EmailAddressCell *)[self.signInTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PasswordCell *passwordCell = (PasswordCell *)[self.signInTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *emailID = emailCell.emailAddressTextfield.text;
    NSString *password = passwordCell.passwordTextField.text;
    
    if(![validations validateEmail:emailID])
    {
        emailCell.emailAddressLabel.text = @"Enter valid email address";
        emailCell.emailAddressLabel.textColor = [UIColor redColor];
    }
    else
    {
        emailCell.emailAddressLabel.text = @"EMAIL ADDRESS";
    }
        
   
   if(![validations validatePassword:password])
    {
        passwordCell.passwordLabel.text = @"Enter correct password";
        passwordCell.passwordLabel.textColor = [UIColor redColor];
    }
    else {
        NSLog(@"Logged In!!!");
    }
}
-(void) forgetPasswordAction
{
    ForgotPasswordViewController *viewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordVcIdentifier"];
    [self.navigationController pushViewController:viewController animated:YES];
}

        



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
