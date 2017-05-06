//
//  NewActivityViewController.m
//  test-2
//
//  Created by hundred wang on 17/5/3.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "NewActivityViewController.h"
#import <WebKit/WebKit.h>

@interface NewActivityViewController ()<WKNavigationDelegate>{
    UIView *_bottomView;
    CGPoint _startPt;
    UIActivityIndicatorView *_activeView;
}

@property (nonatomic, strong) WKWebView * webView;

@end

@implementation NewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    http:\/\/m.ellemen.com\/activity\/native\/
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[[WKWebViewConfiguration alloc] init]];
    [self.view addSubview:self.webView];
    
    self.webView.navigationDelegate = self;
    [self.webView.scrollView.panGestureRecognizer addTarget:self action:@selector(moveScroll:)];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.ellemen.com/activity/native/"]]];
    
    [self setbottomView];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(Screen_Width * 0.5, Screen_Height * 0.5, 40, 40)];
    [self.view addSubview:activeView];
    _activeView = activeView;
    
    // Do any additional setup after loading the view.
}

- (void)setbottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    [self.view addSubview:bottomView];
    
    CGFloat margin = 10;
    CGFloat width = 49 - 2 * margin;
    int8_t count = 5;
    CGFloat gap = (self.view.bounds.size.width - count * width) / (count + 1);
    
    UIButton *backBtn = [[UIButton alloc] init];
    [bottomView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *forwardBtn = [[UIButton alloc] init];
    [bottomView addSubview:forwardBtn];
    [forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [bottomView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(forwardBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *unloveBtn = [[UIButton alloc] init];
    [bottomView addSubview:unloveBtn];
    [unloveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(closeBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *arrowBtn = [[UIButton alloc] init];
    [bottomView addSubview:arrowBtn];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unloveBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    _bottomView = bottomView;
    _bottomView.backgroundColor = [UIColorHex(0x434343) colorWithAlphaComponent:0.7];
    
    [backBtn setImage:[UIImage imageNamed:@"pre"] forState:UIControlStateNormal];
    [forwardBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"webback"] forState:UIControlStateNormal];
//    [unloveBtn setImage:[UIImage imageNamed:@"nolove_on"] forState:UIControlStateNormal];
//    [arrowBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - button and gesture method

- (void)closeVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 根据滚动的距离来判断bottomView是否显示 */
- (void)moveScroll:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan){
        
        _startPt = [pan locationInView:self.view];
        
    }
    CGPoint pt = [pan locationInView:self.view];
    float distance = pt.y - _startPt.y;
    if (distance > 64 && _bottomView.top > self.view.bounds.size.height - 49) [self show];
    if (distance < -64 && _bottomView.top < self.view.bounds.size.height) [self hidden];
}

- (void)show{
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.top = self.view.bounds.size.height - 49;
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.top = self.view.bounds.size.height;
    }];
}

#pragma mark - wkwebviewdelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [_activeView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_activeView stopAnimating];
    NSLog(@"loadSuccess");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [_activeView stopAnimating];
    NSLog(@"loadError:%@", error);
}

- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
