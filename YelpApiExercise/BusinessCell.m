//
//  BusinessCell.m
//  YelpApiExercise
//
//  Created by Chu-An Hsieh on 6/23/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@end

@implementation BusinessCell
- (void)awakeFromNib {
    // Fix the auto-layout bug for text-wrapping
    //self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

/**
 * Custom setter for Business. 
 */
- (void)setBusiness:(Business *)business {
    _business = business;
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:business.imageUrl]];
    self.nameLabel.text = business.name;
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
    self.reviewLabel.text = [NSString stringWithFormat:@"%ld reviews", business.numReviews];
    self.addressLabel.text = business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", business.distance];
}

@end
