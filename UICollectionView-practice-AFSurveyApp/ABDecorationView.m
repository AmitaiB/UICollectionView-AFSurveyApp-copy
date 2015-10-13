//
//  ABDecorationView.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/12/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABDecorationView.h"

@implementation ABDecorationView
{
    UIImageView *binderImageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    binderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binder"]];
    binderImageView.frame = CGRectMake(10, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    binderImageView.contentMode = UIViewContentModeLeft;
    binderImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:binderImageView];
    
    return self;
}

@end
