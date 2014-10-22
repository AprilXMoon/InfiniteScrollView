//
//  ViewController.h
//  InfinityScrollView
//
//  Created by AprilXMoon on 2014/10/7.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ScrollDirection
{
    ScrollRight,
    ScrollLeft,
    
}ScrollDirecton;

@interface ViewController : UIViewController <UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
    int CenterColorIdx;
}

@property(retain,nonatomic)NSArray *ColorArray;
@property(retain,nonatomic)NSArray *ColorNameArray;
@property(assign,nonatomic)ScrollDirecton scrollDirecton;
@property(retain,nonatomic)IBOutlet UIScrollView *MainScrollView;
@property(retain,nonatomic)UIView *leftView;
@property(retain,nonatomic)UIView *centerView;
@property(retain,nonatomic)UIView *rightView;
@property(retain,nonatomic)IBOutlet UILabel *ColorNameLabel;
@end

