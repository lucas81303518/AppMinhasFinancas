unit UIDAOTipoDeContas;

interface

uses
  Model.TipoDeConta, Generics.Collections;

type
  IDAOTipoDeContas = interface
  function Add(aTipoConta: TTipoConta): Boolean;
  function Update(aTipoConta: TTipoConta): Boolean;
  function GetPorTipo(Tipo: Integer): TObjectList<TTipoConta>;
  function GetAll: TObjectList<TTipoConta>;
  function Get(Id: Integer): TTipoConta;
end;

implementation

end.
