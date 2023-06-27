#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreFoundation/CoreFoundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Usage: ./set_output_channels <num_channels>");
            return 1;
        }
        
        NSString *numChannelsStr = [NSString stringWithUTF8String:argv[1]];
        NSInteger numChannels = [numChannelsStr integerValue];
        
        if (numChannels <= 0) {
            NSLog(@"Number of channels must be a positive integer.");
            return 1;
        }
        
        // Obtain the reference to the audio device
        AudioObjectPropertyAddress propertyAddress;
        propertyAddress.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
        propertyAddress.mScope = kAudioObjectPropertyScopeGlobal;
        propertyAddress.mElement = kAudioObjectPropertyElementMain;
        
        AudioDeviceID deviceID;
        UInt32 dataSize = sizeof(deviceID);
        
        OSStatus status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize, &deviceID);
        if (status != noErr) {
            NSLog(@"Failed to get the default output device.");
            return 1;
        }
        
        // Retrieve the current stream format of the audio device
        AudioStreamBasicDescription streamFormat;
        dataSize = sizeof(streamFormat);
        
        propertyAddress.mSelector = kAudioDevicePropertyStreamFormat;
        propertyAddress.mScope = kAudioObjectPropertyScopeOutput;
        propertyAddress.mElement = kAudioObjectPropertyElementMain;
        
        status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, NULL, &dataSize, &streamFormat);
        if (status != noErr) {
            NSLog(@"Failed to get the stream format of the audio device.");
            return 1;
        }
        
        // Modify the stream format by changing the number of output channels
        streamFormat.mChannelsPerFrame = numChannels;
        
        // Set the modified stream format back to the audio device
        status = AudioObjectSetPropertyData(deviceID, &propertyAddress, 0, NULL, dataSize, &streamFormat);
        if (status != noErr) {
            NSLog(@"Failed to set the stream format of the audio device.");
            return 1;
        }
        
        NSLog(@"Number of output channels set to %ld successfully.", (long)numChannels);
    }
    return 0;
}

