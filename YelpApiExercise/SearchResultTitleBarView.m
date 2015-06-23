//
//  SearchResultTitleBarView.m
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/24/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "SearchResultTitleBarView.h"
@interface SearchResultTitleBarView ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@end

@implementation SearchResultTitleBarView

- (void)awakeFromNib {
    // Initialization code
    [self.searchBarView setBackgroundImage:[UIImage new]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onFliterClicked:(id)sender {
    if (self.delegate != nil) {
        [self.delegate filterClicked:self];
    }
}

@end
