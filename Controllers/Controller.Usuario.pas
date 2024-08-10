unit Controller.Usuario;

interface

uses
  ULoginUsuario, DAO.Usuario, UCreateUsuario;

type
  TExecutarAposLogin    = procedure(retorno: string) of object;
  TExecutarAposCadastro = procedure of object;

  ControllerUsuario = class
  private
    FDAOUsuario: TDAOUsuario;
    FExecutarAposCadastro: TExecutarAposCadastro;
    FExecutarAposLogin: TExecutarAposLogin;
  public
    function Login(DtoLogin: TLoginUsuario): string;
    function Cadastrar(DtoCreate: TCreateUsuario): Boolean;
    constructor Create;
    destructor Destroy;

    property OnExecutarAposLogin: TExecutarAposLogin read FExecutarAposLogin write FExecutarAposLogin;
    property OnExecutarAposCadastro: TExecutarAposCadastro read FExecutarAposCadastro write FExecutarAposCadastro;
end;

implementation

uses
  System.Threading, System.SysUtils, System.Classes, ThreadingEx, FMX.Dialogs,
  Loading;

{ ControllerUsuario }

function ControllerUsuario.Cadastrar(DtoCreate: TCreateUsuario): Boolean;
begin
   TTaskEx.Run(
    procedure
    begin
      FDAOUsuario.Cadastrar(DtoCreate);
    end)
    .ContinueWith(
      procedure(const LTaskEx: ITaskEx)
        begin
          TThread.Queue(TThread.CurrentThread,
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

constructor ControllerUsuario.Create;
begin
  inherited;
  FDAOUsuario := TDAOUsuario.Create;
end;

destructor ControllerUsuario.Destroy;
begin
  FDAOUsuario.Destroy;
  inherited;
end;

function ControllerUsuario.Login(DtoLogin: TLoginUsuario): string;
var
  Hash: string;
begin
  TTaskEx.Run(
    procedure
    begin
      Hash := FDAOUsuario.Login(DtoLogin);
    end)
    .ContinueWith(
      procedure(const LTaskEx: ITaskEx)
        begin
          TThread.Queue(TThread.CurrentThread,
          procedure
          begin
            if LTaskEx.Status = TTaskStatus.Exception then
            begin
              TLoading.Hide;
              showmessage(LTaskEx.ExceptObj.ToString);
            end
            else if LTaskEx.Status = TTaskStatus.Completed then
            begin
              if Assigned(OnExecutarAposLogin) then
                OnExecutarAposLogin(Hash);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
