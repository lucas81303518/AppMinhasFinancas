unit UF_Cadastros;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, UF_BaseMenu;

type
  TF_Cadastros = class(TF_BaseMenu)
    lblTitulo: TLabel;
    recEntradas: TRectangle;
    Label1: TLabel;
    recSaidas: TRectangle;
    Label2: TLabel;
    recTipoDeContas: TRectangle;
    Label3: TLabel;
    recMetas: TRectangle;
    Label4: TLabel;
    recFormasPagamento: TRectangle;
    Label5: TLabel;
    procedure recEntradasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recTipoDeContasClick(Sender: TObject);
    procedure recFormasPagamentoClick(Sender: TObject);
<<<<<<< HEAD
    procedure recSaidasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  F_Cadastros: TF_Cadastros;

implementation

{$R *.fmx}

<<<<<<< HEAD
uses UF_CadDocumentos, UF_CadTipoDeConta, UF_CadFormasPagamento;
=======
uses UF_CadEntradas, UF_CadTipoDeConta, UF_CadFormasPagamento;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

procedure TF_Cadastros.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := TCloseAction.cafree;
  F_Cadastros := nil;
end;

<<<<<<< HEAD
procedure TF_Cadastros.FormShow(Sender: TObject);
begin
  inherited;
  MenuAtivo := TMenuAtivo.maCadastros;
end;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
procedure TF_Cadastros.recEntradasClick(Sender: TObject);
begin
  inherited;
  try
<<<<<<< HEAD
    if not Assigned(F_CadDocumentos) then
    begin
      F_CadDocumentos := TF_CadDocumentos.Create(Self, tdEntrada, nil);
      F_CadDocumentos.Show;
=======
    if not Assigned(F_CadEntradas) then
    begin
      F_CadEntradas := TF_CadEntradas.Create(Self, nil);
      F_CadEntradas.Show;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    end;
  except on Ex: Exception do
    begin
      Ex.Message := 'Erro: ' + ex.Message;
      raise;
    end;
  end;
end;

procedure TF_Cadastros.recFormasPagamentoClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_CadFormasPagamento) then
  begin
    F_CadFormasPagamento := TF_CadFormasPagamento.Create(Self);
    F_CadFormasPagamento.Show;
  end;
end;

<<<<<<< HEAD
procedure TF_Cadastros.recSaidasClick(Sender: TObject);
begin
  inherited;
  try
    if not Assigned(F_CadDocumentos) then
    begin
      F_CadDocumentos := TF_CadDocumentos.Create(Self, tdSaida, nil);
      F_CadDocumentos.Show;
    end;
  except on Ex: Exception do
    begin
      Ex.Message := 'Erro: ' + ex.Message;
      raise;
    end;
  end;
end;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
procedure TF_Cadastros.recTipoDeContasClick(Sender: TObject);
begin
  inherited;
   if not Assigned(F_CadTipoDeConta) then
  begin
    F_CadTipoDeConta := TF_CadTipoDeConta.Create(Self);
    F_CadTipoDeConta.Show;
  end;
end;


end.
