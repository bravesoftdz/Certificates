unit OpenUrlUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  DMUnit, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TOpenUrlForm = class(TForm)
    GroupBoxOpenURL: TGroupBox;
    EditUrl: TEdit;
    SpeedButtonCancel: TSpeedButton;
    SpeedButtonOkAndClose: TSpeedButton;
    procedure SpeedButtonOkAndCloseClick(Sender: TObject);
    procedure SpeedButtonCancelClick(Sender: TObject);
    procedure OkAndClose;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  OpenUrlForm: TOpenUrlForm;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TOpenUrlForm.FormShow(Sender: TObject);
begin
  OpenUrlForm.ActiveControl := EditUrl;
end;

procedure TOpenUrlForm.OkAndClose;
const
  GOOGLE_DRIVE = 'google.com/file/d/';
  DROPBOX = 'dropbox.com/s';
var
  StartPos, EndPos, CurrentPos: integer;
  EditUrlText: String;
begin
EditUrlText := EditUrl.Text;
CurrentPos := Pos('http', EditUrl.Text);
  if (CurrentPos = 0) and (CurrentPos = 0) then
  begin
    ModalResult := mrCancel;
    exit;
  end;
  CurrentPos:= Pos(DROPBOX, EditUrl.Text);
  if CurrentPos <> 0 then
    EditUrlText := StringReplace(EditUrlText, '?dl=0', '?dl=1',
      [rfReplaceAll, rfIgnoreCase]);
      CurrentPos    := Pos(GOOGLE_DRIVE, EditUrl.Text);
      if CurrentPos <> 0 then   begin
        StartPos:=CurrentPos+GOOGLE_DRIVE.Length;
        EndPos:=Pos('/view', EditUrlText);
        EditUrlText:='https://drive.google.com/uc?export=download&id='+Copy(EditUrlText,StartPos,EndPos-StartPos);
      end;

  DM.FilePath := EditUrlText;
  DM.LoadingMethod := 'URL';
  DM.IniFileActions(false);
  OpenUrlForm.Close;
  ModalResult := mrOK;
end;

procedure TOpenUrlForm.SpeedButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TOpenUrlForm.SpeedButtonOkAndCloseClick(Sender: TObject);
begin
  OkAndClose;
end;

end.
