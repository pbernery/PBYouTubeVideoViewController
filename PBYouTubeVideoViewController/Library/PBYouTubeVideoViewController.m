//
//  PBYouTubeVideoViewController.m
//
//  Created by Philippe Bernery on 08/02/13.
//  Copyright (c) 2013 Philippe Bernery. All rights reserved.
//

#import "PBYouTubeVideoViewController.h"


NSString *const PBYouTubePlayerEventReady = @"ready";
NSString *const PBYouTubePlayerEventStateChanged = @"stateChange";
NSString *const PBYouTubePlayerEventPlaybackQualityChanged = @"playbackQualityChange";
NSString *const PBYouTubePlayerEventPlaybackRateChanged = @"playbackRateChange";
NSString *const PBYouTubePlayerEventError = @"error";
NSString *const PBYouTubePlayerEventApiChange = @"apiChange";

#define LOG_ERROR(x) NSLog(@"[%@ %@] - error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), x)

const CGFloat YouTubeStandardPlayerWidth = 640;
const CGFloat YouTubeStandardPlayerHeight = 390;


@interface PBYouTubeVideoViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) UIWebView *webView;

@end


@implementation PBYouTubeVideoViewController

- (id)initWithVideoId:(NSString *)videoId
{
    NSParameterAssert(videoId != nil);

    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.videoId = videoId;
    }
    return self;
}

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.webView loadHTMLString:[self htmlContent] baseURL:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self updatePlayerSize];
}

#pragma mark - Actions

- (void)play
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"playVideo();"];
}

- (void)pause
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"pauseVideo();"];
}

- (void)stop
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"stopVideo();"];
}

#pragma mark - Accessors

- (void)setPlayerSize:(CGSize)playerSize
{
    [self.webView stringByEvaluatingJavaScriptFromString:
            [NSString stringWithFormat:@"setPlayerSize(%u, %u);",
                            (unsigned int) playerSize.width, (unsigned int) playerSize.height]];
}

#pragma mark - Helpers

- (NSString *)htmlContent
{
    NSString *pathToHTML = [[NSBundle mainBundle] pathForResource:@"PBYouTubeVideoView" ofType:@"html"];
    NSAssert(pathToHTML != nil, @"could not find PBYouTubeVideoView.html");

    NSError *error = nil;
    NSString *template = [NSString stringWithContentsOfFile:pathToHTML encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        LOG_ERROR(error);
    }

    NSString *result = [NSString stringWithFormat:template, self.videoId];
    return result;
}

- (void)updatePlayerSize
{
    float ratio = 1;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        ratio = self.view.bounds.size.height / YouTubeStandardPlayerHeight;
    } else {
        ratio = self.view.bounds.size.width / YouTubeStandardPlayerWidth;
    }

    CGSize playerSize = CGSizeMake(YouTubeStandardPlayerWidth * ratio, YouTubeStandardPlayerHeight * ratio);
    [self setPlayerSize:playerSize];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request URL].scheme isEqualToString:@"ytplayer"]) {
        NSArray *components = [[request URL] pathComponents];
        if ([components count] > 1) {
            NSString *actionName = components[1];
            NSString *actionData = nil;
            if ([components count] > 2) {
                actionData = components[2];
            }

            [self.delegate youTubeVideoViewController:self didReceiveEventNamed:actionName eventData:actionData];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LOG_ERROR(error);
}

@end
