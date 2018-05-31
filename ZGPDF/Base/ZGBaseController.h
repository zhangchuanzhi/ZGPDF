//
//  ZGBaseController.h
//  ZGPDF
//
//  Created by offcn_zcz32036 on 2018/5/29.
//  Copyright © 2018年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGBaseController : UIViewController
@property(nonatomic,weak)MBProgressHUD *progressHUB;
/**
 创建白色导航栏(本导航栏是加阴影的导航栏)

 @param title 导航栏标题
 */
-(void)createWhiteNavBarWithTitle:(NSString*)title;

/**
 移除白色导航栏【目的是把阴影设置给重置】
 */
-(void)hideNavBarWhiteShadowOpacity;
/**
 导航栏返回按钮
 */
-(void)clickBackNav;
/**
 白色状态栏
 */
-(void)defineUIStatusBarStyleLightContent;
/**
 黑色状态栏
 */
-(void)defineUIStatusBarStyleDefault;
/**
 背景色转图片

 @param color 颜色
 @return image
 */
-(UIImage*)createImageWithColor:(UIColor*)color;
/**
 显示异常信息

 @param obj 类
 */
-(void)showException:(id)obj;
-(void)startLoading:(NSString*)text;//菊花+文字
-(void)hideLoading;//移除菊花+文字
@end
