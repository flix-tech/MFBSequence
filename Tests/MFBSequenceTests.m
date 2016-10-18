//
//  MFBSequenceTests.m
//  Pods
//
//  Created by Mykola Tarbaiev on 24.08.16.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MFBSequence.h"

@interface MFBSequenceTestStep : MFBSequenceStep
- (void)testComplete;
@end

@implementation MFBSequenceTestStep

- (void)start
{
    // To reject calls not expected by partial mock
    [self doesNotRecognizeSelector:_cmd];
}

- (void)complete
{
    // To reject calls not expected by partial mock
    [self doesNotRecognizeSelector:_cmd];
}

- (void)testComplete
{
    [super complete];
}

@end

@interface MFBSequenceTests : XCTestCase

@end

@implementation MFBSequenceTests {
    MFBSequence *_sequence;

    id _firstStepMock;
    id _secondStepMock;
    id _delegateMock;
}

- (void)setUp 
{
    [super setUp];

    _firstStepMock = OCMPartialMock([MFBSequenceTestStep new]);
    _secondStepMock = OCMPartialMock([MFBSequenceTestStep new]);

    _sequence = [[MFBSequence alloc] initWithSteps:@[ _firstStepMock, _secondStepMock ]];
    _sequence.delegate =
    _delegateMock = OCMStrictProtocolMock(@protocol(MFBSequenceDelegate));
}


#pragma mark - Test Methods

- (void)test_start_FirstStepStarted
{
    OCMExpect([(MFBSequenceStep *)_firstStepMock start]);

    [_sequence start];

    OCMVerifyAll(_firstStepMock);
}

- (void)test_firstStepComplete_SecondStepStarted
{
    OCMExpect([(MFBSequenceStep *)_secondStepMock start]);

    [_firstStepMock testComplete];

    OCMVerifyAll(_secondStepMock);
}

- (void)test_lastStepComplete_DelegateNotified
{
    OCMExpect([_delegateMock didCompleteSequence:_sequence]);

    [_secondStepMock testComplete];

    OCMVerifyAll(_delegateMock);
}

- (void)test_sequenceDeallocated_StepsAreNoLongerConnected
{
    __weak id weakSequence = _sequence;

    _sequence = nil;
    XCTAssertNil(weakSequence);

    OCMReject([(MFBSequenceStep *)_secondStepMock start]);

    [_firstStepMock testComplete];

    OCMReject([_delegateMock didCompleteSequence:[OCMArg any]]);

    [_secondStepMock testComplete];
}

- (void)test_sequenceRetainsSteps
{
    __weak id weakFirstStep = _firstStepMock;
    __weak id weakSecondStep = _secondStepMock;

    _firstStepMock = nil;
    _secondStepMock = nil;

    XCTAssertNotNil(weakFirstStep);
    XCTAssertNotNil(weakSecondStep);
}

- (void)test_NoRetainCycles
{
    __weak id weakSequence = _sequence;
    __weak id weakFirstStep = _firstStepMock;
    __weak id weakSecondStep = _secondStepMock;

    _firstStepMock = nil;
    _secondStepMock = nil;
    _sequence = nil;

    XCTAssertNil(weakSequence);
    XCTAssertNotNil(weakFirstStep);
    XCTAssertNotNil(weakSecondStep);
}

@end
