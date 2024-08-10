unit UIDAODocumentos;

interface

uses
  Generics.Collections, Model.Documentos;

type
  IDAODocumento = interface
  function Add(Documento: TDocumento): Boolean;
  function Update(Documento: TDocumento): Boolean;
  function ObterValoresPorPeriodo(Tipo: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
  function RelatorioDetalhadoTipoContas(Id: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
end;

implementation

end.
