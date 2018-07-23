How to Setup computer for use

1. Python and Mathematica must be installed to 
run python and mathematica scripts

--------------------------------------------------------
2. Path Environment Variables must be set up. 

Look up according to operating system how to 
add paths and proceed with both mathematica and pythons 
directory being added

In general on mathematica $BaseDirectory can be used to locate Path.

Windows: 
Mathematica - c:\Program Files\Wolfram Research\Mathematica\<version number>
Python -
C:\Users\<Username>\AppData\Local\Programs\Python\Python36-32\Scripts
C:\Users\<Username>\AppData\Local\Programs\Python\Python36-32\

OSX:
Mathematica - /Applications/Mathematica.app
Python - 
https://docs.python.org/3/using/mac.html

Linux:
Mathematica - /usr/local/Wolfram/Mathematica/<version number>
Python - 
https://docs.python.org/3/using/unix.html

--------------------------------------------------------
run python files with:
python <file> <argv>

Example - 
python proxy.py Print[3*3]
9