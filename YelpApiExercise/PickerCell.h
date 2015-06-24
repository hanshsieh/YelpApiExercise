//
//  PickerCell.h
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerCell;

@protocol PickerCellDelegate
@required
- (NSInteger)numberOfRowsInPickerCell:(PickerCell*)pickerCell;
- (NSString*)pickerCell:(PickerCell*)pickerCell titleForRow:(NSInteger)row;
- (void)pickerCell:(PickerCell *)pickerCell didSelectRow:(NSInteger)row;
@end
    
@interface PickerCell : UITableViewCell
@property (weak, nonatomic) id<PickerCellDelegate> delegate;
- (void)reloadData;
@end
