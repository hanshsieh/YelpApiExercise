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
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sorts;
@property (strong, nonatomic) NSMutableSet *selectedCategories;
@property (assign, nonatomic) long selectedDistance;
@property (assign, nonatomic) BOOL filterDeals;
@property (assign, nonatomic) NSInteger selectedSort;
@end

@implementation FiltersViewController

#pragma mark Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initSections];
        [self initCategories];
        [self initDistances];
        [self initSort];
        self.filterDeals = NO;
        self.selectedSort = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:nil] forCellReuseIdentifier:@"PickerCell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionId = self.sections[section][@"id"];
    if ([@"category" isEqualToString:sectionId]) {
        return self.categories.count;
    } else if ([@"distance" isEqualToString:sectionId]){
        return 1;
    } else if ([@"deals" isEqualToString:sectionId]) {
        return 1;
    } else if ([@"sort" isEqualToString:sectionId]) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionId = [self idForSection:indexPath.section];
    if ([@"category" isEqualToString:sectionId]) {
        SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        return cell;
    } else if ([@"distance" isEqualToString:sectionId]) {
        PickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
        cell.delegate = self;
        [cell reloadData];
        return cell;
    } else if ([@"deals" isEqualToString:sectionId]) {
        SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = @"Filter deals";
        cell.on = self.filterDeals;
        cell.delegate = self;
        return cell;
    } else if ([@"sort" isEqualToString:sectionId]) {
        PickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
        cell.delegate = self;
        [cell reloadData];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark Switch cell

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *sectionId = [self idForSection:indexPath.section];
    if ([@"category" isEqualToString:sectionId]) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    } else if ([@"deals" isEqualToString:sectionId]) {
        self.filterDeals = value;
    }
}

#pragma mark Picker cell

- (NSInteger)numberOfRowsInPickerCell:(PickerCell*)pickerCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:pickerCell];
    NSString *sectionId = [self idForSection:indexPath.section];
    if ([@"distance" isEqualToString:sectionId]) {
        return self.distances.count;
    } else if ([@"sort" isEqualToString:sectionId]){
        return self.sorts.count;
    } else {
        return 0;
    }
}

- (NSString*)pickerCell:(PickerCell *)pickerCell titleForRow:(NSInteger)row {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:pickerCell];
    NSString *sectionId = [self idForSection:indexPath.section];
    if ([@"distance" isEqualToString:sectionId]) {
        return self.distances[row][@"title"];
    } else if ([@"sort" isEqualToString:sectionId]) {
        return self.sorts[row][@"title"];
    } else {
        return nil;
    }
}

- (void)pickerCell:(PickerCell *)pickerCell didSelectRow:(NSInteger)row {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:pickerCell];
    NSString *sectionId = [self idForSection:indexPath.section];
    if ([@"distance" isEqualToString:sectionId]) {
        self.selectedDistance = [self.distances[row][@"distance"] integerValue];
    } else if ([@"sort" isEqualToString:sectionId]) {
        self.selectedSort = [self.sorts[row][@"value"] integerValue];
    }
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
          },
      @{
          @"id": @"deals",
          @"title": @"Filter deals"
          },
      @{
          @"id": @"sort",
          @"title": @"Sort"
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
    self.selectedDistance = -1;
}

- (void)initSort {
    self.sorts =
    @[
      @{
          @"title": @"Best matched",
          @"value": @(0)
          },
      @{
          @"title": @"Distance",
          @"value": @(1)
          },
      @{
          @"title": @"Highest rated",
          @"value": @(2)
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
    if (self.selectedDistance >= 0) {
        NSString *distanceStr = [NSString stringWithFormat:@"%ld", self.selectedDistance];
        [filters setObject:distanceStr forKey:@"radius_filter"];
    }
    if (self.filterDeals) {
        [filters setObject:@"true" forKey:@"deals_filter"];
    } else {
        [filters setObject:@"false" forKey:@"deals_filter"];
    }
    [filters setObject:@(self.selectedSort) forKey:@"sort"];
    return filters;
}


- (NSString*)idForSection:(NSInteger)section {
    return self.sections[section][@"id"];
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
