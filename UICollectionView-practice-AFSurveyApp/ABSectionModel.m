//
//  ABSelectionModel.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABSectionModel.h"

const NSUInteger ABSectionModelNoSelectionIndex = -1;

@interface ABSectionModel ()

@property (nonatomic, strong) NSArray *photoModels;

@end

@implementation ABSectionModel

+(instancetype)sectionModelWithPhotoModels:(NSArray *)photoModels {
    ABSectionModel *model = [ABSectionModel new];
    
    model.photoModels = photoModels;
    model.selectedPhotoModelIndex = ABSectionModelNoSelectionIndex;
    
    return model;
}

-(BOOL)hasBeenSelected {
    return self.selectedPhotoModelIndex != ABSectionModelNoSelectionIndex;
}

@end
