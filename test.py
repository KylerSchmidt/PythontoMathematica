#Program calls Datamodeler.m with given arguements.
#Python Datamodeler.py <table of elements> <Time?> find out more.
#Author: Kyler Schmidt
from subprocess import *
from sys import *

#INITALIZATION
#/***********************************************************************/
#File called with mathematica script arguments.
#Assuming same directory as Datamodeler.py (required to run)
command='-script test.m'

#All arguments stored into parameter. First arguement is ignored
#Since it is the file name
parameter=str(argv[1:])
#/***********************************************************************/

#GRAB FLAGS USED HERE
flags_used = " "
if "-d" in parameter:
    flags_used = flags_used + " -d"
if "-p" in parameter:
    flags_used = flags_used + " -p"
if "-h" in parameter:
    flags_used = flags_used + " -h"
if "-d" not in flags_used and "-h" not in flags_used:
    print("No data input detected. refer to -h for input")
    exit()


#FLAGS
#/***********************************************************************/
#help flag - stops code.
if "-h" in parameter:
#   Datamodeler.py useage
    print ("Test.py is used for testing if Mathematica and Python scripts are setup correctly.\n",
            "Useage: python test.py -p 1 2 3 -d 1 2 3 4\n",
            "If two lines appeared holding the stacks 123 and 1234, mathematica and python are setup.")
    exit()

#Check for if arguments are present past the -h flag
if len(argv) < 3:
    print ("usage: Datamodeler.py [-h][-p] [-d] arguments")
    exit()




#REFORMAT FOR MATHEMATICA
#/***********************************************************************/
parameter=parameter.replace('[','')
parameter=parameter.replace(',','')
parameter=parameter.replace("'",'')
parameter=parameter.replace(']','')
#/***********************************************************************/

#Used to correct if only calling with -f. Breaks for some reason...
if "-p" not in parameter and "-f" in parameter:
    parameter = "-p " + parameter

#grab argument data and send over to Datamodeler.m.
call(['wolframscript',command, parameter])
