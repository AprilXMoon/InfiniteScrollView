//
//  ViewController.m
//  InfinityScrollView
//
//  Created by AprilXMoon on 2014/10/7.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define WIDTH_OFF_SET self.view.frame.size.width
#define HEIGHT_OFF_SET 0
#define SCROLLVIEW_WIDTH self.view.frame.size.width * 3
#define SCROLLVIEW_HEIGHT self.MainScrollView.frame.size.height
#define SET_FRAME(ARTICLEX) x = ARTICLEX.frame.origin.x + increase;\
if(x < 0) x = pageWidth *2;\
if(x >pageWidth *2) x = 0.0f;\
[ARTICLEX setFrame:CGRectMake(x, ARTICLEX.frame.origin.y,ARTICLEX.frame.size.width,ARTICLEX.frame.size.height)]

@synthesize MainScrollView = _MainScrollView;
@synthesize ColorArray = _ColorArray, ColorNameArray = _ColorNameArray;
@synthesize leftView = _leftView,centerView = _centerView,rightView = _rightView;

- (void)viewDidLoad {
    
    [self setDefaultValue];
    [self setMainScrollView];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self changeViewsSize:size];
    }];
}

#pragma mark - Setting methods
-(void)setDefaultValue
{
    self.ColorArray = [[NSArray alloc]initWithObjects:[UIColor grayColor],[UIColor greenColor],[UIColor purpleColor],[UIColor brownColor],[UIColor redColor],[UIColor whiteColor],[UIColor yellowColor],[UIColor orangeColor],nil];
    self.ColorNameArray = [[NSArray alloc]initWithObjects:@"Gray Color",@"Green Color",@"Purple Color",@"Brown Color",@"Red Color",@"White Color",@"Yellow Color",@"Orange Color", nil];
}

-(void)setMainScrollView
{
    self.MainScrollView.delegate = self;
    self.MainScrollView.pagingEnabled = NO;
    self.MainScrollView.showsHorizontalScrollIndicator = NO;
    self.MainScrollView.showsVerticalScrollIndicator = NO;
    self.MainScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    [self AddSubviewToScrollView];
    
    self.MainScrollView.contentOffset = CGPointMake(WIDTH_OFF_SET, HEIGHT_OFF_SET);
}

-(void)AddSubviewToScrollView
{
    float x,y,width,height;
    x = WIDTH_OFF_SET;
    y = HEIGHT_OFF_SET;
    width = WIDTH_OFF_SET;
    height = SCROLLVIEW_HEIGHT;
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, y, width, height)];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(x*2, y, width, height)];
    
    self.leftView.backgroundColor = [_ColorArray objectAtIndex:0];
    self.centerView.backgroundColor = [_ColorArray objectAtIndex:1];
    self.rightView.backgroundColor = [_ColorArray objectAtIndex:2];
    
    self.leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.centerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.MainScrollView addSubview:_leftView];
    [self.MainScrollView addSubview:_centerView];
    [self.MainScrollView addSubview:_rightView];
    
    CenterColorIdx = 1;
    [self changeColorName];
}

#pragma mark - UIScrollViewDelegate
-(void)allArticlesMoveRight:(CGFloat)pageWidth
{
    UIView *tempView = _rightView;
    _rightView = _centerView;
    _centerView = _leftView;
    _leftView = tempView;
    
    float increase = pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(_rightView);
    SET_FRAME(_leftView);
    SET_FRAME(_centerView);
    
    [self changeColor:_leftView CenterView:_centerView RightView:_rightView];
}

-(void)allArticleMoveLeft:(CGFloat)pageWidth
{
    UIView *tempView = _leftView;
    _leftView = _centerView;
    _centerView = _rightView;
    _rightView = tempView;
    
    float increase = -pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(_centerView);
    SET_FRAME(_rightView);
    SET_FRAME(_leftView);

    [self changeColor:_leftView CenterView:_centerView RightView:_rightView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = WIDTH_OFF_SET;

    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page == 1) {
        return;
    }else if(page == 0){
        self.scrollDirecton = ScrollRight;
        [self allArticlesMoveRight:pageWidth];
    }else{
        self.scrollDirecton = ScrollLeft;
        [self allArticleMoveLeft:pageWidth];
    }
    
    [self changeColorName];
    CGPoint Centerpoint = CGPointZero;
    Centerpoint.x = pageWidth;
    [scrollView setContentOffset:Centerpoint animated:NO];
    
}

#pragma mark - Change Component methods
-(void)changeColor:(UIView*)leftView CenterView:(UIView*)centerView RightView:(UIView*)rightView
{
    int leftIdx,centerIdx,rightIdx;

    if (self.scrollDirecton == ScrollLeft) {
        CenterColorIdx = CenterColorIdx + 1;
        
        if (CenterColorIdx >= self.ColorArray.count) {
            CenterColorIdx = 0;
        }
    }else{
        CenterColorIdx = CenterColorIdx - 1;
        if (CenterColorIdx < 0) {
            CenterColorIdx = (int)self.ColorArray.count - 1 ;
        }
    }
    
    leftIdx = (CenterColorIdx - 1 < 0) ? (int)self.ColorArray.count - 1 : CenterColorIdx -1;
    centerIdx = CenterColorIdx;
    rightIdx = (CenterColorIdx + 1 == self.ColorArray.count) ? 0 : CenterColorIdx + 1;
    
    leftView.backgroundColor = [self.ColorArray objectAtIndex:leftIdx];
    centerView.backgroundColor = [self.ColorArray objectAtIndex:centerIdx];
    rightView.backgroundColor = [self.ColorArray objectAtIndex:rightIdx];
}

-(void)changeColorName
{
    self.ColorNameLabel.text = [self.ColorNameArray objectAtIndex:CenterColorIdx];
}

-(void)changeViewsSize:(CGSize)size
{
    UIView *bottomView = [self.view viewWithTag:10];
    self.MainScrollView.contentSize = CGSizeMake(size.width * 3, size.height - bottomView.frame.size.height);
    
    self.leftView.frame = CGRectMake(0, 0, size.width, self.leftView.frame.size.height);
    self.centerView.frame = CGRectMake(size.width, 0, size.width, self.centerView.frame.size.height);
    self.rightView.frame = CGRectMake(size.width * 2, 0, size.width, self.rightView.frame.size.height);
    
    self.MainScrollView.contentOffset = CGPointMake(size.width, HEIGHT_OFF_SET);
}

@end
