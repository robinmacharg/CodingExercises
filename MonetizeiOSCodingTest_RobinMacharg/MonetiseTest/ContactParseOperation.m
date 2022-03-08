//
//  ContactParseOperation.m
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import "ContactParseOperation.h"
#import "Contact.h"
#import "Notifications.h"

@interface ContactParseOperation () <NSXMLParserDelegate>

@property (nonatomic) Contact *currentContactObject;
@property (nonatomic) NSMutableArray *currentParseBatch;
@property (nonatomic) NSMutableString *currentParsedCharacterData;

@end

@implementation ContactParseOperation {
    BOOL _accumulatingParsedCharacterData;
    BOOL _didAbortParsing;
    NSUInteger _parsedContactsCounter;
    NSArray *_collectingElements;
}

- (id)initWithData:(NSData *)parseData
{
    self = [super init];
    if (self) {
        // The elements we wish to extract data from
        _collectingElements = @[kFirstNameElementName, kLastNmeElementName, kPictureElementName, kNotesElementName, kSexElementName, kAgeElementName];
        _contactData = [parseData copy];
        
        
        _currentParseBatch = [[NSMutableArray alloc] init];
        _currentParsedCharacterData = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)addContactsToList:(NSArray *)contacts
{
    assert([NSThread isMainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddContactsNotificationName
                                                        object:self
                                                      userInfo:@{kContactResultsKey: contacts}];
}

- (void)main {
    
    /*
     It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not 
     desirable because it gives less control over the network, particularly in responding to connection errors.
     */
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.contactData];
    [parser setDelegate:self];
    [parser parse];
    
    /*
     Depending on the total number of contacts parsed, the last batch might not have been a 
     "full" batch, and thus not been part of the regular batch transfer. So, we check the 
     count of the array and, if necessary, send it to the main thread.
     */
    if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addContactsToList:)
                               withObject:self.currentParseBatch
                            waitUntilDone:NO];
    }
}

#pragma mark - Parser constants

/*
 When a Contact object has been fully constructed, it must be passed to the main thread 
 and the table view in RootViewController must be reloaded to display it. It is not efficient 
 to do this for every Earthquake object - the overhead in communicating between the threads 
 and reloading the table exceed the benefit to the user. Instead, we pass the objects in 
 batches, sized by the constant below. In your application, the optimal batch size will 
 vary depending on the amount of data in the object and other factors, as appropriate.
 */
static NSUInteger const kSizeOfContactsBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kContactElementName   = @"contact";
static NSString * const kFirstNameElementName = @"firstName";
static NSString * const kLastNmeElementName   = @"lastName";
static NSString * const kAgeElementName       = @"age";
static NSString * const kSexElementName       = @"sex";
static NSString * const kPictureElementName   = @"picture";
static NSString * const kNotesElementName     = @"notes";

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // <contact>  : start of a contact details
    if ([elementName isEqualToString:kContactElementName]) {
        Contact *contact = [[Contact alloc] init];
        self.currentContactObject = contact;
    }

    // <element>string data</element>
    else if ([_collectingElements indexOfObject:elementName] != NSNotFound) {
        // The contents are collected in parser:foundCharacters:.
        _accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [self.currentParsedCharacterData setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    // </contact>
    if ([elementName isEqualToString:kContactElementName]) {
        
        self.currentContactObject.contactID = _parsedContactsCounter;
        
        [self.currentParseBatch addObject:self.currentContactObject];
        _parsedContactsCounter++;
        if ([self.currentParseBatch count] >= kSizeOfContactsBatch) {
            [self performSelectorOnMainThread:@selector(addContactsToList:) withObject:self.currentParseBatch waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    }
    
    else if ([elementName isEqualToString:kAgeElementName]) {
        self.currentContactObject.age = [self.currentParsedCharacterData integerValue];
    }
    
    else if ([elementName isEqualToString:kPictureElementName]) {
        self.currentContactObject.picture = [NSURL URLWithString:[self.currentParsedCharacterData copy]];
    }
    
    // Handily our iVars are the same as the XML so we can use setValue:forKey: as a shortcut.  Probably not recommended for robust production.
    else if ([_collectingElements containsObject:elementName]) {
        [self.currentContactObject setValue:[self.currentParsedCharacterData copy] forKey:elementName];
    }

    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    _accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (_accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:string];
    }
}

/**
 An error occurred while parsing the earthquake data: post the error as an NSNotification to our app delegate.
 */
- (void)handleContactsError:(NSError *)parseError {
    
    assert([NSThread isMainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactsErrorNotificationName object:self userInfo:@{kContactsMessageErrorKey: parseError}];
}

/**
 An error occurred while parsing the earthquake data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of earthquakes.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !_didAbortParsing) {
        [self performSelectorOnMainThread:@selector(handleContactsError:) withObject:parseError waitUntilDone:NO];
    }
}

@end
