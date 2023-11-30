unit uAboutDlg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TAboutDlg }

  TAboutDlg = class(TForm)
    btnClose: TButton;
    imgLogo: TImage;
    lblLazarusUrl: TLabel;
    lblFpcUrl: TLabel;
    lblSourceUrl: TLabel;
    lblSource: TLabel;
    lblAppName: TLabel;
    lblAppVersion: TLabel;
    lblLaz: TLabel;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure lblFpcUrlClick(Sender: TObject);
    procedure lblLazarusUrlClick(Sender: TObject);
    procedure lblSourceUrlClick(Sender: TObject);
  private

  public

  end;

var
  AboutDlg: TAboutDlg;

implementation

uses uApp, lclintf;

{$R *.lfm}

{ TAboutDlg }

procedure TAboutDlg.FormShow(Sender: TObject);
begin
  AboutDlg.Caption := 'About - ' + APP_NAME;
  lblAppName.Caption := APP_NAME;
  lblAPpVersion.Caption := 'Version ' + APP_VERSION;
  lblSourceUrl.Caption := 'https://github.com/wmelvin/ImagePicker';
  lblLazarusUrl.Caption := 'https://www.lazarus-ide.org';
  lblFpcUrl.Caption := 'https://www.freepascal.org';
end;

procedure TAboutDlg.lblFpcUrlClick(Sender: TObject);
begin
  OpenURL(lblFpcUrl.Caption);
end;

procedure TAboutDlg.lblLazarusUrlClick(Sender: TObject);
begin
  OpenURL(lblLazarusUrl.Caption);
end;

procedure TAboutDlg.lblSourceUrlClick(Sender: TObject);
begin
  OpenURL(lblSourceUrl.Caption);
end;

end.

