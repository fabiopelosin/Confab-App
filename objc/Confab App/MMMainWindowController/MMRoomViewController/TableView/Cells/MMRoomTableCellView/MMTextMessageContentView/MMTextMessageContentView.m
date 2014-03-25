//
//  MMTextMessageTableCellView2.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMTextMessageContentView.h"
//#import "NS(Attributed)String+Geometrics.h"
#import "MMFixedTextField.h"

//------------------------------------------------------------------------------
@interface MMTextMessageContentView () <NSTextViewDelegate>
//------------------------------------------------------------------------------
@property (unsafe_unretained) IBOutlet MMFixedTextField *messageTextField;
@end

//------------------------------------------------------------------------------
@implementation MMTextMessageContentView
//------------------------------------------------------------------------------

- (void)awakeFromNib;
{
    [self.subviews.first removeFromSuperview];
    self.messageTextField = [[MMFixedTextField alloc] initWithFrame:self.bounds];
    [self.messageTextField setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression-1.0 forOrientation:NSLayoutConstraintOrientationVertical];
    [self.messageTextField setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable|NSViewMaxYMargin];

    [self.messageTextField setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSView *messageTextField = self.messageTextField;

    [self addSubview:self.messageTextField];
    NSArray *arr;

    //horizontal constraints
    arr = [NSLayoutConstraint constraintsWithVisualFormat:@"|[messageTextField]|"
                                                  options:0
                                                  metrics:nil
                                                    views:NSDictionaryOfVariableBindings(messageTextField)];
    [self addConstraints:arr];

    //vertical constraints
    arr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[messageTextField]|"
                                                  options:0
                                                  metrics:nil
                                                    views:NSDictionaryOfVariableBindings(messageTextField)];
    [self addConstraints:arr];



    [self.messageTextField setEditable:NO];
    [self.messageTextField setLinkTextAttributes:nil];
    [self.messageTextField setDelegate:self];
}

- (void)setMessage:(NSAttributedString *)message;
{
    [self.messageTextField.textStorage setAttributedString:message];
    [self.messageTextField.layoutManager ensureLayoutForTextContainer:self.messageTextField.textContainer];
}


- (NSSize)intrinsicContentSize;
{


    // From stack overflow

    [self.messageTextField setPreferredMaxLayoutWidth:self.preferredMaxLayoutWidth];
    return self.messageTextField.intrinsicContentSize;
//    [self.messageTextField setMaxSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX)];
//    NSTextContainer* textContainer = [self.messageTextField textContainer];
//    NSLayoutManager* layoutManager = [self.messageTextField layoutManager];
//    [layoutManager ensureLayoutForTextContainer: textContainer];
//    NSSize size = [layoutManager usedRectForTextContainer: textContainer].size;
//    size.height += 0;
//    return size;


    // Current implementation
    //  CGFloat widthDelta = self.frame.size.width - self.messageTextField.frame.size.width;
    //  CGFloat heightDelta = self.frame.size.height - self.messageTextField.frame.size.height;
    //  CGFloat height = [self.messageTextField.attributedString heightForWidth:width - widthDelta];
    //  return height + heightDelta;


//    [self.messageTextField setPreferredMaxLayoutWidth:self.preferredMaxLayoutWidth];
    //  CGSize textFieldSize = [self.messageTextField intrinsicContentSize];
    //  return CGSizeMake(self.preferredMaxLayoutWidth, textFieldSize.height);
}

//------------------------------------------------------------------------------
#pragma mark - NSTextViewDelegate
//------------------------------------------------------------------------------

/**
 Removes the selection from the cell once it looses focus.
 - http://stackoverflow.com/questions/4907798/how-can-i-know-when-nstextview-loses-focus
 */
- (void)textDidEndEditing:(NSNotification *)notification
{
    [self.messageTextField setSelectedRange:NSMakeRange(0,0)];
}

/**
 Disable menu that makes sense only when the text field is editable.
 */
- (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex;
{
    [menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
        if (item.action == @selector(cut:) || item.action == @selector(paste:)) {
            [menu removeItem:item];
        }
        else {
            [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *submenuItem, NSUInteger idx2, BOOL *sub_stop) {
                if (submenuItem.action == @selector(orderFrontFontPanel:) || submenuItem.action == @selector(checkSpelling:) || submenuItem.action == @selector(toggleSmartInsertDelete:)) {
                    [menu removeItem:item];
                    *sub_stop = true;
                }
            }];
        }
    }];
    return menu;
}

@end
