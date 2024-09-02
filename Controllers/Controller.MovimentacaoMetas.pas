unit Controller.MovimentacaoMetas;

interface

uses
  DAO.MovimentacaoMetas, System.Generics.Collections,
  ReadMovimentacaoMetas;

type
  TExecutarAposConsultaMovimentacao = procedure
      (retorno: TObjectList<TReadMovimentacaoMetas>) of object;

  TControllerMovimentacaoMetas = class
  private
    FDaoMovimentacaoMeta: TDAOMovimentacaoMetas;
    FExecutarAposConsultaMovimentacao: TExecutarAposConsultaMovimentacao;
  public
    constructor Create;
    destructor Destroy;
    procedure ConsultaMovimentacaoMeta(idMeta: Integer);
    property OnExecutarAposConsultaMovimentacao: TExecutarAposConsultaMovimentacao read FExecutarAposConsultaMovimentacao write FExecutarAposConsultaMovimentacao;
end;

implementation

uses
  ThreadingEx, System.Classes, System.Threading, Loading, FMX.Dialogs;

{ TControllerMovimentacaoMetas }

procedure TControllerMovimentacaoMetas.ConsultaMovimentacaoMeta(
  idMeta: Integer);
var
  Retorno: TObjectList<TReadMovimentacaoMetas>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMovimentacaoMeta.ConsultaMovimentacaoMeta(idMeta);
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
              if Assigned(OnExecutarAposConsultaMovimentacao) then
                OnExecutarAposConsultaMovimentacao(retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

constructor TControllerMovimentacaoMetas.Create;
begin
  inherited Create;
  FDaoMovimentacaoMeta := TDAOMovimentacaoMetas.Create;
end;

destructor TControllerMovimentacaoMetas.Destroy;
begin
  FDaoMovimentacaoMeta.Free;
  inherited;
end;

end.
