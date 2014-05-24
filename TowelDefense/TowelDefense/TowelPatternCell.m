//
//  TowelPatternCell.m
//  TowelDefense
//
//  Created by Philip Brechler on 24.05.14.
//  Copyright (c) 2014 Call a Nerd. All rights reserved.
//

#import "TowelPatternCell.h"

@interface TowelPatternCell ()

@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation TowelPatternCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

}

- (void)setTouched:(BOOL)touched {
    if ([self.delegate towelPatternCellIsCellTappable:self]) {
        _touched = touched;
        NSLog(@"Touched %@",touched ? @"YES" : @"NO");
        [self.delegate towelPatternCellDidChangeTouchState:self];
        [self.patternImageView setAlpha:touched ? 0.5 : 1.0];
    } else {
        [self.patternImageView setAlpha:1.0];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTouched:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTouched:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTouched:NO];
}


@end
