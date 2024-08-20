unit Controller.TipoDeContas;

interface

uses
  Model.TipoDeConta, Generics.Collections, UIDAOTipoDeContas, dao.TipoDeConta;

type
  TControllerTipoDeContas = class
  private
    FIDAOTipoDeContas: TDAOTipoDeConta;
  public
    function Add(aTipoConta: TTipoConta): Boolean;
    function Update(aTipoConta: TTipoConta): Boolean;
    function GetPorTipo(Tipo: Integer): TObjectList<TTipoConta>;
    function GetAll: TObjectList<TTipoConta>;
    function Get(Id: Integer): TTipoConta;

    constructor Create();
end;

implementation

uses
  System.SysUtils;

{ TControllerTipoDeContas }

function TControllerTipoDeContas.Add(aTipoConta: TTipoConta): Boolean;
begin
  Result := FIDAOTipoDeContas.Add(aTipoConta);
end;

constructor TControllerTipoDeContas.Create;
begin
  FIDAOTipoDeContas := TDAOTipoDeConta.Create;
end;

function TControllerTipoDeContas.Get(Id: Integer): TTipoConta;
begin
  Result := FIDAOTipoDeContas.Get(Id);
end;

function TControllerTipoDeContas.GetAll: TObjectList<TTipoConta>;
begin
  Result := FIDAOTipoDeContas.GetAll;
end;

function TControllerTipoDeContas.GetPorTipo(
  Tipo: Integer): TObjectList<TTipoConta>;
begin
  try
    Result := FIDAOTipoDeContas.GetPorTipo(Tipo);
  except on ex: Exception do
    begin
      ex.Message := 'Erro GetPorTipo: ' + ex.Message;
      raise;
    end;
  end;
end;

function TControllerTipoDeContas.Update(aTipoConta: TTipoConta): Boolean;
begin
  Result := FIDAOTipoDeContas.Update(aTipoConta);
end;

end.
