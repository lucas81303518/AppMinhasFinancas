unit Controller.Saldo;

interface

uses
  DAO.Saldo;

type
  TExecutarAposConsulta = procedure(Retorno: Currency) of object;

  TControllerSaldo = class
  private
    FDaoSaldoMensal: TDAOSaldo;
    FExecutarAposConsultaSaldoTotal: TExecutarAposConsulta;
  public
    procedure GetSaldoTotal();
    constructor Create;
    destructor Destroy;
    property OnExecutarAposConsultaSaldoTotal:  TExecutarAposConsulta read FExeCutarAposConsultaSaldoTotal write FExeCutarAposConsultaSaldoTotal;
end;

implementation

uses
  ThreadingEx, System.Classes, Loading, FMX.Dialogs, System.Threading;

{ TControllerSaldo }

constructor TControllerSaldo.Create;
begin
  inherited;
  FDaoSaldoMensal := TDAOSaldo.Create;
end;

destructor TControllerSaldo.Destroy;
begin
  FDaoSaldoMensal.Destroy;
  inherited;
end;

procedure TControllerSaldo.GetSaldoTotal;
var
  Retorno: Currency;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoSaldoMensal.GetSaldoTotal();
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
              if Assigned(OnExecutarAposConsultaSaldoTotal) then
                OnExecutarAposConsultaSaldoTotal(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
