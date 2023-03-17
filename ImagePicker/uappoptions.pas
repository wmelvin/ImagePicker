unit uAppOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAppOptions = class
    private
      FOptList: TStringList;
    public
      constructor Create;
      function OptFileName: String;
      procedure Load;
      procedure Save;
  end;

implementation

uses
  uAppFuncs;

constructor TAppOptions.Create;
begin
  FOptList := TStringList.Create;
end;

function TAppOptions.OptFileName: String;
begin
  OptFileName := AsPath(GetAppConfigDir(False)) + 'ImagePicker.opt';
end;

procedure TAppOptions.Load;
begin
  if FileExists(OptFileName) then
  begin
    FOptList.LoadFromFile(OptFileName)
  end;
  if FOptList.IndexOfName('LastOpenDir') < 0 then
    FOptList.Add('LastOpenDir=');
  if FOptList.IndexOfName('LastSaveDir') < 0 then
    FOptList.Add('LastSaveDir=');
end;

procedure TAppOptions.Save;
var
  fn: String;
  dn: String;
begin
  fn := OptFileName;
  dn := ExtractFileDir(fn);
  if not DirectoryExists(dn) then
     MkDir(dn);
  FOptList.SaveToFile(fn)
end;

end.

