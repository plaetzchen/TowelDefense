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
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UIImageView *towelBackgroundImage;
@property (nonatomic, strong) IBOutlet UIImageView *smileyFace;
@property (nonatomic, strong) IBOutlet UIImageView *yayText;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIView *playerOneTargetPatternView;
@property (nonatomic ,strong) IBOutlet UIView *playerTwoTargetPatternView;
@property (nonatomic, strong) IBOutlet UILabel *playerOneTargetTapsLabel;
@property (nonatomic, strong) IBOutlet UILabel *playerTwoTargetTapsLabel;
@property (nonatomic, strong) IBOutlet UIImageView *playerOneTargetPatternImageView;
@property (nonatomic, strong) IBOutlet UIImageView *playerTwoTargetPatternImageView;
@property (nonatomic, strong) NSArray *patternTypes;
@property (nonatomic) BOOL playing;
@property (nonatomic, strong) NSMutableArray *touchedPatternsPlayerOne;
@property (nonatomic, strong) NSMutableArray *touchedPatternsPlayerTwo;
@property (nonatomic) int numberOfTouchedCellsRequired;
@property (nonatomic) NSString *targetPatternPlayerOne;
@property (nonatomic) NSString *targetPatternPlayerTwo;
@property (nonatomic) int scoreStatus;

- (IBAction)startButtonAction:(id)sender;
@end

#define NUMBER_OF_CELLS NUMBER_OF_ROWS * NUMBER_OF_COLUMNS
#define NUMBER_OF_ROWS 4
#define NUMBER_OF_COLUMNS 5
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

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
    
    self.touchedPatternsPlayerOne = [NSMutableArray array];
    self.touchedPatternsPlayerTwo = [NSMutableArray array];
    [self.towelCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.towelCollectionView setScrollEnabled:NO];
    self.playerOneTargetPatternView.transform = CGAffineTransformRotate(_playerOneTargetPatternView.transform, RADIANS(90));
    self.playerTwoTargetPatternView.transform = CGAffineTransformRotate(_playerTwoTargetPatternView.transform, RADIANS(270));
    [self setScoreStatus:0];
    
    self.smileyFace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile"]];
    self.yayText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yay"]];
    
    [self.view addSubview:self.smileyFace];
    [self.smileyFace setAlpha:0.0];
    
    [self.view addSubview:self.yayText];
    [self.yayText setAlpha:0.0];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _patternTypes.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (TowelPatternCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TowelPatternCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    NSString *patternName = self.patternTypes[indexPath.row];
    
    cell.delegate = self;
    
    [cell.patternImageView setImage:[UIImage imageNamed:patternName]];
    return cell;
}

# pragma mark - TowelPatternCellDelegate

- (void)towelPatternCellDidChangeTouchState:(TowelPatternCell *)cell {
    if (_playing){
        NSIndexPath *indexPathForCell = [self.towelCollectionView indexPathForCell:cell];
        NSString *patternForCell = [self.patternTypes objectAtIndex:indexPathForCell.row];
        NSLog(@"pattern touched %@",patternForCell);
        if ([patternForCell isEqualToString:self.targetPatternPlayerOne]) {
            if (cell.touched){
                [self.touchedPatternsPlayerOne addObject:patternForCell];
            } else {
                [self.touchedPatternsPlayerOne removeObject:patternForCell];
            }
        }
        if ([patternForCell isEqualToString:self.targetPatternPlayerTwo]) {
            if (cell.touched){
                [self.touchedPatternsPlayerTwo addObject:patternForCell];
            }else {
                [self.touchedPatternsPlayerTwo removeObject:patternForCell];
            }
        }
        if (self.touchedPatternsPlayerOne.count == self.numberOfTouchedCellsRequired){
            self.playing = NO;
            NSLog(@"player one won!");
            [self setScoreStatus:_scoreStatus+1];
            if(abs(self.scoreStatus) != 3){
                [self performSelector:@selector(resetRound) withObject:nil afterDelay:1];
            }
        }
        if (self.touchedPatternsPlayerTwo.count == self.numberOfTouchedCellsRequired){
            self.playing = NO;
            NSLog(@"player two won!");
            [self setScoreStatus:_scoreStatus-1];
            if(abs(self.scoreStatus) != 3){
                [self performSelector:@selector(resetRound) withObject:nil afterDelay:1];
            }
        }
    }
}

