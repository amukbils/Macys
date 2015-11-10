//
//  ViewController.h
//  Macy's App
//
//  Created by Ahmed Saleh on 11/9/15.
//  Copyright (c) 2015 Ahmed Saleh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


// properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

