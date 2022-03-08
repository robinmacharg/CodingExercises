//
//  ContactCell.m
//  MonetiseTest
//
//  Created by Robin Macharg on 21/11/2013.
//  Copyright (c) 2013 Techula Ltd. All rights reserved.
//

#import "ContactCell.h"
#import "UIColor+CustomColors.h"
#import "Notifications.h"

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
