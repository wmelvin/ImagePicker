program ImagePicker;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, uImagesList, uAppFuncs, uImageInfo, uApp, uAppOptions, 
uCopyFilesDlg, uClipboard, uPicksFile, uAboutDlg
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCopyFilesDlg, CopyFilesDlg);
  Application.CreateForm(TAboutDlg, AboutDlg);
  Application.Run;
end.

