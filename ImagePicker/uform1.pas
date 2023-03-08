unit uForm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnToggle: TSpeedButton;
    btnFirst: TSpeedButton;
    btnPrev: TSpeedButton;
    btnPlayStop: TSpeedButton;
    btnNext: TSpeedButton;
    btnLast: TSpeedButton;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPlayStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
  private
    procedure LoadImage;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uAppFuncs, uImagesList;

const
  P2_DEFAULT_WIDTH = 250;
  MIN_PLAY_MS = 100;

var
  ImagesList: TImagesList;

{ TForm1 }

procedure TForm1.LoadImage;
var
  filename: String;
begin
  if ImagesList.Count = 0 then Exit;
  filename := ImagesList.CurrentImage;
  StatusBar1.SimpleText := '(' + IntToStr(ImagesList.Index + 1) + ' of '
    + IntToStr(ImagesList.Count) + ') ' + ExtractFileName(filename);
  Image1.Picture.LoadFromFile(filename);
end;

procedure TForm1.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnToggleClick(Sender: TObject);
begin
  if Panel3.Left - Splitter1.Left < 5 then
    begin
      Splitter1.Left := Panel3.Left - P2_DEFAULT_WIDTH;
      btnToggle.ImageIndex := 0;
    end
  else
    begin
      Splitter1.Left := Panel3.Left - 2;
      btnToggle.ImageIndex := 1;
    end;
end;

procedure TForm1.btnFirstClick(Sender: TObject);
begin
  ImagesList.GoFirst;
  LoadImage;
end;

procedure TForm1.btnLastClick(Sender: TObject);
begin
  ImagesList.GoLast;
  LoadImage;
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  ImagesList.GoNext;
  LoadImage;
end;

procedure TForm1.btnPlayStopClick(Sender: TObject);
begin
  (*
  if Timer1.Enabled then
     begin
       Timer1.Enabled := False;
       btnPlay.Caption := 'Play';
     end
  else
    begin
      Timer1.Enabled := True;
      btnPlay.Caption := 'Stop';
    end;
  *)
end;

procedure TForm1.btnPrevClick(Sender: TObject);
begin
  ImagesList.GoPrevious;
  LoadImage;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ImagesList := TImagesList.Create;
end;

end.

