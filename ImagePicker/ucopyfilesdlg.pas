unit uCopyFilesDlg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TCopyFilesDlg }

  TCopyFilesDlg = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    chkNewNames: TCheckBox;
    chkSubDir: TCheckBox;
    editFolder: TLabeledEdit;
    btnBrowse: TSpeedButton;
    dlgSelectDir: TSelectDirectoryDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  CopyFilesDlg: TCopyFilesDlg;

implementation

uses
  uAppOptions;

{$R *.lfm}

{ TCopyFilesDlg }

procedure TCopyFilesDlg.btnBrowseClick(Sender: TObject);
var
  dirname: String;
begin
  dirname := editFolder.Text;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    dlgSelectDir.InitialDir := dirname;

  if dlgSelectDir.Execute then
    editFolder.Text := dlgSelectDir.FileName;
end;

procedure TCopyFilesDlg.FormShow(Sender: TObject);
var
  dirname: String;
begin
  dirname := AppOptions.LastCopyDir;
  if (0 < Length(dirname)) and DirectoryExists(dirname) then
    editFolder.Text := dirname;
end;

end.

