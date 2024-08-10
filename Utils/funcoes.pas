unit funcoes;

interface

uses
  FMX.ListBox, UF_BaseMenu, FMX.Layouts, FMX.Forms, FMX.Controls;

function GetSelectedObject(combobox: TCombobox): TObject;
procedure Ajustar_Scroll(VScroll: TVertScrollBox; Formulario: TForm; foco: TControl);

implementation

uses
  System.Types;

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

end.
