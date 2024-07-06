unit UIDAODocumentos;

interface

uses
  Generics.Collections, Model.Documentos;

type
  IDAODocumento = interface
  function Add(Documento: TDocumento): Boolean;
  function Update(Documento: TDocumento): Boolean;
end;

implementation

end.
