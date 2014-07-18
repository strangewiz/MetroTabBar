//
//  MapViewController.m
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize wvController;

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        NSLog(@"touchesBegan");
        UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"x: %d, y: %d", touchLocation.x, touchLocation.y);


        //NSUInteger tapCount = [touch tapCount];
        switch (tapCount) {
                case 1:
                        [self performSelector:@selector(singleTapMethod)
withObject:nil afterDelay:.4];
                        break;
                case 2:
                        [NSObject cancelPreviousPerformRequestsWithTarget:self
selector:@selector(singleTapMethod) object:nil];
                        [self performSelector:@selector(doubleTapMethod)
withObject:nil afterDelay:.4];
                        break;
                default:
                        break;
        }
}
*/
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"x: %d, y: %d", touchLocation.x, touchLocation.y);
}

 */
/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        NSLog(@"touchesEnded");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"x: %d, y: %d", touchLocation.x, touchLocation.y);

        // We only support single touches, so anyObject retrieves just that
touch from touches
        BOOL tappedTwice = NO;

        if ([touch tapCount] == 2) {
                //Do A
                tappedTwice = YES;
                NSLog(@"tapped twice");
        }

        // In case of a double tap outside the placard view, update the
placard's display string
        else if ([touch tapCount] == 1 && !tappedTwice) {

                NSLog(@"tapped once");

        }
}
 */

CGPoint gLastOffset, gCurrentOffset;
double gLastTouchTimestamp;

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

  // why do i get these touches twice, I need to ignore the last one
  UITouch* touch = [[event allTouches] anyObject];
  if (gLastTouchTimestamp == touch.timestamp)
    return;
  gLastTouchTimestamp = touch.timestamp;

  // If they view didn't change, we just clicked...
  if (CGPointEqualToPoint(gLastOffset, gCurrentOffset)) {
    // is the x and y position near a metro, push the view
    NSLog(@"This is a valid touch, but is it near a metro stop?");
    CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"x: %f, y: %f", touchLocation.x, touchLocation.y);
    float x = touchLocation.x;
    float y = touchLocation.y;

    if (x > 227.0 && x < 241.0 && y > 454.0 && y < 469.0) {
      // push courthouse
      //
      //[self.listOfContents addObject:[NSDictionary
      //dictionaryWithObjectsAndKeys:@"Court House", @"name", @"96", @"site",
      //nil]];

      if (wvController == nil) {
        // Initialize the controller

        WebViewController* aController =
            [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];

        self.wvController = aController;

        [aController release];
      }

      //@""
      self.wvController.metroId = @"96";
      [wvController setTitle:@"Courthouse"];

      [[self navigationController] pushViewController:wvController
                                             animated:YES];
    }
  }

  gCurrentOffset = gLastOffset;
}

/*
// Override initWithNibName:bundle: to load the view using a nib file then
perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
  [super viewDidLoad];

  // seems like this doesn't work from IB
  scrollView.contentSize =
      CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
  scrollView.maximumZoomScale = 5.0;
  scrollView.minimumZoomScale = .3;

  [scrollView flashScrollIndicators];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
  return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView*)aScrollView
                       withView:(UIView*)view
                        atScale:(float)scale {
  gCurrentOffset = aScrollView.contentOffset;
  NSLog(@"scale: %f", scale);
  NSLog(@"bounds-origin: %f, %f -- bounds-size: %f, %f",
        view.bounds.origin.x,
        view.bounds.origin.y,
        view.bounds.size.width,
        view.bounds.size.height);
  NSLog(@"center: %f, %f", view.center.x, view.center.y);
  NSLog(@"content-offset: %f, %f",
        aScrollView.contentOffset.x,
        aScrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)aScrollView {
  NSLog(@"content-offset: %f, %f",
        aScrollView.contentOffset.x,
        aScrollView.contentOffset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView*)aScrollView
                  willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    NSLog(@"content-offset: %f, %f",
          aScrollView.contentOffset.x,
          aScrollView.contentOffset.y);
  }
}

- (BOOL)touchesShouldBegin:(NSSet*)touches
                 withEvent:(UIEvent*)event
             inContentView:(UIView*)view {
  NSLog(@"touchesShouldBegin");
  return TRUE;
}

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
  [wvController dealloc];
  [super dealloc];
}

@end
