//
//  ImageCropView.m
//  test31
//
//  Created by Tsuneo Yoshioka on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCropView.h"

@implementation ImageCropView
@synthesize image;

- (CGRect)rectAdd:(CGRect)rect width:(float)width
{
    CGRect rect2; 
    rect2.origin.x = rect.origin.x - width;
    rect2.origin.y = rect.origin.y - width;
    rect2.size.width = rect.size.width + width*2;
    rect2.size.height = rect.size.height + width*2;
    return rect2;
}
- (void)reset
{
    cropRect = imageRect;
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        imageRect = [self rectAdd:self.bounds width:-10];
        [self reset];
    }
    return self;
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (UIImage*)imageByCropping
{
    CGRect rect;
    
    rect.origin.x = (image.size.width / imageRect.size.width) * (cropRect.origin.x - imageRect.origin.x);
    rect.origin.y = (image.size.height / imageRect.size.height) * (cropRect.origin.y - imageRect.origin.y);
    
    rect.size.width = (image.size.width / imageRect.size.width) * cropRect.size.width;
    rect.size.height = (image.size.height / imageRect.size.height) * cropRect.size.height;

    if(rect.origin.x + rect.size.width > image.size.width){rect.size.width = image.size.width;}
    if(rect.origin.y + rect.size.height > image.size.height){rect.size.height = image.size.height;}
    if(rect.origin.x < 0){rect.size.width +=rect.origin.x; rect.origin.x = 0;}
    if(rect.origin.y < 0){rect.size.height +=rect.origin.y; rect.origin.y = 0;}
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRef imageRef = CGImageCreateWithImageInRect(image2.CGImage, rect);

    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    return cropped;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);
    CGContextFillRect(context, self.bounds);
    
    //[self.image drawInRect:imageRect];
    
    
    // CGContextDrawImage(context, imageRect, self.image.CGImage);
    
    float width = 10;
    CGRect rect2 = [self rectAdd:cropRect width:-(float)width/2];
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 0.3);
    CGContextStrokeRectWithWidth(context, rect2, width);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1);
    CGContextStrokeRect(context, cropRect);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    cropRect.origin.x = p.x;
    cropRect.origin.y = p.y;
    cropRect.size.width = 0;
    cropRect.size.height = 0;
    NSLog(@"1:cropRect=(%f, %f, %f, %f)", cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    [self setNeedsDisplay];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    cropRect.size.width = p.x - cropRect.origin.x;
    cropRect.size.height = p.y - cropRect.origin.y;
    NSLog(@"1:cropRect=(%f, %f, %f, %f)", cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    [self setNeedsDisplay];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.bounds.origin.x <= point.x && self.bounds.origin.y <= point.y && point.x < self.bounds.origin.x + self.bounds.size.width && point.y < self.bounds.origin.y + self.bounds.size.height){
        return self;
    }
    
    return [super hitTest:point withEvent:event];
}
@end