- (BOOL)towelPatternCellIsCellTappable:(TowelPatternCell *)cell {
    return self.playing;
}

# pragma mark - Animations

- (void)moveBackground{
    
    //[UIView beginAnimations:@"MoveBackground" context:nil];
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.backgroundImage setFrame:CGRectMake(-512 + (self.scoreStatus * 160), self.backgroundImage.frame.origin.y, self.backgroundImage.frame.size.width, self.backgroundImage.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Animation done");
                     }];
    //[UIView commitAnimations];
}

- (void)pullTowel{
    
    NSLog(@"PULLING THE TOWEL");
    
    [self.towelCollectionView setAlpha:0];
    [UIView animateWithDuration:2.0
                          delay:5.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.towelBackgroundImage setFrame:CGRectMake(self.towelBackgroundImage.frame.origin.x + self.scoreStatus * -150, self.towelBackgroundImage.frame.origin.y, self.towelBackgroundImage.frame.size.width, self.towelBackgroundImage.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         [self drawEndScreenObjects];
                         [self performSelector:@selector(resetGame) withObject:nil afterDelay:3];
                     }];
}

- (void)resetTowel
{
    [self.towelBackgroundImage setFrame:CGRectMake(79, self.towelBackgroundImage.frame.origin.y, self.towelBackgroundImage.frame.size.width, self.towelBackgroundImage.frame.size.height)];
}

- (void)drawEndScreenObjects{
    
    if(self.scoreStatus < 0){
        [self.smileyFace setFrame:CGRectMake(self.view.frame.size.width - 100,334, self.smileyFace.frame.size.width, self.smileyFace.frame.size.height)];
        self.smileyFace.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        self.yayText.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [self.yayText setFrame:CGRectMake(256,340, self.yayText.frame.size.width, self.yayText.frame.size.height)];
        
    }
    else{
        [self.smileyFace setFrame:CGRectMake(100,340, self.smileyFace.frame.size.width, self.smileyFace.frame.size.height)];
        self.smileyFace.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        self.yayText.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.yayText setFrame:CGRectMake(512,340, self.yayText.frame.size.width, self.yayText.frame.size.height)];
    }
    [self.smileyFace setAlpha:1.0];
    [self.yayText setAlpha:1.0];
}

- (void)hideEndScreenObjects{
    [self.towelCollectionView setAlpha:1];
    [self.smileyFace setAlpha:0.0];
    [self.yayText setAlpha:0.0];
}

# pragma mark - Game Logics

- (void)startGame {
    [self shufflePatterns];
    #ifdef TARGET_IPHONE_SIMULATOR
    self.numberOfTouchedCellsRequired = 1;
    #else
    self.numberOfTouchedCellsRequired = 1 + (arc4random_uniform(4));
    #endif
    [self.playerOneTargetTapsLabel setText:[NSString stringWithFormat:@"%d",_numberOfTouchedCellsRequired]];
    [self.playerTwoTargetTapsLabel setText:[NSString stringWithFormat:@"%d",_numberOfTouchedCellsRequired]];
    self.targetPatternPlayerOne = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
    self.targetPatternPlayerTwo = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
    // Make shure they are not the same;
    while ([_targetPatternPlayerOne isEqualToString: _targetPatternPlayerTwo]) {
        self.targetPatternPlayerTwo = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
    }
    [self.playerOneTargetPatternImageView setImage:[UIImage imageNamed:_targetPatternPlayerOne]];
    [self.playerTwoTargetPatternImageView setImage:[UIImage imageNamed:_targetPatternPlayerTwo]];
    NSLog(@"Number of touches required %d, target pattern player one %@ target pattern player two %@",_numberOfTouchedCellsRequired,_targetPatternPlayerOne,_targetPatternPlayerTwo);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.playerOneTargetPatternView setAlpha:1.0];
        [self.playerTwoTargetPatternView setAlpha:1.0];
        [self.startButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.startButton setHidden:YES];
        
    }];
     
    [UIView animateWithDuration:0.5 delay:3 options:0 animations:^{
        [self.playerOneTargetPatternView setAlpha:0];
        [self.playerTwoTargetPatternView setAlpha:0];
        [self.towelCollectionView setAlpha:1];
     } completion:^(BOOL finished) {
         [self.playerOneTargetPatternView setHidden:YES];
         [self.playerTwoTargetPatternView setHidden:YES];
         [self setPlaying:YES];
     }];
}

