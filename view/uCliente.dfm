inherited frmCliente: TfrmCliente
  Caption = 'Clientes'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    inherited tsSearch: TTabSheet
      inherited pnSearch: TPanel
        inherited pnSearchTop: TPanel
          inherited sbSearch: TSpeedButton
            OnClick = sbSearchClick
          end
        end
        inherited pnList: TPanel
          inherited gdrList: TDBGrid
            DataSource = dsSearch
          end
        end
      end
    end
    inherited tsData: TTabSheet
      inherited pnData: TPanel
        object lbTpDocumento: TLabel [0]
          Left = 8
          Top = 95
          Width = 77
          Height = 13
          Caption = 'Tipo Documento'
        end
        object lbledtTelefone: TLabeledEdit
          Left = 271
          Top = 112
          Width = 121
          Height = 21
          EditLabel.Width = 42
          EditLabel.Height = 13
          EditLabel.Caption = 'Telefone'
          TabOrder = 1
        end
        object cbTpDocumento: TComboBox
          Left = 8
          Top = 112
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'cbTpDocumento'
        end
        object lbledtDocumento: TLabeledEdit
          Left = 144
          Top = 112
          Width = 121
          Height = 21
          EditLabel.Width = 54
          EditLabel.Height = 13
          EditLabel.Caption = 'Documento'
          TabOrder = 3
        end
        object lbledtNome: TLabeledEdit
          Left = 8
          Top = 68
          Width = 393
          Height = 21
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          TabOrder = 4
        end
      end
      inherited pnSaveOrCancel: TPanel
        inherited sbSave: TSpeedButton
          OnClick = sbSaveClick
        end
      end
    end
  end
end
