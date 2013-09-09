//
//  MapWebViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"


@interface MapWebViewController : UIViewController {
	UIWebView *webView;
	WebViewController *wvController;
    UIActivityIndicatorView* progressView;
}


@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) WebViewController *wvController;

@end
