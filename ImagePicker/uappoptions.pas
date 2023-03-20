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
      FLastError: String;
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
      function SaveOptions: Boolean;
    published
      property LastOpenDir: String read GetLastOpenDir write SetLastOpenDir;
      property LastSaveDir: String read GetLastSaveDir write SetLastSaveDir;
      property LastCopyDir: String read GetLastCopyDir write SetLastCopyDir;
      property LastError: String read FLastError;
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
  FLastError := '';
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

function TAppOptions.SaveOptions: Boolean;
var
  filename: String;
  dirname: String;
begin
  SaveOptions := True;
  if not FChanged then
    Exit;
  filename := OptFileName;
  dirname := ExtractFileDir(filename);

  if not DirectoryExists(dirname) then
    if not ForceDirectories(dirname) then
      begin
        FLastError := 'Cannot create directory "' + dirname + '"';
        SaveOptions := False;
        Exit;
      end;

  FOptList.SaveToFile(filename);
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

