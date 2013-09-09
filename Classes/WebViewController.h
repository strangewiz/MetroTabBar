//
//  WebViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
	NSString *metroId;
	UIWebView *webView;
    UIActivityIndicatorView* progressView;
}

- (BOOL)isFavorite;
- (void)changeFavorite;
- (void)stopLoad;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (copy, readwrite) NSString *metroId;

@end
