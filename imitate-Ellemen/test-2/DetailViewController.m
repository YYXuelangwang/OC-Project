//
//  DetailViewController.m
//  test-2
//
//  Created by hundred wang on 17/4/15.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "UIImageView+WebCache.h"
#import "AFNetworkTool.h"

@interface DetailViewController ()<WKNavigationDelegate> {
    CGFloat _headViewHeight, _margin, _scale, _titleFontSize, _detailFontSize, _contentFontSize, _spacing;
    
    UIView *_navView;
    UIView *_bottomView;
    CGPoint _startPt;
    
    UIActivityIndicatorView *_activeView;
}

@property (nonatomic, strong) WKWebView * webView;

@end

@implementation DetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _margin = 15;
        _spacing = 20;
        _scale = 1.2;
    }
    return self;
}

- (void)setModel:(YYMainArticalModel *)model{
    _model = model;
    _titleFontSize = 22;
    _detailFontSize = 15;
    //    _headViewHeight = [self calcuateHeight];
}

#pragma mark - setup View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self setupWebViews];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupWebView];
    
    [self setupNavView];
    [self setbottomView];
    
    //加载request
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.url]]];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(Screen_Width * 0.5, Screen_Height * 0.5, 40, 40)];
    [self.view addSubview:activeView];
    _activeView = activeView;
    
    [self getRecentData];
    
}

- (void)setupNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [self.view addSubview:navView];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [navView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(30);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [navView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(24);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftBtn.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(rightBtn.mas_left).mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(30);
    }];
    
    _navView = navView;
    _navView.backgroundColor = [UIColor whiteColor];
    
    [leftBtn setImage:[UIImage imageNamed:@"leftbut_new"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"font_off"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"font_on"] forState:UIControlStateSelected];
    
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.cat_title, self.model.english_title];
    
    [rightBtn addTarget:self action:@selector(changeTextFontSize:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    UIButton *addBtn = [[UIButton alloc] init];
    [bottomView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *loveBtn = [[UIButton alloc] init];
    [bottomView addSubview:loveBtn];
    [loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addBtn.mas_right).mas_equalTo(gap);
        make.top.mas_equalTo(margin);
        make.width.height.mas_equalTo(width);
    }];
    
    UIButton *unloveBtn = [[UIButton alloc] init];
    [bottomView addSubview:unloveBtn];
    [unloveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loveBtn.mas_right).mas_equalTo(gap);
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
    
    [backBtn setImage:[UIImage imageNamed:@"mback"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"addroom_off"] forState:UIControlStateNormal];
    [loveBtn setImage:[UIImage imageNamed:@"love_on"] forState:UIControlStateNormal];
    [unloveBtn setImage:[UIImage imageNamed:@"nolove_on"] forState:UIControlStateNormal];
    [arrowBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
}

/*
 
 - (CGFloat)calcuateHeight{
 
 CGFloat titleHeight = [_model.title heightForFont:[UIFont systemFontOfSize:_titleFontSize] width:Screen_Width - 2 * _margin];
 CGFloat detailHeight = [_model.detail_description heightForFont:[UIFont systemFontOfSize:_detailFontSize] width:Screen_Width - 2 * _margin];
 CGFloat dateHeight = [_model.published heightForFont:[UIFont systemFontOfSize:_detailFontSize] width:Screen_Width];
 
 CGFloat totalHeight = _spacing * 4 + titleHeight + detailHeight + dateHeight + Screen_Width;
 
 return totalHeight;
 }
 
 - (void)setupWebViews{
 
 UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, -_headViewHeight, Screen_Width, _headViewHeight)];
 
 UIImageView *largeImageView = [[UIImageView alloc] init];
 [headView addSubview:largeImageView];
 [largeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.top.right.mas_equalTo(0);
 make.height.mas_equalTo(Screen_Width);
 }];
 
 UILabel *titleLabel = [[UILabel alloc] init];
 [headView addSubview:titleLabel];
 [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(largeImageView.mas_bottom).mas_equalTo(_spacing);
 make.left.mas_equalTo(_margin);
 make.right.mas_equalTo(-_margin);
 }];
 
 UILabel *detailLabel = [[UILabel alloc] init];
 [headView addSubview:detailLabel];
 [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(_spacing);
 make.left.mas_equalTo(_margin);
 make.right.mas_equalTo(-_margin);
 }];
 
 UILabel *dateLabel = [[UILabel alloc] init];
 [headView addSubview:dateLabel];
 [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.mas_equalTo(44);
 make.top.mas_equalTo(detailLabel.mas_bottom).mas_equalTo(_spacing);
 }];
 
 UIImageView *clickImageView = [[UIImageView alloc] init];
 [headView addSubview:clickImageView];
 [clickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerY.mas_equalTo(detailLabel.mas_centerY).mas_equalTo(0);
 make.left.mas_equalTo(_margin);
 make.width.height.mas_equalTo(13);
 }];
 
 UIView *lineView = [[UIView alloc] init];
 [headView addSubview:lineView];
 [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.mas_equalTo(13);
 make.right.mas_equalTo(-13);
 make.height.mas_equalTo(1);
 }];
 
 WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:webView];
 
 _webView = webView;
 
 webView.navigationDelegate = self;
 webView.scrollView.contentInset = UIEdgeInsetsMake(_headViewHeight, 0, 0, 0);
 [webView.scrollView addSubview:headView];
 [webView.scrollView setContentOffset:CGPointMake(0, -_headViewHeight)];
 
 [largeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.thumb] placeholderImage:nil options:SDWebImageRetryFailed];
 
 titleLabel.font = [UIFont systemFontOfSize:_titleFontSize];
 detailLabel.font = [UIFont systemFontOfSize:_detailFontSize];
 dateLabel.font = [UIFont systemFontOfSize:_detailFontSize];
 
 detailLabel.textColor = UIColorHex(0xb8b7b8);
 dateLabel.textColor = UIColorHex(0xb8b7b8);
 
 }
 
 */

- (void)setupWebView{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    _webView = webView;
    webView.navigationDelegate = self;
    [webView.scrollView.panGestureRecognizer addTarget:self action:@selector(moveScroll:)];
}

#pragma mark - button method

- (void)changeTextFontSize:(UIButton*)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
         [ _webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'" completionHandler:nil];
    }else{
         [ _webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    }
}

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
        _navView.top = 0;
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.top = self.view.bounds.size.height;
        _navView.top = - 64;
    }];
}

#pragma mark - WKWebViewNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"startLoad");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"beginLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_activeView stopAnimating];
    NSLog(@"loadSuccess");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [_activeView stopAnimating];
    NSLog(@"loadError:%@",error);
}

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//    NSLog(@"needAuthod");
//}

#pragma mark - network request

- (void)getRecentData{
    [_activeView startAnimating];
    NSDictionary *params = @{
                             @"app" : @"rss",
                             @"controller" : @"elleplus",
                             @"action" : @"elleplus_content",
                             @"contentid" : _model.contentid,
                             @"from" : @1,
                             @"home_contentid" : _model.home_contentid
                             };
    @weakify(self)
    [[AFNetworkTool sharedTool] GET:@"http://app.ellemen.com/?" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"true"]) {
            NSString *htmlStr = responseObject[@"data"][@"body_html"];
            [weak_self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:@"http://app.ellemen.com/?"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_activeView stopAnimating];
        DLog(@"加载失败%@", error);
    }];
}

/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 CGFloat minAlphaOffset = - 64;
 CGFloat maxAlphaOffset = 200;
 CGFloat offset = scrollView.contentOffset.y;
 CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
 self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
 }
 */

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
