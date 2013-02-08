# PBYouTubeVideoViewController
PBYouTubeVideoViewController is a view controller that embeds the YouTube iframe HTML 5 player.

It is composed of a UIWebView which loads the YouTube API and shows the player centered vertically in the view.

Player events are passed to a delegate and some player actions are available through the controller.

It is licensed under the MIT License.
## Usage
```objc
PBYouTubeVideoViewController *viewController = [[PBYouTubeVideoViewController alloc] initWithVideoId:@"<YouTube_video_id>"];
[self presentViewController:viewController animated:YES completion:NULL];
```
