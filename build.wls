#!/usr/bin/env wolframscript

$dir = DirectoryName[$InputFileName];


Needs["CCompilerDriver`"];


$SystemIDToTargetMap = <|
	"MacOSX-x86-64" -> "x86_64-macos",
	"Linux-x86-64" -> "x86_64-linux",
	"Windows-x86-64" -> "x86_64-windows",
	"MacOSX-ARM64" -> "aarch64-macos"
|>;


(* Use the zig cc compiler *)
$zigDirectory = $ScriptCommandLine[[2]];
$CCompiler = {
	"Compiler" -> CCompilerDriver`GenericCCompiler`GenericCCompiler,
	"CompilerInstallation" -> $zigDirectory,
	"CompilerName" -> "zig cc"
};


(* C file *)
demoStringCFile = FileNameJoin[{$dir, "src", "demo_string.c"}];


(* Override cross-compilation safety check *)
CCompilerDriver`CCompilerDriverBase`BaseDriver["SupportedTargetSystemIDQ"][_, ___] :=
	True;


Options[CreateDynamicLibrary] = Options[CreateLibrary];
lhs:CreateDynamicLibrary[code:(_String|{(_String|_File)..}|File[_String]), funName_String, systemID:_String:$SystemID, optseq:OptionsPattern[]] :=
	CCompilerDriver`Private`CallCompiler[
		CreateLibrary,
		code,
		If[StringStartsQ[systemID, "Windows"], "", "lib"] <> funName, 
		Function[{driver, opts}, "." <> Internal`DynamicLibraryExtension[systemID]], 
		Unevaluated[lhs],
		{
			"CompileOptions" -> Flatten @ {
				"-target " <> $SystemIDToTargetMap[systemID],
				OptionValue[CreateDynamicLibrary, {optseq}, "CompileOptions"]
			},
			optseq
		}
	];

demoLibraries = Association @ Table[
	systemID -> CreateDynamicLibrary[
		{demoStringCFile},
		"demo_string",
		systemID,
		"ShellOutputFunction" -> Print,
		"ShellCommandFunction" -> Print,
		"TargetDirectory" -> FileNameJoin[{$dir, "/LibraryResources", systemID}]
	],
	{systemID, Keys[$SystemIDToTargetMap]}
];

Exit[0];
