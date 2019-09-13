program Certificates;



uses
  System.StartUpCopy,
  FMX.Forms,
  mUnit in 'mUnit.pas' {MainForm},
  DMUnit in 'DMUnit.pas' {DM: TDataModule},
  CertificateUnit in 'CertificateUnit.pas',
  OpenUrlUnit in 'OpenUrlUnit.pas' {OpenUrlForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
