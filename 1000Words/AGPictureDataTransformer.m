//
//  AGPictureDataTransformer.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/26/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGPictureDataTransformer.h"

@implementation AGPictureDataTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}

-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;

}



@end
