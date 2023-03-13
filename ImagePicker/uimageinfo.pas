unit uImageInfo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, StrUtils, SysUtils;

type
  TImageInfo = class(TObject)
    private
      FPath: String;
      FTag: String;
    public
      constructor Create(APath: String; ATag: String);
      function GetFileName: String;
      function AsMvCmd(PadLen: Integer; Title: String = ''; Index: Integer = -1): String;
      function HasTag: Boolean;
      procedure SetTag(ATag: String);
    published
      property Tag: String read FTag write SetTag;
      property FullName: String read FPath;
  end;


implementation

uses uAppFuncs;

constructor TImageInfo.Create(APath: String; ATag: String);
begin
  FPath := APath;
  FTag := ATag;
end;

procedure TImageInfo.SetTag(ATag: String);
begin
  // Tag must not have spaces or commas.
  FTag := ForFileName(ATag);
end;

function TImageInfo.GetFileName: String;
begin
  GetFileName := ExtractFileName(FPath);
end;


function TImageInfo.HasTag: Boolean;
begin
  HasTag := (0 < Length(FTag));
end;

function TImageInfo.AsMvCmd(PadLen: Integer; Title: String = ''; Index: Integer = -1): String;
var
  name: String;
  ext: String;
  t: String;
  new_name: String;
  ns: String;
begin
  AsMvCmd := '';
  name := GetFileName;
  ext := ExtractFileExt(name);

  if HasTag then
    t := '-' + FTag
  else
    t := '';

  if 0 <= Index then
    ns := '-' + format('%.3d', [Index + 1])
  else
    ns := '';

  if 0 < Length(Title) then
    new_name := ForFileName(Title) + ns + t + ext
  else
    new_name := ChangeFileExt(name, '') + t + ext;

  AsMvCmd := 'mv ' + PadRight('"' + name + '"', PadLen + 2)
    + ' "' + new_name + '"';
end;

end.

