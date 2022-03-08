//
//  Notifications.m
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import "Notifications.h"

NSString *kContactImageLoaded = @"ContactImageLoaded";

NSString *kAddContactsNotificationName = @"AddContactsNotification"; // NSNotification name for sending earthquake data back to the app delegate
NSString *kContactResultsKey = @"ContactResultsKey";                 // NSNotification userInfo key for obtaining the earthquake data
NSString *kContactsErrorNotificationName = @"ContactErrorNotif";     // NSNotification name for reporting errors
NSString *kContactsMessageErrorKey = @"ContactsMsgErrorKey";         // NSNotification userInfo key for obtaining the error message