//
//  PFFile+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFFile+NSCoding.h"
#import <objc/runtime.h>

#define kPFFileName @"_name"
#define kPFFileURL @"_url"
#define kPFFileData @"data"

@implementation PFFile (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.name forKey:kPFFileName];
    [encoder encodeObject:self.url forKey:kPFFileURL];
	if (self.isDataAvailable) {
		[encoder encodeObject:[self getData] forKey:kPFFileData];
	}
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	NSString* name = [aDecoder decodeObjectForKey:kPFFileName];
    NSString* url = [aDecoder decodeObjectForKey:kPFFileURL];
	NSData* data = [aDecoder decodeObjectForKey:kPFFileData];
	
	self = [PFFile fileWithName:name data:data];
	if (self) {
        [self setValue:url forKey:@"_url"];
	}
	return self;
}

@end
