//
//  ABCollectionViewController.m
//  UICollectionView-practice-AFSurveyApp
//
//  Created by Amitai Blickstein on 10/11/15.
//  Copyright © 2015 Amitai Blickstein, LLC. All rights reserved.
//

#import "ABCollectionViewController.h"

    //Views
#import "ABCollectionHeaderView.h"
#import "ABCollectionViewCell.h"

    //Models
#import "ABPhotoModel.h"
#import "ABSectionModel.h"

#import "ABFlowLayout.h"

@interface ABCollectionViewController (Private)

    //Don't worry about this, just sets up the data.
-(void)setupModel;

@end

@implementation ABCollectionViewController {
        //Array of section objects
    NSArray *selectionModelArray;
        //Our current index within the sectionModelArray
    NSUInteger currentModelArrayIndex;
        //Whether or not we've completed the survey
    BOOL isFinished;
    
        //DEBUG:
    NSMutableArray *sizesRecord;
}

static NSString *CellReuseIdentifier = @"CellID";
static NSString *HeaderReuseIdentifier = @"HeaderID";

    ///!!!: AF put it all in 'loadView' *and* didn't call '[super loadView]'.  Why???
    //Because it doesn't initialize without a layout...?
-(void)loadView {
//    [super loadView];

    sizesRecord = [NSMutableArray new];
    
        //Create our view
        //Create a basic flow layout that will accomodate 3 columns in portrait
    ABFlowLayout *surveyFlowLayout = [ABFlowLayout new];

        //Create a new collection view with our flow layout and set ourself as delegate and data source
    UICollectionView *surveyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:surveyFlowLayout];
    surveyCollectionView.dataSource = self;
    surveyCollectionView.delegate = self;
    
        // Register classes
    [surveyCollectionView registerClass:[ABCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    [surveyCollectionView registerClass:[ABCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifier];
    
        //Set up the collection view geometry to cover the whole screen in any orientation and other view properties
    surveyCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    surveyCollectionView.opaque = NO;
    surveyCollectionView.backgroundColor = [UIColor clearColor];
    
        //Finally, set our collectionView to the one we have been tinkering with.
    self.collectionView = surveyCollectionView;
    
        //Set up our model
    [self setupModel];
    
        //We start at zero
    currentModelArrayIndex = 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        //Return the smallest of either our curent model index plus one, or our total number of sections.
        //This will show 1 section when we only want to display section zero, etc.
        //It will prevent us from returning 11 when we only have 10 sections.
    return MIN(currentModelArrayIndex + 1, selectionModelArray.count);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        //Return the number of photos in the section model
    return [[selectionModelArray[currentModelArrayIndex] photoModels] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ABCollectionViewCell *cell = (ABCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark -
#pragma mark - === UICollectionViewDelegateFlowLayout Methods ===

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        //!!!: Librarius!
        //Provides a different size for each individual cell
    
        //Grab the photo model for the cell
    ABPhotoModel *photoModel = [self photoModelForIndexPath:indexPath];
    
        //Determine the size and aspect ration for the model's image
    CGSize photoSize = photoModel.image.size;
    CGFloat aspectRatio = photoSize.width / photoSize.height;
    
        //Start out with the detail image size of the maximum size
    CGSize itemSize = kMaxItemSize;
    
    if (aspectRatio < 1) {
            //The photo is taller than it is wide, so constrain the width
        itemSize = CGSizeMake(kMaxItemSize.width * aspectRatio, kMaxItemSize.height);
    }
    else if (aspectRatio > 1) {
            //The photo is wider than it is tall, so constrain the height
        itemSize = CGSizeMake(kMaxItemSize.width, kMaxItemSize.height / aspectRatio);
    }
    
    return itemSize;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == currentModelArrayIndex && !isFinished;
}

#pragma mark Tap and Hold Gesture

-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[self photoModelForIndexPath:indexPath].name];
    }
}

#pragma mark Header
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        //Provides a view for the headers in the collection view
    
    ABCollectionHeaderView *headerView = (ABCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
            //If this is the first header, display a prompt to the user
        [headerView setText:@"Tap on a photo to start the recommendation fakerai"];
    }
    else if (indexPath.section <= currentModelArrayIndex)
    {
            //Otherwise, display a prompt using the selected photo from the previous section
        ABSectionModel *sectionModel = selectionModelArray[indexPath.section - 1];

        NSIndexPath *selectedPhotoIndex = [NSIndexPath indexPathForItem:sectionModel.selectedPhotoModelIndex inSection:indexPath.section - 1];
        ABPhotoModel *selectedPhotoModel = [self photoModelForIndexPath:selectedPhotoIndex];
        
        [headerView setText:[NSString stringWithFormat:@"Because you liked %@...", selectedPhotoModel.name]];
    }
    
    return headerView;
}

