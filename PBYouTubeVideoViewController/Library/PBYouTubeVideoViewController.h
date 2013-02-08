//
//  PBYouTubeVideoViewController.h
//
//  Created by Philippe Bernery on 08/02/13.
//  Copyright (c) 2013 Philippe Bernery. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PBYouTubePlayerEventReady;
extern NSString *const PBYouTubePlayerEventStateChanged;
extern NSString *const PBYouTubePlayerEventPlaybackQualityChanged;
extern NSString *const PBYouTubePlayerEventPlaybackRateChanged;
extern NSString *const PBYouTubePlayerEventError;
extern NSString *const PBYouTubePlayerEventApiChange;


@protocol PBYouTubeVideoViewControllerDelegate;

/**
 * PBYouTubeVideoViewController is a view controller that embeds the HTML 5
 * player of YouTube.
 *
 * It is composed of a UIWebView and send to the delegate the events received
 * from the HTML 5 player.
 *
 * It uses the IFrame YouTube API.
 * (https://developers.google.com/youtube/iframe_api_reference)
 */
@interface PBYouTubeVideoViewController : UIViewController

@property (nonatomic, weak) id<PBYouTubeVideoViewControllerDelegate> delegate;

- (id)initWithVideoId:(NSString *)videoId;

- (void)play;
- (void)pause;
- (void)stop;

/**
 * Sets the size of the player.
 */
- (void)setPlayerSize:(CGSize)playerSize;

/**
 * Duration of the video.
 * Note that the value is available only after the video metadata is loaded,
 * which normally happens just after the video starts playing.
 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/**
 * Get the elapsed time since the video started playing.
 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@end


@protocol PBYouTubeVideoViewControllerDelegate

/**
 * Called when an event is emitted by the YouTube player.
 *
 * See https://developers.google.com/youtube/iframe_api_reference#Events for available events.
 * Event name constants are defined above.
 *
 * @param eventName the name of the event.
 * @param eventData the data associated with the event. May be nil.
 */
- (void)youTubeVideoViewController:(PBYouTubeVideoViewController *)viewController didReceiveEventNamed:(NSString *)eventName eventData:(NSString *)eventData;

@end
