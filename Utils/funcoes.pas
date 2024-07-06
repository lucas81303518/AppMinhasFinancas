unit funcoes;

interface

uses
  FMX.ListBox, UF_BaseMenu;

type
  TMenuAcao = (taRelatorio, taHome, taCadastro);

var
  MenuAtivo: TMenuAcao;

function GetSelectedObject(combobox: TCombobox): TObject;

implementation

function GetSelectedObject(combobox: TCombobox): TObject;
begin
  if combobox.ItemIndex <> -1 then
    Result := combobox.Items.Objects[combobox.ItemIndex]
  else
    Result := nil; // Retorna nil se nenhum item estiver selecionado
end;


end.