#pragma mark - === Interaction ===

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        //The user has selected a cell
    
        //No matter what, deselect that cell
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
        //Set the selected photo index
    [selectionModelArray[currentModelArrayIndex] setSelectedPhotoModelIndex:indexPath.item];
    
    if (currentModelArrayIndex >= selectionModelArray.count - 1) {
            //Let's just present some dialogue so the user knows we're finished.
        
        isFinished = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Recommendation Engine" message:@"Based on your selections, we have concluded you have excellent taste in photography!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Gee, thanks (OK)" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [collectionView performBatchUpdates:^{
        currentModelArrayIndex++;
        [collectionView insertSections:[NSIndexSet indexSetWithIndex:currentModelArrayIndex]];
    } completion:^(BOOL finished) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:currentModelArrayIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }];
}

#pragma mark - Private Custom Methods

    //Handy dandy - returns the photo model at any index path
-(ABPhotoModel*)photoModelForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section >= selectionModelArray.count) return nil;
    if (indexPath.row >= [selectionModelArray[indexPath.section] photoModels].count) return nil;
    
    return [selectionModelArray[indexPath.section] photoModels][indexPath.item];
}

-(void)configureCell:(ABCollectionViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
        //Set the image for the cell
    [cell setImage:[self photoModelForIndexPath:indexPath].image];
    
        //By default, assume the cell is not disabled and unselected
    [cell setDisabled:NO];
    [cell setSelected:NO];
    
        //If the cell is not in our current last index, disable it
    if (indexPath.section < currentModelArrayIndex) {
        [cell setDisabled:YES];
        
            //If the cell was selected by the user previously, select it now
        if (indexPath.row == [selectionModelArray[indexPath.section]selectedPhotoModelIndex]) {
            [cell setSelected:YES];
        }
    }
}


@end
                                          
                                     
                                          
                                          
                                          
                                          

@implementation ABCollectionViewController (Private)

-(void)setupModel
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObjectsFromArray:@[[ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Purple Flower" image:[UIImage imageNamed:@"0.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"WWDC Hypertable" image:[UIImage imageNamed:@"1.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Purple Flower II" image:[UIImage imageNamed:@"2.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Castle" image:[UIImage imageNamed:@"3.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Skyward Look" image:[UIImage imageNamed:@"4.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Kakabeka Falls" image:[UIImage imageNamed:@"5.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Puppy" image:[UIImage imageNamed:@"6.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Thunder Bay Sunset" image:[UIImage imageNamed:@"7.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"SUnflower I" image:[UIImage imageNamed:@"8.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Sunflower II" image:[UIImage imageNamed:@"9.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"10.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Squirrel" image:[UIImage imageNamed:@"11.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Montréal Subway" image:[UIImage imageNamed:@"12.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Geometrically Intriguing Flower" image:[UIImage imageNamed:@"13.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Grand Lake" image:[UIImage imageNamed:@"17.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Spadina Subway Station" image:[UIImage imageNamed:@"15.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Staircase to Grey" image:[UIImage imageNamed:@"14.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Saint John River" image:[UIImage imageNamed:@"16.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Purple Bokeh Flower" image:[UIImage imageNamed:@"18.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Puppy II" image:[UIImage imageNamed:@"19.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Plant" image:[UIImage imageNamed:@"21.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Peggy's Cove I" image:[UIImage imageNamed:@"21.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Peggy's Cove II" image:[UIImage imageNamed:@"22.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Sneaky Cat" image:[UIImage imageNamed:@"23.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"King Street West" image:[UIImage imageNamed:@"24.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"TTC Streetcar" image:[UIImage imageNamed:@"25.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"UofT at Night" image:[UIImage imageNamed:@"26.jpg"]]]],
                                        [ABSectionModel
                                         sectionModelWithPhotoModels:@[
                                                                         [ABPhotoModel photoModelWithName:@"Mushroom" image:[UIImage imageNamed:@"27.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"Montréal Subway Selective Colour" image:[UIImage imageNamed:@"28.jpg"]],
                                                                         [ABPhotoModel photoModelWithName:@"On Air" image:[UIImage imageNamed:@"29.jpg"]]]]]];

    selectionModelArray = [NSArray arrayWithArray:mutableArray];
}

@end


#undef kMaxItemSize