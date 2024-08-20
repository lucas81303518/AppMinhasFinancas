unit funcoes;

interface

uses
  FMX.ListBox, UF_BaseMenu, FMX.Layouts, FMX.Forms, FMX.Controls,
  System.Permissions, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.Graphics,
  System.Classes, System.SysUtils, System.IOUtils,
  FMX.Objects, FMX.DialogService.Async,
  FMX.Dialogs;

type
  TMenuAcao = (taRelatorio, taHome, taCadastro);

  function BitmapToBase64(const Bitmap: TBitmap): string;
  function Base64ToBitmap(const Base64Str: string): TBitmap;
  function GetSelectedObject(combobox: TCombobox): TObject;
  procedure Ajustar_Scroll(VScroll: TVertScrollBox; Formulario: TForm; foco: TControl);

implementation

uses
  System.Types, System.NetEncoding;

function GetSelectedObject(combobox: TCombobox): TObject;
begin
  if combobox.ItemIndex <> -1 then
    Result := combobox.Items.Objects[combobox.ItemIndex]
  else
    Result := nil;
end;

procedure Ajustar_Scroll(VScroll: TVertScrollBox; Formulario: TForm; foco: TControl);
var
  x: Integer;
begin
  with Formulario do
  begin
    VScroll.Margins.Bottom := 250;
    VScroll.ViewportPosition := PointF(VSCroll.ViewportPosition.x,
                                       foco.Position.Y - 90
                                      );
  end;
end;

function BitmapToBase64(const Bitmap: TBitmap): string;
var
  MemoryStream: TMemoryStream;
  Base64Str: string;
begin
  MemoryStream := TMemoryStream.Create;
  try
    Bitmap.SaveToStream(MemoryStream);
    MemoryStream.Position := 0;
    Base64Str := TNetEncoding.Base64.EncodeBytesToString(MemoryStream.Memory, MemoryStream.Size);
    Result := Base64Str;
  finally
    MemoryStream.Free;
  end;
end;

function Base64ToBitmap(const Base64Str: string): TBitmap;
var
  MemoryStream: TMemoryStream;
  Decoder: TBase64Encoding;
  ByteArray: TBytes;
begin
  Result := nil;
  MemoryStream := TMemoryStream.Create;
  Decoder := TBase64Encoding.Create;
  try
    ByteArray := Decoder.DecodeStringToBytes(Base64Str.Replace(#13, '').Replace(#10, '').Trim);
    MemoryStream.Write(ByteArray[0], Length(ByteArray));
    MemoryStream.Position := 0;
    Result := TBitmap.Create;
    try
      Result.LoadFromStream(MemoryStream);
    except
      FreeAndNil(Result);
      raise;
    end;
  finally
    MemoryStream.Free;
    Decoder.Free;
  end;
end;

end.

