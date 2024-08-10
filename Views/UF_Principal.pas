unit UF_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, UF_BaseMenu,
  funcoes;

type
  TF_Principal = class(TF_BaseMenu)
<<<<<<< HEAD
    S: TRectangle;
=======
    recSaldoAtual: TRectangle;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    Label1: TLabel;
    Rectangle1: TRectangle;
    imageOlhoSaldoAtual: TImage;
    lblSaldoAtual: TLabel;
    RecGastoMes: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    ImageOlhoGastoMes: TImage;
    lblGastoMes: TLabel;
    recMetas: TRectangle;
    Label3: TLabel;
    lbMetas: TListBox;
<<<<<<< HEAD
=======
    procedure FormCreate(Sender: TObject);
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses
<<<<<<< HEAD
  Dmodulo;
=======
  Dmodulo, UF_ConfiguracaoAPI;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

{$R *.fmx}

{ TF_Principal }

procedure TF_Principal.FormActivate(Sender: TObject);
begin
  inherited;
<<<<<<< HEAD
  MenuAtivo := TMenuAtivo.maPrincipal;
=======
  if not dmprincipal.Configuracoes.ConfigREST.ValidaConexaoAPI() then
  begin
    ShowMessage('Configure a conexão com a API');
    F_ConfiguracaoAPI := TF_ConfiguracaoAPI.Create(Self);
    F_ConfiguracaoAPI.Show;
  end;
end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
  MenuAtivo := taHome;
  inherited;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

end.
