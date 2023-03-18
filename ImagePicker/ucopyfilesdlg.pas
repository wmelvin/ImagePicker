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
  private

  public

  end;

var
  CopyFilesDlg: TCopyFilesDlg;

implementation

{$R *.lfm}

end.

