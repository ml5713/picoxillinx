/*===================================================================================
 File: StreamLoopback.cpp.

 This module is a simple command line utility designed to illustrate the operation 
 of a Pico stream interface. The streams provide a buffered interface to a module
 fabricated in the FPGA.

 This program interfaces with the firmware kernel StreamLoopback128.v in the sister directory.

=====================================================================================*/

#include <stdio.h>
#include <string.h>
#include <stdio.h>
#include <picodrv.h>
#include <pico_errors.h>

// print <count> 128-bit numbers from buf
void print128(FILE *f, void *buf, int count)
{
    uint32_t	*u32p = (uint32_t*) buf;
    
    for (int i=0; i < count; ++i)
    	fprintf(f, "0x%x_%x_%x_%x\n", u32p[4*i+3], u32p[4*i+2], u32p[4*i+1], u32p[4*i]);
}

int main(int argc, char* argv[])
{
    int         err, i, j, stream;
    uint32_t    rbuf[1024], wbuf[1024], u32, addr;
    char        ibuf[1024];
    PicoDrv     *pico;
    const char* bitFileName;
    
    // specify the .bit file name on the command line
    if (argc < 2) {
        fprintf(stderr, "Please specify the .bit file on the command line.\n"
                        "For example: pbc ../firmware/M501_LX240_StreamLoopback128.bit\n");
        exit(1);
    }
    bitFileName = argv[1];
    
    // The RunBitFile function will locate a Pico card that can run the given bit file, and is not already
    //   opened in exclusive-access mode by another program. It requests exclusive access to the Pico card
    //   so no other programs will try to reuse the card and interfere with us.
    printf("Loading FPGA with '%s' ...\n", bitFileName);
    err = RunBitFile(bitFileName, &pico);
    if (err < 0) {
        // We use the PicoErrors_FullError function to decipher error codes from RunBitFile.
        // This is more informative than just printing the numeric code, since it can report the name of a
        //   file that wasn't found, for example.
        fprintf(stderr, "RunBitFile error: %s\n", PicoErrors_FullError(err, ibuf, sizeof(ibuf)));
        exit(1);
    }
    
    // data goes out to the firmware on stream #1 and also comes back on stream #1
    // the following function call (CreateStream) opens the stream
    printf("Opening streams to and from the FPGA\n");
    stream = pico->CreateStream(1);
    if (stream < 0) {
        // All functions in the Pico API return an error code.  If that code is < 0, then you should use
        // the PicoErrors_FullError function to decode the error message.
        fprintf(stderr, "CreateStream error: %s\n", PicoErrors_FullError(stream, ibuf, sizeof(ibuf)));
        exit(1);
    }
    
    // fill the buffer with data we'll recognize when it comes back.
    for (i=0; i < sizeof(wbuf)/sizeof(wbuf[0]); ++i)
        wbuf[i] = 0x00000000 | i;
    
    // We know that we want to send some data to the FPGA.  We have only allocated 4kB for our tx buffer (wbuf), 
    // so the most we can possibly send is 4kB. 
    // In order to know how much data we can send right now, we first call GetBytesAvailable.
    printf("%i bytes of room in stream to firmware.\n", i=pico->GetBytesAvailable(stream, false /* writing */));
    if (i < 0){
        fprintf(stderr, "GetBytesAvailable error: %s\n", PicoErrors_FullError(i, ibuf, sizeof(ibuf)));
        exit(1);
    }

    // Assuming we have enough room in the input stream buffering in the FPGA (and there should be if all is well), then
    // we will cap our call to WriteStream at 256 words of 16 B each (4kB total).
    if (i > 256*16)
        i = 256*16;

    // Our streams come in two flavors: 4B wide, 16B wide (equivalent to 32b, 128b respectively)
    // However, all calls to WriteStream must be 16B aligned (even for 4B wide streams)
    // Here, we zero out the LS 4 bits of our size (i) in order to guaranteee that our write size is 16B aligned.
    i &= ~0xf;

    // Here is where we actually call WriteStream
    // This writes i bytes of data from our buffer (wbuf) to the stream specified by our stream handle (e.g. 'stream')
    // This call will block until it is able to write the entire i Bytes of data.
    printf("Writing %i B\n", i);
    err = pico->WriteStream(stream, wbuf, i);
    if (err < 0) {
        fprintf(stderr, "WriteStream error: %s\n", PicoErrors_FullError(err, ibuf, sizeof(ibuf)));
        exit(1);
    }

    // clear our read buffer to prepare for the read.
    memset(rbuf, 0, sizeof(rbuf));

    // After we wrote some data to the FPGA, we expect the firmware to operate upon that data and place
    // some results into an output stream.
    // The StreamLoopback firmware returns exactly 1 piece of output data for every 1 piece of input data that it receives.
    // In this way, the firmware loops the input data back to the software.
    // All we have done thus far (after the call to WriteStream) is to clear out a buffer.
    // However, by calling GetBytesAvailable, we will see that the FPGA has already processed some of that 
    // data and placed it into an output stream (if all is well).
    printf("%i B available to read from firmware.\n", i=pico->GetBytesAvailable(stream, true /* reading */));
    if (i < 0){
        fprintf(stderr, "GetBytesAvailable error: %s\n", PicoErrors_FullError(i, ibuf, sizeof(ibuf)));
        exit(1);
    }
    
    // Since the StreamLoopback firmware echoes 1 piece of data back to the software for every piece of data
    // that the software writes to it, we know that we can eventually read exactly 4kB from the FPGA.
    // Since our GetBytesAvailable call likely returned < 4kB, we know that if we were to call ReadStream
    // with a size = 4kB, then it would block until it returned all 4kB of data.
    // This is how the Pico Framework automatically handles the flow control for users.
    // In this case, we choose to only read 512B out of the 4kB that should be available 
    i = 32*16;

    // Again, all our streams must operate upon 16B words
    // Here, we zero out the LS 4 bits of our size (i) in order to guaranteee that our read size is 16B aligned.
    i &= ~0xf;

    // Here is where we actually call ReadStream
    // This reads i bytes of data from the output stream specified by our stream handle (e.g. 'stream') 
    // into our software buffer (rbuf)
    // This call will block until it is able to read the entire i Bytes of data.
    printf("Reading %i B\n", i);
    err = pico->ReadStream(stream, rbuf, i);
    if (err < 0) {
        fprintf(stderr, "ReadStream error: %s\n", PicoErrors_FullError(err, ibuf, sizeof(ibuf)));
        exit(1);
    }

    // Now that we have received all of our read data back from the firmware, we print it out for the user
    // In this sample, it makes the most sense to look at this read data 16B at a time, so we print out
    // 16B chunks
    printf("Data received back from firmware:\n");
    print128(stdout, rbuf, i/16);

    // streams are automatically closed when the PicoDrv object is destroyed, or on program termination, but
    //   we can also close a stream manually.
    pico->CloseStream(stream);
   
    // verify the received data by checking only the last 4 entries of rbuf
    if( rbuf[(i/4)-1] != 0x42424242 || 
        rbuf[(i/4)-2] != 0xdeadbeef || 
        rbuf[(i/4)-3] != 0x400007c0 ||
        rbuf[(i/4)-4] != 0x4200007c ){
        printf("Error: unexpected values for last received 128 bits of rbuf\n");
        exit(1);
    }else{
        printf("All tests successful!\n");
    }
    return 0;
}

