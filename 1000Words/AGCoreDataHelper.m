//
//  AGCoreDataHelper.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/23/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGCoreDataHelper.h"

@implementation AGCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext;
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    
    //Testing to make sure that variable named delegate is responding to the message "manage object context"
    // confirming that this variable exists and understands this method
    
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
