//
//  SummaryViewController.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "SummaryViewController.h"
#import "Transaction.h"
#import "AppDelegate.h"

@interface SummaryViewController ()
// Labels
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashTransactionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankTransactionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTransactionsLabel;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchTransactions];
}

- (void)fetchTransactions {
    PFQuery* query = [PFQuery queryWithClassName:@"Transaction"];
    query.limit = 1000;
    [query whereKey:@"userID" equalTo:[PFUser currentUser].objectId];
    
    // process request
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   double cash = 0, bank = 0, total = 0;
                   int cashTransactions = 0, bankTransactions = 0, totalTransactions = 0;
                   
                   for(Transaction* transaction in objects)
                   {
                       if([transaction.category isEqualToString:@"cash"])
                       {
                           cashTransactions++;
                           cash += transaction.amount;
                       }
                       else if([transaction.category isEqualToString:@"bank"])
                       {
                           bankTransactions++;
                           bank += transaction.amount;
                       }
                   }
                   
                   // if below 0, just set to 0
                   if(cash < 0)
                   {
                       cash = 0;
                   }
                   
                   if(bank < 0)
                   {
                       bank = 0;
                   }
                   
                   // set total
                   total = cash + bank;
                   totalTransactions = cashTransactions + bankTransactions;
                   
                   // update UI
                   self.cashLabel.text = [NSString stringWithFormat:@"$%.2f", cash];
                   self.cashTransactionsLabel.text = [NSString stringWithFormat:@"# of transactions: %i", cashTransactions];
                   self.bankLabel.text = [NSString stringWithFormat:@"$%.2f", bank];
                   self.bankTransactionsLabel.text = [NSString stringWithFormat:@"# of transactions: %i", bankTransactions];
                   self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
                   self.totalTransactionsLabel.text = [NSString stringWithFormat:@"# of transactions: %i", totalTransactions];
               }
               else
               {
                   NSLog(@"Error getting summary info.");
               }
           }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutClicked:(id)sender {
    // logout
    [PFUser logOutInBackground];
    
    // go back to login screen
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    delegate.window.rootViewController = viewController;
}

@end
