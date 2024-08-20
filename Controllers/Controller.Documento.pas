unit Controller.Documento;

interface

uses
  Model.Documentos, Generics.Collections, UIDAODocumentos,
  dao.Documento;

type
  TExecutarAposCadastro = procedure of object;
  TExecutarAposConsultaRelatorioDetalhadoTipoContas =
                          procedure (Retorno: TObjectList<TReadTipoContaTotalDocs>) of object;


  TControllerDocumento = class
  private
    FExecutarAposCadastro: TExecutarAposCadastro;
    FExecutarAposConsultaRelatorioDetalhadoTipoContas: TExecutarAposConsultaRelatorioDetalhadoTipoContas;

    FIDAODocumento: IDAODocumento;
  public
    constructor Create();
    function Add(Documento: TDocumento): Boolean;
    function Update(Documento: TDocumento): Boolean;
    procedure ObterValoresPorPeriodo(Tipo: Integer; Status: string; DataIni, DataFim: TDateTime);
    procedure RelatorioDetalhadoTipoContas(Id: Integer; Status: string; DataIni, DataFim: TDateTime);

    property OnExecutarAposConsulta: TExecutarAposConsultaRelatorioDetalhadoTipoContas read FExecutarAposConsultaRelatorioDetalhadoTipoContas write FExecutarAposConsultaRelatorioDetalhadoTipoContas;
    property OnExecutarAposCadastro: TExecutarAposCadastro read FExecutarAposCadastro write FExecutarAposCadastro;
end;

implementation

uses
  ThreadingEx, FMX.Dialogs, Loading, System.Classes, System.Threading,
  System.SysUtils;

{ TControllerDocumento }

function TControllerDocumento.Add(Documento: TDocumento): Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      FIDAODocumento.Add(Documento);
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

constructor TControllerDocumento.Create;
begin
  inherited;
  FIDAODocumento := TDAODocumento.Create;
end;

procedure TControllerDocumento.ObterValoresPorPeriodo(Tipo: Integer;
  Status: string; DataIni,
  DataFim: TDateTime);
var
  Retorno: TObjectList<TReadTipoContaTotalDocs>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FIDAODocumento.ObterValoresPorPeriodo(Tipo, Status, DataIni, DataFim);
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

procedure TControllerDocumento.RelatorioDetalhadoTipoContas(Id: Integer; Status: string;
 DataIni, DataFim: TDateTime);
var
  Retorno: TObjectList<TReadTipoContaTotalDocs>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FIDAODocumento.RelatorioDetalhadoTipoContas(Id, Status, DataIni, DataFim);
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

function TControllerDocumento.Update(Documento: TDocumento): Boolean;
begin
  Result := FIDAODocumento.Update(Documento);
end;

end.
