//
//  FavoritesViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "WebViewController.h"

@interface FavoritesViewController : UITableViewController {
	NSMutableArray *listOfContents;
    UIBarButtonItem *editButton;
	WebViewController *wvController;
}

+(FavoritesViewController*)GetInstance;
-(void) saveList;
-(NSString *)favoritesPath;
//-(void)addMetroName:(NSString *)name withSite:(NSString *)site withColorImage:(NSString *)img;
-(void)addMetroDictionary:(NSDictionary*)dict;
-(void)removeMetroId:(NSString *)id;
@property (nonatomic, retain) NSMutableArray *listOfContents;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) WebViewController *wvController;
@end
