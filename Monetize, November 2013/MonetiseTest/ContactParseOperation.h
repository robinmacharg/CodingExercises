//
//  ContactParseOperation.h
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactParseOperation : NSOperation

@property (copy, readonly) NSData *contactData;

- (id)initWithData:(NSData *)parseData;

@end
