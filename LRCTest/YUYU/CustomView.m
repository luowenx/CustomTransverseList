//
//  CustomView.m
//  LRCTest
//
//  Created by luowenx on 2016/12/30.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#define weakify(...)  __attribute__((objc_ownership(weak))) __typeof__(__VA_ARGS__) __VA_ARGS__##_weak_ = (__VA_ARGS__);
#define strongify(...) __attribute__((objc_ownership(strong))) __typeof__(__VA_ARGS__) __VA_ARGS__ = __VA_ARGS__##_weak_;


#import "CustomView.h"

#import "CustomCell.h"
#import "Custom.h"

struct CustomProtocolDataSource {
    BOOL number;
    BOOL cellForIndex;
};
typedef struct CustomProtocolDataSource CustomProtocolDataSource;

struct CustomProtocolDelegate {
    BOOL beginScroll;
    BOOL beginScrollDir;
    BOOL beginScrollDirAndIndex;
    BOOL scrollEnd;
};
typedef struct CustomProtocolDelegate CustomProtocolDelegate;

const NSTimeInterval customDuration = 0.5;   // 动画时间
@interface CustomView ()
@property (strong, nonatomic) NSMutableArray *cacheMuArray;
@property (strong, nonatomic) NSMutableSet *cacheMuSet;

@property (nonatomic, readwrite) NSInteger currentIndex;
@property (strong, nonatomic) NSString *identifier;

// 是否在动画
@property (assign, nonatomic) BOOL isAnimation;;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end

@implementation CustomView
{
    CGFloat sizeW;
    CGFloat sizeH;
    CGFloat bigItemW;
    CGFloat bigItemH;
    CGFloat smallItemW;
    CGFloat smallItemH;
    
    // 代理响应判断
    CustomProtocolDataSource protocolSource;
    CustomProtocolDelegate     protocolDelegate;
}
@synthesize currentIndex = _currentIndex;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self distanceWithFrame:frame];
        
        _cacheMuArray = [NSMutableArray array];
        _cacheMuSet = [NSMutableSet set];
        self.isAnimation = NO;
        self.currentIndex = 0;
        self.kProportion = 0.5;
        
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
    }
    return self;
}

- (void) cellLayout
{
    if (protocolSource.cellForIndex) {
        
        // 上一个
        NSInteger previousIndex = self.currentIndex -1;
        if (previousIndex == -1 && protocolSource.cellForIndex) {
            previousIndex = [self.dataSource numbersInCustomView:self] -1;
        }
        CustomCell *previousCell = [self.dataSource customView:self cellForIndex:previousIndex];
        [self addSubview:previousCell];
        previousCell.frame = CGRectMake(0, 0, smallItemW, smallItemH);
        previousCell.center = CGPointMake((sizeW - bigItemW)/4, smallItemH/2);
        previousCell.tag = 999;
        
        // 当前一个
        CustomCell * currentCell = [self.dataSource customView:self cellForIndex:self.currentIndex];
        [self addSubview:currentCell];
        currentCell.frame = CGRectMake(0, 0, bigItemW, bigItemH);
        currentCell.center = CGPointMake(sizeW/2, sizeH/2);
        currentCell.tag = 1000;
        
        // 下一个
        NSInteger nextIndex = self.currentIndex +1;
        if (protocolSource.cellForIndex && nextIndex == ((NSInteger)[self.dataSource numbersInCustomView:self])) {
            nextIndex = 0;
        }
        CustomCell *nextCell = [self.dataSource customView:self cellForIndex:nextIndex];
        [self addSubview:nextCell];
        nextCell.frame = CGRectMake(0, 0, smallItemW, smallItemH);
        nextCell.center = CGPointMake(sizeW - (sizeW - bigItemW)/4, smallItemH/2);
        nextCell.tag = 1001;
        
         // 加入到缓存中
        if (![self.cacheMuSet containsObject:currentCell]) {
            [self.cacheMuSet addObject:currentCell];
        }
        if (![self.cacheMuSet containsObject:previousCell]) {
            [self.cacheMuSet addObject:previousCell];
        }
        if (![self.cacheMuSet containsObject:nextCell]) {
            [self.cacheMuSet addObject:nextCell];
        }
    }
}

