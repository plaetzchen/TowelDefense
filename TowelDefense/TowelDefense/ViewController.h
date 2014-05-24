//
//  ViewController.h
//  TowelDefense
//
//  Created by Philip Brechler on 24.05.14.
//  Copyright (c) 2014 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TowelPatternCellDelegate.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TowelPatternCellDelegate>

@end
