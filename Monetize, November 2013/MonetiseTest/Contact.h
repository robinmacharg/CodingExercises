//
//  Contact.h
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) NSInteger contactID;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *notes;
@property (nonatomic) NSURL *picture;
@property (nonatomic) UIImage *imageData;

@end
