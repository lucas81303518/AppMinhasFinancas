object DmPrincipal: TDmPrincipal
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object ACBrMail: TACBrMail
    Host = 'smtp.gmail.com'
    Port = '465'
    Username = 'lucasferreira8130@gmail.com'
    Password = 'gfbo iebv kfuw xisy'
    SetSSL = True
    SetTLS = False
    Attempts = 3
    From = 'lucasferreira8130@gmail.com'
    FromName = 'Minhas Finan'#231'as App'
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 280
    Top = 144
  end
end
