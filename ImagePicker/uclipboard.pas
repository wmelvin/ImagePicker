unit uClipboard;

{$mode ObjFPC}{$H+}

interface

procedure TextToClipboard(const Text: string);

implementation

{$IFDEF LINUX}
uses Classes, SysUtils, Clipbrd, LCLIntf, LCLType;

procedure TextToClipboard(const Text: string);
begin
  Clipboard.SetTextBuf(PChar(Text));
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
uses Classes, SysUtils, Windows, Clipbrd;

procedure TextToClipboard(const Text: string);
begin
  Clipboard.Open;
  Clipboard.AsText := Text;
  Clipboard.Close;
end;
{$ENDIF}

end.

