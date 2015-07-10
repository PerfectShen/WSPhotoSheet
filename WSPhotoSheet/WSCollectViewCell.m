//
//  WSCollectViewCell.m
//  wangshen
//
//  Created by yunboy on 15/6/16.
//  Copyright (c) 2015年 yunboy. All rights reserved.
//

#import "WSCollectViewCell.h"

@implementation WSCollectViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self _setSubViews];
        
    }
    
    return self;
}


- (void)_setSubViews{
    
    self.aImageView = [[UIImageView alloc] init];
    self.aImageView.userInteractionEnabled = YES;
    [self addSubview:self.aImageView];
    
    self.aIcon = [[UIView alloc] init];
    self.aIcon.backgroundColor = [UIColor blackColor];
    [self addSubview:self.aIcon];
}
- (void)setAIsSelect:(BOOL)aIsSelect{
    
    _aIsSelect = aIsSelect;
    
    if (_aIsSelect == YES) {
        
        self.aIcon.backgroundColor = [UIColor redColor];
    }else{
        
        self.aIcon.backgroundColor = [UIColor grayColor];
    }
    
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.aImageView.frame = self.bounds;
    self.aIcon.frame = CGRectMake(CGRectGetWidth(self.frame) - 20, 20, 15, 15);
    
}

@end
