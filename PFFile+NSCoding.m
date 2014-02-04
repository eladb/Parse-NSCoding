//
//  PFFile+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFFile+NSCoding.h"

#define kPFFileName @"_name"
#define kPFFileUrl @"_url"

@implementation PFFile (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.name forKey:kPFFileName];
	[encoder encodeObject:self.url forKey:kPFFileUrl];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	NSString* name = [aDecoder decodeObjectForKey:kPFFileName];
    NSString* url = [aDecoder decodeObjectForKey:kPFFileUrl];
	self = [super init];
	if (self) {
		[self setValue:name forKey:kPFFileName];
		[self setValue:url forKey:kPFFileUrl];
	}
	return self;
}

@end
