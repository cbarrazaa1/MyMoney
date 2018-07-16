//
//  TransactionViewController.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "TransactionViewController.h"
#import "Helper.h"

@interface TransactionViewController ()
// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *descText;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;

// Views
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *botView;

// Segmented Controls
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;

// Instance Properties //
@property (strong, nonatomic) NSString* category;

// For modifying
@property (nonatomic) BOOL isModifying;
@property (strong, nonatomic) Transaction* modifiedTransaction;
@property (nonatomic) int transactionIndex;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isModifying)
    {
        self.titleText.text = self.modifiedTransaction.title;
        self.descText.text = self.modifiedTransaction.desc;
        
        // set amount
        double amt = self.modifiedTransaction.amount;
        if(amt < 0)
        {
            self.typeSegment.selectedSegmentIndex = 1;
            [self updateBackground];
        }
        amt = fabs(amt);
        self.moneyText.text = [NSString stringWithFormat:@"%.2f", amt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCategory:(NSString*)category {
    self.isModifying = NO;
    _category = category;
}

- (void)modifyWithTransaction:(Transaction*)transaction withIndex:(int)index {
    self.isModifying = YES;
    self.modifiedTransaction = transaction;
    self.transactionIndex = index;
}

- (void)updateBackground {
    if(self.typeSegment.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentView setBackgroundColor:[UIColor colorWithRed:52/255.0 green:81/255.0 blue:58/255.0 alpha:255/255.0]];
            [self.botView setBackgroundColor:[UIColor colorWithRed:52/255.0 green:81/255.0 blue:58/255.0 alpha:255/255.0]];
            [self.topView setBackgroundColor:[UIColor colorWithRed:52/255.0 green:81/255.0 blue:58/255.0 alpha:255/255.0]];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentView setBackgroundColor:[UIColor colorWithRed:98/255.0 green:61/255.0 blue:61/255.0 alpha:255/255.0]];
            [self.botView setBackgroundColor:[UIColor colorWithRed:98/255.0 green:61/255.0 blue:61/255.0 alpha:255/255.0]];
            [self.topView setBackgroundColor:[UIColor colorWithRed:98/255.0 green:61/255.0 blue:61/255.0 alpha:255/255.0]];
        }];
    }
}

- (IBAction)confirmClicked:(id)sender {
    NSString* title = self.titleText.text;
    NSString* desc = self.descText.text;
    NSString* money = self.moneyText.text;
    double amt = [money doubleValue];
    
    // validate title and amount
    if([title length] <= 0 || [money length] <= 0)
    {
        [Helper showAlertWithTitle:@"Transaction Error" withMsg:@"Please enter a title and an amount." sender:self];
    }
    
    // validate amount sign (we always want a positive value since we can set the +/- with the segment)
    if(amt < 0)
    {
        [Helper showAlertWithTitle:@"Transaction Error" withMsg:@"Please enter only positive numbers." sender:self];
    }
    
    // now modifiy amount depending on segment
    if(self.typeSegment.selectedSegmentIndex == 1)
    {
        amt = -amt;
    }
    
    Transaction* transaction = [[Transaction alloc] initWithUserID:[PFUser currentUser].objectId title:title desc:desc category:self.category amt:amt];
    if(!self.isModifying)
    {
        // create transaction
        [transaction saveInBackgroundWithBlock:
                     ^(BOOL succeeded, NSError * _Nullable error)
                     {
                         if(succeeded)
                         {
                             [self.delegate didAddTransaction:transaction];
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }
                         else
                         {
                             NSLog(@"Failed to create transaction.");
                         }
                     }
         ];
    }
    else
    {
        // modifiy transaction
        self.modifiedTransaction.title = title;
        self.modifiedTransaction.desc = desc;
        self.modifiedTransaction.amount = amt;
        [self.modifiedTransaction saveInBackgroundWithBlock:
                                  ^(BOOL succeeded, NSError * _Nullable error)
                                  {
                                      if(succeeded)
                                      {
                                          [self.delegate didModifyTransaction:self.modifiedTransaction withIndex:self.transactionIndex];
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      else
                                      {
                                          NSLog(@"Failed to modify transaction.");
                                      }
                                  }
         ];
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)typeChanged:(id)sender {
    [self updateBackground];
}

@end
