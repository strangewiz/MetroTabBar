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
@synthesize listofStationsMap;

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

  self.listOfStations = [[NSMutableArray alloc] initWithCapacity:90];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Addison Road-Seat Pleasant", @"name", @"G03", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Anacostia", @"name", @"F06", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Archives-Navy Memorial-Penn Quarter", @"name", @"F02", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Arlington Cemetery", @"name", @"C06", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ballston-MU", @"name", @"K04", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Benning Road", @"name", @"G01", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Bethesda", @"name", @"A09", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Braddock Road", @"name", @"C12", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Branch Ave", @"name", @"F11", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Brookland-CUA", @"name", @"B05", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Capitol Heights", @"name", @"G02", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Capitol South", @"name", @"D05", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cheverly", @"name", @"D11", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Clarendon", @"name", @"K02", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cleveland Park", @"name", @"A05", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"College Park-U of MD", @"name", @"E09", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Columbia Heights", @"name", @"E04", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Congress Heights", @"name", @"F07", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Court House", @"name", @"K01", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Crystal City", @"name", @"C09", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Deanwood", @"name", @"D10", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Dunn Loring-Merrifield", @"name", @"K07", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Dupont Circle", @"name", @"A03", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"East Falls Church", @"name", @"K05", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Eastern Market", @"name", @"D06", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Eisenhower Avenue", @"name", @"C14", @"site", @"y", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Farragut North", @"name", @"A02", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Farragut West", @"name", @"C03", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Federal Center SW", @"name", @"D04", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Federal Triangle", @"name", @"D01", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Foggy Bottom-GWU", @"name", @"C04", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Forest Glen", @"name", @"B09", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Fort Totten", @"name", @"E06,B06", @"site", @"gyr", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Franconia-Springfield", @"name", @"J03", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Friendship Heights", @"name", @"A08", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Gallery Pl-Chinatown", @"name", @"B01,F01", @"site", @"gyr", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Georgia Ave-Petworth", @"name", @"E05", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Glenmont", @"name", @"B11", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Greenbelt", @"name", @"E10", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Greensboro", @"name", @"N03", @"site", @"s", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Grosvenor-Strathmore", @"name", @"A11", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Huntington", @"name", @"C15", @"site", @"y", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Judiciary Square", @"name", @"B02", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"King St-Old Town", @"name", @"C13", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"L'Enfant Plaza", @"name", @"F03,D03", @"site", @"bogy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Landover", @"name", @"D12", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Largo Town Center", @"name", @"G05", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"McLean", @"name", @"N01", @"site", @"s", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"McPherson Square", @"name", @"C02", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Medical Center", @"name", @"A10", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Metro Center", @"name", @"C01,A01", @"site", @"bor", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Minnesota Ave", @"name", @"D09", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Morgan Boulevard", @"name", @"G04", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mt Vernon Sq 7th St-Convention Center", @"name", @"E01", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Navy Yard-Ballpark", @"name", @"F05", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Naylor Road", @"name", @"F09", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"New Carrollton", @"name", @"D13", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"NoMa-Gallaudet U", @"name", @"B35", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pentagon", @"name", @"C07", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pentagon City", @"name", @"C08", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Potomac Ave", @"name", @"D07", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Prince George's Plaza", @"name", @"E08", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rhode Island Ave-Brentwood", @"name", @"B04", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rockville", @"name", @"A14", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ronald Reagan Washington National Airport", @"name", @"C10", @"site", @"by", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rosslyn", @"name", @"C05", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shady Grove", @"name", @"A15", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shaw-Howard U", @"name", @"E02", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Silver Spring", @"name", @"B08", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Smithsonian", @"name", @"D02", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Southern Avenue", @"name", @"F08", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Spring Hill", @"name", @"N04", @"site", @"s", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Stadium-Armory", @"name", @"D08", @"site", @"bo", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Suitland", @"name", @"F10", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Takoma", @"name", @"B07", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tenleytown-AU", @"name", @"A07", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Twinbrook", @"name", @"A13", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tysons Corner", @"name", @"N02", @"site", @"s", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"U Street/African-Amer Civil War Memorial/Cardozo", @"name", @"E03", @"site", @"gy", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Union Station", @"name", @"B03", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Van Dorn Street", @"name", @"J02", @"site", @"b", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Van Ness-UDC", @"name", @"A06", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Vienna/Fairfax-GMU", @"name", @"K08", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Virginia Square-GMU", @"name", @"K03", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Waterfront", @"name", @"F04", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"West Falls Church-VT/UVA", @"name", @"K06", @"site", @"o", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"West Hyattsville", @"name", @"E07", @"site", @"g", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wheaton", @"name", @"B10", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"White Flint", @"name", @"A12", @"site", @"r", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wiehle-Reston East", @"name", @"N06", @"site", @"s", @"colorImage", nil]];
  [self.listOfStations addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Woodley Park-Zoo/Adams Morgan", @"name", @"A04", @"site", @"r", @"colorImage", nil]];


  self.listofStationsMap = [[NSMutableArray alloc] initWithCapacity:90];
  [self.listofStationsMap addObject:@{@"old_id": @"92", @"new_id": @"G03", @"new_name": @"Addison Road-Seat Pleasant"}];
  [self.listofStationsMap addObject:@{@"old_id": @"85", @"new_id": @"F06", @"new_name": @"Anacostia"}];
  [self.listofStationsMap addObject:@{@"old_id": @"81", @"new_id": @"F02", @"new_name": @"Archives-Navy Memorial-Penn Quarter"}];
  [self.listofStationsMap addObject:@{@"old_id": @"42", @"new_id": @"C06", @"new_name": @"Arlington Cemetery"}];
  [self.listofStationsMap addObject:@{@"old_id": @"99", @"new_id": @"K04", @"new_name": @"Ballston-MU"}];
  [self.listofStationsMap addObject:@{@"old_id": @"90", @"new_id": @"G01", @"new_name": @"Benning Road"}];
  [self.listofStationsMap addObject:@{@"old_id": @"12", @"new_id": @"A09", @"new_name": @"Bethesda"}];
  [self.listofStationsMap addObject:@{@"old_id": @"47", @"new_id": @"C12", @"new_name": @"Braddock Road"}];
  [self.listofStationsMap addObject:@{@"old_id": @"89", @"new_id": @"F11", @"new_name": @"Branch Ave"}];
  [self.listofStationsMap addObject:@{@"old_id": @"27", @"new_id": @"B05", @"new_name": @"Brookland-CUA"}];
  [self.listofStationsMap addObject:@{@"old_id": @"91", @"new_id": @"G02", @"new_name": @"Capitol Heights"}];
  [self.listofStationsMap addObject:@{@"old_id": @"59", @"new_id": @"D05", @"new_name": @"Capitol South"}];
  [self.listofStationsMap addObject:@{@"old_id": @"66", @"new_id": @"D11", @"new_name": @"Cheverly"}];
  [self.listofStationsMap addObject:@{@"old_id": @"97", @"new_id": @"K02", @"new_name": @"Clarendon"}];
  [self.listofStationsMap addObject:@{@"old_id": @"8", @"new_id": @"A05", @"new_name": @"Cleveland Park"}];
  [self.listofStationsMap addObject:@{@"old_id": @"79", @"new_id": @"E09", @"new_name": @"College Park-U of MD"}];
  [self.listofStationsMap addObject:@{@"old_id": @"75", @"new_id": @"E04", @"new_name": @"Columbia Heights"}];
  [self.listofStationsMap addObject:@{@"old_id": @"86", @"new_id": @"F07", @"new_name": @"Congress Heights"}];
  [self.listofStationsMap addObject:@{@"old_id": @"96", @"new_id": @"K01", @"new_name": @"Court House"}];
  [self.listofStationsMap addObject:@{@"old_id": @"45", @"new_id": @"C09", @"new_name": @"Crystal City"}];
  [self.listofStationsMap addObject:@{@"old_id": @"65", @"new_id": @"D10", @"new_name": @"Deanwood"}];
  [self.listofStationsMap addObject:@{@"old_id": @"102", @"new_id": @"K07", @"new_name": @"Dunn Loring-Merrifield"}];
  [self.listofStationsMap addObject:@{@"old_id": @"6", @"new_id": @"A03", @"new_name": @"Dupont Circle"}];
  [self.listofStationsMap addObject:@{@"old_id": @"100", @"new_id": @"K05", @"new_name": @"East Falls Church"}];
  [self.listofStationsMap addObject:@{@"old_id": @"60", @"new_id": @"D06", @"new_name": @"Eastern Market"}];
  [self.listofStationsMap addObject:@{@"old_id": @"49", @"new_id": @"C14", @"new_name": @"Eisenhower Avenue"}];
  [self.listofStationsMap addObject:@{@"old_id": @"4", @"new_id": @"A02", @"new_name": @"Farragut North"}];
  [self.listofStationsMap addObject:@{@"old_id": @"38", @"new_id": @"C03", @"new_name": @"Farragut West"}];
  [self.listofStationsMap addObject:@{@"old_id": @"58", @"new_id": @"D04", @"new_name": @"Federal Center SW"}];
  [self.listofStationsMap addObject:@{@"old_id": @"53", @"new_id": @"D01", @"new_name": @"Federal Triangle"}];
  [self.listofStationsMap addObject:@{@"old_id": @"40", @"new_id": @"C04", @"new_name": @"Foggy Bottom-GWU"}];
  [self.listofStationsMap addObject:@{@"old_id": @"32", @"new_id": @"B09", @"new_name": @"Forest Glen"}];
  [self.listofStationsMap addObject:@{@"old_id": @"28", @"new_id": @"E06,B06", @"new_name": @"Fort Totten"}];
  [self.listofStationsMap addObject:@{@"old_id": @"95", @"new_id": @"J03", @"new_name": @"Franconia-Springfield"}];
  [self.listofStationsMap addObject:@{@"old_id": @"11", @"new_id": @"A08", @"new_name": @"Friendship Heights"}];
  [self.listofStationsMap addObject:@{@"old_id": @"21", @"new_id": @"B01,F01", @"new_name": @"Gallery Pl-Chinatown"}];
  [self.listofStationsMap addObject:@{@"old_id": @"76", @"new_id": @"E05", @"new_name": @"Georgia Ave-Petworth"}];
  [self.listofStationsMap addObject:@{@"old_id": @"34", @"new_id": @"B11", @"new_name": @"Glenmont"}];
  [self.listofStationsMap addObject:@{@"old_id": @"80", @"new_id": @"E10", @"new_name": @"Greenbelt"}];
  [self.listofStationsMap addObject:@{@"old_id": @"113", @"new_id": @"N03", @"new_name": @"Greensboro"}];
  [self.listofStationsMap addObject:@{@"old_id": @"14", @"new_id": @"A11", @"new_name": @"Grosvenor-Strathmore"}];
  [self.listofStationsMap addObject:@{@"old_id": @"50", @"new_id": @"C15", @"new_name": @"Huntington"}];
  [self.listofStationsMap addObject:@{@"old_id": @"23", @"new_id": @"B02", @"new_name": @"Judiciary Square"}];
  [self.listofStationsMap addObject:@{@"old_id": @"48", @"new_id": @"C13", @"new_name": @"King St-Old Town"}];
  [self.listofStationsMap addObject:@{@"old_id": @"82", @"new_id": @"F03,D03", @"new_name": @"L'Enfant Plaza"}];
  [self.listofStationsMap addObject:@{@"old_id": @"67", @"new_id": @"D12", @"new_name": @"Landover"}];
  [self.listofStationsMap addObject:@{@"old_id": @"109", @"new_id": @"G05", @"new_name": @"Largo Town Center"}];
  [self.listofStationsMap addObject:@{@"old_id": @"111", @"new_id": @"N01", @"new_name": @"McLean"}];
  [self.listofStationsMap addObject:@{@"old_id": @"36", @"new_id": @"C02", @"new_name": @"McPherson Square"}];
  [self.listofStationsMap addObject:@{@"old_id": @"13", @"new_id": @"A10", @"new_name": @"Medical Center"}];
  [self.listofStationsMap addObject:@{@"old_id": @"1", @"new_id": @"C01,A01", @"new_name": @"Metro Center"}];
  [self.listofStationsMap addObject:@{@"old_id": @"64", @"new_id": @"D09", @"new_name": @"Minnesota Ave"}];
  [self.listofStationsMap addObject:@{@"old_id": @"110", @"new_id": @"G04", @"new_name": @"Morgan Boulevard"}];
  [self.listofStationsMap addObject:@{@"old_id": @"70", @"new_id": @"E01", @"new_name": @"Mt Vernon Sq 7th St-Convention Center"}];
  [self.listofStationsMap addObject:@{@"old_id": @"84", @"new_id": @"F05", @"new_name": @"Navy Yard-Ballpark"}];
  [self.listofStationsMap addObject:@{@"old_id": @"87", @"new_id": @"F09", @"new_name": @"Naylor Road"}];
  [self.listofStationsMap addObject:@{@"old_id": @"68", @"new_id": @"D13", @"new_name": @"New Carrollton"}];
  [self.listofStationsMap addObject:@{@"old_id": @"108", @"new_id": @"B35", @"new_name": @"NoMa-Gallaudet U"}];
  [self.listofStationsMap addObject:@{@"old_id": @"43", @"new_id": @"C07", @"new_name": @"Pentagon"}];
  [self.listofStationsMap addObject:@{@"old_id": @"44", @"new_id": @"C08", @"new_name": @"Pentagon City"}];
  [self.listofStationsMap addObject:@{@"old_id": @"61", @"new_id": @"D07", @"new_name": @"Potomac Ave"}];
  [self.listofStationsMap addObject:@{@"old_id": @"78", @"new_id": @"E08", @"new_name": @"Prince George's Plaza"}];
  [self.listofStationsMap addObject:@{@"old_id": @"26", @"new_id": @"B04", @"new_name": @"Rhode Island Ave-Brentwood"}];
  [self.listofStationsMap addObject:@{@"old_id": @"17", @"new_id": @"A14", @"new_name": @"Rockville"}];
  [self.listofStationsMap addObject:@{@"old_id": @"93", @"new_id": @"C10", @"new_name": @"Ronald Reagan Washington National Airport"}];
  [self.listofStationsMap addObject:@{@"old_id": @"41", @"new_id": @"C05", @"new_name": @"Rosslyn"}];
  [self.listofStationsMap addObject:@{@"old_id": @"18", @"new_id": @"A15", @"new_name": @"Shady Grove"}];
  [self.listofStationsMap addObject:@{@"old_id": @"72", @"new_id": @"E02", @"new_name": @"Shaw-Howard U"}];
  [self.listofStationsMap addObject:@{@"old_id": @"31", @"new_id": @"B08", @"new_name": @"Silver Spring"}];
  [self.listofStationsMap addObject:@{@"old_id": @"54", @"new_id": @"D02", @"new_name": @"Smithsonian"}];
  [self.listofStationsMap addObject:@{@"old_id": @"107", @"new_id": @"F08", @"new_name": @"Southern Avenue"}];
  [self.listofStationsMap addObject:@{@"old_id": @"114", @"new_id": @"N04", @"new_name": @"Spring Hill"}];
  [self.listofStationsMap addObject:@{@"old_id": @"63", @"new_id": @"D08", @"new_name": @"Stadium-Armory"}];
  [self.listofStationsMap addObject:@{@"old_id": @"88", @"new_id": @"F10", @"new_name": @"Suitland"}];
  [self.listofStationsMap addObject:@{@"old_id": @"29", @"new_id": @"B07", @"new_name": @"Takoma"}];
  [self.listofStationsMap addObject:@{@"old_id": @"10", @"new_id": @"A07", @"new_name": @"Tenleytown-AU"}];
  [self.listofStationsMap addObject:@{@"old_id": @"16", @"new_id": @"A13", @"new_name": @"Twinbrook"}];
  [self.listofStationsMap addObject:@{@"old_id": @"112", @"new_id": @"N02", @"new_name": @"Tysons Corner"}];
  [self.listofStationsMap addObject:@{@"old_id": @"73", @"new_id": @"E03", @"new_name": @"U Street/African-Amer Civil War Memorial/Cardozo"}];
  [self.listofStationsMap addObject:@{@"old_id": @"25", @"new_id": @"B03", @"new_name": @"Union Station"}];
  [self.listofStationsMap addObject:@{@"old_id": @"94", @"new_id": @"J02", @"new_name": @"Van Dorn Street"}];
  [self.listofStationsMap addObject:@{@"old_id": @"9", @"new_id": @"A06", @"new_name": @"Van Ness-UDC"}];
  [self.listofStationsMap addObject:@{@"old_id": @"103", @"new_id": @"K08", @"new_name": @"Vienna/Fairfax-GMU"}];
  [self.listofStationsMap addObject:@{@"old_id": @"98", @"new_id": @"K03", @"new_name": @"Virginia Square-GMU"}];
  [self.listofStationsMap addObject:@{@"old_id": @"83", @"new_id": @"F04", @"new_name": @"Waterfront"}];
  [self.listofStationsMap addObject:@{@"old_id": @"101", @"new_id": @"K06", @"new_name": @"West Falls Church-VT/UVA"}];
  [self.listofStationsMap addObject:@{@"old_id": @"77", @"new_id": @"E07", @"new_name": @"West Hyattsville"}];
  [self.listofStationsMap addObject:@{@"old_id": @"33", @"new_id": @"B10", @"new_name": @"Wheaton"}];
  [self.listofStationsMap addObject:@{@"old_id": @"15", @"new_id": @"A12", @"new_name": @"White Flint"}];
  [self.listofStationsMap addObject:@{@"old_id": @"115", @"new_id": @"N06", @"new_name": @"Wiehle-Reston East"}];
  [self.listofStationsMap addObject:@{@"old_id": @"7", @"new_id": @"A04", @"new_name": @"Woodley Park-Zoo/Adams Morgan"}];
}


//+++++
// This seems stupid. Easier way?
int gLastIndex = -1;
- (void)tabBarController:(UITabBarController*)tabBarController
    didSelectViewController:(UIViewController*)viewController {
  if (gLastIndex != -1)
    [[self.tabBarController.viewControllers objectAtIndex:gLastIndex]
        popToRootViewControllerAnimated:NO];

  gLastIndex = (int)self.tabBarController.selectedIndex;
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
