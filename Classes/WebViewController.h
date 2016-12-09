//
//  WebViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController {
  NSString* metroId;
  NSString* metroName;
  UIWebView* webView;
  UIActivityIndicatorView* progressView;
}

- (BOOL)isFavorite;
- (void)changeFavorite;
- (void)stopLoad;

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, copy, readwrite) NSString* metroId;
@property(copy, readwrite) NSString* metroName;

@end
