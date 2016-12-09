//
//  ListViewController.m
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "FavoritesViewController.h"
#import "WebViewController.h"
#import "MetroTabBarAppDelegate.h"

@implementation ListViewController

static ListViewController* lvController;

@synthesize listOfContents, listOfSections, listOfSectionTitles, wvController;

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  // Number of sections of metro stations.  If we had one for each letter of the
  // alphabet, it'd be 26
  return [listOfSections count];
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  // for section i(section), how many rows are there?
  return
      [[[listOfSections objectAtIndex:section] objectForKey:@"objects"] count];
}

- (NSString*)tableView:(UITableView*)tableView
    titleForHeaderInSection:(NSInteger)section {
  // for section i(section), what is the title? (a, b, c, d)
  return [[listOfSections objectAtIndex:section] objectForKey:@"letter"];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
  // returns an array of index titles, seems to only be called once...
  return self.listOfSectionTitles;
}

- (NSInteger)tableView:(UITableView*)tableView
    sectionForSectionIndexTitle:(NSString*)title
                        atIndex:(NSInteger)index {
  return index;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {

  static NSString* MyIdentifier = @"MyIdentifier";

  // Try to retrieve from the table view a now-unused cell with the given
  // identifier
  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

  // If no cell is available, create a new one using the given identifier
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
                                   reuseIdentifier:MyIdentifier] autorelease];
  }

  NSString* colorImage = [[[[listOfSections objectAtIndex:indexPath.section]
      objectForKey:@"objects"] objectAtIndex:indexPath.row]
      objectForKey:@"colorImage"];
  cell.image = [UIImage
      imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorImage
                                                              ofType:@"png"
                                                         inDirectory:@"/"]];
  cell.text = [[[[listOfSections objectAtIndex:indexPath.section]
      objectForKey:@"objects"] objectAtIndex:indexPath.row]
      objectForKey:@"name"];
  return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath {

  NSString* site = [[[[listOfSections objectAtIndex:indexPath.section]
      objectForKey:@"objects"] objectAtIndex:indexPath.row]
      objectForKey:@"site"];
  NSString* name = [[[[listOfSections objectAtIndex:indexPath.section]
      objectForKey:@"objects"] objectAtIndex:indexPath.row]
      objectForKey:@"name"];

  /*
  if(self.title == @"Add to Favorites")
  {
      //fire an event for the parent controller to save this as a favorite and
  pop the frame...
      FavoritesViewController* fView =
  (FavoritesViewController*)[self.navigationController.viewControllers
  objectAtIndex:0];

      [fView addMetroName: name withSite: site];
      [[self navigationController] popToRootViewControllerAnimated: YES];
      return;
  }
  else
  */
  {
    if (wvController == nil) {
      // Initialize the controller

      WebViewController* aController =
          [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];

      self.wvController = aController;

      [aController release];
    }

    //@""
    self.wvController.metroId = site;
    self.wvController.metroName = name;
    [wvController setTitle:name];

    [[self navigationController] pushViewController:wvController animated:YES];
  }
  [name release];
  [site release];
}

