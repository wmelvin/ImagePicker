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
      function GetLastLoadDir: String;
      procedure SetLastLoadDir(DirName: String);
      function GetLastCopyDir: String;
      procedure SetLastCopyDir(DirName: String);
      function GetLastCopyOpt: Integer;
      procedure SetLastCopyOpt(FileNameOpt: Integer);
      function GetDoLoop: Boolean;
      procedure SetDoLoop(DoLoop: Boolean);
      function GetSpeedMs: Integer;
      procedure SetSpeedMs(SpeedMs: Integer);
    public
      constructor Create;
      function OptFileName: String;
      procedure LoadOptions;
      function SaveOptions: Boolean;
    published
      property LastOpenDir: String read GetLastOpenDir write SetLastOpenDir;
      property LastSaveDir: String read GetLastSaveDir write SetLastSaveDir;
      property LastLoadDir: String read GetLastLoadDir write SetLastLoadDir;
      property LastCopyDir: String read GetLastCopyDir write SetLastCopyDir;
      property LastCopyOpt: Integer read GetLastCopyOpt write SetLastCopyOpt;
      property DoLoop: Boolean read GetDoLoop write SetDoLoop;
      property SpeedMs: Integer read GetSpeedMs write SetSpeedMs;
      property LastError: String read FLastError;
  end;

var
  AppOptions: TAppOptions;

implementation

uses
  uApp, uAppFuncs;

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

function TAppOptions.GetLastLoadDir: String;
begin
  GetLastLoadDir := FOptList.Values['LastLoadDir'];
end;

procedure TAppOptions.SetLastLoadDir(DirName: String);
begin
  FChanged := True;
  FOptList.Values['LastLoadDir'] := DirName;
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

function TAppOptions.GetLastCopyOpt: Integer;
var
  s: String;
  i: Integer;
begin
  s := FOptList.Values['LastCopyFileNameOpt'];
  i := StrToIntDef(s, 0);
  GetLastCopyOpt := i;
end;

procedure TAppOptions.SetLastCopyOpt(FileNameOpt: Integer);
begin
  FChanged := True;
  FOptList.Values['LastCopyFileNameOpt'] := IntToStr(FileNameOpt);
end;

function TAppOptions.GetDoLoop: Boolean;
var
  s: String;
begin
  s := FOptList.Values['DoLoop'];
  GetDoLoop := (s = 'True');
end;

procedure TAppOptions.SetDoLoop(DoLoop: Boolean);
begin
  FChanged := True;
  if DoLoop then
    FOptList.Values['DoLoop'] := 'True'
  else
    FOptList.Values['DoLoop'] := 'False';
end;

function TAppOptions.GetSpeedMs: Integer;
var
  s: String;
  i: Integer;
begin
  s := FOptList.Values['SpeedMs'];
  i := StrToIntDef(s, DEFAULT_PLAY_MS);
  if (i < MIN_PLAY_MS) or (MAX_PLAY_MS < i) then
    i := DEFAULT_PLAY_MS;
  GetSpeedMs := i;
end;

procedure TAppOptions.SetSpeedMs(SpeedMs: Integer);
begin
  FChanged := True;
  FOptList.Values['SpeedMs'] := IntToStr(SpeedMs);
end;

end.

