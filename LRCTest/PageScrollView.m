//
//  PageScrollView.m
//  LRCTest
//
//  Created by luowenx on 2016/12/28.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import "PageScrollView.h"
#import "UIImageView+AFNetworking.h"

@implementation PageScrollView
{
    CGFloat width;
    UIScrollView *scroll;
    int ant;
    
    CGFloat imageWidth;
    int count;
    
    UIImageView *endImage;
    UIButton *endButt;
    
    UILabel *dateLab;
    UILabel *textLab;
    NSArray *titleArr;
    NSArray *DateArr;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleArr = [NSArray array];
        DateArr = [NSArray array];
        
        ant = 1;
        width = self.frame.size.width/3.0;
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/6)];
        [scroll setScrollEnabled:NO];
        scroll.contentSize = CGSizeMake(width*21, SCREEN_HEIGHT/6);
        scroll.contentOffset = CGPointMake(width, 0);
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.bounces = NO;
        
        [self addSubview:scroll];
        
    }
    return self;
    
}



- (void)setArrDatawithurlImageArr:(NSMutableArray *)urlArr dateArr:(NSMutableArray *)dateArr textArr:(NSMutableArray *)textArr
{
    if (urlArr.count < 4) {
        return;
    }
    titleArr = textArr;
    DateArr = dateArr;
    
    NSMutableArray *Arr = [NSMutableArray array];
    
    for (int i = 0; i < urlArr.count +4; i ++) {
        if (i < 3) {
            
            [Arr addObject:[urlArr objectAtIndex:urlArr.count-3 + i]];
            
        }
        else if (i > 2 && i < urlArr.count+3)
        {
            [Arr addObject:[urlArr objectAtIndex:i-3]];
        }
        else if (i > urlArr.count+2 && i < urlArr.count + 4){
            
            [Arr addObject:[urlArr objectAtIndex:i - urlArr.count-3]];
            
        }
        
    }
    [self addViewwithImageArr:urlArr dateArr:dateArr textArr:textArr];
    
    [self addurlImageWithArr:Arr];
    count = (int)Arr.count;
    scroll.contentSize = CGSizeMake(width*(count+3), self.bounds.size.height-80);
}

//加载网络图片
- (void)addurlImageWithArr:(NSMutableArray *)arr
{
    
    for (int i = 0; i < arr.count; i ++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(width*i+25, 15, width-50, width-50)];
        image.tag = i ;
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageGestureClick:)];
        [image addGestureRecognizer:gesture];
        
        CGFloat imgageW = image.width/2;
        image.clipsToBounds = YES;
        image.layer.cornerRadius = imgageW;
        
        [image sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"headImg"]];
        
        if (i == 2 ) {
            
            image.frame = CGRectMake(width*i+15, 0, width-20, width-20);
            
            CGFloat imgageW = image.width/2;
            image.clipsToBounds = YES;
            image.layer.cornerRadius = imgageW;
            
            endImage = image;
            
        }
        [scroll addSubview:image];
        
    }
    [self addgesture];
    
}
- (void)imageGestureClick:(UITapGestureRecognizer *)gesture
{
    [self.delegate imageGestureClick:gesture];
}

- (void)addViewwithImageArr:(NSArray *)arr dateArr:(NSArray *)dateArr textArr:(NSArray *)textArr
{
    dateLab = [self creatLabwithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height, self.bounds.size.width, 15) text:[dateArr objectAtIndex:0] font:13];
    [self addSubview:dateLab];
    dateLab.textColor = [UIColor whiteColor];
    NSString *text = [textArr objectAtIndex:0];
    
    textLab = [self creatLabwithFrame:CGRectMake(dateLab.frame.origin.x, dateLab.frame.origin.y+dateLab.frame.size.height, dateLab.frame.size.width, self.frame.size.width/3.0) text:[textArr objectAtIndex:0] font:11];
    textLab.numberOfLines = 0;
    textLab.textColor = RGB(242, 209, 0);
    [self addSubview:textLab];
    
    CGSize size = [self getHeight:text font:nil];
    
    CGRect frame = textLab.frame;
    frame.size.height = size.height;
    textLab.frame = frame;
    
}

- (UILabel*)creatLabwithFrame:(CGRect)frame text:(NSString *)text font:(int)font
{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.text =text;
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    
    lab.font = [UIFont systemFontOfSize:font];
    
    return lab;
}

- (CGSize)getHeight:(NSString *)str font:(UIFont *)font
{
    
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [str boundingRectWithSize:CGSizeMake(300, 100) options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
    
}

- (void)buttClick:(UIButton *)butt
{
    if (endButt != butt) {
        butt.selected = YES;
        endButt.selected = NO;
        endButt = butt;
        
    }else{
        butt.selected = YES;
    }
}

- (void)addgesture
{
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(transitionPush:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [scroll addGestureRecognizer:leftswipe];
    
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(transitionPush:)];
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [scroll addGestureRecognizer:rightswipe];
    
}

- (void)animationStartWithImage:(UIImageView *)image
{
    [UIView animateWithDuration:0.2 animations:^{
        image.frame = CGRectMake(width*(ant+1)+15, 0, width-20, width-20);
        
        CGFloat imgageW = image.width/2;
        image.clipsToBounds = YES;
        image.layer.cornerRadius = imgageW;
        
        endImage.frame = CGRectMake(width*endImage.tag+25, 15, width-50, width-50);
        
        CGFloat imgageWith = endImage.width/2;
        endImage.clipsToBounds = YES;
        endImage.layer.cornerRadius = imgageWith;
        
        endImage = image;
        
    }];
    
}

- (void)transitionPush:(UISwipeGestureRecognizer *)swipe
{
    UIButton *butt = [[UIButton alloc] init];
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        ant ++;
        [scroll setContentOffset:CGPointMake(width*ant, 0) animated:YES];
        
        NSLog(@"-------*****-------    %d",ant);
        if (self.pageCount) {
            self.pageCount(ant);
        }
        if (ant == count-3) {
            scroll.contentOffset = CGPointMake(0, 0);
            ant = 1;
        }
        
        UIImageView *image = [scroll viewWithTag:ant+1];
        [self animationStartWithImage:image];
        
        
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        ant --;
        
        [scroll setContentOffset:CGPointMake(width*ant, 0) animated:YES];
        
        NSLog(@"-------#####-------    %d",ant);
        if (self.pageCount) {
            self.pageCount(ant);
        }
        if (ant == 0) {
            scroll.contentOffset = CGPointMake(width*(count-3), 0);
            ant = count-4;
        }
        
        UIImageView *image = [scroll viewWithTag:ant+1];
        [self animationStartWithImage:image];
        
    }
    butt = [self viewWithTag:ant-1+999];
    NSString *textstr = @"";
    NSString *datestr = @"";
    
    if (ant == count - 3) {
        
        butt = [self viewWithTag:999];
        textstr = [titleArr objectAtIndex:0];
        datestr = [DateArr objectAtIndex:0];
        
    }else{
        textstr = [titleArr objectAtIndex:ant-1];
        datestr = [DateArr objectAtIndex:ant-1];
    }
    [self buttClick:butt];
    
    dateLab.text = datestr;
    textLab.text = textstr;
    
    CGSize size = [self getHeight:textstr font:nil];
    
    CGRect frame = textLab.frame;
    frame.size.height = size.height;
    textLab.frame = frame;
    
}

@end
