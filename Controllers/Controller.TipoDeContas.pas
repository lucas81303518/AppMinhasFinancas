unit Controller.TipoDeContas;

interface

uses
  Model.TipoDeConta, Generics.Collections, UIDAOTipoDeContas, dao.TipoDeConta;

type
  TExecutarAposCadastro = procedure of object;
  TExecutarAposConsulta = procedure(Dados: TObjectList<TTipoConta>) of object;

  TControllerTipoDeContas = class
  private
    FIDAOTipoDeContas: TDAOTipoDeConta;
    FExecutarAposCadastro: TExecutarAposCadastro;
    FExecutarAposConsulta: TExecutarAposConsulta;
  public
    function Add(aTipoConta: TTipoConta): Boolean;
    function Update(aTipoConta: TTipoConta): Boolean;
    function GetPorTipo(Tipo: Integer): TObjectList<TTipoConta>;
    function GetAll: TObjectList<TTipoConta>;
    function Get(Id: Integer): TTipoConta;

    property OnExecutarAposCadastro: TExecutarAposCadastro read FExecutarAposCadastro write FExecutarAposCadastro;
    property OnExecutarAposConsulta: TExecutarAposConsulta read FExecutarAposConsulta write FExecutarAposConsulta;
    constructor Create();
end;

implementation

uses
  System.SysUtils, ThreadingEx, System.Classes, Loading, FMX.Dialogs,
  System.Threading;

{ TControllerTipoDeContas }

function TControllerTipoDeContas.Add(aTipoConta: TTipoConta): Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      FIDAOTipoDeContas.Add(aTipoConta);
    end)
    .ContinueWith(
      procedure(const LTaskEx: ITaskEx)
        begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            if LTaskEx.Status = TTaskStatus.Exception then
            begin
              TLoading.Hide;
              showmessage(LTaskEx.ExceptObj.ToString);
            end
            else if LTaskEx.Status = TTaskStatus.Completed then
            begin
              if Assigned(OnExecutarAposCadastro) then
                OnExecutarAposCadastro();
            end;
          end);
        end
    , NotOnCanceled);
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
var
  Retorno: TObjectList<TTipoConta>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FIDAOTipoDeContas.GetAll;
    end)
    .ContinueWith(
      procedure(const LTaskEx: ITaskEx)
        begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            if LTaskEx.Status = TTaskStatus.Exception then
            begin
              TLoading.Hide;
              showmessage(LTaskEx.ExceptObj.ToString);
            end
            else if LTaskEx.Status = TTaskStatus.Completed then
            begin
              if Assigned(OnExecutarAposConsulta) then
                OnExecutarAposConsulta(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

function TControllerTipoDeContas.GetPorTipo(
  Tipo: Integer): TObjectList<TTipoConta>;
var
  Retorno: TObjectList<TTipoConta>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FIDAOTipoDeContas.GetPorTipo(Tipo);
    end)
    .ContinueWith(
      procedure(const LTaskEx: ITaskEx)
        begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            if LTaskEx.Status = TTaskStatus.Exception then
            begin
              TLoading.Hide;
              showmessage(LTaskEx.ExceptObj.ToString);
            end
            else if LTaskEx.Status = TTaskStatus.Completed then
            begin
              if Assigned(OnExecutarAposConsulta) then
                OnExecutarAposConsulta(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

function TControllerTipoDeContas.Update(aTipoConta: TTipoConta): Boolean;
begin
  Result := FIDAOTipoDeContas.Update(aTipoConta);
end;

end.
