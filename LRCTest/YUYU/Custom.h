//
//  Custom.h
//  LRCTest
//
//  Created by luowenx on 2016/12/30.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//

#ifndef Custom_h
#define Custom_h

#import "CustomCell.h"
#import "CustomView.h"
//对象判空
static inline BOOL isEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


#endif /* Custom_h */
