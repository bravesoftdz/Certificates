unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Defaults,
  System.Generics.Collections, IniFiles, System.Types,

  FMX.TextLayout, FMX.ListView.Types,

  XSuperJSON, XSuperObject,

  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,

  CertificateUnit;

type
  TDM = class(TDataModule)
    HTTP: TNetHTTPClient;
    procedure HTTPValidateServerCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);

  private
    { Private declarations }
    CertDataJSONObject: ISuperObject; // JSON данные из файла сертов
    CertificatesCount: Integer; // количество сертификатов в базе

  public
  var
    FilePath, LoadingMethod: String; // Путь до файла, Метод загрузки
    WhereSearchString: String;
    // Изначальная немодифицированная строка с данными из серта
    Count, CurrentCount: Integer;
    // Счётчики для поиска подстроки в данных из серта

    function GetTextHeight(const D: TListItemText; const Width: Single;
      const Text: string): Integer;
    // Вычисление высоты текста в айтеме лист вью
    function FetchCertificatesData: Boolean;
    // загрузить данные по сертам
    // откуда грузить берётся из settings.ini PrefferedMethod
    // LocalFile - из локального файла
    // RemoteFile - с удалённого сервера
    procedure CreateCertificatesList; // создать лист сертификатов
    procedure IniFileActions(const Action: Boolean);
    // действия с файлом настроек.
    // True - загрузить настройки, False - сохранить настройки
  end;

var
  DM: TDM;
  Certificates: TObjectList<TCertificate>;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ TCertificatesDataModule }

procedure TDM.CreateCertificatesList;
var
  I: Integer;
begin
  CertificatesCount := CertDataJSONObject['cert_data'].AsArray.Length;
  Certificates := TObjectList<TCertificate>.Create;
  for I := 0 to CertificatesCount - 1 do
  begin
    Certificates.Add(TCertificate.Create(CertDataJSONObject['cert_data[' +
      I.ToString + ']."num"'].AsString,
      CertDataJSONObject['cert_data[' + I.ToString + ']."from"'].AsString,
      CertDataJSONObject['cert_data[' + I.ToString + ']."till"'].AsString,
      CertDataJSONObject['cert_data[' + I.ToString + ']."firm"'].AsString,
      CertDataJSONObject['cert_data[' + I.ToString + ']."manufacturer"']
      .AsString, CertDataJSONObject['cert_data[' + I.ToString + ']."codes"']
      .AsString, CertDataJSONObject['cert_data[' + I.ToString +
      ']."description"'].AsString, CertDataJSONObject['cert_data[' + I.ToString
      + ']."marks"'].AsString));
  end;
end;

function TDM.FetchCertificatesData: Boolean;
// LocalFile - загружать из локального файла
var
  S: TStringList;
  Ss: TStringStream;
begin
  Result := False;
  // FreeAndNil(S);
  // FreeAndNil(Ss);
  if LoadingMethod = 'LocalFile' then
  begin
    try
      S := TStringList.Create;
      S.LoadFromFile(FilePath);
      CertDataJSONObject := SO(S.Text);
      S.Free;
    except
      Result := True;
    end;
  end
  else
  begin
    try
      Ss := TStringStream.Create('');
      HTTP.Get(FilePath, Ss);
      Ss.SaveToFile(ExtractFilePath(ParamStr(0)) + 'temp.json');
      S := TStringList.Create;
      S.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'temp.json');
      CertDataJSONObject := SO(S.Text);
      // CertDataJSONObject := SO(Ss.DataString);
      DeleteFile(ExtractFilePath(ParamStr(0)) + 'temp.json');
      Ss.Free;
      S.Free;
    except
      Result := True;
    end;
  end;

end;

function TDM.GetTextHeight(const D: TListItemText; const Width: Single;
  const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TDM.HTTPValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

procedure TDM.IniFileActions(const Action: Boolean);
var
  INI: TIniFile;
begin
  // FilePath := '';

  INI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  if Action then // если true то загрузить настройки, иначе записать
  begin
    FilePath := INI.ReadString('Settings', 'FilePath', '');
    LoadingMethod := INI.ReadString('Settings', 'LoadingMethod', 'LocalFile');
  end
  else
  begin
    INI.WriteString('Settings', 'FilePath', FilePath);
    INI.WriteString('Settings', 'LoadingMethod', LoadingMethod);
  end;

end;

end.
