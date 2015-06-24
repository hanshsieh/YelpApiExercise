//
//  SwitchCell.h
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL on;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
