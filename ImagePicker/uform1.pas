unit uForm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, Buttons, Spin, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnRemove: TButton;
    btnApply: TButton;
    btnAdd: TButton;
    btnShow: TButton;
    chkAutoTag: TCheckBox;
    Image1: TImage;
    ImageList1: TImageList;
    editTitle: TLabeledEdit;
    editTag: TLabeledEdit;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    mnuLoad: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnToggle: TSpeedButton;
    btnFirst: TSpeedButton;
    btnPrev: TSpeedButton;
    btnPlayStop: TSpeedButton;
    btnNext: TSpeedButton;
    btnLast: TSpeedButton;
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure btnAddClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPlayStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure editTagEnter(Sender: TObject);
    procedure editTagExit(Sender: TObject);
    procedure editTitleEnter(Sender: TObject);
    procedure editTitleExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure mnuLoadClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1Enter(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    InEdit: Boolean;
    procedure LoadImage(const ATag: String = '');
    procedure ImageFirst;
    procedure ImagePrev;
    procedure ImageNext;
    procedure ImageLast;
    procedure PlayStop;
    procedure TogglePanel2;
    procedure AddCurrentImage;
    procedure ShowSelectedImage;
    procedure SaveList(FileName: String);
    procedure LoadImagesList(FileName: String);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uAppFuncs, uImageInfo, uImagesList, LCLType, StrUtils;

const
  APP_NAME = 'ImagePicker';
  APP_VERSION = '230311.1';
  APP_TITLE = APP_NAME + '  (' + APP_VERSION + ')';
  P2_DEFAULT_WIDTH = 282;
  MIN_PLAY_MS = 100;

var
  ImagesList: TImagesList;

{ TForm1 }

procedure TForm1.LoadImage(const ATag: String = '');
var
  filename: String;
  t: String;
begin
  t := ATag;
  if 0 < Length(t) then
    t := ' [' + t + ']';

  filename := ImagesList.CurrentImage;
  if Length(filename) = 0 then
    Exit;

  StatusBar1.SimpleText := '(' + IntToStr(ImagesList.Index + 1) + ' of '
    + IntToStr(ImagesList.Count) + ') ' + ExtractFileName(filename) + t;

  Panel1.Caption := '';

  Image1.Picture.LoadFromFile(filename);

  TrackBar1.Position := ImagesList.Index + 1;
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

procedure TForm1.LoadImagesList(FileName: String);
begin
  ImagesList.Load(FileName);
  if not ImagesList.SetCurrentImage(FileName) then
    ImagesList.GoFirst;
  if ImagesList.Count = 0 then
    begin
      Panel1.Caption := 'No images.';
      TrackBar1.Enabled := False;
    end
  else
    begin
      Panel1.Caption := '';
      TrackBar1.Min := 1;
      TrackBar1.Max := ImagesList.Count;
      TrackBar1.Enabled := True;
      LoadImage;
    end;
end;

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
  // TODO: OpenDialog1.Filter := 'Image files|*.JPG;*.PNG;*.JPEG;*.BMP;*.GIF';
  if OpenDialog1.Execute then
    LoadImagesList(OpenDialog1.FileName);
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

procedure TForm1.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: Integer;
begin
  p := TrackBar1.Position;
  if ImagesList.SetCurrentIndex(p - 1) then
    LoadImage;
end;

procedure TForm1.TogglePanel2;
begin
  if Panel2.Width < P2_DEFAULT_WIDTH then
    begin
      Panel2.Width := P2_DEFAULT_WIDTH;
      btnToggle.ImageIndex := 0;
    end
  else
    begin
      Panel2.Width := 4;
      btnToggle.ImageIndex := 1;
    end;
  Panel4.Width := Panel2.Width + Panel3.Width + 4;
end;

procedure TForm1.btnToggleClick(Sender: TObject);
begin
  TogglePanel2;
end;

procedure TForm1.btnRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  if not MessageDlg('Confirm', 'Remove selected item(s) from list?',
    mtConfirmation, [mbYes, mbNo],0
  ) = mrYes then
    Exit;

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
  Form1.Caption := APP_TITLE;
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
        LoadImagesList(s);
      end;
  finally
    FreeAndNil(params);
  end;
end;

procedure TForm1.AddCurrentImage;
var
  s: String;
  t: String;
  dup: Integer;
  info: TImageInfo;
begin
  s := ImagesList.CurrentImage;
  if 0 < Length(s) then
  begin
    dup := ListBox1.Items.IndexOf(ExtractFileName(s));
    if dup = -1 then
    begin
      if chkAutoTag.Checked then
        t := editTag.Text
      else
        t := '';
      info := TImageInfo.Create(s, t);
      ListBox1.Items.AddObject(info.GetFileName, info);
    end;
  end;
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  AddCurrentImage;
end;

procedure TForm1.ShowSelectedImage;
var
  i: Integer;
  fn: String;
  t: String;
begin
  fn := '';
  // Get the full file name of the first selected item.
  if 0 < ListBox1.SelCount then
    for i := 0 to ListBox1.Items.Count - 1 do
      if ListBox1.Selected[i] then
        begin
          // fn := TImageInfo(ListBox1.Items.Objects[i]).FullName;
          with TImageInfo(ListBox1.Items.Objects[i]) do
          begin
            fn := FullName;
            t := Tag;
          end;
          break;
        end;
  // If there is a file name, show the image.
  if 0 < Length(fn) then
     if ImagesList.SetCurrentImage(fn) then
        LoadImage(t);
end;

procedure TForm1.btnShowClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TForm1.mnuLoadClick(Sender: TObject);
var
  tf: TextFile;
  fn: String;
  s: String;
  title: String;
  paths_list: TStringList;
  tags_list: TStringList;
  i: Integer;
  info: TImageInfo;
  tag_nv: String;
  tag_val: String;

  {local} function ParsedTag(const TagStr: String; VAR TagNameValue: String): Boolean;
  var
    fn: String;
    tg: String;
  begin
    ParsedTag := False;
    if not (LeftStr(TagStr, 6) = '# Tag:') then
      Exit;
    fn := Trim(RightStr(s, Length(s) - 6));
    tg := Trim(Copy2SymbDel(fn, ','));
    fn := Trim(fn);
    if (0 < Length(fn)) and (0 < Length(tg)) then
      begin
        TagNameValue := fn + '=' + tg;
        ParsedTag := True;
      end;
  end;

begin
  // TODO: This does not work> OpenDialog1.Filter := 'Text files (*.txt)|*.TXT';
  if OpenDialog1.Execute then
    begin
      fn := OpenDialog1.FileName;
      paths_list := TStringList.Create;
      tags_list := TStringList.Create;
      title := '';
      tag_nv := '';
      try
        AssignFile(tf, fn);
        try
          Reset(tf);
          while not EOF(tf) do
          begin
            ReadLn(tf, s);
            s := Trim(s);
            if (0 < Length(s)) and (LeftStr(s, 1) <> '#') then
              paths_list.Add(TrimSet(s, ['"']))
            else if ParsedTag(s, tag_nv) then
              tags_list.Add(tag_nv)
            else if LeftStr(s, 8) = '# Title:' then
              title := Trim(RightStr(s, Length(s) - 8));
          end;
        finally
          CloseFile(tf);
        end;
      except
        on E: EInOutError do
          StatusBar1.SimpleText := 'ERROR: ' + E.Message;
      end;

      if 0 < paths_list.Count then
      begin
        ImagesList.Load(paths_list[0]);
        editTitle.Text := title;
        ListBox1.Clear;
        for i := 0 to paths_list.Count -1 do
        begin
          info := TImageInfo.Create(paths_list[i], '');
          // Names and values in tags_list are in double quotes.
          tag_val := tags_list.Values['"' + info.GetFileName + '"'];
          if (0 < Length(tag_val)) then
            info.Tag := TrimSet(tag_val, ['"']);
          ListBox1.Items.AddObject(info.GetFileName, info);
        end;
      end;
    end;
end;

end.

