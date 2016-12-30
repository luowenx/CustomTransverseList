//
//  CustomCell.m
//  LRCTest
//
//  Created by luowenx on 2016/12/30.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()
@property (strong, nonatomic, readwrite) NSString *identifier;

@end

@implementation CustomCell

-(instancetype)initWithReuseIdentifier:(NSString *)identifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        _identifier = identifier;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

@end
