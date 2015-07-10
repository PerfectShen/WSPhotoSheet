//
//  WSPhotoSheet.m
//  wangshen
//
//  Created by yunboy on 15/6/16.
//  Copyright (c) 2015年 yunboy. All rights reserved.
//


#define KWSBackViewHeight 260
#define KButtonHeight 40
#define KCollectionViewHeight 120
#define KSpace 2


#import "WSPhotoSheet.h"
#import "WSCollectViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>


static NSString *cellidentifier = @"cellItem";


@interface WSPhotoSheet ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIView *wsBackView;
@property (nonatomic,strong) UIButton *wsCancelButton;
@property (nonatomic,strong) UIButton *wsFirstButton;
@property (nonatomic,strong) UIButton *wsSecondButton;
@property (nonatomic,strong) UICollectionView *wsCollectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imageArray;

//@property (nonatomic,strong) NSMutableArray *selectIndexPaths;


@end

@implementation WSPhotoSheet

- (instancetype)initWithFrame:(CGRect)frame{
 
    if (self = [super initWithFrame:frame]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        //self.backgroundColor = [UIColor grayColor];
        self.dataArray  = [NSMutableArray array];
//        self.selectIndexPaths = [NSMutableArray array];
        [self _getImages];
        [self _setSubViews];
        
        
        
    }

    return self;
}


- (void)_setSubViews{
    
    [self addTarget:self action:@selector(_hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.wsBackView];
    [self.wsBackView addSubview:self.wsCancelButton];
    [self.wsBackView addSubview:self.wsFirstButton];
    [self.wsBackView addSubview:self.wsSecondButton];
    [self.wsBackView addSubview:self.wsCollectionView];
    [self.wsCancelButton addTarget:self action:@selector(_hidden) forControlEvents:UIControlEventTouchUpInside];
    [self.wsFirstButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

#pragma mark -- public function -- 
- (void)show{
    
    UIWindow *aWindow = [UIApplication sharedApplication].keyWindow;
    [aWindow addSubview:self];
    
    [self _show];
    
}


#pragma mark -- getter --- 
- (UIView *)wsBackView{
    
    if (!_wsBackView) {
        
        _wsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), KWSBackViewHeight)];
        _wsBackView.backgroundColor = [UIColor clearColor];
    }
    
    return _wsBackView;
}

- (UIButton *)wsCancelButton{
    
    if (!_wsCancelButton) {
        _wsCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(self.wsBackView.frame) - KButtonHeight - 10, CGRectGetWidth(self.frame) - 20, KButtonHeight)];
        _wsCancelButton.layer.cornerRadius = 5;
        [_wsCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_wsCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _wsCancelButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _wsCancelButton;
}

