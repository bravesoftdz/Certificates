object DM: TDM
  OldCreateOrder = False
  Height = 150
  Width = 215
  object HTTP: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    HandleRedirects = True
    AllowCookies = True
    UserAgent = 'Embarcadero URI Client/1.0'
    OnValidateServerCertificate = HTTPValidateServerCertificate
    Left = 88
    Top = 64
  end
end
