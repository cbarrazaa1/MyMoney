//
//  TransactionCell.h
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionCell : UITableViewCell
// Instance Methods //
- (void)setTransaction:(Transaction*)transaction;
@end
