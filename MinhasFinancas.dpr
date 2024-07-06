program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UF_BaseMenu in 'Views\Form Base\UF_BaseMenu.pas' {F_BaseMenu},
  UF_Principal in 'Views\UF_Principal.pas' {F_Principal},
  UF_BaseCadastro in 'Views\Form Base\UF_BaseCadastro.pas' {F_BaseCadastro},
  UF_CadEntradas in 'Views\UF_CadEntradas.pas' {F_CadEntradas},
  UF_Cadastros in 'Views\UF_Cadastros.pas' {F_Cadastros},
  UF_CadTipoDeConta in 'Views\UF_CadTipoDeConta.pas' {F_CadTipoDeConta},
  Dmodulo in 'Data\Dmodulo.pas' {DmPrincipal: TDataModule},
  Model.TipoDeConta in 'Models\Model.TipoDeConta.pas',
  UIDAOTipoDeContas in 'DAO\Interfaces\UIDAOTipoDeContas.pas',
  DAO.TipoDeConta in 'DAO\DAO.TipoDeConta.pas',
  Controller.TipoDeContas in 'Controllers\Controller.TipoDeContas.pas',
  UF_CadFormasPagamento in 'Views\UF_CadFormasPagamento.pas' {F_CadFormasPagamento},
  Model.FormaDePagamento in 'Models\Model.FormaDePagamento.pas',
  UIDAOFormasDePagamento in 'DAO\Interfaces\UIDAOFormasDePagamento.pas',
  DAO.FormasDePagamento in 'DAO\DAO.FormasDePagamento.pas',
  Controller.FormasDePagamento in 'Controllers\Controller.FormasDePagamento.pas',
  Model.Usuario in 'Models\Model.Usuario.pas',
  Model.Documentos in 'Models\Model.Documentos.pas',
  UIDAODocumentos in 'DAO\Interfaces\UIDAODocumentos.pas',
  DAO.Documento in 'DAO\DAO.Documento.pas',
  Controller.Documento in 'Controllers\Controller.Documento.pas',
  funcoes in 'Utils\funcoes.pas',
  UF_ConfiguracaoAPI in 'Views\UF_ConfiguracaoAPI.pas' {F_ConfiguracaoAPI};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.CreateForm(TF_Principal, F_Principal);
  Application.Run;
end.
