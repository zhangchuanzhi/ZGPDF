//
//  WLWebProgressLayer.h
//  WangliBank
//
//  Created by 王启镰 on 16/6/22.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_WIDTH              ([UIScreen mainScreen].bounds.size.width)

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface WYWebProgressLayer : CAShapeLayer

- (void)finishedLoad;

- (void)startLoad;

- (void)closeTimer;

@end
