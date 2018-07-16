//
//  LoginViewController.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/14/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Helper.h"

@interface LoginViewController ()
// Views //
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

// Text Fields //
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

// Buttons //
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // set up UI
    self.usernameView.layer.cornerRadius = 4.5;
    self.usernameView.clipsToBounds = YES;
    self.passwordView.layer.cornerRadius = 4.5;
    self.passwordView.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = 5.5;
    self.loginButton.clipsToBounds = YES;
    self.signupButton.layer.cornerRadius = 5.5;
    self.signupButton.clipsToBounds = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)loginClicked:(id)sender {
    NSString* username = self.usernameText.text;
    NSString* password = self.passwordText.text;
    
    // validate info
    if([username length] <= 0 || [password length] <= 0)
    {
        [Helper showAlertWithTitle:@"Sign Up Error" withMsg:@"Please enter a username and password." sender:self];
    }
    
    // attempt to login
    [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser * _Nullable user, NSError * _Nullable error)
            {
                if(error == nil)
                {
                    // continue
                    [self performSegueWithIdentifier:@"loginSegue" sender:self];
                }
                else
                {
                    [Helper showAlertWithTitle:@"Login Error" withMsg:error.localizedDescription sender:self];
                }
            }
     ];
}

- (IBAction)signUpClicked:(id)sender {
    PFUser* user = [PFUser user];
    NSString* username = self.usernameText.text;
    NSString* password = self.passwordText.text;
    
    // validate info
    if([username length] <= 0 || [password length] <= 0)
    {
        [Helper showAlertWithTitle:@"Sign Up Error" withMsg:@"Please enter a username and password." sender:self];
    }
    
    // set user info
    user.username = username;
    user.password = password;
    
    // attempt to create user
    [user signUpInBackgroundWithBlock:
          ^(BOOL succeeded, NSError * _Nullable error)
          {
              if(succeeded)
              {
                  // continue since we are already authenticated
                  [self performSegueWithIdentifier:@"loginSegue" sender:self];
              }
              else
              {
                  [Helper showAlertWithTitle:@"Sign Up Error" withMsg:error.localizedDescription sender:self];
              }
          }
     ];
}

@end
