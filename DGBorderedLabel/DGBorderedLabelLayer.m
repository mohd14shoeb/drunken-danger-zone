//
//  DGBorderedLabelLayer.m
//  DGBorderedLabel
//
//  Created by Daniel Cohen Gindi on 3/10/13.
//  Copyright (c) 2013 Daniel Cohen Gindi. All rights reserved.
//
//  https://github.com/danielgindi/drunken-danger-zone
//

#import "DGBorderedLabelLayer.h"

@implementation DGBorderedLabelLayer

@dynamic font, textColor, textOutlineWidth, textOutlineColor;

- (void)_DGBorderedLabelLayer_initialize
{
    self.text = @"";
    self.textAlignment = NSTextAlignmentLeft;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentsScale = UIScreen.mainScreen.scale;
    self.rasterizationScale = UIScreen.mainScreen.scale;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _DGBorderedLabelLayer_initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self _DGBorderedLabelLayer_initialize];
    }
    return self;
}

- (id)initWithLayer:(DGBorderedLabelLayer*)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        self->_text = layer->_text;
        self->_textAlignment = layer->_textAlignment;
        self->_lineBreakMode = layer->_lineBreakMode;
        self.font = layer.font;
        self.textColor = layer.textColor;
        self.textOutlineColor = layer.textOutlineColor;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize sz = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
    if (self.text.length)
    {
        sz.width += self.textOutlineWidth * 2.f;
        sz.height += self.textOutlineWidth * 2.f;
        if (sz.width > size.width && size.width > 0.f) sz.width = size.width;
        if (sz.height > size.height && size.height > 0.f) sz.height = size.height;
    }
    return sz;
}

+ (id)defaultValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"font"])
    {
        return [UIFont systemFontOfSize:UIFont.systemFontSize];
    }
    else if ([key isEqualToString:@"textColor"])
    {
        return UIColor.darkTextColor;
    }
    else if ([key isEqualToString:@"textOutlineWidth"])
    {
        return @(1.f);
    }
    else if ([key isEqualToString:@"textOutlineColor"])
    {
        return UIColor.lightTextColor;
    }
    return [super defaultValueForKey:key];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"font"])
    {
        return YES;
    }
    else if ([key isEqualToString:@"textColor"])
    {
        return YES;
    }
    else if ([key isEqualToString:@"textOutlineWidth"])
    {
        return YES;
    }
    else if ([key isEqualToString:@"textOutlineColor"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIFont *font = self.font;
    UIColor *textOutlineColor = self.textOutlineColor;
    UIColor *textColor = self.textColor;
    NSString *text = self.text;
    
    UIGraphicsPushContext(ctx);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetShouldSmoothFonts(ctx, YES);
    if (textOutlineColor)
    {
        CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        CGContextSetFillColorWithColor(ctx, textOutlineColor.CGColor);
        CGContextSetLineWidth(ctx, self.textOutlineWidth);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        [text drawInRect:self.bounds withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    }
    if (textColor)
    {
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetFillColorWithColor(ctx, textColor.CGColor);
        [text drawInRect:self.bounds withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    }
    UIGraphicsPopContext();
}

@end
