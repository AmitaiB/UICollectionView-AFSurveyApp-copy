//
//  ABCollectionHeaderView.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABCollectionHeaderView.h"

    ///A plain supplementary view that has some text (provided by the model, of course!).
@implementation ABCollectionHeaderView
{
    UILabel *textLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    textLabel                 = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 30, 10)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor       = [UIColor whiteColor];
    textLabel.font            = [UIFont boldSystemFontOfSize:20];
    [self addSubview:textLabel];
    
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self setText:@""];
}

-(void)setText:(NSString *)text {
    _text = [text copy];
    
    textLabel.text = text;
}



@end
