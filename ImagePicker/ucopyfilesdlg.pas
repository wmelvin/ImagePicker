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
  private

  public

  end;

var
  CopyFilesDlg: TCopyFilesDlg;

implementation

{$R *.lfm}

{ TCopyFilesDlg }

procedure TCopyFilesDlg.btnBrowseClick(Sender: TObject);
begin
  if dlgSelectDir.Execute then
    editFolder.Text := dlgSelectDir.FileName;
end;

end.

