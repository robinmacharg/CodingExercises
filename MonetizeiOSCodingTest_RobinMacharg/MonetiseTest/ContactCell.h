//
//  ContactCell.h
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageLabel;

@end
