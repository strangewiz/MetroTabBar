//
//  FavoritesViewController.m
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ListViewController.h"
#import "MetroTabBarAppDelegate.h"

@implementation FavoritesViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and
want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

static FavoritesViewController* fvController;

@synthesize listOfContents, editButton, wvController;

+ (FavoritesViewController*)GetInstance {
  return fvController;
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
  [super viewDidLoad];
  fvController = self;
  /*   self.editButton = [[[UIBarButtonItem alloc]
                                                                    initWithTitle:@"Edit"
                                                                    style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(editClicked:)]
     autorelease];*/
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  /*
  UIBarButtonItem *addButton = [[[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addClicked:)] autorelease];
  */

  //    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage
  // imageNamed:@"orange-star.png"]];

  //  UIBarButtonItem *addButton = [[[UIBarButtonItem alloc]
  //                                 initWithCustomView:imageView] autorelease];
  // self.navigationItem.rightBarButtonItem = addButton;

  self.listOfContents =
      [[NSKeyedUnarchiver unarchiveObjectWithFile:[self favoritesPath]] retain];
  if (!self.listOfContents) {
    self.listOfContents = [[NSMutableArray alloc] initWithCapacity:1];
  }


  self.listOfContents = [NSMutableArray arrayWithArray:self.listOfContents];

  NSMutableArray* listofStationsMap =
      ((MetroTabBarAppDelegate*)[[UIApplication sharedApplication] delegate]).listofStationsMap;

  BOOL needsUpdate = NO;
  for (int i = 0; i < [self.listOfContents count]; i++) {
    NSDictionary* item = self.listOfContents[i];
    NSString* old_id = [item objectForKey:@"site"];
    for (NSDictionary* new_item in listofStationsMap) {
      if ([old_id isEqualToString:[new_item objectForKey:@"old_id"]]) {
        NSString* new_id = [new_item objectForKey:@"new_id"];
        NSString* new_name = [new_item objectForKey:@"new_name"];
        NSMutableDictionary* mutable_item = [item mutableCopy];
        [mutable_item setValue:new_id forKey:@"site"];
        [mutable_item setValue:new_name forKey:@"name"];
        self.listOfContents[i] = mutable_item;
        needsUpdate = YES;
      }
    }
  }
  if (needsUpdate) {
    [self saveList];
  }

  // For testing, but maybe it would be cool to auto add smithsoneum or
  // something..
  if ([self.listOfContents count] == 0) {
    //[self.listOfContents addObject:[NSDictionary
    //dictionaryWithObjectsAndKeys:@"Addison Road-Seat Pleasant", @"name",
    //@"92", @"site", nil]];
    //[self.listOfContents addObject:[NSDictionary
    //dictionaryWithObjectsAndKeys:@"Anacostia", @"name", @"85", @"site", nil]];
    //[self.listOfContents addObject:[NSDictionary
    //dictionaryWithObjectsAndKeys:@"Archives-Navy Memorial-Penn Quarter",
    //@"name", @"81", @"site", nil]];
    //[self.listOfContents addObject:[NSDictionary
    //dictionaryWithObjectsAndKeys:@"Arlington Cemetery", @"name", @"42",
    //@"site", nil]];
  }

  self.navigationItem.rightBarButtonItem =
      [listOfContents count] > 0 ? self.editButtonItem : nil;
}

//-(void)addMetroName:(NSString *)name withSite:(NSString *)site
- (void)addMetroDictionary:(NSDictionary*)dict {
  [self.listOfContents addObject:dict];
  [self saveList];
  [self.tableView reloadData];
}

- (void)removeMetroId:(NSString*)id {
  int count = (int)[self.listOfContents count];
  for (int i = 0; i < count; i++) {
    if ([[[self.listOfContents objectAtIndex:i] objectForKey:@"site"]
            isEqualToString:id]) {

      [self.listOfContents removeObjectAtIndex:i];
      [self saveList];
      [self.tableView reloadData];

      return;
    }
  }

  //++++
  /// can we assert here?
}

- (void)saveList {
  [NSKeyedArchiver archiveRootObject:self.listOfContents
                              toFile:self.favoritesPath];

  if ([listOfContents count] > 0) {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
    [self setEditing:NO animated:NO];
  }
}

- (NSString*)favoritesPath {

  //++++
  // This seems like a really complicated way to just save data.  Is this right
  // rizzle?
  NSArray* paths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  return [documentsDirectory stringByAppendingPathComponent:@"favorites"];
}

- (void)addClicked:(id)sender {

  ListViewController* aController =
      [[ListViewController alloc] initWithNibName:@"ListView" bundle:nil];

  aController.title = @"Add to Favorites";

  //	[[self navigationController] presentModalViewController:aController
  //animated:YES];
  [[self navigationController] pushViewController:aController animated:YES];
}

/*
-(void)editClicked:(id)sender {
        if(self.editing)
        {
                [self setEditing: NO animated: YES];
                self.navigationItem.leftBarButtonItem.title = @"Edit";
        }
        else
        {
        [self setEditing: YES animated: YES];
                self.navigationItem.leftBarButtonItem.title = @"Done";
        }
//	self edit
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [listOfContents count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {

  static NSString* CellIdentifier = @"Cell";

  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] autorelease];
  }

  NSString* colorImage =
      [[listOfContents objectAtIndex:indexPath.row] objectForKey:@"colorImage"];
  cell.imageView.image = [UIImage
      imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorImage
                                                              ofType:@"png"
                                                         inDirectory:@"/"]];

  cell.textLabel.text =
      [[listOfContents objectAtIndex:indexPath.row] objectForKey:@"name"];

  return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath {

  // Check to see if the controller is nil or not.
  if (wvController == nil) {
    // Initialize the controller

    WebViewController* aController =
        [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];

    self.wvController = aController;

    [aController release];
  }

  self.wvController.metroId =
      [[listOfContents objectAtIndex:indexPath.row] objectForKey:@"site"];
  NSString* name = [[listOfContents objectAtIndex:indexPath.row]
                    objectForKey:@"name"];
  self.wvController.metroName = name;
  [wvController setTitle:name];
  [[self navigationController] pushViewController:wvController animated:YES];
}

- (void)tableView:(UITableView*)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath*)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {

    NSInteger row = [indexPath row];

    [self.listOfContents removeObjectAtIndex:row];

    [self saveList];
    //+++++
    // WTF?  Why do I have to do this too, rizzle..
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
  }
  if (editingStyle == UITableViewCellEditingStyleInsert) {
  }
}

- (BOOL)tableView:(UITableView*)tableView
    canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  return YES;
}

- (void)tableView:(UITableView*)tableView
    moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
           toIndexPath:(NSIndexPath*)toIndexPath {
//  NSLog(@"fromIndexPath :%ld", (long)fromIndexPath.row);
//  NSLog(@"toIndexPath :%ld", (long)toIndexPath.row);
//  NSLog(@"sizeIndexPath :%ld", (unsigned long)[self.listOfContents count]);

  //+++++
  // Is this leaking?  I see a retain, do I need to release?
  NSDictionary* fromDict =
      [[self.listOfContents objectAtIndex:fromIndexPath.row] retain];
  [self.listOfContents removeObjectAtIndex:fromIndexPath.row];
  [self.listOfContents insertObject:fromDict atIndex:toIndexPath.row];
  [self saveList];
}

- (BOOL)tableView:(UITableView*)tableView
    canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
  return YES;
}

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
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
  [listOfContents release];
  [editButton release];
  [wvController release];
  [super dealloc];
}

@end
