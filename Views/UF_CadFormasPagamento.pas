unit UF_CadFormasPagamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit,
  Controller.FormasDePagamento, model.FormaDePagamento, Generics.Collections;

type
  TFormaPagamentoIncluida = procedure of object;

type
  TF_CadFormasPagamento = class(TF_BaseCadastro)
    Layout3: TLayout;
    Label4: TLabel;
    edtDescricao: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FControllerFormasPagamento: TControllerFormasPagamento;
    FFormaPagamento: TFormaPagamento;
    FEditando: Boolean;
    FFormaPagamentoIncluida: TFormaPagamentoIncluida;
    procedure MontaTela;
    function ValidarCampos: Boolean; override;
  public
    { Public declarations }
    property OnFormaPagamentoIncluida: TFormaPagamentoIncluida read FFormaPagamentoIncluida write FFormaPagamentoIncluida;
    constructor Create(AOwner: TComponent; FormaPagamento: TFormaPagamento = nil);
  end;

var
  F_CadFormasPagamento: TF_CadFormasPagamento;

implementation

{$R *.fmx}

constructor TF_CadFormasPagamento.Create(AOwner: TComponent;
  FormaPagamento: TFormaPagamento);
begin
  inherited Create(AOwner);
  FControllerFormasPagamento := TControllerFormasPagamento.Create;
  FFormaPagamento := FormaPagamento;
  if FFormaPagamento <> nil then
    MontaTela;
  FEditando := FFormaPagamento <> nil;
end;

procedure TF_CadFormasPagamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FControllerFormasPagamento.Free;
  if Assigned(FFormaPagamento) then
    FFormaPagamento.Free;
  Action := TCloseAction.caFree;
  F_CadFormasPagamento := nil;
end;

procedure TF_CadFormasPagamento.MontaTela;
begin
  edtDescricao.Text := FFormaPagamento.Nome;
end;

procedure TF_CadFormasPagamento.recSalvarClick(Sender: TObject);
begin
  if not ValidarCampos() then
    Exit;

  if FFormaPagamento = nil then
    FFormaPagamento := TFormaPagamento.Create;
  FFormaPagamento.Nome := edtDescricao.Text;
  FFormaPagamento.Valor := 0;

  if FEditando then
    FControllerFormasPagamento.Update(FFormaPagamento)
  else
    FControllerFormasPagamento.Add(FFormaPagamento);

  if Assigned(OnFormaPagamentoIncluida) then
    OnFormaPagamentoIncluida();
  Close;
end;

function TF_CadFormasPagamento.ValidarCampos: Boolean;
begin
  Result := False;
  if edtDescricao.Text = '' then
  begin
    ShowMessage('Digite um nome para a forma de pagamento');
    edtDescricao.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
