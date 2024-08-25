unit UF_ConfirmacaoEmail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

type
  TExecutarAposConfirmacao = procedure(CodigoConfirmado: Boolean) of object;

  TF_ConfirmacaoEmail = class(TF_BaseCadastro)
    Layout2: TLayout;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblTempoRestante: TLabel;
    lblEmailEnvio: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
    procedure imageVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FinalizarThread: Boolean;
    FThread: TThread;
    FExecutarAposConfirmacao: TExecutarAposConfirmacao;

    procedure IniciarTimer;
  public
    { Public declarations }
    Email: string;
    property OnExecutarAposConfirmacaco: TExecutarAposConfirmacao read FExecutarAposConfirmacao write FExecutarAposConfirmacao;
  end;

var
  F_ConfirmacaoEmail: TF_ConfirmacaoEmail;

implementation

uses
  ThreadingEx, Dmodulo;

{$R *.fmx}

{ TF_ConfirmacaoEmail }
procedure TF_ConfirmacaoEmail.FormActivate(Sender: TObject);
begin
//...
end;

procedure TF_ConfirmacaoEmail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FinalizarThread := True;
  if Assigned(FThread) then
    TThread.Synchronize(nil,
      procedure
      begin
        FThread.Free;
      end);
  action := TCloseAction.caFree;
  F_ConfirmacaoEmail := nil;
end;

procedure TF_ConfirmacaoEmail.FormResize(Sender: TObject);
begin
  //...
end;

procedure TF_ConfirmacaoEmail.FormShow(Sender: TObject);
begin
  lblEmailEnvio.Text := Email;
  IniciarTimer;
end;

procedure TF_ConfirmacaoEmail.imageVoltarClick(Sender: TObject);
begin
  if Assigned(OnExecutarAposConfirmacaco) then
    OnExecutarAposConfirmacaco(False);
  Close;
end;

procedure TF_ConfirmacaoEmail.IniciarTimer;
begin
  FinalizarThread := False;
  FThread := TThread.CreateAnonymousThread(
    procedure
    var
      TotalTime: Integer;
      Minutes, Seconds: Integer;
    begin
      TotalTime := 3 * 60;
      while (TotalTime > 0) and (not FinalizarThread) do
      begin
        Minutes := TotalTime div 60;
        Seconds := TotalTime mod 60;

        TThread.Queue(nil,
          procedure
          begin
            lblTempoRestante.text := Format('Tempo restante: %d:%2.2d', [Minutes, Seconds]);
          end
        );

        Sleep(1000);

        Dec(TotalTime);
      end;

      TThread.Queue(nil,
        procedure
        begin
          if not FinalizarThread then
          begin
            ShowMessage('Tempo esgotado!');
            imageVoltarClick(imageVoltar);
          end;
        end
      );
    end);

  FThread.FreeOnTerminate := false;
  FThread.Start;
end;

procedure TF_ConfirmacaoEmail.recSalvarClick(Sender: TObject);
begin
  if not Length(edtCodigo.Text) = 6 then
  begin
    ShowMessage('Código deve ter 6 dígitos!');
    Exit;
  end;

  if DmPrincipal.FEmail.ValidarCodigo(edtCodigo.Text) then
  begin
    if Assigned(OnExecutarAposConfirmacaco) then
      OnExecutarAposConfirmacaco(True);
    Close;
  end
  else
  begin
    ShowMessage('Código inválido!');
  end;
end;

end.
