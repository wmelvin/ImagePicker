unit uAppOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAppOptions = class
    private
      FOptList: TStringList;
      FChanged: Boolean;
      function GetLastOpenDir: String;
      procedure SetLastOpenDir(DirName: String);
      function GetLastSaveDir: String;
      procedure SetLastSaveDir(DirName: String);
    public
      constructor Create;
      function OptFileName: String;
      procedure Load;
      procedure Save;
    published
      property LastOpenDir: String read GetLastOpenDir write SetLastOpenDir;
      property LastSaveDir: String read GetLastSaveDir write SetLastSaveDir;
  end;

implementation

uses
  uAppFuncs;

constructor TAppOptions.Create;
begin
  FOptList := TStringList.Create;
  FChanged := False;
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
end;

procedure TAppOptions.Save;
var
  fn: String;
  dn: String;
begin
  if not FChanged then
    Exit;
  fn := OptFileName;
  dn := ExtractFileDir(fn);
  if not DirectoryExists(dn) then
     MkDir(dn);
  FOptList.SaveToFile(fn);
  FChanged := False;
end;

function TAppOptions.GetLastOpenDir: String;
begin
  GetLastOpenDir := FOptList.Values['LastOpenDir'];
end;

procedure TAppOptions.SetLastOpenDir(DirName: String);
begin
  FChanged := True;
  FOptList.Values['LastOpenDir'] := DirName;
end;

function TAppOptions.GetLastSaveDir: String;
begin
  GetLastSaveDir := FOptList.Values['LastSaveDir'];
end;

procedure TAppOptions.SetLastSaveDir(DirName: String);
begin
  FChanged := True;
  FOptList.Values['LastSaveDir'] := DirName;
end;

end.

