//
//  TowelPatternCell.h
//  TowelDefense
//
//  Created by Philip Brechler on 24.05.14.
//  Copyright (c) 2014 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TowelPatternCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *patternImageView;
@property (nonatomic) BOOL touched;
@end