// 左滑
-(void) leftScrollLayout
{
    if (protocolSource.cellForIndex) {
        // 当前 cell
        CustomCell * currentCell = [self viewWithTag:1000];
        // 上一个 cell
        CustomCell *previousCell = [self viewWithTag:999];
        // 下一个 cell
        CustomCell *nextCell = [self viewWithTag:1001];
        // 在下一个cell，下面放上一个新的cell
        NSInteger newIndex = self.currentIndex +2;
        if (protocolSource.cellForIndex && newIndex == ((NSInteger)[self.dataSource numbersInCustomView:self])) {
            newIndex = 0;
        }
        if (protocolSource.cellForIndex && newIndex == ((NSInteger)[self.dataSource numbersInCustomView:self] +1)) {
            newIndex = 1;
        }
        CustomCell *newCell = [self.dataSource customView:self cellForIndex:newIndex];
        [self insertSubview:newCell belowSubview:nextCell];
        newCell.frame = CGRectMake(0, 0, smallItemW, smallItemH);
        newCell.center = CGPointMake(sizeW - (sizeW - bigItemW)/4, smallItemH/2);
        newCell.alpha = 0.0;
        
        if (![self.cacheMuSet containsObject:newCell]) { // 缓存cell
            [self.cacheMuSet addObject:newCell];
        }
        
        weakify(currentCell)weakify(previousCell)weakify(nextCell)weakify(newCell)weakify(self)
        [UIView animateWithDuration:customDuration animations:^{
            // 上一个cell透明
            previousCell_weak_.alpha = 0.0;
            // 当前cell变小, 移动到上一个的位置
            currentCell_weak_.frame = CGRectMake(0, 0, smallItemW, smallItemW);
            currentCell.center = CGPointMake((sizeW - bigItemW)/4, smallItemH/2);
            // 下一个 cell变大， 移动到中间
            nextCell_weak_.frame = CGRectMake(0, 0, bigItemW, bigItemH);
            nextCell_weak_.center = CGPointMake(sizeW/2, sizeH/2);
            // 让新的cell显示出来
            newCell_weak_.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            // 移除上一个cell
            [previousCell_weak_ removeFromSuperview];
            
            // 重置视图tag
            currentCell_weak_.tag = 999;
            nextCell_weak_.tag = 1000;
            newCell_weak_.tag = 1001;
            self_weak_.isAnimation = NO;
        }];
    }
}

// 右滑
-(void) rightScrollLayout
{
    if (protocolSource.cellForIndex) {
        // 当前 cell
        CustomCell * currentCell = [self viewWithTag:1000];
        // 上一个 cell
        CustomCell *previousCell = [self viewWithTag:999];
        // 下一个 cell
        CustomCell *nextCell = [self viewWithTag:1001];
        
        // 在上一个cell，下面放上一个新的cell
        NSInteger newIndex = self.currentIndex -2;
        if (self.currentIndex == 1 && protocolSource.number) {
            newIndex = (NSInteger)[self.dataSource numbersInCustomView:self] -1;
        }
        if (self.currentIndex == 0) {
            newIndex = (NSInteger)[self.dataSource numbersInCustomView:self] -2;
        }
        CustomCell *newCell = [self.dataSource customView:self cellForIndex:newIndex];
        [self insertSubview:newCell belowSubview:previousCell];
        newCell.frame = CGRectMake(0, 0, smallItemW, smallItemH);
        newCell.center = CGPointMake((sizeW - bigItemW)/4, smallItemH/2);
        newCell.alpha = 0.0;
        
        if (![self.cacheMuSet containsObject:newCell]) { // 缓存cell
            [self.cacheMuSet addObject:newCell];
        }
        
        weakify(currentCell)weakify(previousCell)weakify(nextCell)weakify(newCell)weakify(self)
        [UIView animateWithDuration:customDuration animations:^{
            // 上一个变大，移动中间
            previousCell_weak_.frame = CGRectMake(0, 0, bigItemW, bigItemH);
            previousCell_weak_.center = CGPointMake(sizeW/2, sizeH/2);
            // 当前cell变小, 移动到下一个的位置
            currentCell_weak_.frame = CGRectMake(0, 0, smallItemW, smallItemW);
            currentCell.center = CGPointMake(sizeW - (sizeW - bigItemW)/4, smallItemH/2);
            // 下一个 cell隐藏
            nextCell_weak_.alpha = 0.0;
            // 让新的cell显示出来
            newCell_weak_.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            // 移除下一个cell
            [nextCell_weak_ removeFromSuperview];
            
            // 重置视图tag
            currentCell_weak_.tag = 1001;
            previousCell_weak_.tag = 1000;
            newCell_weak_.tag = 999;
            self_weak_.isAnimation = NO;
        }];
    }
}

