unit CertificateUnit;

interface

type
  TCertificate = class
  private
    { Private declarations }

  public
    { Public declarations }
    CertNumber, CertDateFrom, CertDateTill, CertOwner,
      CertManufacturerOfGoods, CertCodes, CertDescriptionOfGoods,
      SertMarksOfGoods: String;
    constructor Create(const ACertNumber, ACertDateFrom, ACertDateTill,
      ACertOwner, ACertManufacturerOfGoods, ACertCodes, ACertDescriptionOfGoods,
      ASertMarksOfGoods: String);
    destructor Destroy(); override;
  end;

implementation

{ TCertificate }

constructor TCertificate.Create(const ACertNumber, ACertDateFrom, ACertDateTill,
  ACertOwner, ACertManufacturerOfGoods, ACertCodes, ACertDescriptionOfGoods,
  ASertMarksOfGoods: String);
begin
  CertNumber := ACertNumber;
  CertDateFrom := ACertDateFrom;
  CertDateTill := ACertDateTill;
  CertOwner := ACertOwner;
  CertManufacturerOfGoods := ACertManufacturerOfGoods;
  CertCodes := ACertCodes;
  CertDescriptionOfGoods := ACertDescriptionOfGoods;
  SertMarksOfGoods := ASertMarksOfGoods;
end;

destructor TCertificate.Destroy;
begin
  inherited;
end;

end.
