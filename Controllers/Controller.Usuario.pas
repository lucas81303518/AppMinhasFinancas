unit Controller.Usuario;

interface

uses
  ULoginUsuario, DAO.Usuario, UCreateUsuario, UReadUsuario, UUpdateUsuario;

type
  TExecutarAposLogin            = procedure(retorno: string) of object;
  TExecutarAposCadastro         = procedure of object;
  TExecutarAposGenerico         = procedure(Sender: TObject) of object;

  ControllerUsuario = class
  private
    FDAOUsuario: TDAOUsuario;
    FExecutarAposCadastro: TExecutarAposCadastro;
    FExecutarAposLogin: TExecutarAposLogin;
    FExecutarAposRecuperarUsuario: TExecutarAposGenerico;
    FExecutarAposAtualizar: TExecutarAposGenerico;
    FExecutarAposAlterarUsuario: TExecutarAposGenerico;
  public
    function Login(DtoLogin: TLoginUsuario): string;
    function Cadastrar(DtoCreate: TCreateUsuario): Boolean;
    function RecuperarUsuario: TReadUsuariosDto;
    function AtualizaFotoUsuario(base64: string): Boolean;
    function AlterarUsuario(usuario: TUpdateUsuario): Boolean;
    constructor Create;
    destructor Destroy;

    property OnExecutarAposLogin: TExecutarAposLogin read FExecutarAposLogin write FExecutarAposLogin;
    property OnExecutarAposCadastro: TExecutarAposCadastro read FExecutarAposCadastro write FExecutarAposCadastro;
    property OnExecutarAposRecuperarUsuario: TExecutarAposGenerico read FExecutarAposRecuperarUsuario write FExecutarAposRecuperarUsuario;
    property OnExecutarAposAtualizar: TExecutarAposGenerico read FExecutarAposAtualizar write FExecutarAposAtualizar;
    property OnExecutarAposAlterarUsuario: TExecutarAposGenerico read FExecutarAposAlterarUsuario write FExecutarAposAlterarUsuario;
end;

implementation

uses
  System.Threading, System.SysUtils, System.Classes, ThreadingEx, FMX.Dialogs,
  Loading;

{ ControllerUsuario }

function ControllerUsuario.RecuperarUsuario: TReadUsuariosDto;
var
  Retorno: TReadUsuariosDto;
begin
  TTaskEx.Run(
    procedure
    begin
      Retorno := FDAOUsuario.RecuperarUsuario();
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
              if Assigned(OnExecutarAposRecuperarUsuario) then
                OnExecutarAposRecuperarUsuario(Retorno);
            end;
          end);
        end
    , NotOnCanceled);
end;

function ControllerUsuario.AlterarUsuario(usuario: TUpdateUsuario): Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      FDAOUsuario.AlterarUsuario(usuario);
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
              if Assigned(OnExecutarAposAlterarUsuario) then
                OnExecutarAposAlterarUsuario(usuario);
            end;
          end);
        end
    , NotOnCanceled);

end;

function ControllerUsuario.AtualizaFotoUsuario(base64: string): Boolean;
var
  retorno: Boolean;
begin
  TTaskEx.Run(
    procedure
    begin
      retorno := FDAOUsuario.AtualizaFotoUsuario(base64);
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
              if Assigned(OnExecutarAposAtualizar) then
                OnExecutarAposAtualizar(TObject(retorno));
            end;
          end);
        end
    , NotOnCanceled);
end;

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
              if Assigned(OnExecutarAposLogin) then
                OnExecutarAposLogin(Hash);
            end;
          end);
        end
    , NotOnCanceled);
end;

end.
