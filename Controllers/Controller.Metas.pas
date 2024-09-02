unit Controller.Metas;

interface

uses
  DAO.Metas, CreateMeta, Controller.Usuario,
  System.Generics.Collections, ReadMeta;

type
  TExecutarAposUpdate = procedure(retorno: Boolean) of object;
  TExecutarAposRecuperarMetas = procedure(retorno: TObject) of object;

  TControllerMetas = class
    private
      FExecutarAposInserirMeta: TExecutarAposUpdate;
      FExecutarAposRecuperarMetas: TExecutarAposRecuperarMetas;
      FExecutarAposAlterarSaldoMeta: TExecutarAposUpdate;
      FExecutarAposRecuperarMeta: TExecutarAposRecuperarMetas;
      FDaoMetas: TDaoMetas;
    public
      procedure InserirMeta(Meta: TCreateMeta);
      procedure SomarSaldo(idMeta: Integer; valor: Currency);
      procedure SubtrairSaldo(idMeta: Integer; valor: Currency);
      procedure RecuperarMetas;
      procedure RecuperarMeta(idMeta: Integer);

      property OnExecutarAposInserirMeta: TExecutarAposUpdate read FExecutarAposInserirMeta write FExecutarAposInserirMeta;
      property OnExecutarAposRecuperarMetas: TExecutarAposRecuperarMetas read FExecutarAposRecuperarMetas write FExecutarAposRecuperarMetas;
      property OnExecutarAposRecuperarMeta: TExecutarAposRecuperarMetas read FExecutarAposRecuperarMeta write FExecutarAposRecuperarMeta;
      property OnExecutarAposAlterarSaldoMeta: TExecutarAposUpdate read FExecutarAposAlterarSaldoMeta write FExecutarAposAlterarSaldoMeta;

      constructor Create;
      destructor Destroy;
  end;

implementation

uses
  ThreadingEx, System.Classes, System.Threading, Loading, Fmx.Dialogs;

{ TControllerMetas }

constructor TControllerMetas.Create;
begin
  inherited;
  FDaoMetas := TDaoMetas.Create;
end;

destructor TControllerMetas.Destroy;
begin
  FDaoMetas.Destroy;
  inherited;
end;

procedure TControllerMetas.InserirMeta(Meta: TCreateMeta);
var
  Retorno: Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMetas.InserirMeta(Meta);
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
              if Assigned(OnExecutarAposInserirMeta) then
                OnExecutarAposInserirMeta(retorno);
            end;
          end);
        end
    , NotOnCanceled);

end;

procedure TControllerMetas.RecuperarMeta(idMeta: Integer);
var
  Retorno: TReadMeta;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMetas.RecuperarMeta(idMeta);
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
              if Assigned(OnExecutarAposRecuperarMeta) then
                OnExecutarAposRecuperarMeta(retorno);
            end;
          end);
        end
    , NotOnCanceled);

end;

procedure TControllerMetas.RecuperarMetas;
var
  Retorno: TObjectList<TReadMeta>;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMetas.RecuperarMetas;
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
              if Assigned(OnExecutarAposRecuperarMetas) then
                OnExecutarAposRecuperarMetas(retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

procedure TControllerMetas.SomarSaldo(idMeta: Integer; valor: Currency);
var
  Retorno: Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMetas.SomarSaldo(idMeta, valor);
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
              if Assigned(OnExecutarAposAlterarSaldoMeta) then
                OnExecutarAposAlterarSaldoMeta(retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

procedure TControllerMetas.SubtrairSaldo(idMeta: Integer; valor: Currency);
var
  Retorno: Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDaoMetas.SubtrairSaldo(idMeta, valor);
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
              if Assigned(OnExecutarAposAlterarSaldoMeta) then
                OnExecutarAposAlterarSaldoMeta(retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
