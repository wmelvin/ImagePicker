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
      function AsMvCmd(PadLen: Integer): String;
      function HasTag: Boolean;
      procedure SetTag(ATag: String);
    published
      property Tag: String read FTag write SetTag;
      property FullName: String read FPath;
  end;


implementation

constructor TImageInfo.Create(APath: String; ATag: String);
begin
  FPath := APath;
  FTag := ATag;
end;

procedure TImageInfo.SetTag(ATag: String);
begin
  FTag := StringReplace(Trim(ATag), ' ', '_', [rfReplaceAll]);
end;

function TImageInfo.GetFileName: String;
begin
  GetFileName := ExtractFileName(FPath);
end;


function TImageInfo.HasTag: Boolean;
begin
  HasTag := (0 < Length(FTag));
end;

function TImageInfo.AsMvCmd(PadLen: Integer): String;
var
  name: String;
  ext: String;
  t: String;
  new_name: String;
begin
  AsMvCmd := '';
  name := GetFileName;
  ext := ExtractFileExt(name);

  if HasTag then
    t := '-' + FTag
  else
    t := '';

  new_name := ChangeFileExt(name, '') + t + ext;

  AsMvCmd := 'mv ' + PadRight('"' + name + '"', PadLen + 2)
    + ' "' + new_name + '"';
end;

end.

