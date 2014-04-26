nsx39i
======

Command line tool for the MSX-39(Pocket Miku) with the OS X.


usages
------

1) binary from stdin

    $ echo -en "\x90\x3c\x64" | nsx39i
    $ echo -en "\x90\x3c\0" | nsx39i


2) binary from stdin

    $ nsx39i -s some_file_path


3) hex string in parameter

    $ nsx39i -S "90 3c 64"
    $ nsx39i -S "903c00"


4) hex string from stdin(interactive)

    $ nsx39i -S
    > 903c64
    > 90 3c 00
    > q
    bye.
    $ 
