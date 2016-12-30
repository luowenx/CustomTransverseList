//
//  ClircleScrollView.m
//  LRCTest
//
//  Created by luowenx on 2016/12/29.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import "ClircleScrollView.h"

@interface ItemView : UIView

@property (strong, nonatomic) UILabel *label;


@end

@interface ClircleScrollView ()<UIScrollViewDelegate>

@end

@implementation ClircleScrollView
{
    CGFloat itemWidth;
    CGFloat itemHeight;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        itemWidth = frame.size.width;
        itemHeight = frame.size.height;
        [self createViewAndSetPosition];
        self.delegate = self;
        self.pagingEnabled = YES;
    }
    return self;
}

// 创建视图并设置位置
- (void)createViewAndSetPosition
{
    for (NSInteger index = 0; index<5; index++) {
        CGFloat X = index * itemWidth;
        ItemView *view = [[ItemView alloc] initWithFrame:CGRectMake(X, 0, itemWidth, itemHeight)];
        view.label.text = [NSString stringWithFormat:@"%@", @(index)];
        [self addSubview:view];
    }
}

@end

@implementation ItemView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:_label];
        _label.center = CGPointMake(frame.size.width *0.5, frame.size.height *0.5);
        _label.textColor = [UIColor orangeColor];
        _label.font = [UIFont systemFontOfSize:30];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor lightGrayColor];
        _label.layer.cornerRadius = 50;
        _label.layer.masksToBounds = YES;
    }
    return self;
}


@end
