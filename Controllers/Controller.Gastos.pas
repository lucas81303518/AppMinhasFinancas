unit Controller.Gastos;

interface

uses
  DAO.Gastos;

type
  TExecutarAposConsulta = procedure(Retorno: Currency) of object;

  TControllerGastos = class
  private
    FDAOGastos: TDAOGastos;
    FExecutarAposConsultaGastoMensal: TExecutarAposConsulta;
  public
    procedure RecuperarGastoMensal(mes, ano: Integer);
    constructor Create();
    destructor Destroy;
    property OnExecutarAposConsultaGastoMensal:  TExecutarAposConsulta read FExeCutarAposConsultaGastoMensal write FExeCutarAposConsultaGastoMensal;
end;

implementation

uses
  ThreadingEx, System.Classes, System.Threading, Loading, FMX.Dialogs;

{ TControllerGastos }

constructor TControllerGastos.Create();
begin
  inherited;
  FDAOGastos := TDAOGastos.Create;
end;

destructor TControllerGastos.Destroy;
begin
  FDAOGastos.Destroy;
  inherited;
end;

procedure TControllerGastos.RecuperarGastoMensal(mes, ano: Integer);
var
  Retorno: Currency;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDAOGastos.RecuperarGastoMensal(mes, ano);
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
              if Assigned(OnExecutarAposConsultaGastoMensal) then
                OnExecutarAposConsultaGastoMensal(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
