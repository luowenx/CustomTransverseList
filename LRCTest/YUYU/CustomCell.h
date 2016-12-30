//
//  CustomCell.h
//  LRCTest
//
//  Created by luowenx on 2016/12/30.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UIView

-(instancetype)initWithReuseIdentifier:(NSString*)identifier NS_DESIGNATED_INITIALIZER;

@property (strong, nonatomic, readonly) NSString *identifier;

@property (strong, nonatomic) UILabel *label;


@end
