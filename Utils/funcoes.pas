unit funcoes;

interface

uses
<<<<<<< HEAD
  FMX.ListBox, UF_BaseMenu, FMX.Layouts, FMX.Forms, FMX.Controls;

function GetSelectedObject(combobox: TCombobox): TObject;
procedure Ajustar_Scroll(VScroll: TVertScrollBox; Formulario: TForm; foco: TControl);

implementation

uses
  System.Types;

=======
  FMX.ListBox, UF_BaseMenu;

type
  TMenuAcao = (taRelatorio, taHome, taCadastro);

var
  MenuAtivo: TMenuAcao;

function GetSelectedObject(combobox: TCombobox): TObject;

implementation

>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
function GetSelectedObject(combobox: TCombobox): TObject;
begin
  if combobox.ItemIndex <> -1 then
    Result := combobox.Items.Objects[combobox.ItemIndex]
  else
<<<<<<< HEAD
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
=======
    Result := nil; // Retorna nil se nenhum item estiver selecionado
end;

>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

end.
