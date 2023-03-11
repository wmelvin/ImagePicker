unit uAppFuncs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function AsPath(const s: String): String;
function ForFileName(const s: String): String;

implementation

uses
  StrUtils;

function AsPath(const s: String): String;
// This just provides a shorter function name.
begin
  AsPath := IncludeTrailingPathDelimiter(s);
end;

function ForFileName(const s: String): String;
// Prepare a string for use in a file name.
// Replaces characters that do not belong* in a file name with underscores.
// The string is trimmed of leading and trailing whitespace first.
// * This is opinionated in that spaces are replaced, though allowed by
//   modern file systems.
var
  t: String;
begin
  t := ReplaceStr(Trim(s), ' ', '_');
  t := ReplaceStr(t, ',', '_');
  t := ReplaceStr(t, '#', '_');
  // TODO: There are probably a few more to replace.
  ForFileName := t;
end;

end.

