unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, Buttons, Spin, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnPickAdd: TButton;
    btnPickCopyAll: TButton;
    btnPickDown: TButton;
    btnPickRemove: TButton;
    btnPickShow: TButton;
    btnPickShowNext: TButton;
    btnPickShowPrev: TButton;
    btnPickUp: TButton;
    btnTagApply: TButton;
    chkLoop: TCheckBox;
    chkAutoTag: TCheckBox;
    Image: TImage;
    Glyphs: TImageList;
    editTag: TLabeledEdit;
    editTitle: TLabeledEdit;
    mnuAbout: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    btnMode: TSpeedButton;
    SpinEditLabel: TLabel;
    Picks: TListBox;
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuFileLoad: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileOpenDir: TMenuItem;
    mnuFileSave: TMenuItem;
    mnuFileCurrent: TMenuItem;
    mnuTools: TMenuItem;
    mnuToolsCopy: TMenuItem;
    mnuToolsOptions: TMenuItem;
    mnuToolsSort: TMenuItem;
    PanelImage: TPanel;
    PanelNav: TPanel;
    PanelPicks: TPanel;
    PanelSide: TPanel;
    btnNavFirst: TSpeedButton;
    btnNavLast: TSpeedButton;
    btnNavNext: TSpeedButton;
    btnNavPrev: TSpeedButton;
    btnNavToggle: TSpeedButton;
    btnNavTogglePlay: TSpeedButton;
    OpenDirDialog: TSelectDirectoryDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    SpinEdit: TSpinEdit;
    StatusBar: TStatusBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Timer: TTimer;
    TrackBar: TTrackBar;
    procedure btnModeClick(Sender: TObject);
    procedure btnNavFirstClick(Sender: TObject);
    procedure btnNavLastClick(Sender: TObject);
    procedure btnNavNextClick(Sender: TObject);
    procedure btnNavPrevClick(Sender: TObject);
    procedure btnNavToggleClick(Sender: TObject);
    procedure btnNavTogglePlayClick(Sender: TObject);
    procedure btnPickAddClick(Sender: TObject);
    procedure btnPickCopyAllClick(Sender: TObject);
    procedure btnPickDownClick(Sender: TObject);
    procedure btnPickRemoveClick(Sender: TObject);
    procedure btnPickShowClick(Sender: TObject);
    procedure btnPickShowNextClick(Sender: TObject);
    procedure btnPickShowPrevClick(Sender: TObject);
    procedure btnPickUpClick(Sender: TObject);
    procedure btnTagApplyClick(Sender: TObject);
    procedure chkLoopChange(Sender: TObject);
    procedure editTagEnter(Sender: TObject);
    procedure editTagExit(Sender: TObject);
    procedure editTitleEnter(Sender: TObject);
    procedure editTitleExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageClick(Sender: TObject);
    procedure ImageDblClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuFileCurrentClick(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileLoadClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuFileOpenDirClick(Sender: TObject);
    procedure mnuFileSaveClick(Sender: TObject);
    procedure mnuToolsCopyClick(Sender: TObject);
    procedure mnuToolsOptionsClick(Sender: TObject);
    procedure mnuToolsSortClick(Sender: TObject);
    procedure PicksDblClick(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);
    procedure SpinEditEnter(Sender: TObject);
    procedure SpinEditExit(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TrackBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    IsActivated: Boolean;
    InEdit: Boolean;
    IsPicksMode: Boolean;
    procedure AddCurrentImage;
    procedure AskToClearPicks;
    procedure CopyFilesInList(DestDir: String; FileNamesOption: Integer; DoSubDir: Boolean);
    procedure GetArgs;
    procedure ImageFirst;
    procedure ImageLast;
    procedure ImageNext;
    procedure ImagePrev;
    procedure LoadImage(const ATag: String = '');
    procedure LoadImagesList(FileName: String; AllowSubDirs: Boolean);
    procedure LoadPicksFromSavedFile;
    procedure MoveSelectedDown;
    procedure MoveSelectedUp;
    procedure PlayStop;
    procedure SaveAppOptions;
    procedure SavePicks(FileName: String);
    procedure SelectShowFirst;
    procedure SelectShowLast;
    procedure SelectShowNext;
    procedure SelectShowPrev;
    procedure ShowSelectedImage;
    procedure TogglePicksMode;
    procedure TogglePanel2;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  uApp,
  uAppFuncs,
  uAppOptions,
  uClipboard,
  uAboutDlg,
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
  GLYPH_COLLAPSE = 0;
  GLYPH_EXPAND = 1;
  GLYPH_FIRST = 2;
  GLYPH_PLAY = 4;
  GLYPH_STOP = 5;
  GLYPH_LAST = 7;
  GLYPH_MODE0 = 8;
  GLYPH_MODE1 = 9;


var
  ImagesList: TImagesList;

{ TMainForm }


procedure TMainForm.btnModeClick(Sender: TObject);
begin
  TogglePicksMode;
end;

procedure TMainForm.btnNavFirstClick(Sender: TObject);
begin
  ImageFirst;
end;

procedure TMainForm.btnNavLastClick(Sender: TObject);
begin
  ImageLast;
end;

procedure TMainForm.btnNavNextClick(Sender: TObject);
begin
  if IsPicksMode then
    SelectShowNext
  else
    ImageNext;
end;

procedure TMainForm.btnNavPrevClick(Sender: TObject);
begin
  if IsPicksMode then
    SelectShowPrev
  else
    ImagePrev;
end;

procedure TMainForm.btnNavToggleClick(Sender: TObject);
begin
  TogglePanel2;
end;

procedure TMainForm.btnNavTogglePlayClick(Sender: TObject);
begin
  PlayStop;
end;

procedure TMainForm.btnPickAddClick(Sender: TObject);
begin
  AddCurrentImage;
end;

procedure TMainForm.btnPickCopyAllClick(Sender: TObject);
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
    StatusBar.SimpleText := 'Nothing to copy.'
  else
    begin
      TextToClipboard(s);
      StatusBar.SimpleText := 'File paths copied to clipboard.'
    end;
end;

procedure TMainForm.btnPickDownClick(Sender: TObject);
begin
  MoveSelectedDown;
end;

procedure TMainForm.btnPickRemoveClick(Sender: TObject);
var
  i: Integer;
  x: Integer;
begin
  if Picks.SelCount = 0 then
    Exit;

  if not MessageDlg('Confirm', 'Remove selected item from the list?',
    mtConfirmation, [mbYes, mbNo],0
  ) = mrYes then
    Exit;

  x := -1;
  for i := Picks.Items.Count - 1 downto 0 do
    if Picks.Selected[i] then
      begin
        if i < (Picks.Items.Count - 1) then
          x := i
        else
          x := i - 1;
        Picks.Items.Objects[i].Free;  // TImageInfo object
        Picks.Items.Delete(i);
      end;
  if 0 <= x then
    begin
      Picks.Selected[x] := True;
      ShowSelectedImage;
    end;
end;

procedure TMainForm.btnPickShowClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TMainForm.btnPickShowNextClick(Sender: TObject);
begin
  SelectShowNext;
end;

procedure TMainForm.btnPickShowPrevClick(Sender: TObject);
begin
  SelectShowPrev;
end;

procedure TMainForm.btnPickUpClick(Sender: TObject);
begin
  MoveSelectedUp;
end;

procedure TMainForm.btnTagApplyClick(Sender: TObject);
var
  i: Integer;
  item: TImageInfo;
begin
  if Picks.SelCount = 0 then
    begin
      StatusBar.SimpleText := 'No items selected in list of images.';
      Exit;
    end;

  for i := Picks.Items.Count - 1 downto 0 do
    if Picks.Selected[i] then
      begin
        item := TImageInfo(Picks.Items.Objects[i]);
        item.Tag := editTag.Text;
      end;
end;

procedure TMainForm.chkLoopChange(Sender: TObject);
begin
  ImagesList.DoLoop := chkLoop.Checked;
  AppOptions.DoLoop := chkLoop.Checked;
  SaveAppOptions;
end;

procedure TMainForm.editTagEnter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TMainForm.editTagExit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TMainForm.editTitleEnter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TMainForm.editTitleExit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if not IsActivated then
    GetArgs;
  IsActivated := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  AppOptions.SaveOptions;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  IsActivated := False;
  MainForm.Caption := APP_TITLE;
  InEdit := False;
  IsPicksMode := False;
  ImagesList := TImagesList.Create;
  AppOptions := TAppOptions.Create;
  AppOptions.LoadOptions;
  chkLoop.Checked := AppOptions.DoLoop;
  ImagesList.DoLoop := chkLoop.Checked;
  SpinEdit.Value := AppOptions.SpeedMs;
  PanelImage.Caption := 'No images.';
  StatusBar.SimpleText := 'No images.';
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Shift = [] then
    case Key of
      VK_HOME: if not InEdit then
        begin
          if IsPicksMode then
            SelectShowFirst
          else
            ImageFirst;
          Key := 0;
        end;

      VK_LEFT: if not InEdit then
        begin
          if IsPicksMode then
            SelectShowPrev
          else
            ImagePrev;
          Key := 0;
        end;

      VK_RIGHT: if not InEdit then
        begin
          if IsPicksMode then
            SelectShowNext
          else
            ImageNext;
          Key := 0;
        end;

      VK_END: if not InEdit then
        begin
          if IsPicksMode then
            SelectShowLast
          else
            ImageLast;
          Key := 0;
        end;


      VK_UP:
        begin
          if IsPicksMode then
            SelectShowPrev;
          Key := 0;
        end;

      VK_DOWN:
        begin
          if IsPicksMode then
            SelectShowNext;
          Key := 0;
        end;

      VK_F2:
        begin
          TogglePicksMode;
          Key := 0;
        end;

      VK_F4:
        begin
          TogglePanel2;
          Key := 0;
        end;

      VK_F5:
        begin
          if not IsPicksMode then
            PlayStop;
          Key := 0;
        end;

      VK_SPACE: if not InEdit then
        begin
          if not IsPicksMode then
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
          if not IsPicksMode then
            ImagePrev;
          Key := 0;
        end;

      VK_RIGHT:
        begin
          if not IsPicksMode then
            ImageNext;
          Key := 0;
        end;
    end;
end;

procedure TMainForm.ImageClick(Sender: TObject);
begin
  // Show full path to image in status bar.
  StatusBar.SimpleText := ImagesList.CurrentImage;
end;

procedure TMainForm.ImageDblClick(Sender: TObject);
begin
  AddCurrentImage;
end;

procedure TMainForm.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.mnuFileLoadClick(Sender: TObject);
begin
  LoadPicksFromSavedFile;
end;

procedure TMainForm.mnuFileOpenClick(Sender: TObject);
var
  dirname: String;
begin
  dirname := AppOptions.LastOpenDir;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    OpenDialog.InitialDir := dirname;

  OpenDialog.Filter := 'Image files|*.jpg;*.png;*.jpeg;*.bmp;*.gif;'
    + '*.JPG;*.PNG;*.JPEG;*.BMP;*.GIF';

  if OpenDialog.Execute then
    begin
      if IsPicksMode then
        TogglePicksMode;
      AskToClearPicks;
      LoadImagesList(OpenDialog.FileName, True);
      AppOptions.LastOpenDir := ExtractFileDir(OpenDialog.FileName);
      SaveAppOptions;
    end;
end;

procedure TMainForm.mnuFileOpenDirClick(Sender: TObject);
var
  dirname: String;
begin
  dirname := AppOptions.LastOpenDir;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    OpenDirDialog.InitialDir := dirname;

  if OpenDirDialog.Execute then
    begin
      if IsPicksMode then
        TogglePicksMode;
      AskToClearPicks;
      LoadImagesList(OpenDirDialog.FileName, True);
      AppOptions.LastOpenDir := ExtractFileDir(OpenDirDialog.FileName);
      SaveAppOptions;
    end;
end;

procedure TMainForm.mnuFileSaveClick(Sender: TObject);
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

  SaveDialog.InitialDir:= dirname;
  SaveDialog.FileName := filename;
  if SaveDialog.Execute then
    begin
      SavePicks(SaveDialog.FileName);
      AppOptions.LastSaveDir := ExtractFileDir(SaveDialog.FileName);
      SaveAppOptions;
    end;
end;

procedure TMainForm.mnuFileCurrentClick(Sender: TObject);
var
  filename: String;
begin
  filename := ImagesList.CurrentImage;
  if 0 < Length(filename) then
    // Open the folder using the default associated application.
    OpenDocument(ExtractFileDir(filename));
end;

procedure TMainForm.mnuToolsCopyClick(Sender: TObject);
var
  mr: TModalResult;
begin
  mr := CopyFilesDlg.ShowModal;
  if mr = mrOk then
    with CopyFilesDlg do
      CopyFilesInList(editFolder.Text, rgFileNames.ItemIndex, chkSubDir.Checked);
end;

procedure TMainForm.mnuToolsOptionsClick(Sender: TObject);
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

procedure TMainForm.mnuToolsSortClick(Sender: TObject);
var
  sl : TStringList;
begin
  if 1 < Picks.Items.Count then
    begin
      // Assign the items to a TStringList and call its Sort method.
      sl := TStringList.Create;
      sl.Assign(Picks.Items);
      sl.Sort;
      // Assign the sorted items back to the TListBox.Items.
      Picks.Items.Assign(sl);
      sl.Free;
    end;
end;

procedure TMainForm.mnuAboutClick(Sender: TObject);
begin
  AboutDlg.ShowModal;
end;

procedure TMainForm.PicksDblClick(Sender: TObject);
begin
  ShowSelectedImage;
end;

procedure TMainForm.SpinEditChange(Sender: TObject);
begin
  if SpinEdit.Value < MIN_PLAY_MS then
    SpinEdit.Value := MIN_PLAY_MS
  else if MAX_PLAY_MS < SpinEdit.Value then
    SpinEdit.Value := MAX_PLAY_MS;

  AppOptions.SpeedMs := SpinEdit.Value;
  // To not slow things down, do not SaveAppOptions now.
  // Setting will be saved on form close.

  Timer.Interval := SpinEdit.Value;
end;

procedure TMainForm.SpinEditEnter(Sender: TObject);
begin
  InEdit := True;
end;

procedure TMainForm.SpinEditExit(Sender: TObject);
begin
  InEdit := False;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  ImageNext;
end;

procedure TMainForm.TrackBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{  Note: Using MouseUp instead of OnChange because OnChange fires for
   every position change when dragging the marker, and would load the
   image at each step, making it very slow to drag to a new position
   in a large set of images.
}
var
  p: Integer;
begin
  p := TrackBar.Position;
  if ImagesList.SetCurrentIndex(p - 1) then
    LoadImage;
end;

procedure TMainForm.AddCurrentImage;
var
  s: String;
  t: String;
  dup: Integer;
  info: TImageInfo;
begin
  if IsPicksMode then
    Exit;
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

procedure TMainForm.AskToClearPicks;
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

procedure TMainForm.CopyFilesInList(DestDir: String; FileNamesOption: Integer; DoSubDir: Boolean);
var
  ok: Boolean;
  i: Integer;
  item: TImageInfo;
  dst_dir: String;
  dst: String;
  src: String;
  ext: String;
  stem: String;
  seqL: String;
  seqR: String;
  tagL: String;
  title: String;
  titleL: String;
  titleR: String;
  do_replace: Boolean = False;
  mr: Integer;
begin
  if not DirectoryExists(DestDir) then
    begin
      MessageDlg('ERROR', 'Folder not found: ' + DestDir, mtError, [mbOk],0);
      Exit;
    end;

  AppOptions.LastCopyDir := DestDir;
  AppOptions.LastCopyOpt := FileNamesOption;

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
        tagL := '-' + item.Tag
      else
        tagL := '';

      title := ForFileName(editTitle.Text);
      if 0 < Length(title) then
        begin
          titleL := '-' + title;
          titleR := title + '-';
        end
      else
        begin
          titleL := '';
          titleR := '';
        end;

      seqL := '-' + format('%.3d', [i + 1]);
      seqR := format('%.3d', [i + 1]) + '-';

      case FileNamesOption of
        // 1: Sequence-FileName-Tag
        1: dst := seqR + stem + tagL + ext;

        // 2: Title-FileName-Tag-Sequence
        2: dst := titleR + stem + tagL + seqL + ext;

        // 3: Title-Sequence-Tag
        3:
          if (Length(title) + Length(tagL) = 0) then
            dst := 'Image' + seqL + ext
          else
            dst := title + seqL + tagL + ext;

        // 4: Title-Tag-Sequence
        4:
          if (Length(title) + Length(tagL) = 0) then
            dst := 'Image' + seqL + ext
          else
            dst := title + tagL + seqL + ext;
      else
        // 0: FileName-Tag
        dst := stem + tagL + ext;
      end;

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

procedure TMainForm.GetArgs;
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

procedure TMainForm.ImageFirst;
begin
  ImagesList.GoFirst;
  LoadImage;
end;

procedure TMainForm.ImageLast;
begin
  ImagesList.GoLast;
  LoadImage;
end;

procedure TMainForm.ImageNext;
begin
  if not ImagesList.GoNext then
    if Timer.Enabled then
      PlayStop;
  LoadImage;
end;

procedure TMainForm.ImagePrev;
begin
  ImagesList.GoPrevious;
  LoadImage;
end;

procedure TMainForm.LoadImage(const ATag: String = '');
var
  filename: String;
  t: String;
begin
  filename := ImagesList.CurrentImage;
  if Length(filename) = 0 then
    Exit;

  t := ATag;
  if 0 < Length(t) then
    begin
      t := ' [' + t + ']';
      if not chkAutoTag.Checked then
        editTag.Text := ATag;
    end;

  StatusBar.SimpleText := '(' + IntToStr(ImagesList.Index + 1) + ' of '
    + IntToStr(ImagesList.Count) + ') ' + ExtractFileName(filename) + t;


  PanelImage.Caption := '';

  Image.Picture.LoadFromFile(filename);

  TrackBar.Position := ImagesList.Index + 1;
end;

procedure TMainForm.LoadImagesList(FileName: String; AllowSubDirs: Boolean);
begin
  ImagesList.Load(FileName, AllowSubDirs);
  if not ImagesList.SetCurrentImage(FileName) then
    ImagesList.GoFirst;
  if ImagesList.Count = 0 then
    begin
      Image.Picture.Clear;
      PanelImage.Caption := 'No images.';
      TrackBar.Enabled := False;
    end
  else
    begin
      PanelImage.Caption := '';
      TrackBar.Min := 1;
      TrackBar.Max := ImagesList.Count;
      TrackBar.Enabled := True;
      LoadImage;
    end;
end;

procedure TMainForm.LoadPicksFromSavedFile;
var
  last_pick: String;
begin
  last_pick := LoadPicksFile(OpenDialog, editTitle, Picks, StatusBar);
  if 0 < Length(last_pick) then
    begin
      if IsPicksMode then
        TogglePicksMode;
      LoadImagesList(last_pick, False);
    end;
  SaveAppOptions;
end;

procedure TMainForm.MoveSelectedDown;
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

procedure TMainForm.MoveSelectedUp;
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

procedure TMainForm.PlayStop;
begin
  if Timer.Enabled then
     begin
       Timer.Enabled := False;
       btnNavTogglePlay.ImageIndex := GLYPH_PLAY;
     end
  else
    begin
      Timer.Enabled := True;
      btnNavTogglePlay.ImageIndex := GLYPH_STOP;
    end;
end;

procedure TMainForm.SaveAppOptions;
begin
  if not AppOptions.SaveOptions then
    MessageDlg('ERROR', AppOptions.LastError, mtError, [mbOk], 0);
end;

procedure TMainForm.SavePicks(FileName: String);
begin
  SavePicksFile(FileName, editTitle.Text, Picks, StatusBar);
end;

procedure TMainForm.SelectShowFirst;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 0 to Picks.Items.Count - 2 do
      if Picks.Selected[i] then
        begin
          Picks.Selected[i] := False;
          break;
        end;
    Picks.Selected[0] := True;
    ShowSelectedImage;
  end;
end;

procedure TMainForm.SelectShowLast;
var
  i: Integer;
begin
  if 0 < Picks.SelCount then
  begin
    for i := 0 to Picks.Items.Count - 2 do
      if Picks.Selected[i] then
        begin
          Picks.Selected[i] := False;
          break;
        end;
    Picks.Selected[Picks.Items.Count -1] := True;
    ShowSelectedImage;
  end;
end;

procedure TMainForm.SelectShowNext;
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

procedure TMainForm.SelectShowPrev;
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

procedure TMainForm.ShowSelectedImage;
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

procedure TMainForm.TogglePicksMode;
begin
  // Do not enter picks-mode while playing images.
  if Timer.Enabled then
    Exit;

  // Do not enter picks-mode if no images have been picked.
  if (not IsPicksMode) and (Picks.Items.Count = 0) then
    begin
      StatusBar.SimpleText := 'No images picked.';
      Exit;
    end;

  IsPicksMode := not IsPicksMode;
  if IsPicksMode then
    begin
      btnMode.ImageIndex := GLYPH_MODE1;
      TrackBar.Enabled := False;
      btnNavFirst.Enabled := False;
      btnNavFirst.ImageIndex := -1;
      btnNavLast.Enabled := False;
      btnNavLast.ImageIndex := -1;
      btnNavTogglePlay.Enabled := False;
      btnNavTogglePlay.ImageIndex := -1;
      if (0 < Picks.Items.Count) and (Picks.SelCount = 0) then
        Picks.Selected[0] := True;
      ShowSelectedImage;
    end
  else
    begin
      btnMode.ImageIndex := GLYPH_MODE0;
      TrackBar.Enabled := True;
      btnNavFirst.Enabled := True;
      btnNavFirst.ImageIndex := GLYPH_FIRST;
      btnNavLast.Enabled := True;
      btnNavLast.ImageIndex := GLYPH_LAST;
      btnNavTogglePlay.Enabled := True;
      btnNavTogglePlay.ImageIndex := GLYPH_PLAY;
    end;
end;

procedure TMainForm.TogglePanel2;
begin
  if PanelPicks.Width < P2_DEFAULT_WIDTH then
    begin
      // Expand.
      PanelPicks.Width := P2_DEFAULT_WIDTH;
      btnNavToggle.ImageIndex := GLYPH_COLLAPSE;
      editTitle.Enabled := True;
      editTag.Enabled := True;
    end
  else
    begin
      // Collapse.
      PanelPicks.Width := 4;
      btnNavToggle.ImageIndex := GLYPH_EXPAND;
      editTitle.Enabled := False;
      editTag.Enabled := False;
      Picks.ClearSelection;
      Picks.SetFocus;
    end;
  PanelSide.Width := PanelPicks.Width + PanelNav.Width + 4;
end;

end.

