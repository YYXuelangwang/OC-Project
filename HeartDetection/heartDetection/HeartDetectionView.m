//
//  HeartDetectionView.m
//  heartDetection
//
//  Created by hundred wang on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "HeartDetectionView.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "calcuteColor.h"

static const int gap = 5;
static const float sampling_frequency = 30;

@interface HeartDetectionView()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    float _lastH;
    int _count;
    NSMutableArray *_points;
    NSArray *_calcutePoints;
}

@end

@implementation HeartDetectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configCaptureSession];
        _count = 0;
        _points = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configCaptureSession];
        _count = 0;
        _points = [NSMutableArray array];
    }
    return self;
}

- (void)startDetection{
    if (!_session) return;
    [_session startRunning];
}

- (void)stopDetection{
    if (!_session) return;
    [_session stopRunning];
}

- (void)configCaptureSession{
    //获取camera
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras) {
        if (AVCaptureDevicePositionBack == device.position) _device = device;
    }
    if (!_device) return;
    
    
    //创建input
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (!videoInput || error) return;
    
    _session = [[AVCaptureSession alloc] init];
    
    [_session beginConfiguration];
    
    _session.sessionPreset =  AVCaptureSessionPreset1280x720;
    if ([_session canAddInput:videoInput]) [_session addInput:videoInput];
    
    //创建output
    AVCaptureVideoDataOutput *avCaptureOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *setting = @{(__bridge id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    avCaptureOutput.videoSettings = setting;
    
    dispatch_queue_t queue = dispatch_queue_create("com.github.org", NULL);
    [avCaptureOutput setSampleBufferDelegate:self queue:queue];
    
    if ([_session canAddOutput:avCaptureOutput]) [_session addOutput:avCaptureOutput];
    
    //开启闪光灯
    if ([_device isTorchModeSupported:AVCaptureTorchModeOn]) {
        [_device lockForConfiguration:nil];
        
        _device.torchMode = AVCaptureTorchModeOn;
        _device.activeVideoMinFrameDuration = CMTimeMake(1, 10);
        [_device setTorchModeOnWithLevel:0.01 error:nil];
        
        [_device unlockForConfiguration];
    }
    
    [_session commitConfiguration];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    //拿到buf，为一堆16进制的rgb，单个以字符表示
    uint8_t *buf = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
    float width = CVPixelBufferGetWidth(pixelBuffer);
    float height = CVPixelBufferGetHeight(pixelBuffer);
    size_t bytePerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    HSV hsv = {0, 0, 0};
    conversionBytesToHSV(buf, width, height, bytePerRow, &hsv);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    CGFloat h = HertRate(_lastH, _count, hsv.h);
    _count++;
    _lastH = hsv.h;
    
    [self handlePointsWithH:h];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

static float HertRate(float lastH, int count, float h){
    float low = 0;
    if (count == 0) return low;
    else low = h - lastH;
    return low;
}

//拿到参考的波峰
- (void)analysisReferencePeaksHeight:(float *)height{
    if (_points.count < (self.frame.size.height / gap - 1)) return;
    int count = (int)_points.count;
    
    _calcutePoints = [_points copy];
    
    float max_Peaks = [_calcutePoints.firstObject floatValue];
    float min_troughs = [_calcutePoints.firstObject floatValue];
    float percent = 0.8;
    
    for (int i = 0 ; i < count; i++) {
        float temp = [_calcutePoints[i] floatValue];
        if (temp > max_Peaks) max_Peaks = temp;
        if (temp < min_troughs) min_troughs = temp;
    }
    //最终波峰参考点，依据这个点计算心率；
    *height = (max_Peaks - min_troughs) * percent + min_troughs;
}

//获取心跳数
- (float)getResult{
    float reference_peaks = 0;
    [self analysisReferencePeaksHeight:&reference_peaks];
    if (reference_peaks == 0) return 0;
    
    int16_t peaks_cout = 0;
    int16_t first_p_index = 0;
    int16_t last_p_index = 0;
    
    for (int i = 0; i < _calcutePoints.count / 2.0; i++) {
        float temp = [_calcutePoints[i] floatValue];
        if (temp > reference_peaks){
            last_p_index = i;
            peaks_cout++;
        }
        if (first_p_index == 0) first_p_index = last_p_index;
    }
    
    //最后心率，一分钟跳多少次；
    return peaks_cout  * sampling_frequency / ((last_p_index - first_p_index) * 1.0) * 60;
}

- (void)handlePointsWithH:(float)h{
    CGFloat height = self.frame.size.height * 0.5 - h * 100;
    
    [_points insertObject:@(height) atIndex:0];
    
    if (_points.count > (self.frame.size.height / gap)) [_points removeLastObject];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"the hert rate:%.2f", [weakSelf getResult]);
    });
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGContextMoveToPoint(context, width, height/2.0);
    
    for (int i = 0; i < _points.count; i++) {
        float h = [_points[i] floatValue];
        
        CGContextAddLineToPoint(context, width - (i * gap), h);
    }
    
    CGContextStrokePath(context);
    
}

@end
