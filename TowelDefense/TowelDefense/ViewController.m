//
//  ViewController.m
//  TowelDefense
//
//  Created by Philip Brechler on 24.05.14.
//  Copyright (c) 2014 Call a Nerd. All rights reserved.
//

#import "ViewController.h"
#import "TowelPatternCell.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *towelCollectionView;
@property (nonatomic, strong) IBOutlet UIView *playerOneInstructionView;
@property (nonatomic, strong) IBOutlet UIView *playerTwoInstructionView;
@property (nonatomic, strong) NSArray *patternTypes;
@end

#define NUMBER_OF_CELLS NUMBER_OF_ROWS * NUMBER_OF_COLUMNS
#define NUMBER_OF_ROWS 4
#define NUMBER_OF_COLUMNS 5
static NSString *cellIdentifer = @"TowelPatternCell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.towelCollectionView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellWithReuseIdentifier:cellIdentifer];
    NSMutableArray *patternsCache = [NSMutableArray arrayWithCapacity:NUMBER_OF_CELLS];
    for (int r = 0; r < NUMBER_OF_ROWS; r++) {
        for (int c = 0; c < NUMBER_OF_COLUMNS; c++) {
            [patternsCache addObject:[NSString stringWithFormat:@"pattern_%d",c]];
        }
    }
    self.patternTypes = [NSArray arrayWithArray:patternsCache];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _patternTypes.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (TowelPatternCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TowelPatternCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    NSString *patternName = self.patternTypes[indexPath.row];
    
    [cell.patternImageView setImage:[UIImage imageNamed:patternName]];
    return cell;
}

# pragma mark - Game Logics

- (void)shufflePatterns {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:_patternTypes];
    
    for(int i = (int)[temp count]; i > 1; i--) {
        int j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    self.patternTypes = [NSArray arrayWithArray:temp];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(164, 164);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

# pragma mark - IBActions

- (IBAction)startGameAction:(id)sender {
    [self shufflePatterns];
}
@end
