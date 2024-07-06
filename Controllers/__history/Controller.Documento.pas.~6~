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

function TControllerDocumento.Update(Documento: TDocumento): Boolean;
begin
  Result := FIDAODocumento.Update(Documento);
end;

end.
