unit Controller.Documento;

interface

uses
  Model.Documentos, Generics.Collections, UIDAODocumentos,
  dao.Documento;

type
  TControllerDocumento = class
  private
    FIDAODocumento: IDAODocumento;
  public
    constructor Create();
    function Add(Documento: TDocumento): Boolean;
    function Update(Documento: TDocumento): Boolean;
<<<<<<< HEAD
    function ObterValoresPorPeriodo(Tipo: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
    function RelatorioDetalhadoTipoContas(Id: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

implementation

{ TControllerDocumento }

function TControllerDocumento.Add(Documento: TDocumento): Boolean;
begin
  Result := FIDAODocumento.Add(Documento);
end;

constructor TControllerDocumento.Create;
begin
  inherited;
  FIDAODocumento := TDAODocumento.Create;
end;

<<<<<<< HEAD
function TControllerDocumento.ObterValoresPorPeriodo(Tipo: Integer;
  Status: string; DataIni,
  DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
begin
  Result := FIDAODocumento.ObterValoresPorPeriodo(Tipo, Status, DataIni, DataFim);
end;

function TControllerDocumento.RelatorioDetalhadoTipoContas(Id: Integer;
  Status: string; DataIni,
  DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
begin
  Result := FIDAODocumento.RelatorioDetalhadoTipoContas(Id, Status, DataIni, DataFim);
end;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
function TControllerDocumento.Update(Documento: TDocumento): Boolean;
begin
  Result := FIDAODocumento.Update(Documento);
end;

end.
