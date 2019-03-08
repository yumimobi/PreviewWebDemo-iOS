//
//  PAPreviewAdViewController.m
//  PlayableAdsPreviewer
//
//  Created by Michael Tang on 2018/8/31.
//

#import "PAPreviewAdViewController.h"
#import <WebKit/WebKit.h>
#import "ZplayAppStore.h"
#import "NSString+YumiURLEncodedString.h"

#define SYSTEM_VERSION_LESS_THAN(v)                                                                                    \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface PAPreviewAdViewController () <WKScriptMessageHandler, WKNavigationDelegate>
@property (nonatomic) WKWebView *previewAdWebView;
@property (nonatomic) UIProgressView *progressBar;
@property (nonatomic) UIImageView *backImgView;
@property (nonatomic) UIButton *backBtn;
@property (nonatomic) ZplayAppStore  *appStore;
@end

@implementation PAPreviewAdViewController
- (void)dealloc {
    [self.previewAdWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.previewAdWebView addObserver:self
                               forKeyPath:@"estimatedProgress"
                                  options:NSKeyValueObservingOptionNew
                                  context:nil];

    [self.view addSubview:self.previewAdWebView];
    [self.view addSubview:self.progressBar];

    [self layoutBackUI];
    
    NSNumber *itunesId = [NSNumber numberWithInt:1167885749];
    self.appStore =  [[ZplayAppStore alloc]
     initWithItunesID:itunesId
     itunesLink:@"https://itunes.apple.com/cn/app/"
     @"%E5%B0%8F%E7%8B%90%E7%8B%B8-%E5%BE%8B%E5%8A%A8%E8%B7%B3%E8%B7%83/id1167885749"];
}

- (void)setLoadUrl:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.previewAdWebView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)htmlStr isReplace:(BOOL)isReplace{
    if (!self.previewAdWebView) {
        return;
    }
    if (htmlStr.length == 0) {
        return;
    }
    if (isReplace) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    }
    [self.previewAdWebView loadHTMLString:htmlStr baseURL:nil];
}

- (void)layoutBackUI {
    [self.view addSubview:self.backImgView];
    [self.view addSubview:self.backBtn];

    [self.view bringSubviewToFront:self.backImgView];
    [self.view bringSubviewToFront:self.backBtn];

    self.backImgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backBtn.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat satusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat imgHeight = 30;
    CGFloat topMargin = 20;
    CGFloat leftMargin = 12;
    // 宽度
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.backImgView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0
                                                                        constant:imgHeight];
    [self.backImgView addConstraint:widthConstraint];

    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.backImgView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.0
                                                                         constant:imgHeight];
    [self.backImgView addConstraint:heightConstraint];

    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.backImgView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:leftMargin];
    [self.view addConstraint:leftConstraint];

    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.backImgView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:satusHeight + topMargin];
    [self.view addConstraint:topConstraint];

    // button
    // 宽度
    NSLayoutConstraint *widthBtnConstraint = [NSLayoutConstraint constraintWithItem:self.backBtn
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:0.0
                                                                           constant:imgHeight * 1.3];
    [self.backBtn addConstraint:widthBtnConstraint];

    // 添加 height 约束
    NSLayoutConstraint *heightBtnConstraint = [NSLayoutConstraint constraintWithItem:self.backBtn
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:0.0
                                                                            constant:imgHeight * 1.3];
    [self.backBtn addConstraint:heightBtnConstraint];

    // 添加 left 约束
    NSLayoutConstraint *leftBtnConstraint = [NSLayoutConstraint constraintWithItem:self.backBtn
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:leftMargin];
    [self.view addConstraint:leftBtnConstraint];

    // 添加 top 约束
    NSLayoutConstraint *topBtnConstraint = [NSLayoutConstraint constraintWithItem:self.backBtn
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:satusHeight + topMargin];
    [self.view addConstraint:topBtnConstraint];
}

- (void)onBackAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [weakSelf.previewAdWebView removeObserver:weakSelf forKeyPath:@"estimatedProgress"];
                                 weakSelf.previewAdWebView.navigationDelegate = nil;
                                 weakSelf.previewAdWebView = nil;
                             }];
}

