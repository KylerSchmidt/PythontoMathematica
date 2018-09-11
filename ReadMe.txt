How to Setup Script for use

1. Python and Mathematica must be installed to
run python and Mathematica scripts

--------------------------------------------------------

2. Path Environment Variables must be set up.

Look up according to operating system how to
add paths and proceed with both Mathematica and pythons
directory being added.

In general on Mathematica $BaseDirectory can be used to locate Path.

Windows:
Mathematica - c:\Program Files\Wolfram Research\Mathematica\<version number>
Python -
C:\Users\<Username>\AppData\Local\Programs\Python\Python36-32\Scripts
C:\Users\<Username>\AppData\Local\Programs\Python\Python36-32\

OSX:
Mathematica - /Applications/Mathematica.app
Python – Apple Installs their own copy of python for use. See
https://docs.python.org/3/using/mac.html for more details.


Linux:
Mathematica - /usr/local/Wolfram/Mathematica/<version number>
Python – Python usually comes preinstalled on linux systems. System may very installation. see
https://docs.python.org/3/using/unix.html for more details.


--------------------------------------------------------
EXAMPLE

run python files with:
python <file> <argv>

Example -
python test.py -p 1 2 3 -d 1 2 3 4
{1., 2., 3.}
{1., 2., 3., 4.}

If this runs correctly, you are setup.

--------------------------------------------------------
FLAGS

Flag	Name			Default		description

-f  	File Input   		Required	Example: Data.xls

-p	Parameters		None		NOT AN ACTUAL FLAG. This flag represents in notes any of the following flags.

-tc 	TargetColumn 		Last		Column in data which contains response (XLS only).
						Automatically chosen if no input

-ev 	ExcludedVariables	Automatic	Inputs not included in developed models

-rv 	RequiredVariables	None		augmented with inputs

-dv 	DataVariables 		{1,x}		Supplied a list of symbols or strings with advantage of developed
						models being directly interpretable.

-time 	TimeConstraint 		300		Input how long program should run (Seconds)

-memory	MemoryLimit		500 "MB"	How much memory to allocate in MB to program.
						Strings GB MB KB may be used for ease.

-ie	IndependentEvolutions	1		execute multiple model searches in sequence with cumulative result
						from all independentEvolutions being returned when finished

-save	StoreModelSet		False		Archives developed models to disk with timestamp to avoid overwrite
