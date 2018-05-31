//
//  ZGWelcomeViewController.m
//  ZGPDF
//
//  Created by offcn_zcz32036 on 2018/5/30.
//  Copyright © 2018年 cn. All rights reserved.
//

#import "ZGWelcomeViewController.h"
#import <QuickLook/QuickLook.h>
#import "ZGWebViewController.h"
#import "ZGPDFViewController.h"
@interface ZGWelcomeViewController ()
<NSURLSessionDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
/**
 数据流
 */
@property(nonatomic,strong)NSMutableData*data;
@end

@implementation ZGWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data=[NSMutableData data];
    [self createWhiteNavBarWithTitle:@"欢迎使用PDF"];
    [self disPlay];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem=nil;
}
-(void)disPlay
{
    // 循环创建3个button,依次为WebView、预览、PDFKit
    NSArray *array = @[@"webView-PDF",@"预览",@"PDFKIT"].mutableCopy;
    NSArray *normalArr = @[[UIColor orangeColor],[UIColor blueColor],[UIColor purpleColor]].mutableCopy;
    NSArray *hltArr = @[[[UIColor orangeColor] colorWithAlphaComponent:0.7f], [[UIColor blueColor] colorWithAlphaComponent:0.56f], [[UIColor purpleColor] colorWithAlphaComponent:0.647f]].mutableCopy;
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [self buttonWithTitle:[array objectAtIndex:i] NormalColor:[normalArr objectAtIndex:i] HltColor:[hltArr objectAtIndex:i] ButtonTag:i];
        btn.frame = CGRectMake((SCREEN_WIDTH - 130) / 2.0f, 60 * i + 70, 130, 50);
        [self.view addSubview:btn];
    }
}

#pragma mak - Public
- (UIButton *)buttonWithTitle:(NSString *)title
                  NormalColor:(UIColor *)normalColor
                     HltColor:(UIColor *)hltColor
                    ButtonTag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:kUIColor(255, 255, 255, 0.7) forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:normalColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:hltColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}
-(void)btnClicked:(UIButton*)btn
{
    switch (btn.tag) {
        case 0:
            [self.navigationController pushViewController:[ZGWebViewController new] animated:YES];
            break;
        case 1:
        {
            NSString *fileName=@"预览显示pdf";
            NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            NSString*filePath=[documentDirectory stringByAppendingPathComponent:fileName];
            if (![fileManager fileExistsAtPath:filePath]) {
                //文件不存在，需要下载文件
                NSLog(@"文件不存在");
            }else
            {
                NSLog(@"文件存在");
            }
            NSURL *url=[NSURL URLWithString:kPDFURL];
            NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];//初始化session并指定代理
            NSURLSessionDataTask *task=[session dataTaskWithURL:url];
            [task resume];//开始
        }
            break;
        case 2:
        [self.navigationController pushViewController:[ZGPDFViewController new] animated:YES];
            break;

        default:
            break;
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSString *destPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    destPath=[destPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",@"预览显示pdf"]];
    //将下载的二进制文件转入文件
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL isDownLoad=[manager createFileAtPath:destPath contents:self.data attributes:nil];
    [self.progressHUB hideAnimated:NO];
    if (isDownLoad) {
        //下载成功
    }
    else
    {
        [self showException:@"下载失败，请稍后重试!"];
    }
    //创建预览
    QLPreviewController*qlPreView=[[QLPreviewController alloc]init];
    qlPreView.view.frame=self.view.bounds;
    qlPreView.dataSource=self;
    qlPreView.delegate=self;
    [self presentViewController:qlPreView animated:YES completion:^{
        [self defineUIStatusBarStyleDefault];
    }];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.progressHUB showAnimated:YES];
    [self.data appendData:data]; // 将每次接受到的数据拼接起来
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [self.progressHUB hideAnimated:NO];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self.progressHUB hideAnimated:NO];
}

#pragma mark QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(nonnull QLPreviewController *)controller {
    return 1; // 返回文件的个数
}

- (nonnull id<QLPreviewItem>)previewController:(nonnull QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    // 在此代理处加载需要显示的文件
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]; // 获取指定文件 路径
    NSURL *storeUrl = [NSURL fileURLWithPath: [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",@"预览显示pdf"]]]; // 导航栏标题

    return storeUrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
