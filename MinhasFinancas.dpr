program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UF_BaseMenu in 'src\Views\Form Base\UF_BaseMenu.pas' {F_BaseMenu},
  UF_Principal in 'src\Views\UF_Principal.pas' {F_Principal},
  UF_BaseCadastro in 'src\Views\Form Base\UF_BaseCadastro.pas' {F_BaseCadastro},
  UF_CadDocumentos in 'src\Views\UF_CadDocumentos.pas' {F_CadDocumentos},
  UF_Cadastros in 'src\Views\UF_Cadastros.pas' {F_Cadastros},
  UF_CadTipoDeConta in 'src\Views\UF_CadTipoDeConta.pas' {F_CadTipoDeConta},
  Dmodulo in 'src\Data\Dmodulo.pas' {DmPrincipal: TDataModule},
  Model.TipoDeConta in 'src\Models\Model.TipoDeConta.pas',
  UIDAOTipoDeContas in 'src\DAO\Interfaces\UIDAOTipoDeContas.pas',
  DAO.TipoDeConta in 'src\DAO\DAO.TipoDeConta.pas',
  Controller.TipoDeContas in 'src\Controllers\Controller.TipoDeContas.pas',
  UF_CadFormasPagamento in 'src\Views\UF_CadFormasPagamento.pas' {F_CadFormasPagamento},
  Model.FormaDePagamento in 'src\Models\Model.FormaDePagamento.pas',
  UIDAOFormasDePagamento in 'src\DAO\Interfaces\UIDAOFormasDePagamento.pas',
  DAO.FormasDePagamento in 'src\DAO\DAO.FormasDePagamento.pas',
  Controller.FormasDePagamento in 'src\Controllers\Controller.FormasDePagamento.pas',
  Model.Usuario in 'src\Models\Model.Usuario.pas',
  Model.Documentos in 'src\Models\Model.Documentos.pas',
  UIDAODocumentos in 'src\DAO\Interfaces\UIDAODocumentos.pas',
  DAO.Documento in 'src\DAO\DAO.Documento.pas',
  Controller.Documento in 'src\Controllers\Controller.Documento.pas',
  funcoes in 'src\Utils\funcoes.pas',
  UF_ConfiguracaoAPI in 'src\Views\UF_ConfiguracaoAPI.pas' {F_ConfiguracaoAPI},
  UF_RelatorioTicoContas in 'src\Views\UF_RelatorioTicoContas.pas' {F_RelatorioTipoContas},
  Frame.Legenda in 'src\Frames\Frame.Legenda.pas' {FrameLegenda: TFrame},
  UF_RelatorioTipoContasDetalhado in 'src\Views\UF_RelatorioTipoContasDetalhado.pas' {F_RelatorioTipoDeContasDetalhado},
  Frame.TipoContaDetalhado in 'src\Frames\Frame.TipoContaDetalhado.pas' {FrameTipoContaDetalhado: TFrame},
  UF_Login in 'src\Views\UF_Login.pas' {F_Login},
  UCreateUsuario in 'src\Data\DTO\UCreateUsuario.pas',
  ULoginUsuario in 'src\Data\DTO\ULoginUsuario.pas',
  DAO.Usuario in 'src\DAO\DAO.Usuario.pas',
  Controller.Usuario in 'src\Controllers\Controller.Usuario.pas',
  Loading in 'src\Utils\Loading.pas',
  UnitSplash in 'src\Views\UnitSplash.pas' {FrmSplash},
  ThreadingEx in 'src\Utils\ThreadingEx.pas',
  uCombobox in 'src\Utils\uCombobox.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.Run;
end.
