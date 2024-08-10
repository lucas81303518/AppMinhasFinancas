unit UnitSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TFrmSplash = class(TForm)
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure ValidaConexaoAPI;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;

implementation

{$R *.fmx}

uses UF_Login, Loading, Dmodulo, UF_ConfiguracaoAPI, System.Threading;

procedure TFrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmSplash := nil;
end;

procedure TFrmSplash.FormCreate(Sender: TObject);
begin
    Image1.Align := TAlignLayout.Center;
end;

procedure TFrmSplash.FormShow(Sender: TObject);
begin
  image1.Opacity := 0;

  Image1.Align := TAlignLayout.None;
  Image1.AnimateFloat('Opacity', 1, 0.4);
  Image1.AnimateFloatDelay('Position.Y', 0, 0.3, 2.5, TAnimationType.&In, TInterpolationType.Back);
  ValidaConexaoAPI;
end;

procedure TFrmSplash.ValidaConexaoAPI;
begin
  TLoading.Show('Testando conex�o com o Servidor...', FrmSplash);
  TTask.Run(
    procedure
    begin
      DmPrincipal.Configuracoes.ConfigREST.ValidaConexaoAPI(
        procedure(Sucesso: Boolean)
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              TLoading.Hide;
              if not Sucesso then
              begin
                ShowMessage('Configure a conex�o com a API');
                F_ConfiguracaoAPI := TF_ConfiguracaoAPI.Create(Self);
                F_ConfiguracaoAPI.Show;
              end
              else
              begin
                if not Assigned(F_Login) then
                    Application.CreateForm(TF_Login, F_Login);
                Application.MainForm := F_Login;
                F_Login.Show;
                FrmSplash.Close;
              end;
            end
          );
        end
      );
    end
  );
end;

end.
