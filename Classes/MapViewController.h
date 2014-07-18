//
//  MapViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface MapViewController : UIViewController<UIScrollViewDelegate> {
  IBOutlet UIScrollView* scrollView;
  IBOutlet UIImageView* imageView;
  WebViewController* wvController;
}

@property(nonatomic, retain) WebViewController* wvController;

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
