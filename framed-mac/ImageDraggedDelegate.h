//
//  ImageDraggedDelegate.h
//  Framed
//
//  Created by Neil McGuiggan on 29/10/2015.
//  Copyright © 2015 Multicoloured Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDraggedDelegate <NSObject>

- (void)didDropImage:(NSString *)filename;

@end