unit mUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, StrUtils,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TabControl, FMX.Edit, FMX.WebBrowser,

  UListItemElements,

  DMUnit, CertificateUnit, OpenUrlUnit, AboutUnit;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1_File: TMenuItem;
    MenuItem3_About: TMenuItem;
    MenuItem4_LoadFromLocalFile: TMenuItem;
    MenuItem5_LoadFromRemoteServer: TMenuItem;
    StatusBar1: TStatusBar;
    MainListView: TListView;
    MainTabControl: TTabControl;
    CertificatesList: TTabItem;
    DetailedInfo: TTabItem;
    DetailedSelectingButtonsGroup: TGroupBox;
    SpeedButtonDescription: TSpeedButton;
    SpeedButtonMarks: TSpeedButton;
    SpeedButtonManufacturer: TSpeedButton;
    SpeedButtonCodes: TSpeedButton;
    CertDetaildInfoLabel: TLabel;
    CertDetailedInfoBox: TGroupBox;
    Panel1: TPanel;
    EditSearch: TEdit;
    SpeedButtonSearch: TSpeedButton;
    LabelStatus: TLabel;
    Panel2: TPanel;
    SpeedButtonLoadData: TSpeedButton;
    WebBrowserDetailedInfo: TWebBrowser;
    OpenFileDialog: TOpenDialog;
    procedure SpeedButtonDescriptionClick(Sender: TObject);
    procedure SpeedButtonMarksClick(Sender: TObject);
    procedure SpeedButtonManufacturerClick(Sender: TObject);
    procedure SpeedButtonCodesClick(Sender: TObject);
    procedure MainListViewUpdatingObjects(const Sender: TObject;
      const AItem: TListViewItem; var AHandled: Boolean);
    procedure SpeedButtonLoadDataClick(Sender: TObject);
    procedure DetailedInfoClick(Sender: TObject);
    procedure EditSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure MenuItem4_LoadFromLocalFileClick(Sender: TObject);
    procedure LoadAndDisplayCertificates;
    procedure MenuItem5_LoadFromRemoteServerClick(Sender: TObject);
    procedure MenuItem3_AboutClick(Sender: TObject);
  private
    { Private declarations }
    FCanUpdate: Boolean;
    procedure PopulateMainListView;
  public
    { Public declarations }
  end;

const
  ITEM_LIST_HEADER_FONT_SIZE = 13;
  ITEM_LIST_TEXT_FONT_SIZE = 12;
  ITEM_LIST_OTHER_FONT_SIZE = 10;
  PRIMARY_COLOR_DARK = $FF616161;
  PRIMARY_COLOR = $FF9E9E9E;
  PRIMARY_COLOR_LIGHT = $FFF5F5F5;
  PRIMARY_COLOR_TEXT = $FF212121;
  ACCENT_COLOR = $FF9E9E9E;
  PRIMARY_TEXT_COLOR = $FF212121;
  SECONDARY_TEXT_COLOR = $FF757575;
  DIVIDER_COLOR = $FFBDBDBD;

  HTML_BEGIN = '<html><body><p style="font-size: 12px; text-align: justify">';
  HTML_END = '</p></body></html><style>span {background-color: cyan}</style>';
  HTML_ANCHOR_BEGIN = '<a name="n';
  HTML_ANCHOR_END = '"></a>';
  HTML_SPAN_OPEN = '<span>';
  HTML_SPAN_CLOSE = '</span>';

var
  MainForm: TMainForm;
  MLVItemIndex: integer;
  Description, Marks, Manufacturer, Codes: String;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TMainForm.DetailedInfoClick(Sender: TObject);

begin
  MainTabControl.TabIndex := 1;
  MLVItemIndex := MainListView.Items[MainListView.ItemIndex].Tag;
  CertDetailedInfoBox.Text := Certificates[MLVItemIndex].CertNumber;
  CertDetaildInfoLabel.Text := 'Заявитель: ' + Certificates[MLVItemIndex]
    .CertOwner + '. Выдан ' + Certificates[MLVItemIndex].CertDateFrom +
    ', действует до ' + Certificates[MLVItemIndex].CertDateTill;
  SpeedButtonDescription.TextSettings.FontColor := TAlphaColorRec.Blue;
  SpeedButtonMarks.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonManufacturer.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonCodes.TextSettings.FontColor := TAlphaColorRec.Black;

  DM.WhereSearchString := Certificates[MLVItemIndex].CertDescriptionOfGoods;

  Description := HTML_BEGIN + Certificates[MLVItemIndex].CertDescriptionOfGoods
    + HTML_END;
  Marks := HTML_BEGIN + Certificates[MLVItemIndex].SertMarksOfGoods + HTML_END;
  Manufacturer := HTML_BEGIN + Certificates[MLVItemIndex]
    .CertManufacturerOfGoods + HTML_END;
  Codes := HTML_BEGIN + Certificates[MLVItemIndex].CertCodes + HTML_END;

  WebBrowserDetailedInfo.BeginUpdate;
  WebBrowserDetailedInfo.LoadFromStrings(Description, '');
  WebBrowserDetailedInfo.EndUpdate;
