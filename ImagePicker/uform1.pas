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
    btnCopy: TButton;
    chkLoop: TCheckBox;
    chkAutoTag: TCheckBox;
    Image1: TImage;
    Glyphs: TImageList;
    editTitle: TLabeledEdit;
    editTag: TLabeledEdit;
    Label1: TLabel;
    Picks: TListBox;
    MainMenu1: TMainMenu;
    mnuOpenDir: TMenuItem;
    mnuCopy: TMenuItem;
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
    OpenDirDialog: TSelectDirectoryDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure btnAddClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
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
    procedure chkLoopChange(Sender: TObject);
    procedure editTagEnter(Sender: TObject);
    procedure editTagExit(Sender: TObject);
    procedure editTitleEnter(Sender: TObject);
    procedure editTitleExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure PicksDblClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuLoadClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuOpenDirClick(Sender: TObject);
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
    procedure SavePicks(FileName: String);
    procedure LoadImagesList(FileName: String; AllowSubDirs: Boolean);
    procedure LoadPicksFromSavedFile;
    procedure CopyFilesInList(DestDir: String; DoNewNames: Boolean; DoSubDir: Boolean);
    procedure SaveAppOptions;
    procedure AskToClearPicks;
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
  uClipboard,
  uCopyFilesDlg,
  uImageInfo,
  uImagesList,
  uPicksFile,
  FileUtil,
  LCLIntf,
  LCLType,
  StrUtils;

const
  P2_DEFAULT_WIDTH = 300;

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
  if not ImagesList.GoNext then
    if Timer1.Enabled then
      PlayStop;
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

procedure TForm1.LoadImagesList(FileName: String; AllowSubDirs: Boolean);
begin
  ImagesList.Load(FileName, AllowSubDirs);
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
      AskToClearPicks;
      LoadImagesList(OpenDialog1.FileName, True);
      AppOptions.LastOpenDir := ExtractFileDir(OpenDialog1.FileName);
      SaveAppOptions;
    end;
end;

procedure TForm1.mnuOpenDirClick(Sender: TObject);
var
  dirname: String;
begin
  dirname := AppOptions.LastOpenDir;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    OpenDirDialog.InitialDir := dirname;

  if OpenDirDialog.Execute then
    begin
      AskToClearPicks;
      LoadImagesList(OpenDirDialog.FileName, True);
      AppOptions.LastOpenDir := ExtractFileDir(OpenDialog1.FileName);
      SaveAppOptions;
    end;
end;

procedure TForm1.mnuOptionsClick(Sender: TObject);
var
  filename: String;
  mr: Integer;
