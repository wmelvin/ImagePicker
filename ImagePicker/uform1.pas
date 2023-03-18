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
    btnShowNext: TButton;
    btnShowPrev: TButton;
    btnDown: TButton;
    btnUp: TButton;
    chkAutoTag: TCheckBox;
    Image1: TImage;
    ImageList1: TImageList;
    editTitle: TLabeledEdit;
    editTag: TLabeledEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    mnuTools: TMenuItem;
    mnuOptions: TMenuItem;
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
    procedure btnDownClick(Sender: TObject);
    procedure btnShowNextClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPlayStopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnShowPrevClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure editTagEnter(Sender: TObject);
    procedure editTagExit(Sender: TObject);
    procedure editTitleEnter(Sender: TObject);
    procedure editTitleExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure mnuLoadClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1Enter(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    InEdit: Boolean;
    procedure GetArgs;
    procedure LoadImage(const ATag: String = '');
    procedure ImageFirst;
    procedure ImagePrev;
    procedure ImageNext;
    procedure ImageLast;
    procedure PlayStop;
    procedure TogglePanel2;
    procedure AddCurrentImage;
    procedure ShowSelectedImage;
    procedure SelectShowNext;
    procedure SelectShowPrev;
    procedure MoveSelectedUp;
    procedure MoveSelectedDown;
    procedure SaveList(FileName: String);
    procedure LoadImagesList(FileName: String);
    procedure LoadFromSavedFile;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uApp,
  uAppFuncs,
  uAppOptions,
  uImageInfo,
  uImagesList,
  LCLType,
  StrUtils;

const
  P2_DEFAULT_WIDTH = 300;
  MIN_PLAY_MS = 100;

var
  AppOptions: TAppOptions;
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
var
  dirname: String;
begin
  dirname := AppOptions.LastOpenDir;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    OpenDialog1.InitialDir := dirname;

  OpenDialog1.Filter := 'Image files|*.jpg;*.png;*.jpeg;*.bmp;*.gif;'
    + '*.JPG;*.PNG;*.JPEG;*.BMP;*.GIF';

  if OpenDialog1.Execute then
    begin
      LoadImagesList(OpenDialog1.FileName);
      AppOptions.LastOpenDir := ExtractFileDir(OpenDialog1.FileName);
      AppOptions.Save;
    end;
end;

procedure TForm1.mnuOptionsClick(Sender: TObject);
var
  s: String;
begin
  // s := AsPath(GetAppConfigDir(False)) + 'ImagePicker.opt';
  s := AppOptions.OptFileName;

  MessageDlg('', s, mtInformation, [mbOk],0);

  // TODO: Use the file to store options, such as default and last directory
  // for open and save dialogs. Load options on startup.
end;

procedure TForm1.SaveList(FileName: String);
var
  tf: TextFile;
  i: Integer;
  item: TImageInfo;
  n: Integer;
  pad_tagged: Integer;
  pad_all: Integer;
  title: String;
begin
  StatusBar1.SimpleText := 'Save as ' + FileName;
  AssignFile(tf, FileName);
  try
    rewrite(tf);

    writeln(tf, '# Created ' + FormatDateTime('yyyy-mm-dd_hh:nn:ss', Now)
      + ' by ' + APP_TITLE);

    // Write title.
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
    pad_tagged := 0;
    pad_all := 0;
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      item := TImageInfo(ListBox1.Items.Objects[i]);
      n := Length(item.GetFileName);
      if pad_all < n then
        pad_all := n;
      if item.HasTag then
        if pad_tagged < n then
          pad_tagged := n;
    end;

    if 0 < pad_tagged then
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
        writeln(tf, '## -- Move/rename tagged files (original):');
        for i := 0 to ListBox1.Items.Count - 1 do
        begin
          item := TImageInfo(ListBox1.Items.Objects[i]);
          if item.HasTag then
            writeln(tf, '# ' + item.AsMvCmd(pad_tagged));
        end;

      end;

    if Length(title) = 0 then
      // Set default title for use by AsMvCmd.
      title := 'image';

    writeln(tf, '');
    writeln(tf, '');
    writeln(tf, '## -- Move/rename all files (new name):');
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      item := TImageInfo(ListBox1.Items.Objects[i]);
      writeln(tf, '# ' + item.AsMvCmd(pad_all, title, i));
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

  fn := AppOptions.LastSaveDir;
  if (Length(fn) = 0) or (not DirectoryExists(fn)) then
    fn := GetCurrentDir;

  fn := AsPath(fn) + 'ImageList-' + title
    + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';

  SaveDialog1.FileName := fn;

  if SaveDialog1.Execute then
    begin
      SaveList(SaveDialog1.FileName);
      AppOptions.LastSaveDir := ExtractFileDir(SaveDialog1.FileName);
      AppOptions.Save;
    end;
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
      // Expand.
      Panel2.Width := P2_DEFAULT_WIDTH;
      btnToggle.ImageIndex := 0;
      editTitle.Enabled := True;
      editTag.Enabled := True;
    end
  else
    begin
      // Collapse.
      Panel2.Width := 4;
      btnToggle.ImageIndex := 1;
      editTitle.Enabled := False;
      editTag.Enabled := False;
      ListBox1.ClearSelection;
      ListBox1.SetFocus;
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
  if ListBox1.SelCount = 0 then
    Exit;

  if not MessageDlg('Confirm', 'Remove selected item from the list?',
    mtConfirmation, [mbYes, mbNo],0
  ) = mrYes then
    Exit;

  for i := ListBox1.Items.Count - 1 downto 0 do
    if ListBox1.Selected[i] then
      begin
        ListBox1.Items.Objects[i].Free;  // TImageInfo object
        ListBox1.Items.Delete(i);
      end;
end;

procedure TForm1.btnUpClick(Sender: TObject);
begin
  MoveSelectedUp;
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

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  AppOptions.Save;
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

procedure TForm1.btnDownClick(Sender: TObject);
begin
  MoveSelectedDown;
end;

procedure TForm1.btnShowNextClick(Sender: TObject);
begin
  SelectShowNext;
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
  AppOptions := TAppOptions.Create;
  AppOptions.Load;
  Panel1.Caption := 'No images.';
  StatusBar1.SimpleText := 'No images.';
  GetArgs;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Shift = [] then
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

      VK_SPACE: if not InEdit then
        begin
          PlayStop;
          Key := 0;
        end;

      VK_F6:
        begin
          ShowSelectedImage;
          Key := 0;
        end;

      VK_F7:
        begin
          SelectShowPrev;
          Key := 0;
        end;

      VK_F8:
        begin
          SelectShowNext;
          Key := 0;
        end;
    end
  else if Shift = [ssCtrl] then
    case Key of
      VK_UP:
        begin
          MoveSelectedUp;
          Key := 0;
        end;

      VK_DOWN:
        begin
          MoveSelectedDown;
          Key := 0;
        end;

      VK_LEFT:
        begin
          ImagePrev;
          Key := 0;
        end;

      VK_RIGHT:
        begin
          ImageNext;
          Key := 0;
        end;
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  // Show full path to image in status bar.
  StatusBar1.SimpleText := ImagesList.CurrentImage;
end;

procedure TForm1.GetArgs;
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

procedure TForm1.btnShowPrevClick(Sender: TObject);
begin
  SelectShowPrev;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TForm1.LoadFromSavedFile;
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
  first_line: Boolean;
  ok: Boolean;

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
  OpenDialog1.Filter := 'Text files (*.txt)|*.txt;*.TXT';
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
          first_line := True;
          ok := True;
          while ok and (not EOF(tf)) do
          begin
            ReadLn(tf, s);

            if first_line then
              begin
                first_line := False;
                if not ((LeftStr(s, 1) = '#')
                and (0 < Pos('ImagePicker', s))) then
                  begin
                    MessageDlg(
                      'Cannot Load',
                      'File does not match ImagePicker format.',
                      mtWarning, [mbClose],0);
                    ok := False;
                    continue;
                  end;
              end;

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
        LoadImagesList(paths_list[paths_list.Count - 1]);

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

procedure TForm1.mnuLoadClick(Sender: TObject);
begin
  LoadFromSavedFile;
end;

procedure TForm1.SelectShowNext;
var
  i: Integer;
begin
  if 0 < ListBox1.SelCount then
  begin
    for i := 0 to ListBox1.Items.Count - 2 do
      if ListBox1.Selected[i] then
        begin
          ListBox1.Selected[i] := False;
          ListBox1.Selected[i + 1] := True;
          break;
        end;
    ShowSelectedImage;
  end;
end;

procedure TForm1.SelectShowPrev;
var
  i: Integer;
begin
  if 0 < ListBox1.SelCount then
  begin
    for i := 1 to ListBox1.Items.Count - 1 do
      if ListBox1.Selected[i] then
        begin
          ListBox1.Selected[i] := False;
          ListBox1.Selected[i - 1] := True;
          break;
        end;
    ShowSelectedImage;
  end;
end;

procedure TForm1.MoveSelectedUp;
var
  i: Integer;
begin
  if 0 < ListBox1.SelCount then
  begin
    for i := 1 to ListBox1.Items.Count - 1 do
      if ListBox1.Selected[i] then
        begin
          ListBox1.Items.Exchange(i, i - 1);
          ListBox1.Selected[i] := False;
          ListBox1.Selected[i - 1] := True;
          break;
        end;
  end;
end;

procedure TForm1.MoveSelectedDown;
var
  i: Integer;
begin
  if 0 < ListBox1.SelCount then
  begin
    for i := 0 to ListBox1.Items.Count - 2 do
      if ListBox1.Selected[i] then
        begin
          ListBox1.Items.Exchange(i, i + 1);
          ListBox1.Selected[i] := False;
          ListBox1.Selected[i + 1] := True;
          break;
        end;
  end;
end;

end.

