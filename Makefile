CC = clang
FRAMEWORKS = -framework Foundation -framework CoreAudio -framework CoreFoundation

set_output_channels: set_output_channels.m
	$(CC) $(FRAMEWORKS) -o set_output_channels set_output_channels.m

clean:
	rm -f set_output_channels

