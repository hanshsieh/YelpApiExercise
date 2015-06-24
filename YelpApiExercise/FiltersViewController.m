//
//  FiltersViewController.m
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FiltersViewController.h"
#import "FiltersViewControllerDelegate.h"
#import "SwitchCell.h"
#import "PickerCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, PickerCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *distances;
@property (strong, nonatomic) NSMutableSet *selectedCategories;
@property (strong, nonatomic) NSArray *sections;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initSections];
        [self initCategories];
        [self initDistances];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:nil] forCellReuseIdentifier:@"PickerCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionId = self.sections[section][@"id"];
    if ([@"category" isEqualToString:sectionId]) {
        return self.categories.count;
    } else if ([@"distance" isEqualToString:sectionId]){
        //return self.distances.count;
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionId = self.sections[indexPath.section][@"id"];
    if ([@"category" isEqualToString:sectionId]) {
        SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        return cell;
    } if ([@"distance" isEqualToString:sectionId]) {
        PickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
        cell.delegate = self;
        [cell reloadData];
        return cell;
    } else {
        return nil;
    }
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

- (NSInteger)numberOfRowsInPickerCell:(PickerCell*)pickerCell {
    return 5;
}

- (NSString*)titleForRowInPickerCell:(PickerCell*)pickerCell {
    return @"Test";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initSections {
    self.sections =
    @[
      @{
          @"id": @"category",
          @"title": @"Categores"
          },
      @{
          @"id": @"distance",
          @"title": @"Distance"
          }
      ];
}

- (void)initCategories {
    self.categories =
    @[
      @{
          @"name": @"Afghan",
          @"code": @"afghani"
          },
      @{
          @"name": @"African",
          @"code": @"african"
          },
      @{
          @"name": @"American, New",
          @"code": @"newamerican"
          },
      @{
          @"name": @"American, Traditional",
          @"code": @"tradamerican"
          },
      @{
          @"name": @"Arabian",
          @"code": @"arabian"
          },
      @{
          @"name": @"Barbeque",
          @"code": @"bbq"
          }
      ];
}

- (void)initDistances {
    self.distances =
    @[
      @{
          @"title": @"Auto",
          @"distance": @(-1)
          },
      @{
          @"title": @"0.5 km",
          @"distance": @(500)
          },
      @{
          @"title": @"2 km",
          @"distance": @(2000)
          },
      @{
          @"title": @"5 km",
          @"distance": @(5000)
          },
      @{
          @"title": @"15 km",
          @"distance": @(1500)
          }
      ];
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    return filters;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
