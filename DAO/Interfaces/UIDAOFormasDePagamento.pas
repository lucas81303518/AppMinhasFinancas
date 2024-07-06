unit UIDAOFormasDePagamento;

interface

uses
  Generics.Collections, model.FormaDePagamento;

type
  IDAOFormasPagamento = interface
    function Add(AFormaPagamento: TFormaPagamento): Boolean;
    function Update(AFormaPagamento: TFormaPagamento): Boolean;
    function GetAll: TObjectList<TFormaPagamento>;
    function Get(Id: Integer): TFormaPagamento;
  end;
implementation

end.