begin
  filename := AppOptions.OptFileName;

  mr := MessageDlg(
    'Open Folder?',
    'Open the folder containing' + #13#10 + filename,
    mtConfirmation, [mbYes, mbNo], 0);

  if mr = mrYes then
    // Open the folder using the default associated application.
    OpenDocument(ExtractFileDir(filename));

  { TODO: (maybe) Create a form for editing application options. For this
    application, that may not be necessary. For a commercial product,
    you'd want a form with input validation. }
end;

procedure TForm1.SavePicks(FileName: String);
begin
  SavePicksFile(FileName, editTitle.Text, Picks, StatusBar1);
end;

procedure TForm1.mnuSaveClick(Sender: TObject);
var
  dirname: String;
  filename: String;
  title: String;
  dt: String;
begin
  title := StringReplace(editTitle.Text, ' ', '_', [rfReplaceAll]);
  if 0 < Length(title) then
    title := title + '-';

  dirname := AppOptions.LastSaveDir;
  if (Length(dirname) = 0) or (not DirectoryExists(dirname)) then
    dirname := GetCurrentDir;

  dt := FormatDateTime('yyyymmdd_hhnnss', Now);
  filename := 'ImageList-' + title + dt + '.txt';

  SaveDialog1.InitialDir:= dirname;
  SaveDialog1.FileName := filename;
  if SaveDialog1.Execute then
    begin
      SavePicks(SaveDialog1.FileName);
      AppOptions.LastSaveDir := ExtractFileDir(SaveDialog1.FileName);
      SaveAppOptions;
    end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value < MIN_PLAY_MS then
    SpinEdit1.Value := MIN_PLAY_MS
  else if MAX_PLAY_MS < SpinEdit1.Value then
    SpinEdit1.Value := MAX_PLAY_MS;

  AppOptions.SpeedMs := SpinEdit1.Value;
  // To not slow things down, do not SaveAppOptions now.
  // Setting will be saved on form close.

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
  ImageNext;
end;

procedure TForm1.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{  Note: Using MouseUp instead of OnChange because OnChange fires for
   every position change when dragging the marker, and would load the
   image at each step, making it very slow to drag to a new position
   in a large set of images.
}
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
      Picks.ClearSelection;
      Picks.SetFocus;
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
  if Picks.SelCount = 0 then
    Exit;

  if not MessageDlg('Confirm', 'Remove selected item from the list?',
    mtConfirmation, [mbYes, mbNo],0
  ) = mrYes then
    Exit;

  for i := Picks.Items.Count - 1 downto 0 do
    if Picks.Selected[i] then
      begin
        Picks.Items.Objects[i].Free;  // TImageInfo object
        Picks.Items.Delete(i);
      end;
end;

procedure TForm1.btnUpClick(Sender: TObject);
begin
  MoveSelectedUp;
end;

procedure TForm1.chkLoopChange(Sender: TObject);
begin
  ImagesList.DoLoop := chkLoop.Checked;
  AppOptions.DoLoop := chkLoop.Checked;
  SaveAppOptions;
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

procedure TForm1.FormActivate(Sender: TObject);
begin
  GetArgs;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  AppOptions.SaveOptions;
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
  if Picks.SelCount = 0 then
    begin
      StatusBar1.SimpleText := 'No items selected in list of images.';
      Exit;
    end;

  for i := Picks.Items.Count - 1 downto 0 do
    if Picks.Selected[i] then
      begin
        item := TImageInfo(Picks.Items.Objects[i]);
        item.Tag := editTag.Text;
      end;
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  AddCurrentImage;
end;

procedure TForm1.btnCopyClick(Sender: TObject);
var
  i: Integer;
  item: TImageInfo;
  s: string;
begin
  s := '';
  for i := 0 to Picks.Items.Count - 1 do
  begin
    item := TImageInfo(Picks.Items.Objects[i]);
    s := s + '"' + item.FullName + '"' + #13#10;
  end;
  if 0 = Length(s) then
    StatusBar1.SimpleText := 'Nothing to copy.'
  else
    begin
      TextToClipboard(s);
      StatusBar1.SimpleText := 'File paths copied to clipboard.'
    end;
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
  AppOptions.LoadOptions;
  chkLoop.Checked := AppOptions.DoLoop;
  ImagesList.DoLoop := chkLoop.Checked;
  SpinEdit1.Value := AppOptions.SpeedMs;
  Panel1.Caption := 'No images.';
  StatusBar1.SimpleText := 'No images.';
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
        LoadImagesList(s, True);
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
    dup := Picks.Items.IndexOf(ExtractFileName(s));
    if dup = -1 then
    begin
      if chkAutoTag.Checked then
        t := editTag.Text
      else
        t := '';
      info := TImageInfo.Create(s, t);
      Picks.Items.AddObject(info.GetFileName, info);
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
  if 0 < Picks.SelCount then
    for i := 0 to Picks.Items.Count - 1 do
      if Picks.Selected[i] then
        begin
          with TImageInfo(Picks.Items.Objects[i]) do
          begin
            fn := FullName;
            t := Tag;
          end;
          break;
        end;

  // If there is a file name, show the image.
  if 0 < Length(fn) then
     if ImagesList.SetCurrentImage(fn) then
        LoadImage(t)
     else
       { The selected pick is not in the current ImagesList. This is probably
         because the list of picks was loaded from a saved file where multiple
         source directories were used in picking the images. Try re-loading
         the ImagesList based on the selected pick.
       }
       begin
         LoadImagesList(fn, False);
         if ImagesList.SetCurrentImage(fn) then
            LoadImage(t);
       end;
end;

procedure TForm1.btnShowClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TForm1.btnShowPrevClick(Sender: TObject);
begin
  SelectShowPrev;
end;

procedure TForm1.PicksDblClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TForm1.mnuCopyClick(Sender: TObject);
var
  mr: TModalResult;
begin
  mr := CopyFilesDlg.ShowModal;
  if mr = mrOk then
    with CopyFilesDlg do
        CopyFilesInList(editFolder.Text, chkNewNames.Checked, chkSubDir.Checked);
end;

procedure TForm1.LoadPicksFromSavedFile;
var
  last_pick: String;
begin
  last_pick := LoadPicksFile(OpenDialog1, editTitle, Picks, StatusBar1);
  if 0 < Length(last_pick) then
    LoadImagesList(last_pick, False);
end;

procedure TForm1.mnuLoadClick(Sender: TObject);
begin
  LoadPicksFromSavedFile;
end;

procedure TForm1.SelectShowNext;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 0 to Picks.Items.Count - 2 do
      if Picks.Selected[i] then
        begin
          Picks.Selected[i] := False;
          Picks.Selected[i + 1] := True;
          break;
        end;
    ShowSelectedImage;
  end;
end;

procedure TForm1.SelectShowPrev;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 1 to Picks.Items.Count - 1 do
      if Picks.Selected[i] then
        begin
          Picks.Selected[i] := False;
          Picks.Selected[i - 1] := True;
          break;
        end;
    ShowSelectedImage;
  end;
end;

procedure TForm1.MoveSelectedUp;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 1 to Picks.Items.Count - 1 do
      if Picks.Selected[i] then
        begin
          Picks.Items.Exchange(i, i - 1);
          Picks.Selected[i] := False;
          Picks.Selected[i - 1] := True;
          break;
        end;
  end;
end;

procedure TForm1.MoveSelectedDown;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 0 to Picks.Items.Count - 2 do
      if Picks.Selected[i] then
        begin
          Picks.Items.Exchange(i, i + 1);
          Picks.Selected[i] := False;
          Picks.Selected[i + 1] := True;
          break;
        end;
  end;
end;

procedure TForm1.CopyFilesInList(DestDir: String; DoNewNames: Boolean; DoSubDir: Boolean);
var
  ok: Boolean;
  i: Integer;
  item: TImageInfo;
  dst_dir: String;
  dst: String;
  src: String;
  ext: String;
  stem: String;
  seq: String;
  t: String;
  do_replace: Boolean = False;
  mr: Integer;
begin
  if not DirectoryExists(DestDir) then
    begin
      MessageDlg('ERROR', 'Folder not found: ' + DestDir, mtError, [mbOk],0);
      Exit;
    end;

  AppOptions.LastCopyDir := DestDir;

  if Picks.Count = 0 then
    begin
      MessageDlg('Nothing to do', 'No images in list.', mtInformation, [mbOk],0);
      Exit;
    end;

  dst_dir := DestDir;
  if DoSubDir then
    begin
      dst_dir := AsPath(dst_dir) + FormatDateTime('yyyymmdd_hhnnss', Now);
      CreateDir(dst_dir);
    end;

  for i := 0 to Picks.Items.Count - 1 do
    begin
      item := TImageInfo(Picks.Items.Objects[i]);
      src := item.FullName;
      stem := ChangeFileExt(item.GetFileName, '');
      ext := ExtractFileExt(item.GetFileName);
      if item.HasTag then
        t := '-' + item.Tag
      else
        t := '';

      if DoNewNames then
        begin
          seq := '-' + format('%.3d', [i + 1]);
          if 0 < Length(editTitle.Text) then
            dst := ForFileName(editTitle.Text) + seq + t + ext
          else
            dst := stem + t + ext;
        end
      else
        dst := stem + t + ext;

      dst := AsPath(dst_dir) + dst;

      if FileExists(dst) and (not do_replace) then
        begin
          mr := MessageDlg(
            'Replace existing file?',
            dst + ' already exists. Replace?',
            mtConfirmation, [mbYes, mbYesToAll, mbNo, mbCancel],
            0);
          if mr = mrYesToAll then
            do_replace := True
          else if mr = mrNo then
            continue
          else if mr = mrCancel then
            Exit;
        end;

      ok := CopyFile(src, dst, True);
      if not ok then
        begin
          MessageDlg('ERROR', 'Copy failed: ' + dst, mtError, [mbOk],0);
          Exit;
        end;
    end;
end;

procedure TForm1.SaveAppOptions;
begin
  if not AppOptions.SaveOptions then
    MessageDlg('ERROR', AppOptions.LastError, mtError, [mbOk], 0);
end;

procedure TForm1.AskToClearPicks;
begin
  If Picks.Items.Count = 0 then
    Exit;
  if mrNo = MessageDlg(
    'Keep current picks?',
    'Keep the current list of picks?' + #13#10
    + 'Choose No to clear the list of picked images.',
    mtConfirmation, [mbYes, mbNo], 0)
  then
    Picks.Items.Clear;
end;

end.

