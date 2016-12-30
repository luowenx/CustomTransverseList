//
//  RollLyricCell.m
//  LRCTest
//
//  Created by luowenx on 2016/12/22.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import "RollLyricCell.h"
#import "PureLayout.h"
@implementation RollLyricCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lyricLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_lyricLabel];
        _lyricLabel.backgroundColor = [UIColor orangeColor];
        [_lyricLabel autoCenterInSuperview];
        _lyricLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}



@end
