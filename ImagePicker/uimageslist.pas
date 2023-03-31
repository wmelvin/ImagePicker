unit uImagesList;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TRecurseSetting = (none, yes, no);

  TImagesList = class
    private
      FFileList: TStringList;
      FListIndex: Integer;
      FDoLoop: Boolean;
      FSubDirs: TRecurseSetting;
      function GetCount: Integer;
      procedure ScanDirectory(const DirName: String);
    public
      constructor Create;
      function IncludeFile(FileName: String): Boolean;
      procedure Add(filename: String);
      function CurrentImage: String;
      procedure GoFirst;
      procedure GoPrevious;
      function GoNext: Boolean;
      procedure GoLast;
      procedure Load(FileName: String);
      function SetCurrentImage(FileName: String): Boolean;
      function SetCurrentIndex(Index: Integer): Boolean;
    published
      property Count: Integer read GetCount;
      property Index: Integer read FListIndex;
      property DoLoop: Boolean read FDoLoop write FDoLoop;
  end;

implementation

uses
  uAppFuncs, Controls, Dialogs;

constructor TImagesList.Create;
begin
  FFileList := TStringList.Create;
  FListIndex := 0;
  FDoLoop := False;
end;

function TImagesList.IncludeFile(FileName: String): Boolean;
var
  ext: String;
begin
  IncludeFile := False;
  ext := LowerCase(ExtractFileExt(FileName));
  if (ext = '.jpg') or (ext = '.png') or (ext = '.jpeg')
  or (ext = '.bmp') or (ext = '.gif') then
    IncludeFile := True;
end;

procedure TImagesList.Add(FileName: String);
var
  dup: Integer;
begin
  dup := FFileList.IndexOf(FileName);
  if dup = -1 then
    FFileList.Append(FileName);
end;

function TImagesList.GetCount: Integer;
begin
  GetCount := FFileList.Count;
end;


function TImagesList.CurrentImage: String;
begin
  if (FFileList.Count = 0) or (FListIndex < 0) then
    CurrentImage := ''
  else
    CurrentImage := FFileList[FListIndex];
end;

function TImagesList.SetCurrentImage(FileName: String): Boolean;
var
  i: Integer;
begin
  SetCurrentImage := False;
  if FFileList.Count = 0 then Exit;
  i := FFileList.IndexOf(FileName);
  if 0 <= i then
    begin
      FListIndex := i;
      SetCurrentImage := True;
    end;
end;

function TImagesList.SetCurrentIndex(Index: Integer): Boolean;
begin
  SetCurrentIndex := False;
  if FFileList.Count = 0 then Exit;
  if FFileList.Count <= Index then Exit;
  FListIndex := Index;
  SetCurrentIndex := True;
end;

procedure TImagesList.GoFirst;
begin
  FListIndex := 0;
end;

procedure TImagesList.GoPrevious;
begin
  dec(FListIndex);
  if FListIndex < 0 then
    if FDoLoop then
      FListIndex := FFileList.Count - 1
    else
      FListIndex := 0;
end;

function TImagesList.GoNext: Boolean;
begin
  GoNext := True;
  inc(FListIndex);
  if FListIndex >= FFileList.Count then
    if FDoLoop then
      FListIndex := 0
    else
      begin
        FListIndex := FFileList.Count - 1;
        GoNext := False;
      end;
end;

procedure TImagesList.GoLast;
begin
  FListIndex := FFileList.Count - 1;
end;

procedure TImagesList.Load(FileName: String);
var
  dirpath: String;
  isDir: Boolean;
begin
  FSubDirs := none;
  FFileList.Clear;
  FFileList.Sorted := True;
  FFileList.Duplicates := dupIgnore;
  FFileList.CaseSensitive := False;
  FListIndex := -1;

  isDir := FileGetAttr(FileName) AND faDirectory = faDirectory;

  if isDir then
    dirpath := FileName
  else
    dirpath := ExtractFileDir(FileName);

  ScanDirectory(dirpath);

  // FFileList.SaveToFile('DEBUG-FileList.txt');
end;

procedure TImagesList.ScanDirectory(const DirName: String);
var
  dirpath: String;
  fspec: String;
  sr: TSearchRec;
begin
  dirpath := AsPath(DirName);
  fSpec := dirpath + '*';
  if FindFirst(fspec, faAnyfile, sr) = 0 then
  repeat
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      if sr.Attr AND faDirectory = faDirectory then
        begin
          if FSubDirs = none then
            if MessageDlg(
              'Sub-folders Found',
              'Also scan sub-folders for image files?',
              mtConfirmation, [mbYes, mbNo], 0
            ) = mrYes then
              FSubDirs := yes
            else
              FSubDirs := no;
          if FSubDirs = yes then
            ScanDirectory(dirpath + sr.Name)
        end
      else
        if IncludeFile(sr.Name) then
          FFileList.Append(dirpath + sr.Name);
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;


end.