end;

procedure TMainForm.EditSearchChange(Sender: TObject);
var
  ModifyinglString, SubString: String;
  CurrentPosition, SearchCounter: integer;
begin
  CurrentPosition := 0;
  SearchCounter := 0;
  SubString := EditSearch.Text;
  ModifyinglString := DM.WhereSearchString;
  CurrentPosition := PosEx(SubString, ModifyinglString, 1);
  if CurrentPosition <> 0 then
  begin
    DM.CurrentCount := 1;
    repeat
      Inc(SearchCounter);
      Insert(HTML_ANCHOR_BEGIN + SearchCounter.ToString, ModifyinglString,
        CurrentPosition);
      CurrentPosition := CurrentPosition + HTML_ANCHOR_BEGIN.Length +
        SearchCounter.ToString.Length;
      Insert(HTML_ANCHOR_END, ModifyinglString, CurrentPosition);
      CurrentPosition := CurrentPosition + HTML_ANCHOR_END.Length;
      Insert(HTML_SPAN_OPEN, ModifyinglString, CurrentPosition);
      CurrentPosition := CurrentPosition + HTML_SPAN_OPEN.Length +
        SubString.Length;
      Insert(HTML_SPAN_CLOSE, ModifyinglString, CurrentPosition);
      CurrentPosition := CurrentPosition + HTML_SPAN_CLOSE.Length;
      CurrentPosition := PosEx(SubString, ModifyinglString, CurrentPosition);
    until (CurrentPosition = 0);
  end;
  DM.Count := SearchCounter;
  ModifyinglString := HTML_BEGIN + ModifyinglString + HTML_END;
  if (SearchCounter <> 0) then
  begin
    SpeedButtonSearch.Text := 'найдено совпадений: ' + SearchCounter.ToString;
  end
  else
    SpeedButtonSearch.Text := 'нет совпадений';
  WebBrowserDetailedInfo.LoadFromStrings(ModifyinglString, '');
  EditSearch.SetFocus;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DM.Count := 0;
  DM.CurrentCount := 1;
  DM.WhereSearchString := '';
  DM.IniFileActions(True);
  LabelStatus.Text := 'Текущее расположение файла: ' + DM.FilePath;
end;

procedure TMainForm.LoadAndDisplayCertificates;
begin
  if not DM.FetchCertificatesData then
  begin
    LabelStatus.Text := 'Текущее расположение файла: ' + DM.FilePath;
    DM.CreateCertificatesList;
    PopulateMainListView;
    MainTabControl.Tabs[1].Enabled := True;
  end
  else
  begin
    LabelStatus.Text := 'Ошибка! Файл не загружен.';
    ShowMessage('Ошибка! Файл не загружен.');
  end;

end;

procedure TMainForm.MainListViewUpdatingObjects(const Sender: TObject;
  const AItem: TListViewItem; var AHandled: Boolean);

var
  LText: TListItemText;
  LRect: TListItemRoundedRect;
  XOffset, YOffset: integer;
  AvailableWidth: Single;
  Drawable: TListItemText;
  Text: String;