- (void)openAppstore:(NSURL *)openUrl{
    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        [[UIApplication sharedApplication] openURL:openUrl];
    } else {
        [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (void)showAlert:(NSString *)message{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:confirm];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark: webview call back
- (void)handlePlayablePageMessage:(NSString *)msg {
    [self showAlert:msg];
    if ([msg isEqualToString:@"user_did_tap_install"]) {
        NSLog(@"user_did_tap_install");
//         [self.appStore present];
       NSURL  *openUrl = [NSURL URLWithString:self.adModel.target_url];
//        2的时候只支持user_did_tap_install
        if (self.adModel.support_function == 2) {
            [self openAppstore:openUrl];
        }
    }else if ([msg isEqualToString:@"close_playable_ads"]) {
        NSLog(@"close zplayads...");
        [self onBackAction:nil];
    }
//    NSLog(@" --- %@",msg);
//    if ([msg isEqualToString:@"video_did_end_loading"]) {
//
//    } else if ([msg isEqualToString:@"video_did_start_playing"]) {
//
//    } else if ([msg isEqualToString:@"video_did_end_playing"]) {
//
//    } else if ([msg isEqualToString:@"user_did_tap_install"]) {
//        [self.appStore present];
//    } else if ([msg isEqualToString:@"animated_end_card"]) {
//
//    } else if ([msg isEqualToString:@"replay"]) {
//
//    } else if ([msg isEqualToString:@"video_did_fail_loading"]) {
//
//    }else if ([msg isEqualToString:@"close_playable_ads"]) {
//        NSLog(@"close zplayads...");
//        [self onBackAction:self.backBtn];
//    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressBar.progress = self.previewAdWebView.estimatedProgress;
        if (self.progressBar.progress == 1) {
            self.progressBar.progress = 0;
            self.progressBar.hidden = YES;
        }
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"zplayads"]) {
        [self handlePlayablePageMessage:message.body];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.progressBar.hidden = NO;
    [self.view bringSubviewToFront:self.progressBar];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView
    didFailNavigation:(null_unspecified WKNavigation *)navigation
            withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView
    didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation
                       withError:(NSError *)error {
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   
    NSString *rUrl = [navigationAction.request.URL absoluteString];
    if ([rUrl hasPrefix:@"zplayads:"]) {
        NSArray *v = [rUrl componentsSeparatedByString:@":"];
        if (v.count > 1) {
            [self handlePlayablePageMessage:v[1]];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([rUrl hasPrefix:@"https://"] || [rUrl hasPrefix:@"http://"]) {
        NSURL *openUrl = [NSURL URLWithString:rUrl];
        if (self.adModel.support_function == 1 || self.adModel.support_function == 3) {
            [self openAppstore:openUrl];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([rUrl hasPrefix:@"mraid://open"]){
        NSArray *arr = [rUrl componentsSeparatedByString:@"="];
        NSString *str = [arr.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self openAppstore:[NSURL URLWithString:str]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([rUrl hasPrefix:@"mraid://"]){
        
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark : -- getter method
- (WKWebView *)previewAdWebView {
    if (!_previewAdWebView) {
        NSString *mraidJs = nil;
        if (self.isSupportMarid) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"mraid" ofType:@"js"];
            NSData *data= [[NSData alloc] initWithContentsOfFile:path];
            mraidJs = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        WKUserScript *script = [[WKUserScript alloc] initWithSource:mraidJs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addUserScript:script];
        [config.userContentController addScriptMessageHandler:self name:@"zplayads"];
        config.allowsInlineMediaPlayback = YES;
        
        CGRect frame =
            CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _previewAdWebView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        _previewAdWebView.scrollView.bounces = NO;
        _previewAdWebView.navigationDelegate = self;
        _previewAdWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      
        if (@available(iOS 11.0, *)) {
            [_previewAdWebView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        } else {
            // Fallback on earlier versions
        }
        
    }
    return _previewAdWebView;
}

- (UIProgressView *)progressBar {
    if (!_progressBar) {
        CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        _progressBar = [[UIProgressView alloc]
            initWithFrame:CGRectMake(0.0f, statusHeight, [UIScreen mainScreen].bounds.size.width, 5.0f)];
        _progressBar.backgroundColor = [UIColor clearColor];
        _progressBar.trackTintColor = [UIColor clearColor];
        _progressBar.progressTintColor = [UIColor blueColor];
    }
    return _progressBar;
}

- (UIImageView *)backImgView {
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] init];
        _backImgView.image = [UIImage imageNamed:@"back_icon"];
    }
    return _backImgView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
