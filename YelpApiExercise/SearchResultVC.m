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

@interface SearchResultVC () <UITableViewDataSource, UITableViewDelegate>
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
    self.tableView.estimatedRowHeight = 200.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    NSLog(@"======%lf", UITableViewAutomaticDimension);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
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

@end
