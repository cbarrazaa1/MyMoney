//
//  Transaction.h
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>

@interface Transaction : PFObject <PFSubclassing>
// Instance Properties //
@property (strong, nonatomic, nonnull) NSString* userID;
@property (strong, nonatomic, nonnull) NSString* title;
@property (strong, nonatomic, nullable) NSString* desc;
@property (strong, nonatomic, nonnull) NSString* category; // 'cash' or 'bank'
@property (nonatomic) double amount;

// Constructors //
- (nonnull instancetype)initWithUserID:(nonnull NSString*)userID title:(nonnull NSString*)title desc:(nullable NSString*)desc category:(nonnull NSString*)category amt:(double)amt;
@end
