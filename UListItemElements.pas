unit UListItemElements;

interface
uses
  FMX.Objects,
  FMX.Graphics,
  FMX.ListView.Types,
  FMX.TextLayout,
  system.UITypes,
  system.Types,
  system.Math.Vectors,
  Generics.Collections;

type
  TListItemCircle = class(TListItemDrawable)
  private
    FColor: TAlphaColor;
    FBorderColor: TAlphaColor;
    FLineWidth: Single;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetLineWidth(const Value: Single);
  public

    constructor Create(const AOwner: TListItem); override;
    procedure Render( const Canvas:TCanvas; const DrawItemindex: Integer;
                      const DrawStates: TListItemDrawStates;
                     const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
                      const SubPassNo: Integer=0); override;
    property Color:TAlphaColor read FColor write SetColor;
    property BorderColor:TAlphaColor read FBorderColor write SetBorderColor;
    property LineWidth:Single read FLineWidth write SetLineWidth;
  end;

  TListItemCorner = class(TListItemDrawable)
  private
    FColor: TAlphaColor;
    FSize: integer;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetSize(const Value: integer);
  public
    procedure Render( const Canvas:TCanvas; const DrawItemindex: Integer;
                      const DrawStates: TListItemDrawStates;
                     const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
                      const SubPassNo: Integer=0); override;
    property Color:TAlphaColor read FColor write SetColor;
    property Size: integer read FSize write SetSize;
  end;

  TListItemRect = class(TListItemDrawable)
  private
    FColor: TAlphaColor;
    FBorderColor: TAlphaColor;
    FLineWidth: Single;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetLineWidth(const Value: Single);
  public
    constructor Create(const AOwner: TListItem); override;
    procedure Render( const Canvas:TCanvas; const DrawItemindex: Integer;
                      const DrawStates: TListItemDrawStates;
                     const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
                      const SubPassNo: Integer=0); override;
    property Color:TAlphaColor read FColor write SetColor;
    property BorderColor:TAlphaColor read FBorderColor write SetBorderColor;
    property LineWidth:Single read FLineWidth write SetLineWidth;
  end;

  TListItemRoundedRect = class(TListItemRect)
  private
    FRounded: Single;
    procedure SetRounded(const Value: Single);
  public
    constructor Create(const AOwner: TListItem); override;
    procedure Render(const Canvas:TCanvas; const DrawItemindex: Integer;
                     const DrawStates: TListItemDrawStates;
                     const Resources: TListItemStyleResources;
                     const Params: FMX.ListView.Types.TListItemDrawable.TParams;
                     const SubPassNo: Integer=0); override;
    property Color;
    property BorderColor;
    property LineWidth;
    property Rounded: Single read FRounded write SetRounded;
  end;

  TListItemLine = class(TListItemDrawable)
  private
    FColor: TAlphaColor;
    FLineWidth: Single;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetLineWidth(const Value: Single);
  public
    constructor Create(const AOwner: TListItem); override;
    procedure Render( const Canvas:TCanvas; const DrawItemindex: Integer;
                      const DrawStates: TListItemDrawStates;
                     const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
                      const SubPassNo: Integer=0); override;
    property Color:TAlphaColor read FColor write SetColor;
    property LineWidth:Single read FLineWidth write SetLineWidth;
  end;

implementation

uses FMX.Types;

{ TListItemCircleText }

constructor TListItemCircle.Create(const AOwner: TListItem);
begin
  inherited;
  FLineWidth := 1;
end;

procedure TListItemCircle.Render(const Canvas: TCanvas;
  const DrawItemindex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
  const SubPassNo: Integer);
begin
  if SubPassNo<>0 then
    exit;

  Canvas.Fill.Color := Color;
  Canvas.FillEllipse(LocalRect,1);
  Canvas.Stroke.Color := BorderColor;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Thickness := LineWidth;
  Canvas.DrawEllipse(LocalRect,1);
end;


