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
      property Count: Integer read GetCount;
      property Index: Integer read FListIndex;
      property DoLoop: Boolean read FDoLoop write FDoLoop;
  end;

implementation

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
  if (ext = '.jpg') or (ext = '.png') then IncludeFile := True;
end;

procedure TImagesList.Add(FileName: String);
begin
  FFileList.Append(FileName);
end;

function TImagesList.GetCount: Integer;
begin
  GetCount := FFileList.Count;
end;


function TImagesList.CurrentImage: String;
begin
  if FFileList.Count = 0 then
    CurrentImage := ''
  else
    CurrentImage := FFileList[FListIndex];
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

end.

