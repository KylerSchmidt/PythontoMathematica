(* ::Package:: *)

(* VARIABLE DECLARATION *)
Needs["DataModeler`"]
(* A double check of making sure directory is correctly set to the same
   folder as this file *)
Quiet[SetDirectory[NotebookDirectory[]]];
(* List of possible flags in SymbolicRegression. Update as more is added. *)
flaglist = {"-f", "-tc", "-ev", "-rv", "-dv", "-time", "-memory",
  "-ie", "-save"};
(* Variable to save excel data to *)
data;
(* Defaults: *)
(* Last Column *)
targetColumn;
(* Automatic *)
excludedVariables;
(* None *)
requiredVariables;
(* {1,x} *)
dataVariables;
(* 300 *)
timeConstraint;
(* 500 "MB" *)
memoryLimit;
(* 1 *)
independentEvolutions;
(* True do to the nature of this program. Usually false.*)
storeModelSet;

(* ---------------------------------------------- *)
(* FUNCTIONS *)
(* Gets variable to save and flag to start from;
  saves all data given from commandLine from flag to flag or End
   @Parameter variablegiven, variable to store data
   @Parameter flag, flag to start storing from commandLine
   @Return list back into variablegiven *)
CommandLineBreak[variablegiven_, flag_]:=
  Module[{breakit, x, i, newvariable},
    Clear[breakit];
    breakit = False;
    variablegiven = {};
      Do[
          Clear[x];
          x = 1;
          (* If we have reached the end of the commandline arguments... *)
          If[Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, flag]]] - i < 0,
            (* Then True *)
            Break[];
            (* Then False *)
            ];

          (* If we have reached another flag in the commandline... *)
          While[Length[flaglist] - x  >= 0,
              If[flaglist[[x]] == ToString[$CommandLine[[Internal`StringToDouble@ToString[Position[$CommandLine, flag] + i]]]],
                (* Then True *)
                  breakit = True;
                  (* Print["Found another flag. Exiting..."]; *)
                  Break[];
                ]
                  x++;
              ];
          (* Throws a break if reached another flag indedcated by above code *)
          If[breakit,
              (* Then True *)
              Break[];
            ];
      (* add commandline input to variable *)
      variablegiven = Append[variablegiven, ToString[$CommandLine[[Internal`StringToDouble@ToString[Position[$CommandLine, flag] + i]]]]];
      ,
      {i, 1, Length[data]}
      ];
    ];

(* ---------------------------------------------- *)
(* DATA *)
(* TODO: If file has a space somewhere, we have a problem,
   as it will not be loaded. *)
(* If -f flag is found in commandline, *)
If[Position[$CommandLine, "-f"] != {},
  (* Then TRUE *)
  (* Store info from file into mathematica with ImportDataMatrix *)
  Quiet[{dataVariables, data} = ImportDataMatrix[
  $CommandLine[[
    Internal`StringToDouble@ToString[Position[$CommandLine, "-f"] + 1]
    ]] ,
    Directory -> Directory[]]; ]
  ,
  (* Then FALSE *)
  (* Print["This message should never appear. If it has, god help you."] *)
  Print["Failed to find -f flag in commandline. "]
  ]

(* Check if there is data in... data. This code will catch if something was loaded or not, if not, closes and notifies. *)
If[Length[data] == 0 ,
  (* Then True *)
  Print["Data found was either empty or file failed to be found. Is the data in the same directory?"];
  Exit[]
  ,
  (* Then False *)
  Print["\nData Succesfully found. Loading Parameters..."];
  ]

(* This overall will capture with Print[] inside the ifs and show what parameters were not used. *)
Print["\n---------------------------------------------- PARAMETERS NOT FOUND ----------------------------------------------"];

(* ---------------------------------------------- *)
(* TARGETCOLUMN *)
(* TargetColumn Requires a string from a column in the excel sheet.
   For direct interaction Grabbing the default is the only difficulty here *)
(* If -tc is found in commandline, and it is not the end of the file*)
If[Position[$CommandLine, "-tc"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-tc"]]] > 0,
  (* Then True *)
  targetcolumnlist;
  CommandLineBreak[targetcolumnlist, "-tc"];
  targetColumn = First[targetcolumnlist];
  ,
  (* Then False *)
  Print["No TargetColumn. Falling onto Default (Last Column)..."]
  (* Mathematica gets confused since targetColumn is set to something above.
    This applies to all other variables as well below*)
  Clear[targetColumn];
  (* First Row, Last Column *)
  targetColumn = Last;
  ]

(* ---------------------------------------------- *)
(* EXCLUDEDVARIABLES *)
(* A List of variables to be tossed out for SymbolicRegression. *)
(* If -ev is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-ev"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-ev"]]] > 0,
  (* Then True *)
  CommandLineBreak[excludedVariables, "-ev"]
  ,
  (* Then False *)
  Print["No ExcludedVariables. Falling onto Default (Automatic)..."]
  Clear[excludedVariables];
  excludedVariables = Automatic;
  ];

(* ---------------------------------------------- *)
(* REQUIREDVARIABLES *)
(* Requiredvariables is a list of variables to be specifically targeted by SymbolicRegression. *)
(* If -rv is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-rv"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-rv"]]] > 0,
  (* Then True *)
  CommandLineBreak[requiredVariables, "-rv"]
  ,
  (* Then False*)
  Print["No RequiredVariables. Falling onto Default (none)..."]
  Clear[requiredVariables];
  requiredVariables = None;
  ]

(* ---------------------------------------------- *)
(* DATAVARIABLES *)
(* Datavariables is a list of variables used by SymbolicRegression. *)
(* If -dv is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-dv"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-dv"]]] > 0,
  Clear[dataVariables];
  CommandLineBreak[dataVariables, "-dv"]
  ,
  (* Then False *)
  Print["No DataVariables. Falling onto Default ({1, x})"]
  (* DataVariables are already set above in data *)
  ]

(* ---------------------------------------------- *)
(* TIMECONSTRAINT *)
(* TimeConstraint is an Integer for how long the program will run *)
(* If -time is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-time"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-time"]]] > 0,
  (* Then True *)
  timeConstraintlist;
  CommandLineBreak[timeConstraintlist, "-time"];
  timeConstraint = Internal`StringToDouble@ToString[First[timeConstraintlist]];
  ,
  (* Then False *)
  Print["No TimeContraint. Falling onto Default (300)..."]
  Clear[timeConstraint];
  timeConstraint = 300
  ]

(* ---------------------------------------------- *)
(* MEMORYLIMIT *)
(* MemoryLimit is an integer and string for how much RAM to run the program with *)
(* If -memory is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-memory"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-memory"]]] > 0,
  (* Then True *)
  memoryLimitlist;
  CommandLineBreak[memoryLimitlist, "-memory"];
  memoryLimit = memoryLimitlist[[1]] memoryLimitlist[[2]];
  ,
  (* Then False *)
  Print["No MemoryLimit. Falling onto Default (500 'MB')..."];
  (* Time already set above in variables declaration *)
  Clear[memoryLimit];
  memoryLimit = 500 "MB";
  ]

(* ---------------------------------------------- *)
(* INDEPENDENTEVOLUTIONS *)
(* IndependentEvolutions is an integer for how many times to run symoblicregression *)
(* If -ie is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-ie"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-ie"]]] > 0,
  (* Then True *)
  Clear[independentEvolutions];
  ielist;
  CommandLineBreak[ielist, "-ie"];
  independentEvolutions = First[ielist];
  ,
  (* Then False *)
  Print["No IndependendentEvolutions. Falling onto Default (1)..."];
  Clear[independentEvolutions];
  independentEvolutions = 1;
  ]

