//
//  RollLyricView.h
//  LRCTest
//
//  Created by luowenx on 2016/12/22.
//  Copyright © 2016年 xtkj_ios. All rights reserved.
//


#define AutoViewGetter(TypeName, obj) \
-(TypeName *)obj\
{\
if (!_##obj) {\
_##obj = [TypeName newAutoLayoutView];\
}\
return _##obj;\
}\

#define ObjGetter(TypeName, obj) \
-(TypeName *)obj\
{\
if (!_##obj) {\
_##obj = [TypeName new];\
}\
return _##obj;\
}\

#import <UIKit/UIKit.h>
#include "PureLayout.h"
@interface RollLyricView : UIView

@property (strong, nonatomic) NSArray *lyrics;

@end
