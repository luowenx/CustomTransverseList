//
//  CustomView.h
//  LRCTest
//
//  Created by luowenx on 2016/12/30.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class CustomCell;
@protocol CustomViewDelegate;
@protocol CustomViewDataSource;

extern const NSTimeInterval customDuration;   // 动画时间
@interface CustomView : UIView

@property (weak, nonatomic) id<CustomViewDelegate> delegate;

@property (weak, nonatomic) id<CustomViewDataSource> dataSource;

- (nullable __kindof CustomCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

// 大小单元格比例，默认0.5
@property (assign, nonatomic) CGFloat kProportion;

@property (nonatomic, readonly) NSInteger currentIndex;

@end

@protocol CustomViewDelegate <NSObject>
@optional
// 开始滑动，
- (void)beginScrollWithCustomView:(CustomView *)customView duration:(NSTimeInterval)duration;
- (void)beginScrollWithCustomView:(CustomView *)customView duration:(NSTimeInterval)duration direction:(UISwipeGestureRecognizerDirection)direction;
- (void)beginScrollWithCustomView:(CustomView *)customView
                         duration:(NSTimeInterval)duration
                        direction:(UISwipeGestureRecognizerDirection)direction
                     currentIndex:(NSInteger)currentIndex;

// 滑动结束后
- (void) scrollEndWithCustomView:(CustomView *)customView currentIndex:(NSInteger)currentIndex;

@end

@protocol CustomViewDataSource <NSObject>
@required;
// 数据个数
- (NSInteger)numbersInCustomView:(CustomView *)customView;
// 当前cell显示内容
- (CustomCell *)customView:(CustomView *)customView cellForIndex:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END
