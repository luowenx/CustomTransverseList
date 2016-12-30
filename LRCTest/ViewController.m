//
//  ViewController.m
//  LRCTest
//
//  Created by luowenx on 2016/12/22.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "Custom.h"

#import "ClircleScrollView.h"
static NSString *cellID = @"cellid";
@interface ViewController ()<CustomViewDataSource, CustomViewDelegate>

@property (strong, nonatomic) CustomView *customView;

@property (strong, nonatomic) ClircleScrollView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.customView];
}

#pragma mark  === CustomViewDelegate
- (void)beginScrollWithCustomView:(CustomView *)customView
                         duration:(NSTimeInterval)duration
                        direction:(UISwipeGestureRecognizerDirection)direction
                     currentIndex:(NSInteger)currentIndex
{
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        // 这个需要读者去判断 currentIndex == 最后一个的情况
        [self.scrollView setContentOffset:CGPointMake((currentIndex +1) *self.view.frame.size.width, 0) animated:YES];
    }
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        // 这个需要读者去判断 currentIndex == 第一个的情况
        [self.scrollView setContentOffset:CGPointMake((currentIndex -1)*self.view.frame.size.width, 0) animated:YES];
    }
}


#pragma mark  === CustomViewDataSource
- (NSInteger)numbersInCustomView:(CustomView *)customView
{
    return 5;
}

- (CustomCell *)customView:(CustomView *)customView cellForIndex:(NSInteger)index
{
    CustomCell *cell = [customView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CustomCell alloc] initWithReuseIdentifier:cellID];
    }
    
    cell.label.text = [NSString stringWithFormat:@"%@", @(index)];
    return cell;
}

#pragma mark  =====  getter

-(CustomView *)customView
{
    if (!_customView) {
        _customView = [[CustomView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
        _customView.dataSource = self;
        _customView.delegate = self;
        _customView.backgroundColor = [UIColor lightGrayColor];
    }
    return _customView;
}

-(ClircleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ClircleScrollView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width *5, 0);
    }
    return _scrollView;
}


@end
