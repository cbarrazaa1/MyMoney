//
//  TransactionViewController.h
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@protocol TransactionViewControllerDelegate
- (void)didAddTransaction:(Transaction*)transaction;
- (void)didModifyTransaction:(Transaction*)transaction withIndex:(int)index;
@end

@interface TransactionViewController : UIViewController
// Instance Properties //
@property (weak, nonatomic) id<TransactionViewControllerDelegate> delegate;

// Instance Methods //
- (void)setCategory:(NSString*)category;
- (void)modifyWithTransaction:(Transaction*)transaction withIndex:(int)index;
@end
