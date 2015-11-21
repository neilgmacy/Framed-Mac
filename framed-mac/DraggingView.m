//
//  DraggingView.m
//  Framed
//
//  Created by Neil McGuiggan on 28/10/2015.
//  Copyright © 2015 Multicoloured Software. All rights reserved.
//

#import "DraggingView.h"

@implementation DraggingView

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSLog(@"view drag entered event");
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        [self.delegate didDropImage:files[0]];
    }
    return YES;
}

@end
