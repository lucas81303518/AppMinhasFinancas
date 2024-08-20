unit Controller.FormasDePagamento;

interface

uses
  Generics.Collections, model.FormaDePagamento,
  UIDAOFormasDePagamento, dao.FormasDePagamento;

type
  TExecutarAposCadastro = procedure of object;
  TExecutarAposConsulta = procedure(Dados: TObjectList<TFormaPagamento>) of object;

  TControllerFormasPagamento = class
  private
    FIDAOFormasPagamento: TDAOFormasPagamento;
    FExecutarAposCadastro: TExecutarAposCadastro;
    FExecutarAposConsulta: TExecutarAposConsulta;
  public
    function Add(AFormaPagamento: TFormaPagamento): Boolean;
    function Update(AFormaPagamento: TFormaPagamento): Boolean;
    function GetAll: TObjectList<TFormaPagamento>;
    function Get(Id: Integer): TFormaPagamento;

    property OnExecutarAposCadastro: TExecutarAposCadastro read FExecutarAposCadastro write FExecutarAposCadastro;
    property OnExecutarAposConsulta: TExecutarAposConsulta read FExecutarAposConsulta write FExecutarAposConsulta;
    constructor Create();
end;

implementation

uses
  ThreadingEx, System.Classes, System.Threading, Loading, FMX.Dialogs;

{ TControllerFormasPagamento }

function TControllerFormasPagamento.Add(
  AFormaPagamento: TFormaPagamento): Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      FIDAOFormasPagamento.Add(AFormaPagamento);
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
                OnExecutarAposCadastro;
            end;
          end);
        end
    , NotOnCanceled);
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
var
  Retorno: TObjectList<TFormaPagamento>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FIDAOFormasPagamento.GetAll;;
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

function TControllerFormasPagamento.Update(
  AFormaPagamento: TFormaPagamento): Boolean;
begin
  Result := FIDAOFormasPagamento.Update(AFormaPagamento);
end;

end.
