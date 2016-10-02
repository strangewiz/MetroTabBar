//
//  MetroTabBarAppDelegate.m
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "MetroTabBarAppDelegate.h"
#import "ListViewController.h"

@implementation MetroTabBarAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize listOfStations;

//++++
// we need a singleton for the application?
// we need an accessor for the favorites data, setting favorites data, and the
// metro list

- (void)applicationDidFinishLaunching:(UIApplication*)application {

  [Fabric with:@[[Crashlytics class]]];

  // Update window size for tall iPhones.
  CGSize size = [[UIScreen mainScreen] bounds].size;
  self.window.frame = CGRectMake(0, 0, size.width, size.height);

  // Add the tab bar controller's current view as a subview of the window
  [self.window setRootViewController:tabBarController];

  self.listOfStations = [[NSMutableArray alloc] initWithCapacity:40];
    
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Addison Road-Seat Pleasant", @"name", @"92", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Anacostia", @"name", @"85", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Archives-Navy Memorial-Penn Quarter", @"name", @"81", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Arlington Cemetery", @"name", @"42", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ballston-MU", @"name", @"99", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Benning Road", @"name", @"90", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Bethesda", @"name", @"12", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Braddock Road", @"name", @"47", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Branch Ave", @"name", @"89", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Brookland-CUA", @"name", @"27", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Capitol Heights", @"name", @"91", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Capitol South", @"name", @"59", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cheverly", @"name", @"66", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Clarendon", @"name", @"97", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cleveland Park", @"name", @"8", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"College Park-U of MD", @"name", @"79", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Columbia Heights", @"name", @"75", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Congress Heights", @"name", @"86", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Court House", @"name", @"96", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Crystal City", @"name", @"45", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Deanwood", @"name", @"65", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Dunn Loring-Merrifield", @"name", @"102", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Dupont Circle", @"name", @"6", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"East Falls Church", @"name", @"100", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Eastern Market", @"name", @"60", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Eisenhower Avenue", @"name", @"49", @"site", @"y", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Farragut North", @"name", @"4", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Farragut West", @"name", @"38", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Federal Center SW", @"name", @"58", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Federal Triangle", @"name", @"53", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Foggy Bottom-GWU", @"name", @"40", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Forest Glen", @"name", @"32", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Fort Totten", @"name", @"28", @"site", @"gyr", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Franconia-Springfield", @"name", @"95", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Friendship Heights", @"name", @"11", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Gallery Pl-Chinatown", @"name", @"21", @"site", @"gyr", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Georgia Ave-Petworth", @"name", @"76", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Glenmont", @"name", @"34", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Greenbelt", @"name", @"80", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Greensboro", @"name", @"113", @"site", @"s", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Grosvenor-Strathmore", @"name", @"14", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Huntington", @"name", @"50", @"site", @"y", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Judiciary Square", @"name", @"23", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"King Street", @"name", @"48", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"L'Enfant Plaza", @"name", @"82", @"site", @"bogy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Landover", @"name", @"67", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Largo Town Center", @"name", @"109", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"McLean", @"name", @"111", @"site", @"s", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"McPherson Square", @"name", @"36", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Medical Center", @"name", @"13", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Metro Center", @"name", @"1", @"site", @"bor", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Minnesota Ave", @"name", @"64", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Morgan Boulevard", @"name", @"110", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mt Vernon Sq 7th St-Convention Center", @"name", @"70", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Navy Yard", @"name", @"84", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Naylor Road", @"name", @"87", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"New Carrollton", @"name", @"68", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"New York Ave-Florida Ave-Gallaudet U", @"name", @"108", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pentagon", @"name", @"43", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pentagon City", @"name", @"44", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Potomac Ave", @"name", @"61", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Prince George's Plaza", @"name", @"78", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rhode Island Ave-Brentwood", @"name", @"26", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rockville", @"name", @"17", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ronald Reagan Washington National Airport", @"name", @"93", @"site", @"by", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rosslyn", @"name", @"41", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shady Grove", @"name", @"18", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shaw-Howard U", @"name", @"72", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Silver Spring", @"name", @"31", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Smithsonian", @"name", @"54", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Southern Avenue", @"name", @"107", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Spring Hill", @"name", @"114", @"site", @"s", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Stadium-Armory", @"name", @"63", @"site", @"bo", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Suitland", @"name", @"88", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Takoma", @"name", @"29", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tenleytown-AU", @"name", @"10", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Twinbrook", @"name", @"16", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tysons Corner", @"name", @"112", @"site", @"s", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"U Street/African-Amer Civil War Memorial/Cardozo", @"name", @"73", @"site", @"gy", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Union Station", @"name", @"25", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Van Dorn Street", @"name", @"94", @"site", @"b", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Van Ness-UDC", @"name", @"9", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Vienna/Fairfax-GMU", @"name", @"103", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Virginia Square-GMU", @"name", @"98", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Waterfront-SEU", @"name", @"83", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"West Falls Church-VT/UVA", @"name", @"101", @"site", @"o", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"West Hyattsville", @"name", @"77", @"site", @"g", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wheaton", @"name", @"33", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"White Flint", @"name", @"15", @"site", @"r", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wiehle-Reston East", @"name", @"115", @"site", @"s", @"colorImage", nil]];
	[self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Woodley Park-Zoo/Adams Morgan", @"name", @"7", @"site", @"r", @"colorImage", nil]];

}


//+++++
// This seems stupid. Easier way?
int gLastIndex = -1;
- (void)tabBarController:(UITabBarController*)tabBarController
    didSelectViewController:(UIViewController*)viewController {
  if (gLastIndex != -1)
    [[self.tabBarController.viewControllers objectAtIndex:gLastIndex]
        popToRootViewControllerAnimated:NO];

  gLastIndex = self.tabBarController.selectedIndex;
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController
didEndCustomizingViewControllers:(NSArray *)viewControllers
changed:(BOOL)changed {
}
*/

- (void)dealloc {
  [listOfStations release];
  [tabBarController release];
  [window release];
  [super dealloc];
}

@end
