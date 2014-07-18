//
//  ListViewController.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface ListViewController : UITableViewController {
  NSMutableArray* listOfContents;
  NSMutableArray* listOfSections;
  NSMutableArray* listOfSectionTitles;
  WebViewController* wvController;
}

+ (ListViewController*)GetInstance;

@property(nonatomic, retain) NSMutableArray* listOfContents;
@property(nonatomic, retain) NSMutableArray* listOfSections;
@property(nonatomic, retain) NSMutableArray* listOfSectionTitles;
@property(nonatomic, retain) WebViewController* wvController;

@end
