//
//  Helper.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/14/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (void)showAlertWithTitle:(NSString*)title withMsg:(NSString*)msg sender:(UIViewController*)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    // create actions
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    // add action and show
    [alert addAction:okAction];
    [sender presentViewController:alert animated:YES completion:nil];
}
@end
