//
//  PickerCell.m
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "PickerCell.h"

@interface PickerCell () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation PickerCell

- (void)awakeFromNib {
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.delegate) {
        return [self.delegate numberOfRowsInPickerCell:self];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.delegate titleForRowInPickerCell:self];
}

- (void)reloadData {
    [self.pickerView reloadAllComponents];
}

@end
