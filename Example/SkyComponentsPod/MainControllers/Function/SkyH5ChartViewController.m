//
//  SkyH5ChartViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/3/31.
//  Copyright © 2016年 Jason.He. All rights reserved.
//
#import "SkyH5ChartViewController.h"
#import <WebKit/WebKit.h>
#import "JSONKit.h"
@interface SkyH5ChartViewController()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
@property(nonatomic,strong)WKWebView *wkwebView;
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation SkyH5ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self wkwebViewLoad];
    [self uiwebViewLoad];
   
}
- (void)wkwebViewLoad
{
    _wkwebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
    _wkwebView.scrollView.scrollEnabled = YES;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:path isDirectory:YES];
    NSString *IndexFilePath = @"index.html?type=p";
    NSURL *indexUrl = [NSURL URLWithString:IndexFilePath relativeToURL:baseURL];

    [_wkwebView loadRequest:[NSURLRequest requestWithURL:indexUrl]];
    _wkwebView.UIDelegate = self;
    _wkwebView.navigationDelegate = self;

    [self.view addSubview:_wkwebView];

}
- (void)uiwebViewLoad{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-64)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.scrollEnabled = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:path isDirectory:YES];
    NSString *IndexFilePath = @"";
    IndexFilePath = @"index.html?type=p";
    NSURL *indexUrl = [NSURL URLWithString:IndexFilePath relativeToURL:baseURL];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:indexUrl]];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];

}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self invokeJS];

}


- (void)invokeJS
{
    
    NSDictionary *demoDic = @{@"totalAmount":@(1000),
                              @"statusSummary":@[@{@"status":@(0),@"amount":@(20),@"color":@"red"},
                                                 @{@"status":@(1),@"amount":@(10),@"color":@"#00FFFF"},
                                                 @{@"status":@(2),@"amount":@(40),@"color":@"blue"},
                                                 @{@"status":@(4),@"amount":@(10),@"color":@"green"},
                                                 ],
                              @"categorySummary":@[@{@"categoryName":@"分类1",@"amount":@(25),@"color":@"#00FFFF"},
                                                   @{@"categoryName":@"分类2",@"amount":@(21),@"color":@"blue"},
                                                   @{@"categoryName":@"分类3",@"amount":@(31),@"color":@"red"},
                                                   @{@"categoryName":@"分类4",@"amount":@(23),@"color":@"green"}],
                              @"memberSummary":@[@{@"commentName":@"DemocommentName",@"amount":@(80),@"color":@"green"}]};
    
//        demoDic = @{@"memberSummary":@[@{@"amount":@"2975.17",@"commentName":@"晕倒1",@"color":@"#00FFFF"},
//                                      @{@"amount":@"871.00",@"commentName":@"后勤",@"color":@"#FF8C00"},@{@"amount":@"653.00",@"commentName":@"行政",@"color":@"#F08080"},
//                                       @{@"amount":@"100.00",@"commentName":@"前台",@"color":@"#3CB371"},@{@"amount":@(46),@"commentName":@"其他",@"color":@"#B0C4DE"},
//                                       @{@"amount":@"46.00",@"commentName":@"秘书"}],
//                    @"statusSummary":@[@{@"amount":@"3105.00",@"color":@"#00FFFF",@"status":@"1"},
//                                       @{@"amount":@"1640.17",@"color":@"#FF8C00",@"status":@"2"},
//                                       @{@"amount":@"0.00",@"color":@"#F08080",@"status":@"4"}],@"totalAmount":@(4745.17),
//                    @"categorySummary":@[@{@"amount":@"200.00",@"categoryName":@"交通",@"color":@"#00FFFF"},
//                                         @{@"amount":@"1640.17",@"categoryName":@"餐饮",@"color":@"#FF8C00"},
//                                         @{@"amount":@"916.00",@"categoryName":@"住宿",@"color":@"#F08080"},
//                                         @{@"amount":@"1943.00",@"categoryName":@"办公用品",@"color":@"#3CB371"},
//                                         @{@"amount":@"46.00",@"categoryName":@"其他",@"color":@"#B0C4DE"}]};
    
    NSString *jsonString = [demoDic JSONString];
    NSMutableString *js = [[NSMutableString alloc] initWithString:@"initData('"];
    //    [js appendString:[statisticData toJSONString]];
    [js appendString:jsonString];
    [js appendString:@"')"];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    [self.wkwebView evaluateJavaScript:js completionHandler:nil];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self invokeJS];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}
@end
