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
      function GetLastCopyDir: String;
      procedure SetLastCopyDir(DirName: String);
    public
      constructor Create;
      function OptFileName: String;
      procedure LoadOptions;
      procedure SaveOptions;
    published
      property LastOpenDir: String read GetLastOpenDir write SetLastOpenDir;
      property LastSaveDir: String read GetLastSaveDir write SetLastSaveDir;
      property LastCopyDir: String read GetLastCopyDir write SetLastCopyDir;
  end;

var
  AppOptions: TAppOptions;

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
  OptFileName := AsPath(GetAppConfigDir(False)) + 'ImagePicker-Options.txt';
end;

procedure TAppOptions.LoadOptions;
begin
  if FileExists(OptFileName) then
  begin
    FOptList.LoadFromFile(OptFileName)
  end;
end;

procedure TAppOptions.SaveOptions;
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

function TAppOptions.GetLastCopyDir: String;
begin
  GetLastCopyDir := FOptList.Values['LastCopyDir'];
end;

procedure TAppOptions.SetLastCopyDir(DirName: String);
begin
  FChanged := True;
  FOptList.Values['LastCopyDir'] := DirName;
end;

end.

