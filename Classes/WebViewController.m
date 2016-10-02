//
//  WebViewController.m
//  MetroTabBar
//
//  Created by Justin Cohen on 9/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "FavoritesViewController.h"
#import "MetroTabBarAppDelegate.h"

@implementation WebViewController

@synthesize metroId, webView;

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
  if (![progressView isAnimating])
    return;

  UIAlertView* modalMessage =
      [[UIAlertView alloc] initWithTitle:nil
                                 message:@"Couldn't connect to Metro..."
                                delegate:self
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil];
  [modalMessage show];
  [modalMessage release];

  [self stopLoad];
}

- (void)stopLoad {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [progressView stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
  [self stopLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
  [webView stopLoading];

  NSURL* metroUrl = [NSURL URLWithString:@"about:blank"];
  NSURLRequest* metroRequest = [NSURLRequest requestWithURL:metroUrl];
  [webView loadRequest:metroRequest];

  UIButton* button =
      (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  [button setBackgroundImage:nil forState:UIControlStateNormal];
  [self stopLoad];
}

- (void)viewDidAppear:(BOOL)animated {

  UIButton* button =
      (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  if ([self isFavorite])
    [button setBackgroundImage:[UIImage imageNamed:@"orange-star.png"]
                      forState:UIControlStateNormal];
  else
    [button setBackgroundImage:[UIImage imageNamed:@"grey-star.png"]
                      forState:UIControlStateNormal];

  // NSString *webAddress = [[NSString alloc]
  // initWithFormat:@"http://wmata.com/metrorail/Stations/showpid/showpid.cfm?station=%@",
  // metroId];
  NSString* webAddress = [[NSString alloc]
      initWithFormat:
          @"http://www.wmata.com/rider_tools/pids/showpid.cfm?station_id=%@",
          metroId];

  // load metro website
  NSURL* metroUrl = [NSURL URLWithString:webAddress];
  [webAddress release];
  NSURLRequest* metroRequest = [NSURLRequest requestWithURL:metroUrl];
  [webView loadRequest:metroRequest];
  webView.scalesPageToFit = NO;

  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  if (!progressView) {
    progressView = [[UIActivityIndicatorView alloc]
        initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 12,
                                 self.view.bounds.size.height / 2 - 12,
                                 24,
                                 24)];
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin);

    [self.view addSubview:progressView];
  }

  [progressView startAnimating];
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
  // UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage
  // imageNamed:@"orange-star.png"]];

  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBounds:CGRectMake(0.0, 0.0, 22, 22)];
  [button addTarget:self
                action:@selector(toggleFavorite)
      forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem* addButton =
      [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
  self.navigationItem.rightBarButtonItem = addButton;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toggleFavorite {

  UIButton* button =
      (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  if ([self isFavorite])
    [button setBackgroundImage:[UIImage imageNamed:@"grey-star.png"]
                      forState:UIControlStateNormal];
  else
    [button setBackgroundImage:[UIImage imageNamed:@"orange-star.png"]
                      forState:UIControlStateNormal];
  [self changeFavorite];
}

- (BOOL)isFavorite {
  int count = (int)[[FavoritesViewController GetInstance].listOfContents count];
  for (int i = 0; i < count; i++) {
    if ([[[[FavoritesViewController GetInstance].listOfContents objectAtIndex:i]
            objectForKey:@"site"] isEqualToString:self.metroId]) {
      return YES;
    }
  }
  return NO;
}

- (void)changeFavorite {
  if ([self isFavorite]) {
    [[FavoritesViewController GetInstance] removeMetroId:self.metroId];
  } else {

    NSMutableArray* listOfContents =
        ((MetroTabBarAppDelegate*)[[UIApplication sharedApplication] delegate])
            .listOfStations;

    int count = (int)[listOfContents count];
    for (int i = 0; i < count; i++) {
      if ([[[listOfContents objectAtIndex:i] objectForKey:@"site"]
              isEqualToString:self.metroId]) {

        [[FavoritesViewController GetInstance]
            addMetroDictionary:[listOfContents objectAtIndex:i]];
        break;
      }
    }

    //[[FavoritesViewController GetInstance] addMetroName:self.title
    //withSite:self.metroId];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];  // Releases the view if it doesn't have a
                                    // superview
  // Release anything that's not essential, such as cached data
}

- (void)dealloc {
  [metroId release];
  [webView release];
  [progressView release];
  [super dealloc];
}

@end
