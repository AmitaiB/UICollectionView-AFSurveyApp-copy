//
//  ABCollectionViewCell.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABCollectionViewCell.h"

@implementation ABCollectionViewCell {
    UIImageView *imageView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
        //???: Is this archaic? When does the CGRectZero stuff work?
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self setImage:nil];
    [self setSelected:NO];
}

-(void)layoutSubviews {
    imageView.frame = CGRectInset(self.bounds, 10, 10);
}

-(void)setImage:(UIImage *)image {
    _image = image;
    
    imageView.image = image;
}

-(void)setDisabled:(BOOL)disabled {
    self.contentView.alpha = disabled ? 0.5f : 1.0f;
    self.backgroundColor = disabled ? [UIColor grayColor] : [UIColor whiteColor];
}

@end