procedure TListItemCircle.SetBorderColor(const Value: TAlphaColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TListItemCircle.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TListItemCircle.SetLineWidth(const Value: Single);
begin
  FLineWidth := Value;
  Invalidate;
end;

{ TListItemCorner }

procedure TListItemCorner.Render(const Canvas: TCanvas;
  const DrawItemindex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
  const SubPassNo: Integer);
var pts:TPolygon;
begin
  if SubPassNo<>0 then
    exit;
  SetLength(pts,4);
  Canvas.Fill.Color := Color;
  Canvas.Fill.Kind := TBrushKind.Solid;
  pts[0] := LocalRect.BottomRight;
  pts[1] := LocalRect.BottomRight;
  pts[2] := LocalRect.BottomRight;
  pts[3] := pts[0];
  pts[1].Offset(0,-size);
  pts[2].Offset(-size,0);
  Canvas.FillPolygon(pts,1);
//  Canvas.FillRect(LocalRect,0,0,[], 1);
end;

procedure TListItemCorner.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TListItemCorner.SetSize(const Value: integer);
begin
  FSize := Value;
  Invalidate;
end;

{ TListItemRect }

constructor TListItemRect.Create(const AOwner: TListItem);
begin
  inherited;
  FLineWidth := 1;
end;

procedure TListItemRect.Render(const Canvas: TCanvas;
  const DrawItemindex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
  const SubPassNo: Integer);
begin
  if SubPassNo<>0 then
    exit;

  Canvas.Fill.Color := Color;
  Canvas.FillRect(LocalRect,0,0,[],1);
  Canvas.Stroke.Color := BorderColor;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Thickness := LineWidth;
  Canvas.DrawRect(LocalRect,0,0,[],1);
end;

procedure TListItemRect.SetBorderColor(const Value: TAlphaColor);
begin
  FBorderColor:=Value;
  Invalidate;
end;

procedure TListItemRect.SetColor(const Value: TAlphaColor);
begin
  FColor:=Value;
  Invalidate;
end;

procedure TListItemRect.SetLineWidth(const Value: Single);
begin
  FLineWidth := Value;
  Invalidate;
end;

{ TListItemRoundedRect }

constructor TListItemRoundedRect.Create(const AOwner: TListItem);
begin
  inherited;
  FRounded := 0;
end;

procedure TListItemRoundedRect.Render(const Canvas: TCanvas;
  const DrawItemindex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources; const Params: FMX.ListView.Types.TListItemDrawable.TParams;
  const SubPassNo: Integer);
begin
  if SubPassNo<>0 then
    exit;
  Canvas.Fill.Color := Color;
  Canvas.FillRect(LocalRect, FRounded, FRounded,[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1, TCornerType.Round);
  Canvas.Stroke.Color := BorderColor;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Thickness := LineWidth;
  Canvas.DrawRect(LocalRect, FRounded, FRounded,[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight], 1, TCornerType.Round);
end;

procedure TListItemRoundedRect.SetRounded(const Value: Single);
begin
  FRounded:=Value;
  Invalidate;
end;

{ TListItemList }

constructor TListItemLine.Create(const AOwner: TListItem);
begin
  inherited;
  FLineWidth := 1;
end;

procedure TListItemLine.Render(const Canvas: TCanvas;
  const DrawItemindex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: FMX.ListView.Types.TListItemDrawable.TParams;
  const SubPassNo: Integer);
var
  p1,p2:TPointF;
begin
  if SubPassNo<>0 then
    exit;

  Canvas.Stroke.Color := Color;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  p1:=LocalRect.TopLeft;
  p2:=LocalRect.BottomRight;
  Canvas.Stroke.Thickness := LineWidth;
  Canvas.DrawLine(p1, p2, 1);
end;

procedure TListItemLine.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TListItemLine.SetLineWidth(const Value: Single);
begin
  FLineWidth := Value;
  Invalidate;
end;

end.