+ (ListViewController*)GetInstance {
  return lvController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  lvController = self;
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  /*
  self.listOfContents = [[NSMutableArray alloc] initWithCapacity:40];

  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Addison Road-Seat Pleasant", @"name", @"92",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Anacostia", @"name", @"85", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Archives-Navy Memorial-Penn Quarter", @"name",
  @"81", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Arlington Cemetery", @"name", @"42", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Ballston-MU", @"name", @"99", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Benning Road", @"name", @"90", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Bethesda", @"name", @"12", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Braddock Road", @"name", @"47", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Branch Ave", @"name", @"89", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Brookland-CUA", @"name", @"27", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Capitol Heights", @"name", @"91", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Capitol South", @"name", @"59", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Cheverly", @"name", @"66", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Clarendon", @"name", @"97", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Cleveland Park", @"name", @"8", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"College Park-U of MD", @"name", @"79", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Columbia Heights", @"name", @"75", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Congress Heights", @"name", @"86", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Court House", @"name", @"96", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Crystal City", @"name", @"45", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Deanwood", @"name", @"65", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Dunn Loring-Merrifield", @"name", @"102",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Dupont Circle", @"name", @"6", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"East Falls Church", @"name", @"100", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Eastern Market", @"name", @"60", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Eisenhower Avenue", @"name", @"49", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Farragut North", @"name", @"4", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Farragut West", @"name", @"38", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Federal Center SW", @"name", @"58", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Federal Triangle", @"name", @"53", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Foggy Bottom-GWU", @"name", @"40", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Forest Glen", @"name", @"32", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Fort Totten", @"name", @"28", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Franconia-Springfield", @"name", @"95",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Friendship Heights", @"name", @"11", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Gallery Pl-Chinatown", @"name", @"21", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Georgia Ave-Petworth", @"name", @"76", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Glenmont", @"name", @"34", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Greenbelt", @"name", @"80", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Grosvenor-Strathmore", @"name", @"14", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Huntington", @"name", @"50", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Judiciary Square", @"name", @"23", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"King Street", @"name", @"48", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"L'Enfant Plaza", @"name", @"82", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Landover", @"name", @"67", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Largo Town Center", @"name", @"109", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"McPherson Square", @"name", @"36", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Medical Center", @"name", @"13", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Metro Center", @"name", @"1", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Minnesota Ave", @"name", @"64", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Morgan Boulevard", @"name", @"110", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mt
  Vernon Sq 7th St-Convention Center", @"name", @"70", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Navy Yard", @"name", @"84", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Naylor Road", @"name", @"87", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"New Carrollton", @"name", @"68", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"New York Ave-Florida Ave-Gallaudet U", @"name",
  @"108", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Pentagon", @"name", @"43", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Pentagon City", @"name", @"44", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Potomac Ave", @"name", @"61", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Prince George's Plaza", @"name", @"78",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Rhode Island Ave-Brentwood", @"name", @"26",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Rockville", @"name", @"17", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Ronald Reagan Washington National Airport",
  @"name", @"93", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Rosslyn", @"name", @"41", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Shady Grove", @"name", @"18", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Shaw-Howard U", @"name", @"72", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Silver Spring", @"name", @"31", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Smithsonian", @"name", @"54", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Southern Avenue", @"name", @"107", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Stadium-Armory", @"name", @"63", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Suitland", @"name", @"88", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Takoma", @"name", @"29", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Tenleytown-AU", @"name", @"10", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Twinbrook", @"name", @"16", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"U
  Street/African-Amer Civil War Memorial/Cardozo", @"name", @"73", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Union Station", @"name", @"25", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Van Dorn Street", @"name", @"94", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Van Ness-UDC", @"name", @"9", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Vienna/Fairfax-GMU", @"name", @"103", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Virginia Square-GMU", @"name", @"98", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Waterfront-SEU", @"name", @"83", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"West Falls Church-VT/UVA", @"name", @"101",
  @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"West Hyattsville", @"name", @"77", @"site",
  nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Wheaton", @"name", @"33", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"White Flint", @"name", @"15", @"site", nil]];
  [self.listOfContents addObject:[NSDictionary
  dictionaryWithObjectsAndKeys:@"Woodley Park-Zoo/Adams Morgan", @"name", @"7",
  @"site", nil]];
*/
  self.listOfContents =
      ((MetroTabBarAppDelegate*)[[UIApplication sharedApplication] delegate])
          .listOfStations;
  // [delegate customMethod];

  self.listOfSections = [[NSMutableArray alloc] initWithCapacity:20];
  self.listOfSectionTitles = [[NSMutableArray alloc] initWithCapacity:20];

  NSString* lastLetter = @"_";

  for (int index = 0; index < [listOfContents count]; index++) {
    NSString* sTemp =
        [[[listOfContents objectAtIndex:index] objectForKey:@"name"]
            substringToIndex:1];

    if (![sTemp isEqualToString:lastLetter]) {
      lastLetter = sTemp;

      // create a new mutable array in listOfSections with a letter and an empty
      // array
      [listOfSections
          addObject:[NSDictionary
                        dictionaryWithObjectsAndKeys:lastLetter,
                                                     @"letter",
                                                     [[NSMutableArray alloc]
                                                         initWithCapacity:1],
                                                     @"objects",
                                                     nil]];
      [listOfSectionTitles addObject:lastLetter];
    }

    // add dictionary to that empty array
    [[[listOfSections objectAtIndex:[listOfSections count] - 1]
        objectForKey:@"objects"]
        addObject:[listOfContents objectAtIndex:index]];

    //[sTemp release];
  }
}

/*
 // Override to support editing the list
 - (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
 withRowAnimation:YES];
 }
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array,
 and add a new row to the table view
 }
 }
 */

/*
 // Override to support conditional editing of the list
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
 *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support rearranging the list
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
 *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the list
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
 *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];  // Releases the view if it doesn't have a
                                    // superview
  // Release anything that's not essential, such as cached data
}

- (void)dealloc {

  [listOfContents release];
  [listOfSections release];
  [listOfSectionTitles release];
  [wvController release];
  [super dealloc];
}

@end
