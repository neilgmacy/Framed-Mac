//
//  ViewController.m
//  framed-mac
//
//  Created by Neil McGuiggan on 24/09/2015.
//  Copyright © 2015 Multicoloured Software. All rights reserved.
//

#import "ViewController.h"
#import "DraggingView.h"
#import "DraggingButton.h"
#import "DraggingImageView.h"

@interface ViewController()

@property (weak) IBOutlet NSButton *screenshot;
@property (weak) IBOutlet NSImageView *framedImage;
@property (weak) IBOutlet NSButton *chooseButton;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    [self registerDragReceivers];
}

- (void)registerDragReceivers {
    [self.view registerForDraggedTypes:@[NSFilenamesPboardType]];
    if ([self.view isKindOfClass:[DraggingView class]]) {
        ((DraggingView *)self.view).delegate = self;
    }
    
    [self.chooseButton registerForDraggedTypes:@[NSFilenamesPboardType]];
    if ([self.chooseButton isKindOfClass:[DraggingButton class]]) {
        ((DraggingButton *)self.chooseButton).delegate = self;
    }
    
    [self.framedImage registerForDraggedTypes:@[NSFilenamesPboardType]];
    if ([self.framedImage isKindOfClass:[DraggingImageView class]]) {
        ((DraggingImageView *)self.framedImage).delegate = self;
    }
}

- (IBAction)chooseScreenshot:(id)sender {
    NSOpenPanel *imagePanel = [NSOpenPanel openPanel];
    [imagePanel setAllowedFileTypes:[NSImage imageTypes]];
    [imagePanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    [imagePanel setAllowsMultipleSelection:NO];
    [imagePanel setCanChooseDirectories:NO];
    [imagePanel setCanChooseFiles:YES];
    [imagePanel setResolvesAliases:YES];
    [imagePanel setMessage:@"Load your screenshot"];
    
    NSWindow *window = [[self view] window];
    
    [imagePanel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            // We aren't allowing multiple selection, but NSOpenPanel still returns
            // an array with a single element.
            NSURL *imagePath = [[imagePanel URLs] objectAtIndex:0];
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:imagePath];
            self.screenshot.image = image;
        } else {
            [imagePanel close];
        }
    }];
}

- (IBAction)shareScreenshot:(id)sender {
    NSSharingServicePicker *sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:@[self.framedImage.image]];
    sharingServicePicker.delegate = self;
    
    [sharingServicePicker showRelativeToRect:[sender bounds]
                                      ofView:sender
                               preferredEdge:NSMinYEdge];
}

- (IBAction)saveScreenshot:(id)sender {
    NSImageView *imageToSave = self.framedImage;
    [imageToSave lockFocus];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[imageToSave bounds]];
    [imageToSave unlockFocus];
    NSData *data = [rep representationUsingType:NSPNGFileType properties:@{NSImageCompressionFactor:@1.0}];
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    [panel setNameFieldStringValue:@"FramedScreenshot.png"];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *saveURL = [panel URL];
            [data writeToURL:saveURL atomically:YES];
        }
    }];
}

- (void)didDropImage:(NSString *)filename {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:filename];
    self.screenshot.image = image;
}

@end