#pragma mark  ====== UISwipeGestureRecognizer
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (self.isAnimation) {
        return;
    }
    self.isAnimation = YES;
    if (protocolDelegate.beginScroll) {
        [self.delegate beginScrollWithCustomView:self duration:customDuration];
    }
    if (protocolDelegate.beginScrollDir) {
        [self.delegate beginScrollWithCustomView:self duration:customDuration direction:sender.direction];
    }
    if (protocolDelegate.beginScrollDirAndIndex) {
        [self.delegate beginScrollWithCustomView:self duration:customDuration direction:sender.direction currentIndex:self.currentIndex];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self leftScrollLayout];
        [self currentIndexAdd];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self rightScrollLayout];
        [self currentIndexReduce];
    }
    if (protocolDelegate.scrollEnd) {
        [self.delegate scrollEndWithCustomView:self currentIndex:self.currentIndex];
    }

}

#pragma mark === public

- (nullable __kindof CustomCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (isEmpty(self.identifier)) {
        self.identifier = identifier;
    }
    
    if ([identifier isEqualToString:self.identifier]) {
        // 当前 cell
        CustomCell * currentCell = [self viewWithTag:1000];
        // 上一个 cell
        CustomCell *previousCell = [self viewWithTag:999];
        // 下一个 cell
        CustomCell *nextCell = [self viewWithTag:1001];

        @autoreleasepool {
            for (CustomCell *cell in [self.cacheMuSet copy]) {
                if (![cell isEqual:currentCell] && ![cell isEqual:nextCell] && ![cell isEqual:previousCell]) {
                    cell.alpha = 1.0;
                    return cell;
                }
            }
        }
    }
    return nil;
}

#pragma mark === private

// 代替 self.currentIndex ++;
- (void)currentIndexAdd
{
    if (protocolSource.number && (NSInteger)[self.dataSource numbersInCustomView:self] == (self.currentIndex + 1)) {
        self.currentIndex = 0;
        return;
    }
    self.currentIndex ++;
}

// 代替 self.currentIndex --;
- (void)currentIndexReduce
{
    if (0 == self.currentIndex) {
        self.currentIndex = (NSInteger)[self.dataSource numbersInCustomView:self] -1;
        return;
    }
    self.currentIndex --;
}

-(void) distanceWithFrame:(CGRect)frame
{
    sizeW = frame.size.width;
    sizeH = frame.size.height;
    bigItemW = MIN(sizeW/3, sizeH);
    bigItemH = bigItemW;
    smallItemW = bigItemW * _kProportion;
    smallItemH = smallItemW;
}

#pragma mark ====  setter
-(void)setDelegate:(id<CustomViewDelegate>)delegate
{
    _delegate = delegate;
    if (delegate && [delegate respondsToSelector:@selector(beginScrollWithCustomView:duration:)]) {
        protocolDelegate.beginScroll = 1;
    }
    if (delegate && [delegate respondsToSelector:@selector(scrollEndWithCustomView:currentIndex:)]) {
        protocolDelegate.scrollEnd = 1;
    }
    if (delegate && [delegate respondsToSelector:@selector(beginScrollWithCustomView:duration:direction:)]) {
        protocolDelegate.beginScrollDir = 1;
    }
    if (delegate && [delegate respondsToSelector:@selector(beginScrollWithCustomView:duration:direction:currentIndex:)]) {
        protocolDelegate.beginScrollDirAndIndex = 1;
    }
}

-(void)setDataSource:(id<CustomViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(numbersInCustomView:)]) {
        protocolSource.number = 1;
    }
    if (dataSource && [dataSource respondsToSelector:@selector(customView:cellForIndex:)]) {
        protocolSource.cellForIndex = 1;
    }
    [self cellLayout];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self distanceWithFrame:frame];
}

-(void)setKProportion:(CGFloat)kProportion
{
    _kProportion = kProportion;
    [self distanceWithFrame:self.frame];
}

@end
