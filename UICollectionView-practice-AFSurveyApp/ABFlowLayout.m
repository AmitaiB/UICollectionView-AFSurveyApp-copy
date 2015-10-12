//
//  ABFlowLayout.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/12/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABFlowLayout.h"


@implementation ABFlowLayout

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
        //Create a basic flow layout that will accomodate 3 columns in portrait
    self.sectionInset = UIEdgeInsetsMake(30.0f, 80.0f, 30.0f, 20.0f);
    self.minimumInteritemSpacing = 20.0f;
    self.minimumLineSpacing = 20.0f;
    self.itemSize = kMaxItemSize;
    self.headerReferenceSize = CGSizeMake(60, 70); //<--important! default is CGSizeZero!
    
    return self;
}


#pragma mark - === Overridden Methods ===

#pragma mark - Cell Layout

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        [self applyLayoutAttributes:attributes];
    }
    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self applyLayoutAttributes:attributes];
    
    return attributes;
}

#pragma mark - Helper Methods

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes*)attributes {
//representedElementKind == nil only when the element is a Cell: perfect!
//We need to find the center point. We do so by divying up the space equally,
//and putting our cell in the center of that area.
    if (attributes.representedElementKind == nil)
    {
        CGFloat width       = [self collectionViewContentSize].width;
        CGFloat leftMargin  = [self sectionInset].left;
        CGFloat rightMargin = [self sectionInset].right;
        CGFloat availableSpace = width - (leftMargin + rightMargin);
        
        NSUInteger itemsInSection = [[self collectionView] numberOfItemsInSection:attributes.indexPath.section];
        CGFloat firstXPosition = availableSpace / (2 * itemsInSection);
        CGFloat xPosition = firstXPosition + (2 * firstXPosition * attributes.indexPath.item);
        
        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame); //To avoid 1/2-pixels.
    }
}

@end
