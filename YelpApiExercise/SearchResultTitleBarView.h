//
//  SearchResultTitleBarView.h
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultTitleBarView;

@protocol SearchResultTitleBarDelegate <NSObject>

@optional
- (void)filterClicked:(SearchResultTitleBarView *) view;

@end

@interface SearchResultTitleBarView : UITableViewCell
@property (weak, nonatomic) id<SearchResultTitleBarDelegate> delegate;
@end
