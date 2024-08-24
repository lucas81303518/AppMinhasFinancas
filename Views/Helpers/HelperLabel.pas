unit HelperLabel;

interface

uses
  System.Generics.Collections,
  FMX.StdCtrls;

type
  TLabelHelper = class helper for TLabel
  private
    class var FRealTexts: TDictionary<TLabel, string>;
    procedure SetMaskedText(const Value: string);
    function GetMaskedText: string;
    procedure SetMasked(const Value: Boolean);
    function GetMasked: Boolean;
  public
    property MaskedText: string read GetMaskedText write SetMaskedText;
    property Masked: Boolean read GetMasked write SetMasked;
    procedure ToggleMask;
    class constructor Create;
    class destructor Destroy;
  end;

implementation

{ TLabelHelper }

class constructor TLabelHelper.Create;
begin
  FRealTexts := TDictionary<TLabel, string>.Create;
end;

class destructor TLabelHelper.Destroy;
begin
  FRealTexts.Free;
end;

function TLabelHelper.GetMaskedText: string;
begin
  if Masked then
    Result := StringOfChar('?', Length(FRealTexts.Items[Self]))
  else
    Result := FRealTexts.Items[Self];
end;

procedure TLabelHelper.SetMaskedText(const Value: string);
begin
  FRealTexts.AddOrSetValue(Self, Value);
  if Masked then
    Self.text := StringOfChar('?', Length(Value))
  else
    Self.text := Value;
end;

procedure TLabelHelper.SetMasked(const Value: Boolean);
begin
  if Value then
    Self.text := StringOfChar('?', Length(FRealTexts.Items[Self]))
  else
    Self.text := FRealTexts.Items[Self];
  Tag := Integer(Value);
end;

function TLabelHelper.GetMasked: Boolean;
begin
  Result := Boolean(Tag);
end;

procedure TLabelHelper.ToggleMask;
begin
  Masked := not Masked;
end;


end.
