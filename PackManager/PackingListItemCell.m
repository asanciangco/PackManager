//
//  PackingListItemCell.m
//  PackManager
//
//  Created by Heather Blockhus on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingListItemCell.h"

@implementation PackingListItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithPackable:(Packable *)item style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(item.quantity > 0)
        {
            self.itemTextLabel.text = item.name;
            self.quantityTextLabel.text = [NSString stringWithFormat:@"x%li", (long)item.quantity];
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            self.hidden = YES;
        }
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
