//
//  ViewController.m
//  Macy's App
//
//  Created by Ahmed Saleh on 11/9/15.
//  Copyright (c) 2015 Ahmed Saleh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/* private variables */

// Holds the meanings returned by the web API
@property (nonatomic, strong)  NSMutableArray *meanings;

@end

@implementation ViewController

- (void)setMeanings:(NSMutableArray *)meanings{
    
    // every time  this array changes,
    // reflect that on the tableview
    [self.tableView reloadData];
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide the tableview, only show tableview when there ar suggestions, looks pretty
    self.tableView.hidden = YES;
    
    // tableview settings
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // initialize meaningsArray
    self.meanings = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get cell from storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sampleCell"];
    
    
    // adjust cell
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark -  UITextFieldDelegate

#pragma mark - Generic Methods

// calls the acronym API using AFNetworking. Puts the
// result in self.meanings
- (void)getMeaningsForAcronym: (NSString *)acronym {
    
    // call acronyms API asynchronously, taken from Documentation on github
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"sf": acronym};
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // log result
        NSLog(@"JSON: %@", responseObject);
        
        //
        
        // show the tableview
        self.tableView.hidden = YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - ButtonActions
- (IBAction)searchButtonPressed:(id)sender {
    [self getMeaningsForAcronym:self.textField.text];
}



@end