begin
  if not FCanUpdate then
    Exit;

  YOffset := 4;
  XOffset := 4;

  LRect := AItem.Objects.FindObjectT<TListItemRoundedRect>('rectangle_header');
  // прямоугольник
  if LRect = nil then
  begin
    LRect := TListItemRoundedRect.Create(AItem);
    LRect.Name := 'rectangle_header';
    LRect.PlaceOffset.X := 0;
    LRect.PlaceOffset.Y := YOffset;
    LRect.Height := 21;
    LRect.Color := PRIMARY_COLOR;
    LRect.BorderColor := TAlphaColorRec.Null;
    LRect.Rounded := 5;
    LRect.LineWidth := 0;
  end;
  LRect.Width := (Sender as TListView).Width - 42;
  YOffset := YOffset - 8;

  LText := AItem.Objects.FindObjectT<TListItemText>('num'); // номер серта
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'num';
    LText.PlaceOffset.X := XOffset - 2;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_COLOR_LIGHT;
    LText.SelectedTextColor := PRIMARY_COLOR_LIGHT;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Center;
    LText.Font.Size := ITEM_LIST_HEADER_FONT_SIZE;
    LText.Font.Style := [TFontStyle.fsBold];
    LText.Trimming := TTextTrimming.Character;
  end;
  LText.Text := AItem.Data['num'].AsString + ' от ' + AItem.Data['from']
    .AsString + ' до ' + AItem.Data['till'].AsString;
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('num'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text);
  LText.Width := AvailableWidth;
  YOffset := Round(LText.Height) - 20;

  LText := AItem.Objects.FindObjectT<TListItemText>('firm'); // владелец серта
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'firm';
    LText.PlaceOffset.X := XOffset;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_TEXT_COLOR;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Center;
    LText.Font.Size := ITEM_LIST_TEXT_FONT_SIZE;
    LText.Trimming := TTextTrimming.Character;
  end;
  LText.Text := 'Выдан: ' + AItem.Data['firm'].AsString;

  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('firm'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text);
  LText.Width := AvailableWidth;
  YOffset := YOffset + Round(LText.Height) - 16;

  LText := AItem.Objects.FindObjectT<TListItemText>('manufacturer');
  // изготовитель
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'manufacturer';
    LText.PlaceOffset.X := XOffset;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_TEXT_COLOR;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Center;
    LText.Font.Size := ITEM_LIST_TEXT_FONT_SIZE;
    LText.WordWrap := True;
    LText.Trimming := TTextTrimming.Character;
  end;
  LText.Text := 'Изготовитель: ' + AItem.Data['manufacturer'].AsString;
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('manufacturer'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text);
  LText.Width := AvailableWidth;
  YOffset := YOffset + Round(LText.Height) - 10;

  LText := AItem.Objects.FindObjectT<TListItemText>('description');
  // описание товара
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'description';
    LText.PlaceOffset.X := XOffset;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_TEXT_COLOR;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Leading;
    LText.Font.Size := ITEM_LIST_TEXT_FONT_SIZE;
    LText.WordWrap := True;
    LText.Trimming := TTextTrimming.Character;
  end;
  LText.Text := 'Продукция: ' + AItem.Data['description'].AsString;
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('description'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text);
  LText.Width := AvailableWidth;
  YOffset := YOffset + Round(LText.Height) - 12;
  XOffset := XOffset + 4;

  LText := AItem.Objects.FindObjectT<TListItemText>('codes'); // коды ТН ВЭД
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'codes';
    LText.PlaceOffset.X := XOffset;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_TEXT_COLOR;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Center;
    LText.Font.Size := ITEM_LIST_OTHER_FONT_SIZE;
    LText.WordWrap := True;
    LText.Trimming := TTextTrimming.Character;
  end;
  LText.Text := 'Код ТНВЭД ЕАЭС: ' + AItem.Data['codes'].AsString;
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('codes'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text);
  LText.Width := AvailableWidth;
  YOffset := YOffset + Round(LText.Height) - 8;

  LText := AItem.Objects.FindObjectT<TListItemText>('marks'); // маркировка
  if LText = nil then
  begin
    LText := TListItemText.Create(AItem);
    LText.Name := 'marks';
    LText.PlaceOffset.X := XOffset;
    LText.PlaceOffset.Y := YOffset;
    LText.TextColor := PRIMARY_TEXT_COLOR;
    LText.TextAlign := TTextAlign.Leading;
    LText.TextVertAlign := TTextAlign.Leading;
    LText.Font.Size := ITEM_LIST_OTHER_FONT_SIZE;
    LText.WordWrap := True;
    LText.Trimming := TTextTrimming.Word;
  end;
  LText.Text := 'Маркировка: ' + AItem.Data['marks'].AsString;
  AvailableWidth := TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
    - TListView(Sender).ItemSpaces.Right;
  Drawable := TListItemText(AItem.View.FindDrawable('marks'));
  Text := Drawable.Text;
  LText.Height := DM.GetTextHeight(Drawable, AvailableWidth, Text) - 12;
  if LText.Height > 180 then
    LText.Height := 190;
  LText.Width := AvailableWidth;
  YOffset := YOffset + Round(LText.Height);

  AItem.Height := YOffset;
  AHandled := True;
end;

procedure TMainForm.MenuItem3_AboutClick(Sender: TObject);
begin
  AboutForm := TAboutForm.Create(Self);
  AboutForm.ShowModal;
  AboutForm.Free;
end;

procedure TMainForm.MenuItem4_LoadFromLocalFileClick(Sender: TObject);
begin
  OpenFileDialog.Filter := 'Файлы списка (JSON)|*.json';
  if OpenFileDialog.Execute then
  begin
    DM.FilePath := OpenFileDialog.FileName;
    DM.LoadingMethod := 'LocalFile';
    DM.IniFileActions(false);
    LoadAndDisplayCertificates;
  end;
end;

