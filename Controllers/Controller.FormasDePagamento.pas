unit Controller.FormasDePagamento;

interface

uses
  Generics.Collections, model.FormaDePagamento,
  UIDAOFormasDePagamento, dao.FormasDePagamento;

type
  TControllerFormasPagamento = class
  private
    FIDAOFormasPagamento: TDAOFormasPagamento;
  public
    function Add(AFormaPagamento: TFormaPagamento): Boolean;
    function Update(AFormaPagamento: TFormaPagamento): Boolean;
    function GetAll: TObjectList<TFormaPagamento>;
    function Get(Id: Integer): TFormaPagamento;

    constructor Create();
end;

implementation

{ TControllerFormasPagamento }

function TControllerFormasPagamento.Add(
  AFormaPagamento: TFormaPagamento): Boolean;
begin
  Result := FIDAOFormasPagamento.Add(AFormaPagamento);
end;

constructor TControllerFormasPagamento.Create;
begin
  FIDAOFormasPagamento := TDAOFormasPagamento.Create;
end;

function TControllerFormasPagamento.Get(Id: Integer): TFormaPagamento;
begin
  Result := FIDAOFormasPagamento.Get(Id);
end;

function TControllerFormasPagamento.GetAll: TObjectList<TFormaPagamento>;
begin
  Result := FIDAOFormasPagamento.GetAll;
end;

function TControllerFormasPagamento.Update(
  AFormaPagamento: TFormaPagamento): Boolean;
begin
  Result := FIDAOFormasPagamento.Update(AFormaPagamento);
end;

end.
