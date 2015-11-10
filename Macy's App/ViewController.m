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

// property setter
- (void)setMeanings:(NSMutableArray *)meanings{
    
    // update the property
    _meanings = meanings;
    
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
    return self.meanings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get cell from storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sampleCell"];
    
    
    // adjust cell
    cell.textLabel.text = [[self.meanings objectAtIndex:indexPath.row] objectForKey:@"lf"];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

// to make things prettier, we'll disable selection (well, sort of )
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Generic Methods

// calls the acronym API using AFNetworking. Puts the
// result in self.meanings
- (void)getMeaningsForAcronym: (NSString *)acronym {
    
    // show the progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // call acronyms API asynchronously, taken from Documentation on github
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // add some acceptable response types. It will error if you don't add this line
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSDictionary *parameters = @{@"sf": acronym};
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // log result
        NSLog(@"JSON: %@", responseObject);
        
        // here's the structure
        // lfs -> array of dictionaries
        // lf = name, also list of vars
        // could create structures but for now, just query the raw results
        self.meanings = [[(NSArray*)responseObject firstObject] objectForKey:@"lfs"];
        
        // show the tableview
        self.tableView.hidden = NO;
        
        
        // hide the progress hud
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-oh!" message:@"We were not able to download teh data" delegate:nil cancelButtonTitle:@"Oh Well" otherButtonTitles:nil, nil];
        [alert show];
        
        // hide the hud
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


#pragma mark - ButtonActions
- (IBAction)searchButtonPressed:(id)sender {
    
    // hide the keyboard
    [self.textField resignFirstResponder];
    
    // get the data
    [self getMeaningsForAcronym:self.textField.text];
}



@end
