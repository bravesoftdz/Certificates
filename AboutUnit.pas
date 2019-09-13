unit AboutUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, SHELLAPI, FMX.Platform.Win,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.WebBrowser, FMX.Objects;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    WebBrowser1: TWebBrowser;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label3: TLabel;
    Panel2: TPanel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.fmx}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  WebBrowser1.URL := ExtractFilePath(ParamStr(0)) + 'about\about.html';
end;

procedure TAboutForm.Label3Click(Sender: TObject);
begin
  If (Sender is TLabel) then
    with (Sender as TLabel) do
      ShellExecute(WindowHandleToPlatform(Handle).Wnd, 'open',
        'https://money.yandex.ru/to/410014926236780', nil, nil, 5);
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  If (Sender is TLabel) then
    with (Sender as TLabel) do
      ShellExecute(WindowHandleToPlatform(Handle).Wnd, 'open',
        'mailto:scbeast-develop@yandex.ru', nil, nil, 5);
end;

procedure TAboutForm.SpeedButton1Click(Sender: TObject);
begin
  AboutForm.Close;
end;

end.
