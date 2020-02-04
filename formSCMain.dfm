object frmSCMain: TfrmSCMain
  Left = 0
  Top = 0
  Caption = 'Shrodinger Cellular Automaton'
  ClientHeight = 623
  ClientWidth = 731
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 258
    Width = 731
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 265
  end
  object chartMass: TChart
    Left = 0
    Top = 263
    Width = 731
    Height = 341
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    TabOrder = 0
    ExplicitTop = 269
    ExplicitHeight = 268
    object flsMass: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      ShowInLegend = False
      Title = 'Mass'
      LinePen.Color = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 731
    Height = 29
    Caption = 'ToolBar'
    TabOrder = 1
    object tbnCAStart: TToolButton
      Left = 0
      Top = 0
      Action = actCAStart
    end
    object tbnCAStop: TToolButton
      Left = 23
      Top = 0
      Action = actCAStop
    end
  end
  object chartPot: TChart
    Left = 0
    Top = 29
    Width = 731
    Height = 229
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alTop
    TabOrder = 2
    object flsPot: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      ShowInLegend = False
      Title = 'Potential'
      LinePen.Color = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 604
    Width = 731
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitLeft = 232
    ExplicitTop = 344
    ExplicitWidth = 0
  end
  object ActionList: TActionList
    Left = 304
    object actCAStart: TAction
      Caption = 'Start'
      OnExecute = actCAStartExecute
    end
    object actCAStop: TAction
      Caption = 'Stop'
      OnExecute = actCAStopExecute
    end
  end
  object ImageList: TImageList
    Left = 336
  end
end
