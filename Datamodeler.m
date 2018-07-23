(* ::Package:: *)

listtable = {}
parameters = {}
If[$CommandLine[[5]] == "-f", Do[listtable = Append[listtable, Internal`StringToDouble@ToString[$CommandLine[[i + 5]]]],{i,Length[$CommandLine[[]]] - 5}]]
(* If there are parameters, Then... *)
If[$CommandLine[[5]] == "-p", 
(* Then TRUE *)
(* Grabs -f data.  If -f is present (or if -f is not empty in set) *)
If[Position[$CommandLine, "-f"]!= {},
(* Parameters *)
Do[parameters = Append[parameters, Internal`StringToDouble@ToString[$CommandLine[[i + 5]]]],
{i,Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-f"]]] - 6}]
(* Data *)
Do[listtable = Append[listtable, Internal`StringToDouble@ToString[$CommandLine[[i + Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-f"]]]]]]],
{i,Length[$CommandLine[[]]] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-f"]]]}]]

(* Grabs -d data. If -d is present (or if -d is not empty in set) *)
If[Position[$CommandLine, "-d"]!= {},
(* Parameters *)
Do[parameters = Append[parameters, Internal`StringToDouble@ToString[$CommandLine[[i + 5]]]],
{i,Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-d"]]] - 6}]
(* Data *)
Do[listtable = Append[listtable, Internal`StringToDouble@ToString[$CommandLine[[i + Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-d"]]]]]]],
{i,Length[$CommandLine[[]]] - Round[Internal`StringToDouble@ToString[Position[$CommandLine, "-d"]]]}]]

,
(* Then FALSE *)
Do[listtable = Append[listtable, Internal`StringToDouble@ToString[$CommandLine[[i + 5]]]],{i,Length[$CommandLine[[]]] - 5}]
]
Print[parameters]
Print[listtable]

(* DATAMODELER CODE GOES HERE BASED OFF OF LISTTABLE AND PARAMETERS *)
If[parameters == {}, 
(* Parameters are not used and symbolic regression is used with basic data input *)

,
(* Parameters used, if numeric, used for restraints, otherwise it could be to run
symbolic regression a certain way *)

]
