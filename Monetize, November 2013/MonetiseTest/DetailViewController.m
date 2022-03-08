//
//  DetailViewController.m
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+CustomColors.h"
#import "Notifications.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController {
    IBOutlet UILabel *contactName;
    IBOutlet UIImageView *contactImageView;
    IBOutlet UITextView *contactNotes;
    UIActivityIndicatorView *activityIndicator;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    // The image may be loaded after we are
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoaded:)
                                                 name:kContactImageLoaded
                                               object:nil];
    [self configureView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kContactImageLoaded
                                                  object:nil];
}

#pragma mark - Managing the detail item

- (void)setContact:(id)contact
{
    if (_contact != contact) {
        _contact = contact;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.contact) {
        contactName.text = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
        contactNotes.text = self.contact.notes;

        // If there's no image data it might be loading.  We'll get notified about that
        if (self.contact.imageData) {
            [contactImageView setImage:self.contact.imageData];
        }
        
        // No image? Let the user know something's happening
        else {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, contactImageView.frame.size.width, contactImageView.frame.size.height)];
            activityIndicator.color = [UIColor blackColor];
            [contactImageView addSubview:activityIndicator];
            [activityIndicator startAnimating];
        }

        self.view.backgroundColor = [self.contact.sex isEqualToString:@"m"] ? [UIColor maleColor] : [UIColor femaleColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageLoaded:(NSNotification *)notification
{
    if ([notification.userInfo[@"contactID"] integerValue] == self.contact.contactID) {
        if (activityIndicator) {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }
        if (self.contact.imageData) {
            [contactImageView setImage:self.contact.imageData];
        }
    }
}

@end
