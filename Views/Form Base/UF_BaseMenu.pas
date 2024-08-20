unit UF_BaseMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Classes, System.Generics.Collections;

type
  TMenuAtivo = (maGrafico, maPrincipal, maCadastros);

  TF_BaseMenu = class(TForm)
    recGeral: TRectangle;
    recMenu: TRectangle;
    rectMenuLateral: TRectangle;
    ImageMoney: TImage;
    recMenuLateralPerfil: TRectangle;
    Label6: TLabel;
    recMenuLateralSair: TRectangle;
    Label8: TLabel;
    recMenuLateralGrafico: TRectangle;
    Label7: TLabel;
    recMenuLateralCadastrar: TRectangle;
    Label9: TLabel;
    recMenuLateralInicio: TRectangle;
    Label10: TLabel;
    recMenuFooter: TRectangle;
    recHome: TRectangle;
    recGrafico: TRectangle;
    recCadastros: TRectangle;
    imageMenu: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    image6: TImage;
    imageHome: TImage;
    imageCadastro: TImage;
    imagemGrafico: TImage;
    imageUser: TCircle;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imageMenuClick(Sender: TObject);
    procedure ImageMoneyClick(Sender: TObject);
    procedure recGeralClick(Sender: TObject);
    procedure recMenuLateralInicioClick(Sender: TObject);
    procedure recMenuLateralSairClick(Sender: TObject);
    procedure recMenuLateralCadastrarClick(Sender: TObject);
    procedure imagemGraficoClick(Sender: TObject);
    procedure ImageUserClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FMenuBottomAtivo: TMenuAtivo;

    procedure SetMenuAtivo(const Value: TMenuAtivo);
    procedure InicializaMenuBottom;
    procedure SetaCorMenuAtivo(const Value: TMenuAtivo);
    procedure AjustaVisibilidadeMenuLateral(Visivel: Boolean);
    procedure GoToHome(FormAtivo: TForm = nil);
  protected
    property MenuAtivo: TMenuAtivo read FMenuBottomAtivo write SetMenuAtivo;
  public
    { Public declarations }
  end;

var
  F_BaseMenu: TF_BaseMenu;

const COR_ESCURA_MENU = $FF36512A;
const COR_CLARA_MENU  = $FF4F8835;

implementation

uses
  UF_Cadastros, funcoes, UF_RelatorioTicoContas, UF_Login, FMX.Ani,
  UF_InformacoesUsuario, Dmodulo;

{$R *.fmx}

procedure TF_BaseMenu.AjustaVisibilidadeMenuLateral(Visivel: Boolean);
  const marginRightOriginal = 100;
  const widthOriginal = 169;
begin
  if Visivel then
  begin
    rectMenuLateral.Height     := Trunc(recGeral.Height - recMenuFooter.Height);
    rectMenuLateral.Width      := Trunc(recGeral.Width / 2);
    rectMenuLateral.Position.X := 0;
    rectMenuLateral.Position.Y := 0;
    rectMenuLateral.BringToFront;
    rectMenuLateral.Repaint;
    rectMenuLateral.Visible := True;

    ImageMoney.Margins.Right := (marginRightOriginal * rectMenuLateral.Width) / widthOriginal;
  end
  else
  begin
    rectMenuLateral.Visible := False;
  end;
end;

procedure TF_BaseMenu.FormActivate(Sender: TObject);
begin
  if(DmPrincipal.Usuario.FotoBase64 <> '')then
  begin
    ImageUser.Fill.Bitmap.Bitmap.Assign(Base64ToBitmap(DmPrincipal.Usuario.FotoBase64));
  end;
end;

procedure TF_BaseMenu.FormCreate(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);

end;

procedure TF_BaseMenu.FormResize(Sender: TObject);
begin
  inherited;
  if rectMenuLateral.Visible then
  begin
    rectMenuLateral.Height     := Trunc(recGeral.Height - recMenuFooter.Height);
    rectMenuLateral.Width      := Trunc(recGeral.Width / 2);
    rectMenuLateral.Position.X := 0;
    rectMenuLateral.Position.Y := 0;
    rectMenuLateral.Repaint;
  end;
end;

procedure TF_BaseMenu.imageMenuClick(Sender: TObject);
begin
  AjustaVisibilidadeMenuLateral(True);
end;

procedure TF_BaseMenu.imagemGraficoClick(Sender: TObject);
begin
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_RelatorioTipoContas) then
  begin
    F_RelatorioTipoContas := TF_RelatorioTipoContas.Create(nil);
  end;
  F_RelatorioTipoContas.Show;

  GoToHome(F_RelatorioTipoContas);
end;

procedure TF_BaseMenu.ImageMoneyClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

procedure TF_BaseMenu.ImageUserClick(Sender: TObject);
begin
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_InformacoesUsuario) then
  begin
    F_InformacoesUsuario := TF_InformacoesUsuario.create(nil);
  end;
  F_InformacoesUsuario.show;

  GoToHome(F_InformacoesUsuario);
end;

procedure TF_BaseMenu.InicializaMenuBottom;
begin
  recGrafico.Fill.Color   := COR_CLARA_MENU;
  recHome.Fill.Color      := COR_CLARA_MENU;
  recCadastros.Fill.Color := COR_CLARA_MENU;
end;

procedure TF_BaseMenu.recGeralClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

procedure TF_BaseMenu.recMenuLateralCadastrarClick(Sender: TObject);
begin
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_Cadastros) then
  begin
    F_Cadastros := TF_Cadastros.create(nil);
  end;
  F_Cadastros.show;

  GoToHome(F_Cadastros);
end;

procedure TF_BaseMenu.recMenuLateralInicioClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
  GoToHome;
end;

procedure TF_BaseMenu.GoToHome(FormAtivo: TForm);
var
  I: Integer;
  Form: TForm;
begin
  for I := Screen.FormCount - 1 downto 0 do
  begin
    Form := TForm(Screen.Forms[I]);
    if (Form <> Application.MainForm) and (Form <> FormAtivo) then
    begin
//      Form.Hide;
//      Form.Transparency := True;
      Form.Close;
    end;
  end;
end;

procedure TF_BaseMenu.recMenuLateralSairClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
  Application.CreateForm(TF_Login, F_Login);
  Application.MainForm := F_Login;
  F_Login.Show;
  GoToHome();
end;

procedure TF_BaseMenu.SetaCorMenuAtivo(const Value: TMenuAtivo);
begin
  case Value of
    maGrafico:   recGrafico.Fill.Color   := COR_ESCURA_MENU;
    maPrincipal: recHome.Fill.Color      := COR_ESCURA_MENU;
    maCadastros: recCadastros.Fill.Color := COR_ESCURA_MENU;
  end;
end;

procedure TF_BaseMenu.SetMenuAtivo(const Value: TMenuAtivo);
begin
  FMenuBottomAtivo := Value;
  InicializaMenuBottom;
  SetaCorMenuAtivo(Value);
end;

end.

