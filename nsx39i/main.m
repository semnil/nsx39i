//
//  main.m
//  nsx39i
//
//  Created by semnil on 4/23/14.
//  Copyright (c) 2014 semnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

#include "stdio.h"


#define DEVICE_NAME CFSTR("NSX-39 ")
#define PORT_NAME CFSTR("NSX-39voiceOut")


MIDIEndpointRef getEndpointWithDisplayName(CFStringRef name)
{
    NSUInteger count = MIDIGetNumberOfDestinations();
    
    for (int i = 0;i < count;i++) {
        MIDIEndpointRef foundObj = MIDIGetDestination(i);
        CFStringRef endPointName;
        MIDIObjectGetStringProperty(foundObj, kMIDIPropertyDisplayName, &endPointName);
        if (endPointName && CFStringCompare(name , endPointName, 0) == kCFCompareEqualTo)
            return (MIDIEndpointRef)foundObj;
    }
    
    return 0;
}

MIDIClientRef getMidiClient()
{
    MIDIClientRef midiClient;
    
    MIDIClientCreate(PORT_NAME, NULL, NULL, &midiClient);
    
    return midiClient;
}

MIDIPortRef getOutPutPort()
{
    MIDIPortRef outPort;
    
    MIDIOutputPortCreate(getMidiClient(), PORT_NAME, &outPort);
    
    return outPort;
}

MIDIPacketList getMidiPacketList(Byte *message, UInt16 length)
{
    MIDIPacketList packetList;
    
    packetList.numPackets = 1;
    
    MIDIPacket* firstPacket = &packetList.packet[0];
    
    firstPacket->timeStamp = 0;
    
    int maxLen = sizeof(firstPacket->data);
    if (length > maxLen)
        length = maxLen;
    firstPacket->length = length;
    
    for (UInt16 i = 0;i < length;i++) {
        firstPacket->data[i] = message[i];
    }
    
    return packetList;
}

void sendNote(MIDIEndpointRef endPoint, Byte *message, UInt16 length)
{
    MIDIPacketList packetList = getMidiPacketList(message, length);
    
    MIDISend(getOutPutPort(), endPoint, &packetList);
}

int main(int argc, const char **argv)
{
    CFStringRef endPointName = DEVICE_NAME;
    MIDIEndpointRef endPoint = getEndpointWithDisplayName(endPointName);
    
    Byte buf[256];
    UInt16 len = 0;
    while (fscanf(stdin, "%c", &buf[len], NULL) != EOF) {
        len++;
    };
    sendNote(endPoint, buf, len);
    
    MIDIEndpointDispose(endPoint);
    
    return 0;
}
