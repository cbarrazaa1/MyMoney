//
//  TransactionCell.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "TransactionCell.h"

@interface TransactionCell ()
// Labels
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

// Instance Properties
@property (strong, nonatomic) Transaction* transaction;
@end

@implementation TransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateUI {
    double amt = fabs(self.transaction.amount);
    self.titleLabel.text = self.transaction.title;
    self.descLabel.text = self.transaction.desc;
    
    // set money
    char sign = '+';
    if(self.transaction.amount < 0)
    {
        sign = '-';
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%c$%.2f", sign, amt];
    
    // set date format
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d, h:mm a";
    self.dateLabel.text = [formatter stringFromDate:self.transaction.createdAt];
    
    // update background
    if(self.transaction.amount > 0)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:52/255.0 green:81/255.0 blue:58/255.0 alpha:255/255.0]];
    }
    else if(self.transaction.amount < 0)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:98/255.0 green:61/255.0 blue:61/255.0 alpha:255/255.0]];
    }
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];
}

@end
