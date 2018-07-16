//
//  Transaction.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
@dynamic userID, title, desc, category, amount;

+ (nonnull NSString*)parseClassName {
    return @"Transaction";
}

- (nonnull instancetype)initWithUserID:(nonnull NSString*)userID title:(nonnull NSString*)title desc:(nullable NSString*)desc category:(nonnull NSString*)category amt:(double)amt
{
    self = [super init];
    self.userID = userID;
    self.title = title;
    self.desc = desc;
    self.category = category;
    self.amount = amt;
    return self;
}
@end
