unit Controller.Receitas;

interface

uses
  DAO.Receitas;

type
  TExecutarAposConsulta = procedure(Retorno: Currency) of object;

  TControllerReceitas = class
  private
    FDAOReceitas: TDAOReceitas;
    FExecutarAposConsultaReceitaMensal: TExecutarAposConsulta;
  public
    procedure RecuperarReceitaMensal(mes, ano: Integer);
    constructor Create();
    destructor Destroy;
    property OnExecutarAposConsultaReceitaMensal: TExecutarAposConsulta read FExeCutarAposConsultaReceitaMensal write FExeCutarAposConsultaReceitaMensal;
end;

implementation

uses
  ThreadingEx, System.Classes, System.Threading, Loading, FMX.Dialogs;

{ TControllerReceitas }

constructor TControllerReceitas.Create();
begin
  inherited;
  FDAOReceitas := TDAOReceitas.Create;
end;

destructor TControllerReceitas.Destroy;
begin
  FDAOReceitas.Destroy;
  inherited;
end;

procedure TControllerReceitas.RecuperarReceitaMensal(mes, ano: Integer);
var
  Retorno: Currency;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDAOReceitas.RecuperarReceitaMensal(mes, ano);
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
              if Assigned(OnExecutarAposConsultaReceitaMensal) then
                OnExecutarAposConsultaReceitaMensal(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
