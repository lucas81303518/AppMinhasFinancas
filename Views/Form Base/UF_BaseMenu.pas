unit UF_BaseMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Classes, System.Generics.Collections;

type
  TF_BaseMenu = class(TForm)
    recGeral: TRectangle;
    recMenu: TRectangle;
    imageMenu: TImage;
    ImageUser: TImage;
    recMenuFooter: TRectangle;
    imageHome: TImage;
    imagemGrafico: TImage;
    rectMenuLateral: TRectangle;
    ImageMoney: TImage;
    recMenuLateralPerfil: TRectangle;
    Image2: TImage;
    Label6: TLabel;
    recMenuLateralSair: TRectangle;
    Label8: TLabel;
    Image6: TImage;
    recMenuLateralGrafico: TRectangle;
    Label7: TLabel;
    Image5: TImage;
    recMenuLateralCadastrar: TRectangle;
    Label9: TLabel;
    Image4: TImage;
    recMenuLateralInicio: TRectangle;
    Label10: TLabel;
    Image3: TImage;
    imageCadastro: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imageMenuClick(Sender: TObject);
    procedure ImageMoneyClick(Sender: TObject);
    procedure recGeralClick(Sender: TObject);
    procedure recMenuLateralInicioClick(Sender: TObject);
    procedure recMenuLateralSairClick(Sender: TObject);
    procedure recMenuLateralCadastrarClick(Sender: TObject);
    procedure imagemGraficoClick(Sender: TObject);
  private
    { Private declarations }
    procedure AjustaVisibilidadeMenuLateral(Visivel: Boolean);
    procedure GoToHome;
  public
    { Public declarations }
  end;

var
  F_BaseMenu: TF_BaseMenu;

implementation

uses
  UF_Cadastros, funcoes;

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
  MenuAtivo := taRelatorio;
end;

procedure TF_BaseMenu.ImageMoneyClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

procedure TF_BaseMenu.recGeralClick(Sender: TObject);
begin
  inherited;
  AjustaVisibilidadeMenuLateral(False);
end;

procedure TF_BaseMenu.recMenuLateralCadastrarClick(Sender: TObject);
begin
  MenuAtivo := taCadastro;
  AjustaVisibilidadeMenuLateral(False);
  if not Assigned(F_Cadastros) then
  begin
    F_Cadastros := TF_Cadastros.create(Self);
    F_Cadastros.show;
  end;
end;

procedure TF_BaseMenu.recMenuLateralInicioClick(Sender: TObject);
begin
  inherited;
  MenuAtivo := taHome;
  AjustaVisibilidadeMenuLateral(False);
  GoToHome;
end;

procedure TF_BaseMenu.GoToHome;
var
  I: Integer;
  Form: TForm;
begin
  for I := Screen.FormCount - 1 downto 0 do
  begin
    Form := TForm(Screen.Forms[I]);
    if (Form <> Application.MainForm) then
      Form.Close;
  end;
end;

procedure TF_BaseMenu.recMenuLateralSairClick(Sender: TObject);
begin
  inherited;
  Application.Terminate;
end;

end.
