unit uAppFuncs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function AsPath(s: String): String;

implementation

function AsPath(s: String): String;
// This just provides a shorter function name.
begin
  AsPath := IncludeTrailingPathDelimiter(s);
end;

end.

