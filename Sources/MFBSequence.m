//
//  MFBSequence.m
//  Pods
//
//  Created by Mykola Tarbaiev on 22.08.16.
//
//

#import "MFBSequence.h"

@interface MFBSequenceStep ()
@property (nonatomic) MFBSequenceStep *nextStep;
@end

@implementation MFBSequenceStep

- (instancetype)init
{
    NSCAssert(![self isMemberOfClass:[MFBSequenceStep class]],
              @"Cannot instantiate abstract class %@.",
              NSStringFromClass(self.class));

    self = [super init];
    return self;
}

- (void)start
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)complete
{
    [_nextStep start];
}

@end

@interface MFBSequenceCompletionStep : MFBSequenceStep
- (instancetype)initWithSequence:(MFBSequence *)sequence;
@end


@implementation MFBSequence {
    MFBSequenceStep *_firstStep;
}

- (instancetype)initWithSteps:(NSArray<MFBSequenceStep *> *)steps
{
    NSCParameterAssert(steps.count > 0);

    self = [super init];
    if (self) {
        _firstStep = steps[0];

        MFBSequenceStep *prevStep;

        for (MFBSequenceStep *step in steps) {
            prevStep.nextStep = step;
            prevStep = step;
        }

        prevStep.nextStep = [[MFBSequenceCompletionStep alloc] initWithSequence:self];
    }
    return self;
}

- (void)dealloc
{
    MFBSequenceStep *step = _firstStep;

    while (step) {
        MFBSequenceStep *nextStep = step.nextStep;
        step.nextStep = nil;
        step = nextStep;
    }
}

- (void)start
{
    [_firstStep start];
}


#pragma mark - Private Methods

- (void)complete
{
    [_delegate didCompleteSequence:self];
}

@end


@implementation MFBSequenceCompletionStep {
    __weak MFBSequence *_sequence;
}

- (instancetype)initWithSequence:(MFBSequence *)sequence
{
    self = [super init];
    if (self) {
        _sequence = sequence;
    }
    return self;
}

- (void)start
{
    [_sequence complete];
}

@end