(* ---------------------------------------------- *)
(* STOREMODELSET *)
(* StoreModelset is a boolean for if the data running should be saved or not. This almost will always be true. *)
(* If -ev is found in commandline and it is not the end of the file*)
If[Position[$CommandLine, "-save"] != {} && Length[$CommandLine] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-save"]]] > 0,
  Clear[storeModelSet];
  smslist;
  CommandLineBreak[smslist, "-save"];
  storeModelSet = First[smslist];
  ,
  (* Then False *)
  Print["No StoreModelSet. Falling onto Default(TRUE)..."];
  Clear[storeModelSet];
  storeModelSet = True;
  ]

Print["\n---------------------------------------------- DATA IN SYMBOLIC REGRESSION ----------------------------------------------"];
Print["TargetColumn: " <> ToString[targetColumn]];
Print["\nExcludedVariables: " <> ToString[excludedVariables]];
Print["\nRequiredVariables: " <> ToString[requiredVariables]];
(* Help keep things looking clean in Terminal *)
If[Length[dataVariables] > 10,
  Print["\nDataVariables: Over 10 Variables Input."];
  ,
  Print["\nDataVariables: " <> ToString[dataVariables]];
  ]
Print["\nTimeContraint: " <> ToString[timeConstraint]];
Print["\nMemoryLimit: " <> ToString[memoryLimit]];
Print["\nIndependentEvolutions: " <> ToString[independentEvolutions]];
Print["\nStoreModelSet: " <> ToString[storeModelSet]];

Print["\n---------------------------------------------- SYMBOLIC REGRESSION ----------------------------------------------"];
Print["Running SymbolicRegression..."];

(* Change directory to save files in since it can get a bit messy *)
SetDirectory[StringJoin[Directory[] <> "/SavedData"]]
(* Front end is specifically for the speak functionallity of symbolicregression
   If speak is taken out, all front end code can be taken out.*)
UsingFrontEnd[
ParetoFrontPlot[
  models = SymbolicRegression[data,
    TargetColumn -> targetColumn,
    ExcludedVariables -> excludedVariables,
    RequiredVariables -> requiredVariables,
    DataVariables -> dataVariables,
    TimeConstraint -> timeConstraint,
    MemoryLimit -> memoryLimit,
    IndependentEvolutions -> independentEvolutions,
    StoreModelSet -> storeModelSet,
    Directory -> Directory[],
    Quiet -> True
    (* Speak -> False *)
(*  List of opts to add later on (ADD AS NEEDED):
    Compression?
    Maybe an option to turn the speak on and off? Maybe front end stuff could
    be bad for what a company wants to use this for. Might not be worth it, but
    speech is great for beta testing.
*)
  ]
]
];
Pause[2.5];
CloseFrontEnd[];
Print["\nSymbolicRegression Completed."];
