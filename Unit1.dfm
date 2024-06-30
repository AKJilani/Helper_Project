object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Helper'
  ClientHeight = 687
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 15
  object Label1: TLabel
    Left = 78
    Top = 80
    Width = 193
    Height = 21
    Caption = 'Image_Details from Folder'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 78
    Top = 344
    Width = 232
    Height = 21
    Caption = 'Image_Details from Database IB'
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 80
    Top = 488
    Width = 272
    Height = 21
    Caption = 'Image_Details from Database_MySQL'
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 80
    Top = 208
    Width = 196
    Height = 21
    Caption = 'Get Image List from Folder'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 78
    Top = 112
    Width = 233
    Height = 23
    Color = clBtnHighlight
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 79
    Top = 371
    Width = 233
    Height = 23
    TabOrder = 1
    OnClick = Edit2DblClick
  end
  object Button1: TButton
    Left = 78
    Top = 152
    Width = 105
    Height = 33
    Caption = 'Get Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 78
    Top = 416
    Width = 105
    Height = 33
    Caption = 'Get Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 80
    Top = 528
    Width = 105
    Height = 33
    Caption = 'Get Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 376
    Top = 72
    Width = 344
    Height = 513
    PopupMenu = PopupMenu1
    TabOrder = 5
  end
  object Button5: TButton
    Left = 208
    Top = 416
    Width = 104
    Height = 33
    Caption = 'img_Break'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 616
    Top = 81
    Width = 96
    Height = 25
    Caption = 'Save to .txt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = Button6Click
  end
  object Edit3: TEdit
    Left = 79
    Top = 240
    Width = 233
    Height = 23
    TabOrder = 8
  end
  object Button4: TButton
    Left = 79
    Top = 281
    Width = 105
    Height = 33
    Caption = 'Get Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = Button4Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=IB')
    LoginPrompt = False
    Left = 816
    Top = 16
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT series_number, COUNT(*) AS image_count FROM image_details' +
        ' GROUP BY series_number')
    Left = 920
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 1008
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object OpenFile1: TMenuItem
        Caption = 'New File'
      end
      object OpenFile2: TMenuItem
        Caption = 'Open File'
      end
      object OpenFile3: TMenuItem
        Caption = 'Exit'
      end
    end
    object File2: TMenuItem
      Caption = 'Option'
      object ImageDetails1: TMenuItem
        Caption = 'Image_Details'
      end
      object ImageDetails2: TMenuItem
        Caption = 'Image_Details_db'
      end
      object ImageDetailsbdCyrillic1: TMenuItem
        Caption = 'Image_Details_bd_Cyrillic'
      end
    end
    object ImageDetailsbdCyrillic2: TMenuItem
      Caption = 'Security'
      object ChangePassword1: TMenuItem
        Caption = 'Change Password'
      end
      object ChangePassword2: TMenuItem
        Caption = 'Manage User'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
    end
    object Help2: TMenuItem
      Caption = 'About'
    end
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 992
    Top = 96
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 864
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    Left = 768
    Top = 104
    object WriteQuery1: TMenuItem
      Caption = 'Select_Query_Data'
      OnClick = WriteQuery1Click
    end
    object SelectQueryImageDetailsTemp1: TMenuItem
      Caption = 'Select_Query_Image_Details'
      OnClick = SelectQueryImageDetailsTemp1Click
    end
    object PopUP1: TMenuItem
      Caption = 'Select_Query_Image_Details_Temp'
      OnClick = PopUP1Click
    end
  end
end
