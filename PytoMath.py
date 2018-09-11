#Program calls PytoMath.m with given arguements.
#Author: Kyler Schmidt
from subprocess import *
from sys import *
import ctypes
#INITALIZATION
#/***********************************************************************/
#File called with mathematica script arguments.
#Assuming same directory as PytoMath.py (required to run)
command='-script PytoMath.m'

#All arguments stored into parameter. First arguement is ignored
#Since it is the file name
parameter=str(argv[1:])
#/***********************************************************************/

if len(argv) < 2:
#   When typing in terminal, you give PytoMath.py typically.
#   this is to help someone using the terminal from getting annoying pop ups
    if "PytoMath.py" == argv[0]:
        print ("usage: PytoMath.py [-h] [-f] [-d] [-p] arguments")
        exit()
    ctypes.windll.user32.MessageBoxW(0, "No data input was detected.\nRefer to python PytoMath.py -h in terminal for help\nor see readme file for correct usage", "Error", 1)
    exit()

#GRAB FLAGS USED HERE
flags_used = " "
if "-f" in parameter:
    flags_used = "-f"
if "-h" in parameter:
    flags_used = flags_used + " -h"
if "-f" not in flags_used and "-h" not in flags_used:
    print("No file flag detected. refer to -h for input")
    exit()


#FLAGS
#/***********************************************************************/
#help flag - stops code.
if "-h" in flags_used:
#   PytoMath.py useage
    print ("\n\nusage: PytoMath.py [-h] [-p] [-f]",
           "\nPytoMath.m must be in the same directory as PytoMath.py",
           "\n\n-h: Displays this help guide",
           "\n-f: input file for data. ",
           "\n-tc: TargetColumn. Column which contains response",
           "\n-ev: ExcludedVariables. Inputs not included in developed models",
           "\n-rv: RequiredVariables. Augmented with inputs",
           "\n-dv: DataVariables. List with advantage of directly interpretable models",
           "\n-time: TimeConstraint Default: 300  (in seconds)",
           "\n-memory: MemoryLimit  Default: 500 'MB' Strings GB MB KB can be used",
           "\n-ie: IndependentEvolutions. How many model searches to perform. Default: 1",
           "\n-save: StoreModelSet: Default: True, saves data to folder SavedData",
           "\n\nFor more information, See ReadMe.txt or ReadMe.docx, go to Evolved-analytics.com,",
           "\nor see documentation in datamodeler for more information on symoblic regression"
           )
    exit()

#Check for if arguments are present past the -h flag
if len(argv) < 3:
    print ("usage: PytoMath.py [-h] [-f] [-d] [-p] arguments")
    exit()

#REFORMAT FOR MATHEMATICA
#/***********************************************************************/
parameter=parameter.replace('[','')
parameter=parameter.replace(',','')
parameter=parameter.replace("'",'')
parameter=parameter.replace(']','')
#/***********************************************************************/

#Used to correct placement for wolframscript. Never likes first argument.
if "-p" not in parameter and "-f" in parameter:
    parameter = "-p " + parameter

#grab argument data and send over to PytoMath.m.
call(['wolframscript',command, parameter])
