unit uImageInfo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TImageInfo = class(TObject)
    private
      FPath: String;
      FTag: String;
    public
      constructor Create(APath: String; ATag: String);
      function GetFileName: String;
    published
      property Tag: String read FTag write FTag;
  end;


implementation

constructor TImageInfo.Create(APath: String; ATag: String);
begin
  FPath := APath;
  FTag := ATag;
end;

function TImageInfo.GetFileName: String;
begin
  GetFileName := ExtractFileName(FPath);
end;

end.

