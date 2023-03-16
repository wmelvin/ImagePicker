unit uImagesList;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TImagesList = class
    private
      FFileList: TStringList;
      FListIndex: Integer;
      FDoLoop: Boolean;
      function GetCount: Integer;
    public
      constructor Create;
      function IncludeFile(FileName: String): Boolean;
      procedure Add(filename: String);
      function CurrentImage: String;
      procedure GoFirst;
      procedure GoPrevious;
      procedure GoNext;
      procedure GoLast;
      procedure PlayNext;
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
  uAppFuncs;

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
var
  i: Integer;
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

procedure TImagesList.GoNext;
begin
  inc(FListIndex);
  if FListIndex >= FFileList.Count then
    if FDoLoop then
      FListIndex := 0
    else
      FListIndex := FFileList.Count - 1;
end;

procedure TImagesList.GoLast;
begin
  FListIndex := FFileList.Count - 1;
end;

procedure TImagesList.PlayNext;
begin
  inc(FListIndex);
  if FListIndex >= FFileList.Count then
     FListIndex := 0;  // Always loop
end;

procedure TImagesList.Load(FileName: String);
var
  dirpath: String;
  fspec: String;
  sr: TSearchRec;
  isDir: Boolean;
begin
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

  dirpath := AsPath(dirpath);
  fSpec := dirpath + '*';
  if FindFirst(fspec, faAnyfile, sr) = 0 then
  repeat
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      if not (sr.Attr AND faDirectory = faDirectory) then
        if IncludeFile(sr.Name) then
          FFileList.Append(dirpath + sr.Name);
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

end.