- (void)resetGame {
    [self resetTowel];
    [self hideEndScreenObjects];
    [self setScoreStatus:0];
    [self resetRound];
    [self setPlaying:NO];
    [self.touchedPatternsPlayerOne removeAllObjects];
    [self.touchedPatternsPlayerTwo removeAllObjects];
}

- (void)resetRound {
    [self.touchedPatternsPlayerOne removeAllObjects];
    [self.touchedPatternsPlayerTwo removeAllObjects];
    [UIView animateWithDuration:0.5 animations:^{
        [self.towelCollectionView setAlpha:0];
    } completion:^(BOOL finished) {
            [self shufflePatterns];
            #ifdef TARGET_IPHONE_SIMULATOR
            self.numberOfTouchedCellsRequired = 1;
            #else
            self.numberOfTouchedCellsRequired = 1 + (arc4random_uniform(4));
            #endif
            [self.playerOneTargetTapsLabel setText:[NSString stringWithFormat:@"%d",_numberOfTouchedCellsRequired]];
            [self.playerTwoTargetTapsLabel setText:[NSString stringWithFormat:@"%d",_numberOfTouchedCellsRequired]];
            self.targetPatternPlayerOne = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
            self.targetPatternPlayerTwo = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
            // Make shure they are not the same;
            while ([_targetPatternPlayerOne isEqualToString: _targetPatternPlayerTwo]) {
                self.targetPatternPlayerTwo = [NSString stringWithFormat:@"pattern_%d",arc4random_uniform(NUMBER_OF_COLUMNS)];
            }
            [self.playerOneTargetPatternImageView setImage:[UIImage imageNamed:_targetPatternPlayerOne]];
            [self.playerTwoTargetPatternImageView setImage:[UIImage imageNamed:_targetPatternPlayerTwo]];
            NSLog(@"Number of touches required %d, target pattern player one %@ target pattern player two %@",_numberOfTouchedCellsRequired,_targetPatternPlayerOne,_targetPatternPlayerTwo);

    }];
    [self.playerOneTargetPatternView setAlpha:0];
    [self.playerTwoTargetPatternView setAlpha:0];
    [self.playerOneTargetPatternView setHidden:NO];
    [self.playerTwoTargetPatternView setHidden:NO];
    [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
        [self.playerOneTargetPatternView setAlpha:1.0];
        [self.playerTwoTargetPatternView setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.5 delay:3 options:0 animations:^{
        [self.playerOneTargetPatternView setAlpha:0];
        [self.playerTwoTargetPatternView setAlpha:0];
        [self.towelCollectionView setAlpha:1];
    } completion:^(BOOL finished) {
        [self.playerOneTargetPatternView setHidden:YES];
        [self.playerTwoTargetPatternView setHidden:YES];
        [self setPlaying:YES];
    }];

}

- (void)shufflePatterns {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:_patternTypes];
    
    for(int i = (int)[temp count]; i > 1; i--) {
        int j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
//        for (int i = 0; i < NUMBER_OF_CELLS; i++){
//            int oldIndex = i;
//            int newIndex = (int)[temp indexOfObject:_patternTypes[i]];
//            [self.towelCollectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:oldIndex inSection:0] toIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]];
//        }
    
        self.patternTypes = [NSArray arrayWithArray:temp];
    [self.towelCollectionView reloadData];
}

- (void)setScoreStatus:(int)scoreStatus {
    _scoreStatus = scoreStatus;
    NSLog(@"Score %d",scoreStatus);
    [self moveBackground];
    
    if(abs(self.scoreStatus) == 3)
    {
        [self pullTowel];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(146, 146);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

# pragma mark - IBActions

- (IBAction)startButtonAction:(id)sender {
    [self startGame];
}



@end
