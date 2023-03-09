unit uForm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, Buttons, Spin;

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
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPlayStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure LoadImage;
    procedure ImageFirst;
    procedure ImagePrev;
    procedure ImageNext;
    procedure ImageLast;
    procedure PlayStop;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uAppFuncs, uImagesList, LCLType;

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

procedure TForm1.ImageFirst;
begin
  ImagesList.GoFirst;
  LoadImage;
end;

procedure TForm1.ImagePrev;
begin
  ImagesList.GoPrevious;
  LoadImage;
end;

procedure TForm1.ImageNext;
begin
  ImagesList.GoNext;
  LoadImage;
end;

procedure TForm1.ImageLast;
begin
  ImagesList.GoLast;
  LoadImage;
end;

procedure TForm1.PlayStop;
begin
  if Timer1.Enabled then
     begin
       Timer1.Enabled := False;
       btnPlayStop.ImageIndex := 4;
     end
  else
    begin
      Timer1.Enabled := True;
      btnPlayStop.ImageIndex := 5;
    end;
end;

procedure TForm1.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value < MIN_PLAY_MS then SpinEdit1.Value := MIN_PLAY_MS;
  Timer1.Interval := SpinEdit1.Value;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ImagesList.PlayNext;
  LoadImage;
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
  ImageFirst;
end;

procedure TForm1.btnLastClick(Sender: TObject);
begin
  ImageLast;
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  ImageNext;
end;

procedure TForm1.btnPlayStopClick(Sender: TObject);
begin
  PlayStop;
end;

procedure TForm1.btnPrevClick(Sender: TObject);
begin
  ImagePrev;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ImagesList := TImagesList.Create;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
    VK_F: ImageFirst;
    VK_P: ImagePrev;
    VK_N: ImageNext;
    VK_L: ImageLast;
    VK_SPACE: PlayStop;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ImagesList.Load('/home/bill/Pictures/');
end;

end.

