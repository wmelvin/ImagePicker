unit uForm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, Buttons, Spin, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnDelete: TButton;
    btnApply: TButton;
    btnAdd: TButton;
    chkAutoTag: TCheckBox;
    Image1: TImage;
    ImageList1: TImageList;
    editTitle: TLabeledEdit;
    editTag: TLabeledEdit;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
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
    procedure btnAddClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPlayStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure editTagEnter(Sender: TObject);
    procedure editTagExit(Sender: TObject);
    procedure editTitleChange(Sender: TObject);
    procedure editTitleEnter(Sender: TObject);
    procedure editTitleExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1Enter(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    InEdit: Boolean;
    procedure LoadImage;
    procedure ImageFirst;
    procedure ImagePrev;
    procedure ImageNext;
    procedure ImageLast;
    procedure PlayStop;
    procedure TogglePanel2;
    procedure AddCurrentImage;
    procedure SaveList(FileName: String);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uAppFuncs, uImageInfo, uImagesList, LCLType;

const
  P2_DEFAULT_WIDTH = 282;
  MIN_PLAY_MS = 100;

var
  ImagesList: TImagesList;

{ TForm1 }

procedure TForm1.LoadImage;
var
  filename: String;
begin
  filename := ImagesList.CurrentImage;
  if Length(filename) = 0 then
    Exit;
  StatusBar1.SimpleText := '(' + IntToStr(ImagesList.Index + 1) + ' of '
    + IntToStr(ImagesList.Count) + ') ' + ExtractFileName(filename);
  Panel1.Caption := '';
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

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      ImagesList.Load(OpenDialog1.FileName);
      if ImagesList.SetCurrentImage(OpenDialog1.FileName) then
        LoadImage
      else
        StatusBar1.SimpleText := 'Not a supported image type.';
      if ImagesList.Count = 0 then
        Panel1.Caption := 'No images.'
      else
        Panel1.Caption := '';
    end;
end;

procedure TForm1.SaveList(FileName: String);
var
  tf: TextFile;
  i: Integer;
  item: TImageInfo;
  n: Integer;
  pad: Integer;
  title: String;
begin
  StatusBar1.SimpleText := 'Save as ' + FileName;
  AssignFile(tf, FileName);
  try
    rewrite(tf);

    // Write title to first line.
    title := Trim(editTitle.Text);
    writeln(tf, '# Title: ' + title);
    writeln(tf, '');
    writeln(tf, '');

    // Write file paths.
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      item := TImageInfo(ListBox1.Items.Objects[i]);
      writeln(tf, '"' + item.FullName + '"');
    end;

    // Get length of longest file name in items with a tag.
    pad := 0;
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      item := TImageInfo(ListBox1.Items.Objects[i]);
      if item.HasTag then
        begin
          n := Length(item.GetFileName);
          if pad < n then
            pad := n;
        end;
    end;

    if 0 < pad then
      // There are one or more items with a tag.
      begin
        writeln(tf, '');
        writeln(tf, '');
        writeln(tf, '## -- Tagged Images:');
        for i := 0 to ListBox1.Items.Count - 1 do
        begin
          item := TImageInfo(ListBox1.Items.Objects[i]);
          if item.HasTag then
            writeln(tf,
              '# Tag: "' + item.Tag + '", "' + item.GetFileName + '"'
            );
        end;

        writeln(tf, '');
        writeln(tf, '');
        writeln(tf, '## -- To move (rename) tagged image files:');
        for i := 0 to ListBox1.Items.Count - 1 do
        begin
          item := TImageInfo(ListBox1.Items.Objects[i]);
          if item.HasTag then
            writeln(tf, '# ' + item.AsMvCmd(pad));
        end;
      end;

    CloseFile(tf);
  except
    on E: EInOutError do
      StatusBar1.SimpleText := 'ERROR: ' + E.Message;
  end;
end;

procedure TForm1.mnuSaveClick(Sender: TObject);
var
  fn: String;
  title: String;
begin
  title := StringReplace(editTitle.Text, ' ', '_', [rfReplaceAll]);
  if 0 < Length(title) then
    title := title + '-';

  fn := AsPath(GetCurrentDir) + 'ImageList-' + title
    + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';

  SaveDialog1.FileName := fn;

  if SaveDialog1.Execute then
    SaveList(SaveDialog1.FileName);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value < MIN_PLAY_MS then SpinEdit1.Value := MIN_PLAY_MS;
  Timer1.Interval := SpinEdit1.Value;
end;

procedure TForm1.SpinEdit1Enter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TForm1.SpinEdit1Exit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ImagesList.PlayNext;
  LoadImage;
end;

procedure TForm1.TogglePanel2;
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

procedure TForm1.btnToggleClick(Sender: TObject);
begin
  TogglePanel2;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  if 0 < ListBox1.SelCount then
    for i := ListBox1.Items.Count - 1 downto 0 do
      if ListBox1.Selected[i] then
        begin
          ListBox1.Items.Objects[i].Free;  // TImageInfo object
          ListBox1.Items.Delete(i);
        end;
end;

procedure TForm1.editTagEnter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TForm1.editTagExit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TForm1.editTitleChange(Sender: TObject);
begin
  // btnApply.Enabled := (0 < Length(editTitle.Text));
end;

procedure TForm1.editTitleEnter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TForm1.editTitleExit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TForm1.btnFirstClick(Sender: TObject);
begin
  ImageFirst;
end;

procedure TForm1.btnApplyClick(Sender: TObject);
var
  i: Integer;
  item: TImageInfo;
begin
  if ListBox1.SelCount = 0 then
    begin
      StatusBar1.SimpleText := 'No items selected in list of images.';
      Exit;
    end;

  for i := ListBox1.Items.Count - 1 downto 0 do
    if ListBox1.Selected[i] then
      begin
        item := TImageInfo(ListBox1.Items.Objects[i]);
        item.Tag := editTag.Text;
      end;
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  AddCurrentImage;
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
  InEdit := False;
  ImagesList := TImagesList.Create;
  Panel1.Caption := 'No images.';
  StatusBar1.SimpleText := 'No images.';
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
    VK_HOME: if not InEdit then
      begin
        ImageFirst;
        Key := 0;
      end;

    VK_LEFT: if not InEdit then
      begin
        ImagePrev;
        Key := 0;
      end;

    VK_RIGHT: if not InEdit then
      begin
        ImageNext;
        Key := 0;
      end;

    VK_END: if not InEdit then
      begin
        ImageLast;
        Key := 0;
      end;

    VK_F4:
      begin
        TogglePanel2;
        Key := 0;
      end;

    VK_F5:
      begin
        PlayStop;
        Key := 0;
      end;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
  params: TStringList;
  s: String;
begin
  params := TStringList.Create;
  try
    Application.GetNonOptions('', [], params);
    if 0 < params.Count then
      // Take first argument as file or directory to load.
      begin
        s := params[0];
        ImagesList.Load(s);
        if not ImagesList.SetCurrentImage(s) then
          ImagesList.GoFirst;
        LoadImage;
      end;
  finally
    FreeAndNil(params);
  end;
end;

procedure TForm1.AddCurrentImage;
var
  s: String;
  t: String;
  info: TImageInfo;
begin
  s := ImagesList.CurrentImage;
  if 0 < Length(s) then
  begin
    if chkAutoTag.Checked then
      t := editTag.Text
    else
      t := '';
    info := TImageInfo.Create(s, t);
    ListBox1.Items.AddObject(info.GetFileName, info);
  end;
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  AddCurrentImage;
end;

end.

