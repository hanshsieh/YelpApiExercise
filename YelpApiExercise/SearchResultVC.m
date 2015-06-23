//
//  ViewController.m
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/23/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "SearchResultVC.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "SearchResultTitleBarView.h"

@interface SearchResultVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchResultTitleBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSArray *businesses;
@end

@implementation SearchResultVC
NSString * const kYelpConsumerKey = @"DcD9CzLluNyi3DIbdKkaPw";
NSString * const kYelpConsumerSecret = @"8rTF8KMMcZpAaWe1yyEebVk7lDc";
NSString * const kYelpToken = @"DnKGwo-syhDRQSAYCW6D8WPrO9KOXIkV";
NSString * const kYelpTokenSecret = @"SeMVKcy4JQIrK4GTnyTs12pxBYE";

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.estimatedRowHeight = 200.0;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    // Setup search bar
    /*UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 310.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;*/
    SearchResultTitleBarView *searchBar = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTitleBarView" owner:self options:nil] objectAtIndex:0];
//    searchBar.delegate = self;
//    [searchBar setBackgroundImage:[UIImage new]];
    //searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        NSArray *businessesArr = response[@"businesses"];
        self.businesses = [Business parseBusinesses: businessesArr];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    Business *business = self.businesses[indexPath.row];
    cell.business = business;
    return cell;
}

- (void)filterClicked:(SearchResultTitleBarView *) view {
    NSLog(@"Filter clicked");
}

@end
