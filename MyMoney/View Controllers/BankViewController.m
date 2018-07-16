//
//  BankViewController.m
//  MyMoney
//
//  Created by César Francisco Barraza on 7/15/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BankViewController.h"
#import "TransactionViewController.h"
#import "Transaction.h"
#import "TransactionCell.h"
#import "AppDelegate.h"

@interface BankViewController () <UITableViewDataSource, UITableViewDelegate, TransactionViewControllerDelegate>
// Table View //
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Transaction*>* transactions;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation BankViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight:79];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // set up refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:nil action:@selector(fetchTransactions) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // fetch data
    [self fetchTransactions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"transactionSegue"])
    {
        TransactionViewController* vc = (TransactionViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
        vc.delegate = self;
        [vc setCategory:@"bank"];
        
        if([sender isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray* data = (NSMutableArray*)sender;
            Transaction* transaction = (Transaction*)data[0];
            NSIndexPath* indexPath = (NSIndexPath*)data[1];
            [vc modifyWithTransaction:transaction withIndex:(int)indexPath.row];
        }
    }
}

- (void)fetchTransactions {
    PFQuery* query = [PFQuery queryWithClassName:@"Transaction"];
    query.limit = 30;
    [query whereKey:@"userID" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"category" equalTo:@"bank"];
    [query orderByDescending:@"createdAt"];
    
    // send the request
    [query findObjectsInBackgroundWithBlock:
     ^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if(error == nil)
         {
             self.transactions = (NSMutableArray*)objects;
         }
         else
         {
             NSLog(@"Error trying to get bank transactions.");
         }
         
         [self.tableView reloadData];
         [self.refreshControl endRefreshing];
     }
     ];
}

- (void)didAddTransaction:(Transaction*)transaction {
    [self.transactions insertObject:transaction atIndex:0];
    [self.tableView reloadData];
}

- (void)didModifyTransaction:(Transaction*)transaction withIndex:(int)index {
    [self.transactions removeObjectAtIndex:index];
    [self.transactions insertObject:transaction atIndex:index];
    [self.tableView reloadData];
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

- (void)tryDeleteTransaction:(Transaction*)transaction {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Are you sure you want to delete this transaction?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action)
                          {
                              [transaction deleteInBackground];
                              [self.transactions removeObject:transaction];
                              [self.tableView reloadData];
                          }
                          ];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)modifyTransaction:(Transaction*)transaction index:(NSIndexPath*)index {
    NSMutableArray* data = [NSMutableArray new];
    [data addObject:transaction];
    [data addObject:index];
    [self performSegueWithIdentifier:@"transactionSegue" sender:data];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TransactionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    Transaction* transaction = self.transactions[indexPath.row];
    
    if(transaction != nil)
    {
        [cell setTransaction:transaction];
    }
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<UIContextualAction*>* actions = [NSMutableArray new];
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete"
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                        {
                                            [self tryDeleteTransaction:self.transactions[indexPath.row]];
                                        }
                                        ];
    [deleteAction setBackgroundColor:[UIColor colorWithRed:145/255.0 green:63/255.0 blue:63/255.0 alpha:255/255.0]];
    
    
    UIContextualAction* editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Modify"
                                                                           handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                      {
                                          [self modifyTransaction:self.transactions[indexPath.row] index:indexPath];
                                      }
                                      ];
    [editAction setBackgroundColor:[UIColor colorWithRed:56/255.0 green:60/255.0 blue:65/255.0 alpha:255/255.0]];
    
    [actions addObject:deleteAction];
    [actions addObject:editAction];
    UISwipeActionsConfiguration* config = [UISwipeActionsConfiguration configurationWithActions:actions];
    return config;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactions.count;
}
@end
