//
//  MasterViewController.m
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//
// ============================================================================
// Notes for Monetise:
//
// Based on Apple's standard master/detail template, with boilerplate
// portions lifted from Apple's Seismic demo app:
//     https://developer.apple.com/library/ios/samplecode/SeismicXML
// which provides an example SAX parser structure
//
// This solution may be overkill for the purposes of testing programming skills
// and with these volumes of data - DOM is obviously more suited -
// but is at least extensible, and provides me with an opportunity to
// re-exercise some skills.
//
// Comments should answer the "why?" questions, and provide a quick narrative of the
// structure.  For instance View lifecycle and Table Delegate methods are not commented
// explicitly - we know what they do and why they're there; the details therein are,
// however commented, where necessary.
//
// Both XML loading and parsing, and image loading, are backgrounded, and I've used
// NSNotifications to let me know when the images arrive.
//
// I've tried to make things as modular as possible - adding a category for custom colours,
// static notification strings etc.  In-memory caching is used for images, but not for the
// XML document.
//
// I also have some idioms that I'm quite prepared to relearn, e.g.
// [@[] mutableCopy] instead of the (to my eyes) less readable and more verbose
// [[NSMutableArray alloc] init]
//
// Also note for the purposes of showing off (albeit trivial) cell styling I've
// added a female contact manually after XML parsing.  Pull-to-refresh adds Ada
// multiple times to better show off the issues with constant background reloading
// and lack of smart caching.  Commented out initially.  Uncomment the #ifdef
// block in addContactsToList: to enable.
//
// The detail page layout could use some work on 3.5" screens.  Looks fine on 4".
// Autolayout would help.

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ContactParseOperation.h"
#import "ContactCell.h"
#import "Contact.h"
#import "Notifications.h"
#import "UIColor+CustomColors.h"

@interface MasterViewController ()

@property (nonatomic) NSMutableArray *contactList;
@property (nonatomic) NSOperationQueue *parseQueue; // A queue for parsing web responses

@end

@implementation MasterViewController {
    NSInteger ops; // number of refresh operations, for synthesizing increasing numbers of Adas
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ops = 0;
   
    // Add pull to refresh - do a full reload on refresh.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.contactList = [@[] mutableCopy];
    self.parseQueue = [NSOperationQueue new];
    
    // Observe our XML parser notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addContacts:)
                                                 name:kAddContactsNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactsError:)
                                                 name:kContactsErrorNotificationName object:nil];
    
    [self loadData:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

-(void)loadData:(id)sender
{
    // Retrieve the feed URL from the main app bundle plist
    NSString *contactsFeedURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MonetiseContactFeedURL"];
    
    // We always want to get a fresh contact list
    NSURLRequest *contactsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:contactsFeedURL]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                 timeoutInterval:60];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Async request - non blocking
    [NSURLConnection sendAsynchronousRequest:contactsRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               
                               // here we check for any returned NSError from the server, "and" we also check for any http response errors
                               if (error != nil) {
                                   [self handleError:error];
                               }
                               else {
                                   // check for any response errors
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/xml"]) {
                                       
                                       // Update the UI and start parsing the data,
                                       // Spawn an NSOperation to parse the earthquake data so that the UI is not
                                       // blocked while the application parses the XML data.
                                       ContactParseOperation *parseOperation = [[ContactParseOperation alloc] initWithData:data];
                                       [self.parseQueue addOperation:parseOperation];
                                   }
                                   else {
                                       NSString *errorString =
                                       NSLocalizedString(@"HTTP Error", @"Error message displayed when receving a connection error.");
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorString};
                                       NSError *reportError = [NSError errorWithDomain:@"HTTP"
                                                                                  code:[httpResponse statusCode]
                                                                              userInfo:userInfo];
                                       [self handleError:reportError];
                                   }
                               }
                           }];
}

/**
 Handle errors in the download by showing an alert to the user. This is a very simple way of handling the error, 
 partly because this application does not have any offline functionality for the user. Most real applications 
 should handle the error in a less obtrusive way and provide offline functionality to the user.
 */
- (void)handleError:(NSError *)error
{
    NSString *basicMessage = NSLocalizedString(@"There was an error retrieving the contact list.  Error details", @"Basic error message");
    NSString *errorMessage = [NSString stringWithFormat:@"%@:\n\n%@", basicMessage, [error localizedDescription]];
    NSString *alertTitle = NSLocalizedString(@"Error", @"Title for alert displayed when download or parse error occurs.");
    NSString *okTitle = NSLocalizedString(@"OK ", @"OK Title for alert displayed when download or parse error occurs.");
    
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:okTitle
                      otherButtonTitles:nil]
     show];
}

