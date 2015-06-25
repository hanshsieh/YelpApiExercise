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
#import "FiltersViewController.h"

@interface SearchResultVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSArray *businesses;
@property (strong, nonatomic) NSArray *searchedBusinesses;
@property (strong, nonatomic) NSDictionary *filters;
@property (strong, nonatomic) UISearchBar *searchBar;
- (void)fetchBusinessesWithQuery:(NSString*)query params:(NSDictionary *)params;
@end

@implementation SearchResultVC
NSString * const kYelpConsumerKey = @"DcD9CzLluNyi3DIbdKkaPw";
NSString * const kYelpConsumerSecret = @"8rTF8KMMcZpAaWe1yyEebVk7lDc";
NSString * const kYelpToken = @"DnKGwo-syhDRQSAYCW6D8WPrO9KOXIkV";
NSString * const kYelpTokenSecret = @"SeMVKcy4JQIrK4GTnyTs12pxBYE";

#pragma mark - Private methods

#pragma mark Life cycle

- (instancetype)initWithCoder:(NSCoder*) coder {
    self = [super initWithCoder:coder];
    NSLog(@"initialized with coder");
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Intialize the view
    self.filters = nil;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 0, 0)];
    self.navigationItem.titleView = searchBar;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey
                                           consumerSecret:kYelpConsumerSecret
                                           accessToken:kYelpToken
                                           accessSecret:kYelpTokenSecret];
    
    // Initialize the data
    [self fetchBusinessesWithQuery:nil params:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Search bar

//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    searchBar.text = @"";
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchStr = searchBar.text;
    [self fetchBusinessesWithQuery:searchStr params:self.filters];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        NSArray *businessesArr = response[@"businesses"];
        self.businesses = [Business parseBusinesses: businessesArr];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    NSLog(@"Query is sent");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

#pragma mark Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    Business *business = self.businesses[indexPath.row];
    cell.business = business;
    return cell;
}

- (void)onFilterButton {
    NSLog(@"Filter clicked");
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters updated: %@", filters);
    self.searchBar.text = @"";
    self.filters = filters;
    [self fetchBusinessesWithQuery:nil params:filters];
}

@end
