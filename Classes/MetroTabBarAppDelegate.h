//
//  MetroTabBarAppDelegate.h
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroTabBarAppDelegate
    : NSObject<UIApplicationDelegate, UITabBarControllerDelegate> {
  UIWindow* window;
  UITabBarController* tabBarController;
  NSMutableArray* listOfStations;
  NSMutableArray* listofStationsMap;
}

@property(nonatomic, retain) IBOutlet UIWindow* window;
@property(nonatomic, retain) IBOutlet UITabBarController* tabBarController;
@property(nonatomic, retain) NSMutableArray* listOfStations;
@property(nonatomic, retain) NSMutableArray* listofStationsMap;


@end
