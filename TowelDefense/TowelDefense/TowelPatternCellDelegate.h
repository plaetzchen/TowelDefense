//
//  TowelPatternCellDelegate.h
//  TowelDefense
//
//  Created by Philip Brechler on 24.05.14.
//  Copyright (c) 2014 Call a Nerd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TowelPatternCell;
@protocol TowelPatternCellDelegate <NSObject>

- (void)towelPatternCellDidChangeTouchState:(TowelPatternCell *)cell;
- (BOOL)towelPatternCellIsCellTappable:(TowelPatternCell *)cell;
@end
