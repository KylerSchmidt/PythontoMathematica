#Program calls Datamodeler.m with given arguements.
#Python Datamodeler.py <table of elements> <Time?> find out more.
#Author: Kyler Schmidt
from subprocess import *
from sys import *

#INITALIZATION
#/***********************************************************************/
#File called with mathematica script arguments.
#Assuming same directory as Datamodeler.py (required to run)
command='-script Datamodeler.m'

#All arguments stored into parameter. First arguement is ignored
#Since it is the file name
parameter=str(argv[1:])
#/***********************************************************************/

#GRAB FLAGS USED HERE
flags_used = " "
if "-f" in parameter:
    flags_used = "-f"
if "-d" in parameter:
    flags_used = flags_used + " -d"
if "-p" in parameter:
    flags_used = flags_used + " -p"
if "-h" in parameter:
    flags_used = flags_used + " -h"
if "-f -d" in flags_used:
    print(flags_used)
    print ("file and data cannot be used at the same time.")
    exit()
if "-f" not in flags_used and "-d" not in flags_used and "-h" not in flags_used:
    print("No data input detected. refer to -h for input")
    exit()

    
#FLAGS
#/***********************************************************************/
#help flag - stops code.
if "-h" in parameter:
#   Datamodeler.py useage
    print ("\n\nusage: Datamodeler.py [-h] [-p] [-f] [-d] ",
           "\nDatamodeler.m must be in the same directory as Datamodeler.py",
           "\nAlways use flag -p before flags -d or -f. other ways may not be supported.",
           "\n\n-h: Displays this help guide",
           "\n-f: input file for data. input parameters separately or in file provide an -p with numbers.",
           "\n-d: direct data input into command line",
           "\n\nThe following are examples on how to use each flag:",
           "\n\n: -h: Datamodeler.py -h",
           "\n: -f: Datamodeler.py -f Data.txt",
           "\n: -p and -d: Datamodeler.py -p 1 2 3 4 -d 1 2 3 4",)
    exit()

#Check for if arguments are present past the -h flag
if len(argv) < 3:
    print ("usage: Datamodeler.py [-h] [-f] [-d] [-p] arguments")
    exit()

#if file flag is used
if "-f" in parameter:
#   Better flag integerations. Splits up string after certain flag.
#   Use this for more flag integerations with
    try:
        file_name = parameter.split("'-f', '",1)[1]
        previous_data = parameter.split("'-f',",1) [0]
    except IndexError:
        print ("Error Occured with flag -f. Is it separated with spaces?")
        exit()
    file_name = file_name.split("']",1) [0]
    
    if "." not in file_name:
        file_name = file_name + ".txt"
        
    try:
        fp = open(file_name)
    except FileNotFoundError:
        print ("File not found in directory: " + file_name)
        exit()
    
    parameter = previous_data + "-f " + fp.read()
#/***********************************************************************/


#REFORMAT
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
