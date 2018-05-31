//
//  ZGBaseController.m
//  ZGPDF
//
//  Created by offcn_zcz32036 on 2018/5/29.
//  Copyright © 2018年 cn. All rights reserved.
//

#import "ZGBaseController.h"

@interface ZGBaseController ()
{
    MBProgressHUD*HUD;
}
@end

@implementation ZGBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kUIColorFromRGB(0xf5f5f5);

}

-(void)createWhiteNavBarWithTitle:(NSString *)title
{
    //设置标题
    self.navigationItem,title=title;
    //隐藏导航栏线条
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //修改导航栏色值
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //返回按钮
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_ic_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackNav)];
    //设置导航栏字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:kUIColorFromRGB(0x353535)}];
    //导航栏加载阴影
    self.navigationController.navigationBar.layer.shadowColor=[UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset=CGSizeMake(-1.56, 1.56);
    self.navigationController.navigationBar.layer.shadowOpacity=0.18f;
    self.navigationController.navigationBar.translucent=NO;
    [self defineUIStatusBarStyleDefault];
}
-(void)hideNavBarWhiteShadowOpacity
{
    //移除阴影
    self.navigationController.navigationBar.layer.shadowColor=[UIColor clearColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset=CGSizeMake(0, 0);
    self.navigationController.navigationBar.layer.shadowOpacity=0.0f;
    self.navigationController.navigationBar.translucent=YES;
}
-(void)clickBackNav
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)defineUIStatusBarStyleLightContent
{
    //白色状态栏
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}
-(void)defineUIStatusBarStyleDefault
{
    //黑色状态栏
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}
-(void)showException:(id)obj
{
    NSString*text=nil;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        text=[(NSDictionary*)obj objectForKey:@"respmsg"];
    }else if ([obj isKindOfClass:[NSString class] ])
    {
        text=(NSString*)obj;
    }
    if (text.length) {
        MBProgressHUD*hub=[[MBProgressHUD alloc]initWithView:self.view];
        hub.removeFromSuperViewOnHide=YES;
        hub.mode=MBProgressHUDModeText;
        hub.animationType=MBProgressHUDAnimationFade;
        hub.detailsLabel.text=text;
        if (IOS_VERSION>=11.0) {
            //hub的背景色
            hub.bezelView.color=[kUIColorFromRGB(0x000000)colorWithAlphaComponent:0.752];
        }else
        {
            hub.bezelView.color=[kUIColorFromRGB(0x000000)colorWithAlphaComponent:0.12];
        }
        if (IOS_VERSION >= 9.0) {
            hub.detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0f];
        }
        else {
            hub.detailsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        }
        hub.bezelView.layer.shadowRadius=1.56f;
        hub.bezelView.layer.shadowColor=kUIColorFromRGB(0xffcc01).CGColor;
        hub.bezelView.layer.shadowOpacity=0.240f;
        hub.detailsLabel.textColor=[UIColor whiteColor];//异常文字字体颜色
        [self.view addSubview:hub];
        [hub showAnimated:YES];
        [hub hideAnimated:YES afterDelay:2.0f];
    }
}
-(void)startLoading:(NSString *)text
{
    if (text!=nil) {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.bezelView.color=[kUIColorFromRGB(0x000000)colorWithAlphaComponent:0.82];
        HUD.contentColor=[[UIColor whiteColor]colorWithAlphaComponent:0.78];
        HUD.userInteractionEnabled=YES;
        HUD.mode=MBProgressHUDModeIndeterminate;
        HUD.label.text=text;
        HUD.label.textColor=[UIColor whiteColor];
        if (SCREEN_WIDTH==320) {
            HUD.offset=CGPointMake(0, -50);
        }
        if (IOS_VERSION >= 9.0) {
            HUD.label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0f];
        }
        else {
            HUD.label.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        }
        [HUD showAnimated:YES];
        HUD.removeFromSuperViewOnHide=YES;
        if (![HUD isDescendantOfView:self.view]) {
            [self.view addSubview:HUD];
        }
        [self.view bringSubviewToFront:HUD];
    }
}
-(void)hideLoading
{
    HUD.removeFromSuperViewOnHide=YES;
    if (HUD!=nil) {
        [HUD hideAnimated:YES];
    }
}
-(MBProgressHUD *)progressHUB
{
    if (!_progressHUB) {
        MBProgressHUD*hud=[[MBProgressHUD alloc]initWithView:self.view];
        hud.bezelView.color=[kUIColorFromRGB(0x000000) colorWithAlphaComponent:0.78];
        hud.contentColor=[[UIColor whiteColor]colorWithAlphaComponent:0.78];
        [self.view addSubview:hud];
        _progressHUB=hud;
    }
    [self.view bringSubviewToFront:_progressHUB];
    return _progressHUB;
}
-(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}





































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