procedure TMainForm.MenuItem5_LoadFromRemoteServerClick(Sender: TObject);
begin
  OpenUrlForm := TOpenUrlForm.Create(Self);
  if OpenUrlForm.ShowModal = mrOk then
  begin
    LoadAndDisplayCertificates;
  end;
  OpenUrlForm.Free;
end;

procedure TMainForm.PopulateMainListView;
var
  LItem: TListViewItem;
  I: integer;

begin
  MainListView.ItemsClearTrue;
  MainListView.BeginUpdate;
  for I := 0 to Certificates.Count - 1 do
  begin
    FCanUpdate := false;

    LItem := MainListView.Items.Add;
    LItem.Data['num'] := Certificates[I].CertNumber;
    LItem.Data['from'] := Certificates[I].CertDateFrom;
    LItem.Data['till'] := Certificates[I].CertDateTill;
    LItem.Data['firm'] := Certificates[I].CertOwner;
    LItem.Data['manufacturer'] := Certificates[I].CertManufacturerOfGoods;
    LItem.Data['codes'] := Certificates[I].CertCodes;
    LItem.Data['description'] := Certificates[I].CertDescriptionOfGoods;
    LItem.Data['marks'] := Certificates[I].SertMarksOfGoods;
    LItem.Tag := I;

    FCanUpdate := True;
    MainListView.Adapter.ResetView(LItem);
  end;

  MainListView.EndUpdate;
  MainListView.ItemIndex := 0;
end;

procedure TMainForm.SpeedButtonCodesClick(Sender: TObject);
begin
  SpeedButtonDescription.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonMarks.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonManufacturer.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonCodes.TextSettings.FontColor := TAlphaColorRec.Blue;

  DM.WhereSearchString := Certificates[MLVItemIndex].CertCodes;

  WebBrowserDetailedInfo.BeginUpdate;
  WebBrowserDetailedInfo.LoadFromStrings(Codes, '');
  WebBrowserDetailedInfo.EndUpdate;
end;

procedure TMainForm.SpeedButtonDescriptionClick(Sender: TObject);
begin
  SpeedButtonDescription.TextSettings.FontColor := TAlphaColorRec.Blue;
  SpeedButtonMarks.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonManufacturer.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonCodes.TextSettings.FontColor := TAlphaColorRec.Black;

  DM.WhereSearchString := Certificates[MLVItemIndex].CertDescriptionOfGoods;

  WebBrowserDetailedInfo.BeginUpdate;
  WebBrowserDetailedInfo.LoadFromStrings(Description, '');
  WebBrowserDetailedInfo.EndUpdate;
end;

procedure TMainForm.SpeedButtonManufacturerClick(Sender: TObject);
begin
  SpeedButtonDescription.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonMarks.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonManufacturer.TextSettings.FontColor := TAlphaColorRec.Blue;
  SpeedButtonCodes.TextSettings.FontColor := TAlphaColorRec.Black;

  DM.WhereSearchString := Certificates[MLVItemIndex].CertManufacturerOfGoods;

  WebBrowserDetailedInfo.BeginUpdate;
  WebBrowserDetailedInfo.LoadFromStrings(Manufacturer, '');
  WebBrowserDetailedInfo.EndUpdate;
end;

procedure TMainForm.SpeedButtonMarksClick(Sender: TObject);
begin
  SpeedButtonDescription.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonMarks.TextSettings.FontColor := TAlphaColorRec.Blue;
  SpeedButtonManufacturer.TextSettings.FontColor := TAlphaColorRec.Black;
  SpeedButtonCodes.TextSettings.FontColor := TAlphaColorRec.Black;

  DM.WhereSearchString := Certificates[MLVItemIndex].SertMarksOfGoods;

  WebBrowserDetailedInfo.BeginUpdate;
  WebBrowserDetailedInfo.LoadFromStrings(Marks, '');
  WebBrowserDetailedInfo.EndUpdate;
end;

procedure TMainForm.SpeedButtonLoadDataClick(Sender: TObject);
begin
  LoadAndDisplayCertificates;
end;

procedure TMainForm.SpeedButtonSearchClick(Sender: TObject);
begin
  WebBrowserDetailedInfo.EvaluateJavaScript('document.location.href="#n' +
    DM.CurrentCount.ToString + '";');
  if DM.Count = 0 then
  begin
    SpeedButtonSearch.Text := 'нет совпадений';
  end
  else
  begin
    SpeedButtonSearch.Text := 'совпадение ' + DM.CurrentCount.ToString + ' из '
      + DM.Count.ToString;
    Inc(DM.CurrentCount);
    if DM.CurrentCount > DM.Count then
      DM.CurrentCount := 1;
  end;
end;

end.
