//
//  DraggingImageView.h
//  Framed
//
//  Created by Neil McGuiggan on 29/10/2015.
//  Copyright © 2015 Multicoloured Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageDraggedDelegate.h"

@interface DraggingImageView : NSImageView <NSDraggingDestination>

@property (nonatomic, weak) id<ImageDraggedDelegate> delegate;

@end
