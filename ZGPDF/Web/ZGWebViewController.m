//
//  ZGWebViewController.m
//  ZGPDF
//
//  Created by offcn_zcz32036 on 2018/5/30.
//  Copyright © 2018年 cn. All rights reserved.
//

#import "ZGWebViewController.h"
#import <WebKit/WebKit.h>
#import "WYWebProgressLayer.h"
@interface ZGWebViewController ()
<WKNavigationDelegate>
/**
 网页加载进度条
 */
@property(nonatomic,strong)WYWebProgressLayer*progressLayer;
@property(nonatomic,strong)WKWebView*webView;
@property(nonatomic,strong)UILabel*textLabel;
@end

@implementation ZGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWhiteNavBarWithTitle:@"webView显示pdf"];
    [self disPlay];
}
-(void)disPlay
{
    WKWebView*webView=[WKWebView new];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.left.right.bottom.offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    webView.navigationDelegate=self;
    webView.opaque=NO;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.backgroundColor=[UIColor clearColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kPDFURL]]];
    self.webView=webView;
    UILabel *textLabel=[[UILabel alloc]init];
    [webView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.centerX.offset(0);
        make.height.mas_equalTo(12);
    }];
    textLabel.hidden=YES;
    textLabel.textColor=[kUIColorFromRGB(0x000000)colorWithAlphaComponent:0.45];
    textLabel.text=@"网页由www.hshy.com";
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.font=[UIFont systemFontOfSize:12];
    [webView bringSubviewToFront:webView.scrollView];
    self.textLabel=textLabel;
    WYWebProgressLayer *progressLayer=[WYWebProgressLayer new];
    progressLayer.frame=CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:progressLayer];
    self.progressLayer=progressLayer;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressLayer finishedLoad];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载
    [_progressLayer startLoad];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //加载完成
    _textLabel.hidden=NO;
    [_progressLayer finishedLoad];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil]; // 禁止复制
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //网页出错
    _textLabel.hidden=NO;
    [_progressLayer finishedLoad];
    NSLog(@"网页报错信息:%@",error.localizedDescription);
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //网页出错
    [_progressLayer finishedLoad];
    NSLog(@"网页报错信息:%@",error.localizedDescription);
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url=navigationAction.request.URL;
    NSLog(@"URL:%@",url);
    NSString *scheme = [url scheme];
    NSLog(@"scheme:%@",scheme);
    decisionHandler(WKNavigationActionPolicyAllow);
}






































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
