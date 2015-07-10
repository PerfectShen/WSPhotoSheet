//
//  ws_PhotoSheetVC.m
//  wangshen
//
//  Created by yunboy on 15/6/16.
//  Copyright (c) 2015年 yunboy. All rights reserved.
//

#import "ws_PhotoSheetVC.h"
#import "WSPhotoSheet/WSPhotoSheet.h"

@implementation ws_PhotoSheetVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 40);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)btnAction:(UIButton *)sender{
    
    NSLog(@"点击弹出  －－ ");
    
    WSPhotoSheet *aView = [[WSPhotoSheet alloc] init];
    [aView show];
}

@end