- (UIButton *)wsFirstButton{
    
    if (!_wsFirstButton) {
        _wsFirstButton  = [[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(self.wsBackView.frame) - (KButtonHeight +  10) * 2, CGRectGetWidth(self.frame) - 20, KButtonHeight)];
        _wsFirstButton.layer.cornerRadius = 5;
        [_wsFirstButton setTitle:@"相册" forState:UIControlStateNormal];
        [_wsFirstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _wsFirstButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _wsFirstButton;
}

- (UIButton *)wsSecondButton{
    
    if (!_wsSecondButton) {
        _wsSecondButton = [[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(self.wsBackView.frame) - (KButtonHeight + 10) * 2 - KButtonHeight - KSpace, CGRectGetWidth(self.frame) - 20, KButtonHeight)];
        _wsSecondButton.layer.cornerRadius = 5;
        [_wsSecondButton setTitle:@"发送" forState:UIControlStateNormal];
        [_wsSecondButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _wsSecondButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _wsSecondButton;

}

- (UICollectionView *)wsCollectionView{
    
    if (!_wsCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _wsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(10,CGRectGetHeight(self.wsBackView.frame) - (KButtonHeight +  10) * 2 - KButtonHeight - KSpace - KCollectionViewHeight, CGRectGetWidth(self.frame) - 20, KCollectionViewHeight) collectionViewLayout:layout];
        [_wsCollectionView registerClass:[WSCollectViewCell class] forCellWithReuseIdentifier:cellidentifier];
        _wsCollectionView.delegate = self;
        _wsCollectionView.dataSource = self;
        _wsCollectionView.showsHorizontalScrollIndicator = NO;
        _wsCollectionView.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return _wsCollectionView;
}


#pragma mark -- private function -- 
- (void)_show{
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.wsBackView.transform = CGAffineTransformMakeTranslation(0, -KWSBackViewHeight);
        
    } completion:^(BOOL finished) {
       
        [self.wsCollectionView reloadData];
    }];
    
}

- (void)_hidden{
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.wsBackView.transform = CGAffineTransformMakeTranslation(0, 0);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

    
}

- (void)_getImages{
    
    [self.dataArray removeAllObjects];
    // [fullImages removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
//                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
//                    NSString *fileName = result.defaultRepresentation.filename;
                    //  NSString *fullUrl =
                    //图片的url
                    // NSLog(@" %@",result.defaultRepresentation.filename);
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                            //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    UIImage *image  = [UIImage imageWithCGImage:result.thumbnail]; //result.thumbnail
                    objc_setAssociatedObject(image, @"select", @"0", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [self.dataArray addObject:image];
                    // [fileNames addObject:fileName];
                    // [self.tableView reloadData];
                    [self.wsCollectionView reloadData];
                }
            }
            
        };
        
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group == nil)
            {
                
            }
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[NSArray arrayWithArray:[g1 componentsSeparatedByString:@","]];
                NSString *g2=[[arr objectAtIndex:0]substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }
               // NSString *groupName=g2;//组的name
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
        NSLog(@"%@",self.imageArray);
    });

}

- (void)_changeSecondBtn{
    
    NSInteger count = 0;
    for (UIImage *aimge in self.dataArray) {
        
        NSString *aStr = objc_getAssociatedObject(aimge, @"select");
        if ([aStr isEqualToString:@"1"]) {
            
            count ++;
        }
    }
    
    if (count > 0 ) {
    [self.wsSecondButton setTitle:[NSString stringWithFormat:@"发送%ld张",(long)count] forState:UIControlStateNormal];
    }else{
            [self.wsSecondButton setTitle:@"发送" forState:UIControlStateNormal];
        
    }
    

}

#pragma mark - --- Action --
- (void)btnAction:(UIButton *)sender{
    
    
    NSLog(@"做一些操作");
    [self _hidden];
}


#pragma mark --- UIcollectionDataSource --- 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WSCollectViewCell *cell =(WSCollectViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    //NSString *imageName = [NSString stringWithFormat:@"image%ld.jpg",indexPath.row];
    UIImage *aImage =  [self.dataArray objectAtIndex:indexPath.row];

    cell.aImageView.image = aImage;
    NSString *aIcon = objc_getAssociatedObject(aImage, @"select");
    if ([aIcon isEqualToString:@"0"]) {
        cell.aIsSelect = NO;
    }else{
        
        cell.aIsSelect = YES;
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *imageName = [NSString stringWithFormat:@"image%ld.jpg",(long)indexPath.row];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return CGSizeMake(image.size.width/image.size.height * 150, 150);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImage *image = [self.dataArray objectAtIndex:indexPath.row];
    WSCollectViewCell *cell = (WSCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    NSString *aIcon = objc_getAssociatedObject(image, @"select");
    if ([aIcon isEqualToString:@"0"]) {
        objc_setAssociatedObject(image, @"select", @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cell.aIsSelect = YES;
    }else{
                objc_setAssociatedObject(image, @"select", @"0", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cell.aIsSelect = NO;
    }
    
    [self _changeSecondBtn];

}





@end
