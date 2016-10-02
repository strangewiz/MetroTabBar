//
//  MapWebViewController.m
//  MetroTabBar
//
//  Created by Justin Cohen on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MapWebViewController.h"
#import "ListViewController.h"
#import "MetroTabBarAppDelegate.h"

@implementation MapWebViewController

@synthesize webView, wvController;

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

- (void)webViewDidFinishLoad:(UIWebView*)webView {
  [progressView stopAnimating];
}

- (BOOL)webView:(UIWebView*)webView
    shouldStartLoadWithRequest:(NSURLRequest*)request
                navigationType:(UIWebViewNavigationType)navigationType {
  NSURL* url = [request URL];
  NSString* fragment = [url fragment];
  if (fragment != nil && [fragment length] > 0) {
    if (wvController == nil) {
      // Initialize the controller
      WebViewController* aController =
          [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
      self.wvController = aController;
      [aController release];
    }

    //@""
    self.wvController.metroId = fragment;

    NSMutableArray* listOfContents =
        ((MetroTabBarAppDelegate*)[[UIApplication sharedApplication] delegate])
            .listOfStations;

    int count = (int)[listOfContents count];
    for (int i = 0; i < count; i++) {
      if ([[[listOfContents objectAtIndex:i] objectForKey:@"site"]
              isEqualToString:fragment]) {
        [wvController
            setTitle:[[listOfContents objectAtIndex:i] objectForKey:@"name"]];
        break;
      }
    }

    [[self navigationController] pushViewController:wvController animated:YES];

    NSString* imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath =
        [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath =
        [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    // NSString *HTMLData = @"<img src='dc-metro.png' />";
    //[webView loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString
    // stringWithFormat:@"file:/%@//",imagePath]]];

    NSString* filePath =
        [[NSBundle mainBundle] pathForResource:@"dc-metro-silver"
                                        ofType:@"html"];
    NSData* htmlData = [NSData dataWithContentsOfFile:filePath];
    [self.webView loadData:htmlData
                  MIMEType:@"text/html"
          textEncodingName:@"UTF-8"
                   baseURL:[NSURL URLWithString:
                                      [NSString stringWithFormat:@"file:/%@//",
                                                                 imagePath]]];
  }
  return YES;
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
  [super viewDidLoad];

  // load metro map resource
  /*
  NSString *webAddress = [[NSString alloc] initWithFormat:@"dc-metro.png"];
  NSURL *metroUrl = [NSURL URLWithString:webAddress];
  [webAddress release];
  */

  NSString* imagePath = [[NSBundle mainBundle] resourcePath];
  imagePath =
      [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
  imagePath =
      [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

  // NSString *HTMLData = @"<img src='dc-metro.png' />";
  //[webView loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString
  // stringWithFormat:@"file:/%@//",imagePath]]];

  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"dc-metro-silver" ofType:@"html"];
  NSData* htmlData = [NSData dataWithContentsOfFile:filePath];
  [webView loadData:htmlData
              MIMEType:@"text/html"
      textEncodingName:@"UTF-8"
               baseURL:[NSURL URLWithString:[NSString
                                                stringWithFormat:@"file:/%@//",
                                                                 imagePath]]];

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
  // NSURL *fileURL = [NSURL fileURLWithPath: @"Resources/dc-metro.png" ];
  // NSURLRequest *metroRequest = [NSURLRequest requestWithURL:fileURL];
  //[webView loadRequest:metroRequest];
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
  [progressView release];
  [webView release];
  [super dealloc];
}

@end