#pragma mark - Notifications

/**
 Our NSNotification callback from the running NSOperation to add the contacts
 */
- (void)addContacts:(NSNotification *)notification
{
    assert([NSThread isMainThread]);
    [self.refreshControl endRefreshing];
    [self addContactsToList:[[notification userInfo] valueForKey:kContactResultsKey]];
}

/**
 Our NSNotification callback from the running NSOperation when a parsing error has occurred
 */
- (void)contactsError:(NSNotification *)notif
{
    assert([NSThread isMainThread]);
    [self handleError:[[notif userInfo] valueForKey:kContactsMessageErrorKey]];
}

/**
 The NSOperation "ParseOperation" calls addContacts: via NSNotification, on the main thread which in turn calls 
 this method.
 */
- (void)addContactsToList:(NSArray *)contacts
{
    
//#ifdef DEBUG
//    ops++;
//    NSMutableArray *newContacts = [contacts mutableCopy];
//    for (int i=0; i<ops; i++) {
//        // Add one female into the mix for testing, and solely for the purposes of this test exercise.  This is not production code!
//        Contact *contact = [[Contact alloc] init];
//        contact.firstName = @"Ada";
//        contact.lastName = @"Lovelace";
//        contact.age = 37;
//        contact.sex = @"f";
//        contact.notes = @"An English mathematician and writer chiefly known for her work on Charles Babbage's early mechanical general-purpose computer, the Analytical Engine.";
//        contact.picture = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/167px-Ada_Lovelace_portrait.jpg"];
//        
//        [newContacts insertObject:contact atIndex:2];
//    }
//    
//    contacts = [NSArray arrayWithArray:newContacts];
//#endif
    
    NSInteger startingRow = [self.contactList count];
    NSInteger contactsCount = [contacts count];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:contactsCount];
    
    for (NSInteger row = startingRow; row < (startingRow + contactsCount); row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [indexPaths addObject:indexPath];
    }

    self.contactList = [contacts mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Contact *contact = self.contactList[indexPath.row];
//    [cell configureWithContact:contact forIndexPath:indexPath];

    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    cell.ageLabel.text = [NSString stringWithFormat:@"%i", contact.age];
    cell.sexLabel.text = [contact.sex isEqualToString:@"m"] ? @"Male" : @"Female";
    cell.imageLabel.image = nil;
    
    cell.backgroundColor = [contact.sex isEqualToString:@"m"] ? [UIColor maleColor] : [UIColor femaleColor];
    
    // Load the cell images in the background
    // http://stackoverflow.com/a/17318739/2431627 - credit where it's due.
    //__block NSData *imageData;
    //dispatch_queue_t backgroundQueue  = dispatch_queue_create("contactImages", NULL);
    
    // Load images asynchronously, update the UI on the main thread when it arrives.
    // Uses local cache for images by default.
    // Steve Jobs' image is a big one - should probably resize images after loading
    // TODO: more error checking and handling failure nicely.  Handle missing images more elegantly - placeholders etc.
    // http://stackoverflow.com/a/7852138/2431627 for tips on writing to the correct cell.
    if (contact.picture) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, cell.imageLabel.frame.size.width, cell.imageLabel.frame.size.height)];
        [activityIndicator setColor:[UIColor blackColor]];
        [cell.imageLabel addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:contact.picture
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:120];
        
        [NSURLConnection sendAsynchronousRequest:imageRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   //imageData = data;
                                   UIImage *imageLoad;
                                   imageLoad = [[UIImage alloc] initWithData:data];
                                   contact.imageData = imageLoad;
                                   [activityIndicator removeFromSuperview];
                                   
                                   // Update UI on main thread
                                   dispatch_async(dispatch_get_main_queue(), ^(void) {
                                       [activityIndicator stopAnimating];
                                       
                                       ContactCell *cell = (ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                                       cell.imageLabel.image = imageLoad;
                                       [cell setNeedsLayout];
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kContactImageLoaded object:nil userInfo:@{@"contactID" : @(contact.contactID)}];
                                   });
                               }];
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contact *contact = [self.contactList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setContact:contact];
    }
}

@end
