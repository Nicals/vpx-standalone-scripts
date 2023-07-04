' Bram Stoker's Dracula / IPD No. 3072 / April, 1993 / 4 Players
' VP91x 1.03 by JPSalas 2011
' Magnet script by Dorsolas/Lander's script, with just a small modification

Option Explicit
Randomize

Dim HideSlingGraphics
Dim FlipperCoilRampupMode
Dim dtxx
Dim DesktopMode:DesktopMode = Table1.ShowDT
Dim luts, lutpos

'01010111 01101001 01101110 01101110 01100101 01110010 01110011 00100000
'01100100 01101111 01101110 00100111 01110100 00100000 01110011 01100101
'01101100 01101100 00100000 01010110 01010000 01011000 00100000 01110100
'01100001 01100010 01101100 0110F0101 01110011 00101110
'

' Thalamus 2020-05-04 : Improved directional sounds
' Special thanks to DjRobX, Rothbauwerw, Dark, Fleep, Flupper, Kiwi, JPSalas and ICPJuggla

'  .5 = lower volume
' 1.5 = higher volume

Const VolBump   = 1    ' Bumpers volume.
Const VolRol    = 1    ' Rollovers volume.
Const VolGates  = 1    ' Gates volume.
Const VolMetal  = 3    ' Metals volume.
Const VolRH     = 1    ' Rubber hits volume.
Const VolPi     = 1    ' Rubber pins volume.
Const VolTarg   = 1    ' Targets volume.
Const VolSpin   = 1    ' Spinners volume.
Const VolDrain  = 1    ' Drain volume.
Const VolSling  = 1    ' Slingshots volume.
Const VolBRol   = .01  ' Volume Ball Rolling.
Const VolPRol   = .1   ' Volume Plastics Rolling.
Const VolMRol   = .8   ' Volume Metals Rolling.
Const VolDrop   = .4   ' Balldrop volume.

' Want to hide the sling graphics ? Set HideSlingGraphis = 1
HideSlingGraphics = 1

' You might want to change this to either a 0 or a 1 value.
FlipperCoilRampupMode = 0

' 1 - on; 0 - off; if on then the right magnasave button let's you rotate all LUT's
Const EnableRightMagnasave = 1

' Ballshowdow enable or not
Const BallSHW = 1

' Yellowflippers and lit Moon - I didn't find that the Moon has any light in manual.
Const YellowFlippers = 1

If YellowFlippers Then
  LFLogo.Image = "bsd_flipper_left_yellow"
  RFLogo.Image = "bsd_flipper_right_yellow"
End if

Const BallSize = 50
giw32.state = 0

If HideSlingGraphics Then
  Primitive239.Visible = False
  Primitive109.Visible = False
  gakk1.Visible = True
  gakk2.Visible = True
  gakk3.Visible = True
  gakk4.Visible = True
  gakk5.Visible = True
  gakk6.Visible = True
Else
  Primitive239.Visible = True
  Primitive109.Visible = True
  gakk1.Visible = False
  gakk2.Visible = False
  gakk3.Visible = False
  gakk4.Visible = False
  gakk5.Visible = False
  gakk6.Visible = False
End if

LSling1.visible = 0
LSling2.visible = 0
RSling1.visible = 0
RSling2.visible = 0

TextBox001.visible = 0

' Lut code shamelessly stolen from Totan - Tnanks Flupper

luts = array( "colorgradelut256x16_1to1SL30", "colorgradelut256x16_1to1SL50", "colorgradelut256x16_1to1SL60desat", "ColorGradeLUT256x16_ConSat" )
lutpos = 2                        '  set the nr of the LUT you want to use (0 = first in the list above, 1 = second, etc); 5 is the default


If DesktopMode = True Then
  Ramp15.visible = 1
  Ramp16.visible = 1
  SideWood.visible = 1
  For each dtxx in Dflasher:dtxx.Visible = 1:next
  l58.Intensity = 0
  l58a.Intensity = 0
  l21.Intensity = 0
  l22.Intensity = 0
else
  For each dtxx in Dflasher:dtxx.Visible = 0:next
  l58.Intensity = 50
  l58a.Intensity = 25
  l21.Intensity = 20
  l22.Intensity = 20
  Ramp15.visible = 0
  Ramp16.visible = 0
  SideWood.visible = 0
End If

Dim VarHidden, UseVPMDMD
Const UseVPMModSol = 1

If Table1.ShowDT = true then
  UseVPMDMD = true
  VarHidden = 1
else
  UseVPMDMD = False
  VarHidden = 0
end if

On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the controller.vbs in order to run this table, available in the vp10 package"
On Error Goto 0

LoadVPM "01560000", "WPC.VBS", 3.26

' Thalamus - for Fast Flip v2
NoUpperRightFlipper
NoUpperLeftFlipper

'********************
'Standard definitions
'********************

Const UseSolenoids = 2
Const UseLamps = 1
Const UseSync = 0
Const HandleMech = 0

' Standard Sounds
Const SSolenoidOn = "Solenoid"
Const SSolenoidOff = ""
Const SFlipperOn = "FlipperUp"
Const SFlipperOff = "FlipperDown"
Const SCoin = "Coin"

Set GiCallback2 = GetRef("UpdateGI2")

Dim bsTrough, bsCryptPopper, bsBLPopper, bsCastlePopper, bsCoffinPopper
Dim mMagnet, dtLDrop, bsCastleLock, x, bumper1, bumper2, bumper3, plungerIM


On Error Resume Next
Dim i
For i=0 To 127
  If IsObject(eval("L" & i)) Then
    Execute "Set Lights(" & i & ")  = L" & i
  End If
Next

Lights(58)=Array(L58,L58A)

'************
' Table init.
'************

Const cGameName = "drac_l1"

Sub Table1_Init
  vpmInit Me
  With Controller
    .GameName = cGameName
    If Err Then MsgBox "Can't start Game " & cGameName & vbNewLine & Err.Description:Exit Sub
    .SplashInfoLine = "Bram Stoker's Dracula, Williams, 1993" & vbNewLine & "VP91x table by JPSalas v1.03"
    .Games(cGameName).Settings.Value("rol") = 0 'rotated left
    .HandleKeyboard = 0
    .ShowTitle = 0
    .ShowDMDOnly = 1
    .ShowFrame = 0
    .HandleMechanics = 0
    .Hidden = Desktopmode
    On Error Resume Next
    .Run GetPlayerHWnd
    If Err Then MsgBox Err.Description
      On Error Goto 0
      .Switch(22) = 1 'close coin door
      .Switch(24) = 1 'and keep it close
  End With

  ' Nudging
  vpmNudge.TiltSwitch = 14
  vpmNudge.Sensitivity = 5
  vpmNudge.TiltObj = Array(bumper1, bumper2, bumper3, LeftSlingshot, RightSlingshot)

  ' Trough
  Set bsTrough = New cvpmBallStack
  With bsTrough
    .InitSw 48, 41, 42, 43, 44, 0, 0, 0
    .InitKick BallRelease, 90, 4
    .InitEntrySnd "Solenoid", "Solenoid"
    .InitExitSnd "ballrel", "Solenoid"
    .Balls = 4
  End With

  ' Crypt Popper
  set bsCryptPopper = new cvpmBallStack
  With bsCryptPopper
    .InitSw 0, 56, 0, 0, 0, 0, 0, 0
    .InitKick sw56, 78, 10
    .KickForceVar = 2
    .KickAngleVar = 5
    .KickBalls = 2
    .InitExitSnd "Popper", "Solenoid"
    .Balls = 0
  End With

  ' Wire Ramp Popper
  set bsBLPopper = new cvpmBallStack
  With bsBLPopper
    .InitSw 0, 55, 0, 0, 0, 0, 0, 0
    .InitKick sw55, 180, 1
    .InitExitSnd "ExitKick", "Solenoid"
    .Balls = 0
  End With

  ' Castle Popper
  set bsCastlePopper = new cvpmBallStack
  With bsCastlePopper
    .InitSw 0, 71, 0, 0, 0, 0, 0, 0
    .InitKick sw71, 210, 10
    .KickForceVar = 1
    .KickAngleVar = 5
    .KickBalls = 2
    .InitExitSnd "fx_ScoopExit", "Solenoid"
  End With

  ' Coffin Popper
  set bsCoffinPopper = new cvpmBallStack
  With bsCoffinPopper
    .InitSw 0, 72, 0, 0, 0, 0, 0, 0
    .InitKick sw72, 180, 1
    .InitExitSnd "Popper", "Solenoid"
  End With

  ' Mist Magnet
  Set mMagnet = New cMagnet
  ' mMagnet.InitMagnet Magnet, 5
  mMagnet.InitMagnet Magnet, 3.8 ' Thalamus
  mMagnet.Size = 60
  ' mMagnet.Size = 50
  MagnetPos = 0:SetMagnetPosition

  ' Drop target
  Set dtLDrop = New cvpmDropTarget
  With dtLDrop
    .InitDrop sw15, 15
    .InitSnd "droptarget_l", "Solenoid"
    .CreateEvents "dtLDrop"
  End With

  ' Castle Lock
  Set bsCastleLock = new cvpmBallStack
  With bsCastleLock
    .initsw 0, 53, 54, 57, 0, 0, 0, 0
    .InitKick CastleLock, 135, 1
  End With


  ' Main Timer init
  PinMAMETimer.Interval = PinMAMEInterval
  PinMAMETimer.Enabled = 1

  Plunger.Pullback
  Wdivert.Isdropped = 1

End Sub

Sub table1_Paused:Controller.Pause = 1:End Sub
Sub table1_unPaused:Controller.Pause = 0:End Sub

'**********
' Keys
'**********

Sub table1_KeyDown(ByVal Keycode)

  If keycode = LeftFlipperKey Then LFPress = 1
  If keycode = RightFlipperKey Then rfpress = 1

  'If keycode = 3 Then SetFlash 131,1
  If keycode = PlungerKey Then Controller.Switch(34) = 1

  If keycode = LeftTiltKey Then
    Nudge 90, 2
  End If

  If keycode = RightTiltKey Then
  Nudge 270, 2
  End If
  If keycode = CenterTiltKey Then
  Nudge 0, 2
 End If

 If keycode = RightMagnaSave and EnableRightMagnasave = 1 then
  textbox001.visible = 1
  lutpos = lutpos + 1 : If lutpos > ubound(luts) Then lutpos = 0 : end if
  table1.ColorGradeImage = luts(lutpos)
  dim tekst : tekst = "lutpos:" & lutpos & " " & luts(lutpos)
  textbox001.text = tekst
  vpmTimer.AddTimer 2000, "If textbox001.text =" + chr(34) + tekst + chr(34) + " then textbox001.visible = 0'"
 End if

  If vpmKeyDown(keycode) Then Exit Sub
End Sub

Sub table1_KeyUp(ByVal Keycode)

  If keycode = LeftFlipperKey Then
    lfpress = 0
    leftflipper.eostorqueangle = EOSA
    leftflipper.eostorque = EOST
  End If
  If keycode = RightFlipperKey Then
    rfpress = 0
    rightflipper.eostorqueangle = EOSA
    rightflipper.eostorque = EOST
  End If

  'If keycode = 3 Then SetFlash 131,0
  If keycode = PlungerKey Then Controller.Switch(34) = 0
  If vpmKeyUp(keycode) Then Exit Sub
End Sub


'*********
' Switches
'*********

' Slings & div switches
Dim LStep, RStep

Sub LeftSlingShot_Slingshot
  ' PlaySound "slingshot", 0, 0.3, -0.1, 0.25, 0, 1, AudioFade(sling2)
  RandomSoundSlingshotLeft()
  vpmTimer.PulseSw 64
  LSling.Visible = 0
  LSling1.Visible = 1
  sling2.TransZ = -20
  LStep = 0
  LeftSlingShot.TimerEnabled = 1
  LeftSlingShot.TimerInterval = 10
End Sub

Sub LeftSlingShot_Timer
  Select Case LStep
    Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.TransZ = -10
    Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.TransZ = 0:LeftSlingShot.TimerEnabled = 0
  End Select
  LStep = LStep + 1
End Sub

Sub RightSlingShot_Slingshot
  ' PlaySound "slingshot", 0, 0.3, 0.1, 0.25, 0, 1, AudioFade(sling1)
  RandomSoundSlingshotRight()
  vpmTimer.PulseSw 65
  RSling.Visible = 0
  RSling1.Visible = 1
  sling1.TransZ = -20
  RStep = 0
  RightSlingShot.TimerEnabled = 1
  RightSlingShot.TimerInterval = 10
End Sub

Sub RightSlingShot_Timer
  Select Case RStep
    Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.TransZ = -10
    Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.TransZ = 0:RightSlingShot.TimerEnabled = 0
  End Select
  RStep = RStep + 1
End Sub


' Bumpers
' Sub Bumper1_Hit:vpmTimer.PulseSw 61:PlaySoundAtVol "bumper", ActiveBall, VolBump:End Sub
Sub Bumper1_Hit:vpmTimer.PulseSw 61:RandomSoundBumperA:End Sub

Sub Bumper1_Timer()
  Select Case bump1
    Case 1:Ring1a.IsDropped = 0:bump1 = 2
    Case 2:Ring1b.IsDropped = 0:Ring1a.IsDropped = 1:bump1 = 3
    Case 3:Ring1c.IsDropped = 0:Ring1b.IsDropped = 1:bump1 = 4
    Case 4:Ring1c.IsDropped = 1:Me.TimerEnabled = 0
  End Select
End Sub

' Sub Bumper2_Hit:vpmTimer.PulseSw 62:PlaySoundAtVol "bumper", ActiveBall, VolBump:End Sub
Sub Bumper2_Hit:vpmTimer.PulseSw 62:RandomSoundBumperB:End Sub
Sub Bumper2_Timer()
  Select Case bump2
    Case 1:Ring2a.IsDropped = 0:bump2 = 2
    Case 2:Ring2b.IsDropped = 0:Ring2a.IsDropped = 1:bump2 = 3
    Case 3:Ring2c.IsDropped = 0:Ring2b.IsDropped = 1:bump2 = 4
    Case 4:Ring2c.IsDropped = 1:Me.TimerEnabled = 0
  End Select
End Sub

' Sub Bumper3_Hit:vpmTimer.PulseSw 63:PlaySoundAtVol "bumper", ActiveBall, VolBump:End Sub
Sub Bumper3_Hit:vpmTimer.PulseSw 63:RandomSoundBumperC:End Sub
Sub Bumper3_Timer()
  Select Case bump3
    Case 1:Ring3a.IsDropped = 0:bump3 = 2
    Case 2:Ring3b.IsDropped = 0:Ring3a.IsDropped = 1:bump3 = 3
    Case 3:Ring3c.IsDropped = 0:Ring3b.IsDropped = 1:bump3 = 4
    Case 4:Ring3c.IsDropped = 1:Me.TimerEnabled = 0
  End Select
End Sub

' Drain holes, vuks & saucers
Sub Drain_Hit:RandomSoundDrain():bsTrough.AddBall Me:End Sub
Sub Drain1_Hit:RandomSoundDrain():ClearBallID:bsTrough.AddBall Me:End Sub
Sub Drain2_Hit:RandomSoundDrain():ClearBallID:bsTrough.AddBall Me:End Sub
Sub Drain3_Hit:RandomSoundDrain():ClearBallID:bsTrough.AddBall Me:End Sub
Sub Drain4_Hit:RandomSoundDrain():ClearBallID:bsTrough.AddBall Me:End Sub

'Sub sw72a_Hit:PlaySoundAt "fx_Hole2", sw72a:bsCoffinPopper.addball Me:End Sub

Dim rball

Sub sw72a_Hit:PlaySoundAtVol "fx_Hole2", sw72a, 1:me.destroyball:set rball = me.createball:drop.enabled = 1:End Sub

Sub drop_timer()
  If rball.Z <= -50 Then
    me.enabled = 0
    drop2.enabled = 1
  End If
  rball.Z = rball.Z - 1
End Sub

Sub drop2_timer()
  sw72a.destroyball
  bsCoffinPopper.addball rball
  me.enabled = 0
End Sub

Sub sw71_Hit
  PlaySound "hole_enter", 0, 0.3, AudioPan(sw71), 0.25, 0, 1, 0, AudioFade(sw71)
  vpmTimer.PulseSwitch 71, 0, 0
  mMagnet.RemoveBall ActiveBall
  Me.destroyball
  bsCastlePopper.AddBall Me
End Sub

Sub sw58_Hit
  PlaySound "hole_enter", 0, 0.3, AudioPan(sw58), 0.25, 0, 1, 0, AudioFade(sw58)
  Me.DestroyBall
  PlaySoundAtVol "subway2", sw58, 1
  vpmTimer.PulseSwitch 58, 1250, "bsBLPopper.AddBall 0 '"
End Sub

Sub sw56_Hit
  PlaySound "hole_enter", 0, 0.3, AudioPan(sw56), 0.25, 0, 1, 0, AudioFade(sw56)
  vpmTimer.PulseSwitch 56, 100, 0
  mMagnet.RemoveBall ActiveBall
  bsCryptPopper.AddBall Me
End Sub

Sub sw56a_Hit
  PlaySound "hole_enter", 0, 0.3, AudioPan(sw56a), 0.25, 0, 1, 0, AudioFade(sw56a)
  mMagnet.RemoveBall ActiveBall
  bsCryptPopper.AddBall Me
End Sub

Sub CastleLock_Hit()
  PlaysoundAtVol "metalhit2", CastleLock, 1
  bsCastleLock.AddBall Me
End Sub

' Rollovers & Ramp Switches
Sub sw35_Hit:Controller.Switch(35) = 1:RandomSoundRollover():End Sub
Sub sw35_UnHit:Controller.Switch(35) = 0:End Sub

Sub sw36_Hit:Controller.Switch(36) = 1:RandomSoundRollover():End Sub
Sub sw36_UnHit:Controller.Switch(36) = 0:End Sub

Sub sw37_Hit:Controller.Switch(37) = 1:RandomSoundRollover():End Sub
Sub sw37_UnHit:Controller.Switch(37) = 0:End Sub

Sub sw38_Hit:Controller.Switch(38) = 1:RandomSoundRollover():End Sub
Sub sw38_UnHit:Controller.Switch(38) = 0:End Sub

Sub sw25_Hit:Controller.Switch(25) = 1:RandomSoundRollover():End Sub
Sub sw25_UnHit:Controller.Switch(25) = 0:End Sub

Sub sw26_Hit:Controller.Switch(26) = 1:RandomSoundRollover():End Sub
Sub sw26_Unhit:Controller.Switch(26) = 0:End Sub

Sub sw27_Hit:Controller.Switch(27) = 1:RandomSoundRollover():End Sub
Sub sw27_Unhit:Controller.Switch(27) = 0:End Sub

Sub sw16_Hit:Controller.Switch(16) = 1:RandomSoundRollover():End Sub
Sub sw16_Unhit:Controller.Switch(16) = 0:End Sub

Sub sw28_Hit:Controller.Switch(28) = 1:End Sub
Sub sw28_Unhit:Controller.Switch(28) = 0:End Sub

Sub sw84_Hit:Controller.Switch(84) = 1:End Sub
Sub sw84_Unhit:Controller.Switch(84) = 0:End Sub

Sub sw85_Hit:Controller.Switch(85) = 1:End Sub
Sub sw85_Unhit:Controller.Switch(85) = 0:End Sub

Sub sw31_Hit:Controller.Switch(31) = 1:RandomSoundRollover():End Sub
Sub sw31_Unhit:Controller.Switch(31) = 0:End Sub

Sub sw51_Hit:Controller.Switch(51) = 1:RandomSoundRollover():End Sub
Sub sw51_Unhit:Controller.Switch(51) = 0:End Sub

Sub sw52_Hit:Controller.Switch(52) = 1:RandomSoundRollover():End Sub
Sub sw52_Unhit:Controller.Switch(52) = 0:End Sub

Sub sw73_Hit
  Controller.Switch(73) = 1
  If ActiveBall.VelY < -25 Then
    PlaySoundAt "Subway2",sw73
  End If
End Sub

Sub sw73_Unhit:Controller.Switch(73) = 0:End Sub

Sub sw17_Hit:Controller.Switch(17) = 1:End Sub
Sub sw17_Unhit:Controller.Switch(17) = 0:End Sub

' Targets
Sub sw66_Hit:vpmTimer.PulseSw 66:PlaySoundAt "target",sw66:End Sub
Sub sw66_Timer:sw66.IsDropped = 0:End Sub

Sub sw67_Hit:vpmTimer.PulseSw 67:PlaySoundAt "target",sw67:End Sub
Sub sw67_Timer:sw67.IsDropped = 0:End Sub

Sub sw68_Hit:vpmTimer.PulseSw 68:PlaySoundAt "target",sw68:End Sub
Sub sw68_Timer:sw68.IsDropped = 0:End Sub

Sub sw86_Hit:vpmTimer.PulseSw 86:PlaySoundAt "target",sw86:End Sub
Sub sw86_Timer:sw86.IsDropped = 0:End Sub

Sub sw87_Hit:vpmTimer.PulseSw 87:PlaySoundAt "target",sw87:End Sub
Sub sw87_Timer:sw87.IsDropped = 0:End Sub

Sub sw88_Hit:vpmTimer.PulseSw 88:PlaySoundAt "target",sw88:End Sub
Sub sw88_Timer:sw88.IsDropped = 0:Me.TimerEnabled = 0:End Sub

'*********
'Solenoids
'*********

SolCallback(1) = "Auto_Plunger"
SolCallback(2) = "bsCoffinPopper.SolOut"
SolCallback(3) = "bsCastlePopper.SolOut"
SolCallback(4) = "SolRRampDown"
SolCallback(5) = "bsCryptPopper.SolOut"
SolCallback(6) = "bsBLPopper.SolOut"
SolCallback(7) = "vpmSolSound ""Knocker"","
SolCallback(8) = "SolShooterRamp"
SolCallback(14) = "SolRRampUp"
SolCallback(15) = "bsTrough.SolIn"
SolCallback(16) = "bsTrough.SolOut"

SolModCallback(17) = "Sol117"
SolModCallback(18) = "Sol118"
SolModCallback(19) = "Sol119"
SolModCallback(20) = "Sol120"
SolModCallback(21) = "Sol121"
SolModCallback(22) = "Sol122"
SolModCallback(23) = "Sol123"
SolModCallback(24) = "Sol124"
SolCallback(25) = "dtLDrop.SolDropUp"
SolCallback(27) = "SolMistMagnet"
SolCallback(33) = "solTopDiverter"
SolCallback(34) = "SolRGate"
SolCallback(35) = "bsCastleLock.SolOut"
SolCallback(36) = "SolLGate"

Sub Auto_Plunger(Enabled)
  If Enabled Then
    Plunger.Fire
    PlaySoundAtVol "Autoplunger", Plunger, 1
  Else
    Plunger.PullBack
  End If
End Sub

'*************
' Moving Ramp
'*************

Dim RRampDir, RRAmpCurrPos, RRamp
RRampCurrPos = 0 ' down
RRampDir = 1     '1 is up -1 is down dir
Controller.Switch(77) = False
'RightRamp.Collidable = True

Sub SolRRampUp(Enabled)
  If Enabled Then
    RRampDir = 1
    Controller.Switch(77) = True
    RightRamp.Collidable = False
    UpdateRamp.Enabled = True
    playsoundAtVol "diverter", RightRamp, 1
  End If
End Sub

Sub SolRRampDown(Enabled)
  If Enabled Then
    RRampDir = -1
    Controller.Switch(77) = False
    RightRamp.Collidable = True
    UpdateRamp.Enabled = True
    playsoundAtVol "diverter", RightRamp, 1
  End If
End sub

Sub UpdateRamp_Timer
  RRampCurrPos = RRampCurrPos + RRampDir
  If RRampCurrPos> 10 Then
    RRampCurrPos = 10
    UpdateRamp.Enabled = 0
  End If
  If RRampCurrPos <0 Then
    RRampCurrPos = 0
    UpdateRamp.Enabled = 0
  End If
  RightRamp2.HeightBottom = RRampCurrPos *5
  CoffinLiftRampOpaque.RotX = RRampCurrPos -11
  CoffinLiftRamp.RotX = RRampCurrPos -11
  Refresh.State = 1
  Refresh.State = 0
End Sub

' Shooter Ramp

Sub SolShooterRamp(Enabled)
  If Enabled Then
    sramp2.Collidable = 0
    dirsrt = 1:shootramp.enabled = 1
    PlaysoundAtVol "solenoid", sramp2, 1
  Else
    sramp2.Collidable = 1
    dirsrt = 2:shootramp.enabled = 1
    PlaysoundAtVol "solenoid", sramp2, 1
  End If
End Sub

' Top Ramp Diverter

Sub SolTopDiverter(Enabled)
  PlaysoundAtVol "Diverter", WDivert, 1
  If Enabled Then
    wDivert.isdropped = 0
    ddir = 1:Divert.enabled = 1
  Else
    WDivert.isdropped = 1
    ddir = 2:Divert.enabled = 1
  End If
End sub

Dim FlashState(200), FlashLevel(200)
Dim FlashSpeedUp, FlashSpeedDown
'Dim x

FlashInit()
FlasherTimer.Interval = 10 'flash fading speed
FlasherTimer.Enabled = 1

Sub FlashInit
  Dim i
  For i = 0 to 200
    FlashState(i) = 0
    FlashLevel(i) = 0
  Next
  FlashSpeedUp = 500   ' fast speed when turning on the flasher
  FlashSpeedDown = 100 ' slow speed when turning off the flasher, gives a smooth fading
  AllFlashOff()
End Sub

Sub AllFlashOff
  Dim i
  For i = 0 to 200
    FlashState(i) = 0
  Next
End Sub

Sub Flash(nr, object)
  Select Case FlashState(nr)
    Case 0 'off
      FlashLevel(nr) = FlashLevel(nr) - FlashSpeedDown
      If FlashLevel(nr) < 0 Then
        FlashLevel(nr) = 0
        FlashState(nr) = -1 'completely off
      End if
      Object.opacity = FlashLevel(nr)
    Case 1 ' on
      FlashLevel(nr) = FlashLevel(nr) + FlashSpeedUp
      If FlashLevel(nr) > 1000 Then
        FlashLevel(nr) = 1000
        FlashState(nr) = -2 'completely on
      End if
      Object.opacity = FlashLevel(nr)
  End Select
End Sub

Sub Flashm(nr, object) 'multiple flashers, it doesn't change the flashstate
  Select Case FlashState(nr)
    Case 0         'off
      Object.opacity = FlashLevel(nr)
    Case 1         ' on
      Object.opacity = FlashLevel(nr)
  End Select
End Sub

Sub SetFlash(nr, stat)
  FlashState(nr) = ABS(stat)
End Sub

Sub FlasherTimer_Timer()
  Flash 161, f61
  Flash 162, f62
  Flash 163, f63
  Flashm 158, f58
  Flash 158, f58a
  Flashm 121, F121
  Flash 121, F121a
  Flashm 122, F122
  Flash 122, F122a
End Sub

Dim ddir

Sub Divert_Timer()
  Select Case ddir
    Case 1:
      If Diverter.Z = -315 Then
        me.enabled = 0
        Controller.Switch(78) = True
        Diverter.Z = -315
      End If
      Diverter.Z = Diverter.Z - 1
    Case 2:
      If Diverter.Z = -280 Then
        me.enabled = 0
        Controller.Switch(78) = False
        Diverter.Z = -280
      End If
      Diverter.Z = Diverter.Z + 1
  End Select
End Sub

' Mist Gates

Sub SolLGate(Enabled)
  If Enabled then
    LGate.open = 1
    Wall_LO.isdropped = 1
  else
    LGate.open = 0
    Wall_LO.isdropped = 0
  End If
End Sub

Sub SolRGate(Enabled)
  If Enabled then
    RGate.open = 1
    RGateWall.IsDropped = True
  else
    RGate.open = 0
    RGateWall.IsDropped = False
  End If
End Sub

Sub Sol117(Level)
  dim Enabled:Enabled = Level > 0
  F17.State=Enabled
  F17.Intensity = (Level * 15 / 255)
  F17a.State=Enabled
  F17a.Intensity = (Level * 15 / 255)
  F17b.State=Enabled
  F17b.Intensity = (Level * 15 / 255)
End Sub

Sub Sol118(Level)
  dim Enabled:Enabled = Level > 0
  F18.State=(Enabled)
  F18.Intensity = (Level * 15 / 255)
  F18a.State=(Enabled)
  F18a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol119(Level)
  dim Enabled:Enabled = Level > 0
  F19.State=(Enabled)
  F19.Intensity = (Level * 15 / 255)
  F19a.State=(Enabled)
  F19a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol120(Level)
  dim Enabled:Enabled = Level > 0
  F20.State=(Enabled)
  F20.Intensity = (Level * 15 / 255)
  F20a.State=(Enabled)
  F20a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol121(Level)
  dim Enabled:Enabled = Level > 0
  F21.State=(Enabled)
  F21.Intensity = (Level * 15 / 255)
  F21a.State=(Enabled)
  F21a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol122(Level)
  dim Enabled:Enabled = Level > 0
  F22.State=(Enabled)
  F22.Intensity = (Level * 15 / 255)
  F22a.State=(Enabled)
  F22a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol123(Level)
  dim Enabled:Enabled = Level > 0
  F23.State=(Enabled)
  F23.Intensity = (Level * 15 / 255)
  F23a.State=(Enabled)
  F23a.Intensity = (Level * 15 / 255)
End Sub

Sub Sol124(Level)
  dim Enabled:Enabled = Level > 0
  F24.State=(Enabled)
  F24.Intensity = (Level * 15 / 255)
End Sub

'**************
' Flipper Subs
'**************

SolCallback(sLRFlipper) = "SolRFlipper"
SolCallback(sLLFlipper) = "SolLFlipper"

Sub SolLFlipper(Enabled)
  If Enabled Then
    PlaySoundAt "flipperup",LeftFlipper:LF.fire
  Else
    PlaySoundAt "flipperdown",LeftFlipper:LeftFlipper.RotateToStart
  End If
End Sub

Sub SolRFlipper(Enabled)
  If Enabled Then
    PlaySoundAt "flipperup",RightFlipper:RF.fire
  Else
    PlaySoundAt "flipperdown",RightFlipper:RightFlipper.RotateToStart
  End If
End Sub

'***********
' Update GI
'***********

Dim gistep, xxx
gistep = 1 / 8

Sub UpdateGI2(no, step)
  Select Case no
    Case 0 : For each xxx in GIBOT:xxx.IntensityScale = gistep * step:next
    Case 1 : For each xxx in GITOP:xxx.IntensityScale = gistep * step:next
    Case 2 : For each xxx in GIMID:xxx.IntensityScale = gistep * step:next
    Case 4 : Light80.IntensityScale = gistep * step
  End Select
  if l17.state = 0 then 
	giw32.state = 1
  Else
	giw32.state = 0
  End if
End Sub

'*******************************
'          Mist Magnet
'    taken from Lander's table
' with only a small modification
'*******************************

'-------------------------------
' Magnet Simulator Class
' (07/10/2001 Dorsola)
' Modified for Dracula (08/16/2001) by Dorsola
'-------------------------------

class cMagnet
  Private cX, cY, cStrength, cRange
  private cBalls, cClaimed
  private cTempX, cTempY

  Private Sub Class_Initialize()
      set cBalls = CreateObject("Scripting.Dictionary")
      cRange = 1
      cStrength = 0
  End Sub

  Public Sub InitMagnet(aTrigger, inStrength)
      cX = aTrigger.X
      cY = aTrigger.Y
      cRange = aTrigger.Radius
      cStrength = inStrength
  End Sub

  Public Sub MoveTo(inX, inY)
      cX = inX
      cY = inY
  End Sub

  Public Property Get X:X = cX:End Property
  Public Property Get Y:Y = cY:End Property
  Public Property Get Strength:Strength = cStrength:End Property
  Public Property Get Size:Size = cRange:End Property
  Public Property Get Range:Range = cRange:End Property
  Public Property Get Balls:Balls = cBalls.Keys:End Property

  Public Property Let X(inX):cX = inX:End Property
  Public Property Let Y(inY):cY = inY:End Property
  Public Property Let Strength(inStrength):cStrength = inStrength:End Property
  Public Property Let Size(inSize):cRange = inSize:End Property
  Public Property Let Range(inSize):cRange = inSize:End Property

  Public Sub AddBall(aBall)
      cBalls.Item(aBall) = 0
  End Sub

  Public Sub RemoveBall(aBall)
      ' This function tags balls for removal, but does not remove them.
      ' Another sub will be called to remove tagged objects from the dictionary.
      If cBalls.Exists(aBall) then
          if cClaimed then
              cBalls.Item(aBall) = 1
          else
              cBalls.Remove(aBall)
          end if
      end if
  End Sub

  Public Sub Claim():cClaimed = True:End Sub

  Public Sub Release()
      cClaimed = False
      Dim tempobj
      for each tempobj in cBalls.Keys
          if cBalls.Item(tempobj) = 1 then cBalls.Remove(tempobj)
      next
  End Sub

  Public Sub ProcessBalls()
      Dim tempObj
      for each tempObj in cBalls.Keys:AttractBall tempObj:next
  End Sub

  Public Function GetDist(aBall)
      on error resume next
      if aBall is Nothing then
          GetDist = 100000
      else
          cTempX = aBall.X - cX
          cTempY = aBall.Y - cY
          GetDist = Sqr(cTempX * cTempX + cTempY * cTempY)
          if Err then GetDist = 100000
      end if
  End Function

  Public Sub AttractBall(aBall)
      if aBall is Nothing then Exit Sub
      Dim Dist
      Dist = GetDist(aBall)
      if Dist> cRange then Exit Sub

      ' Attract ball toward magnet center (cX,cY).

      ' Attraction force is determined by distance from center, and strength of magnet.

      Dim Force, Ratio
      Ratio = Dist / (1.5 * cRange)

      ' TODO: Figure out how to dampen the force when ball is near center and
      ' at low velocity, so that balls don't jitter on the magnets.
      ' Also shore up instability on moving magnet.

      Force = cStrength * exp(-0.2 / Ratio) / (Ratio * Ratio * 56)
      aBall.VelX = (aBall.VelX - cTempX * Force / Dist) * 0.985
      aBall.VelY = (aBall.VelY - cTempY * Force / Dist) * 0.985
  End Sub
End Class

'-----------------------------------------------
' Mist Multiball - courtesy of Dorsola
'-----------------------------------------------

' Method: Since any ball that can block the Mist opto is necessarily in the Mist Magnet's trigger area,
' we automatically have access to all balls in this range.  We can therefore check each ball's position
' against a line equation and see if it happens to be blocking the opto, and set the switch accordingly.
' This requires a timer loop.

Dim MagnetOn
MagnetOn = false

Sub MistTimer_Timer()
  ' Endpoints of the line are (108,1247) and (908,895)
  ' Slope: m = (y2-y1)/(x2-x1) = -0.44
  ' Y-intercept: b = y1 - m*x1 = 1294.52

  mMagnet.Claim

  Dim obj, CheckState, x, TargetY
  CheckState = 0
  on error resume next
  for each obj in mMagnet.Balls
      ' y = mx+b (m=slope, b=yint)
      TargetY = (-0.44) * obj.X + 1250.52
      if(obj.Y> TargetY - 25) and(obj.Y <TargetY + 25) then CheckState = 1
  next
  on error goto 0
  Controller.Switch(82) = CheckState
  if MagnetOn then mMagnet.ProcessBalls
  mMagnet.Release
End Sub

Sub SolMistMagnet(enabled)
  MagnetOn = enabled
End Sub

Sub Magnet_Hit()
  mMagnet.AddBall ActiveBall
End Sub

Sub Magnet_UnHit()
  mMagnet.RemoveBall ActiveBall
End Sub

'------------------------
' Handle the Mist Motor
'------------------------
' Method: Treat motor's position as a number from right to left (0-500)
' and compute its position based on the line equation given above.

const motorx1 = 880
const motorx2 = 108
const motorxrange = 800
const motory1 = 850
const motory2 = 1200
const motoryrange = -312
const motorslope = -0.44
const motoryint = 1249.52

' Endpoints of the line are (108,1247) and (908,895)
' Slope: m = (y2-y1)/(x2-x1) = -0.44
' Y-intercept: b = y1 - m*x1 = 1294.52

Dim MagnetPos, MagnetDir
MagnetPos = 0:MagnetDir = 0

' Coding for MagnetDir: 0 = left, 1 = right, toggle at endpoints.

Sub MotorTimer_Timer()
  if Controller.Solenoid(28) then
    if MagnetDir = 0 then
      'MagnetPos = MagnetPos + 1
      MagnetPos = MagnetPos + .6 ' Thalamus
      'mist lights
      Select Case MagnetPos \ 33
        Case 0:ml1.State = 0:ml2.State = 0:ml3.State = 0:ml4.State = 0
          ml5.State = 0:ml6.State = 0:ml7.State = 0:ml8.State = 0
          ml9.State = 0:ml10.State = 0:ml11.State = 0:ml12.State = 0:ml13.State = 0
        Case 1:ml13.State = 1
        Case 2:ml12.State = 1:ml13.State = 0
        Case 3:ml11.State = 1:ml12.State = 0
        Case 4:ml10.State = 1:ml11.State = 0
        Case 5:ml9.State = 1:ml10.State = 0
        Case 6:ml8.State = 1:ml9.State = 0
        Case 7:ml7.State = 1:ml8.State = 0
        Case 8:ml6.State = 1:ml7.State = 0
        Case 9:ml5.State = 1:ml6.State = 0
        Case 10:ml4.State = 1:ml5.State = 0
        Case 11:ml3.State = 1:ml4.State = 0
        Case 12:ml2.State = 1:ml3.State = 0
        Case 13:ml1.State = 1:ml2.State = 0
        Case 14:ml1.State = 0
      End Select

      if MagnetPos >= 500 then
        MagnetPos = 500
        MagnetDir = 1
      end if
    else
      'MagnetPos = MagnetPos - 1
      MagnetPos = MagnetPos - .6 ' Thalamus
      Select Case MagnetPos \ 33
        Case 0:ml1.State = 0:ml2.State = 0:ml3.State = 0:ml4.State = 0
          ml5.State = 0:ml6.State = 0:ml7.State = 0:ml8.State = 0
          ml9.State = 0:ml10.State = 0:ml11.State = 0:ml12.State = 0:ml13.State = 0
        Case 1:ml13.State = 0
        Case 2:ml12.State = 0:ml13.State = 1
        Case 3:ml11.State = 0:ml12.State = 1
        Case 4:ml10.State = 0:ml11.State = 1
        Case 5:ml9.State = 0:ml10.State = 1
        Case 6:ml8.State = 0:ml9.State = 1
        Case 7:ml7.State = 0:ml8.State = 1
        Case 8:ml6.State = 0:ml7.State = 1
        Case 9:ml5.State = 0:ml6.State = 1
        Case 10:ml4.State = 0:ml5.State = 1
        Case 11:ml3.State = 0:ml4.State = 1
        Case 12:ml2.State = 0:ml3.State = 1
        Case 13:ml1.State = 0:ml2.State = 1
        Case 14:ml1.State = 1
      End Select
      if MagnetPos <= 0 then
        MagnetPos = 0
        MagnetDir = 0
      end if
    end if

    SetMagnetPosition
    Controller.Switch(81) = (MagnetPos> 490)
    Controller.Switch(83) = (MagnetPos <10)
  end if
End Sub

Sub SetMagnetPosition()
  mMagnet.X = motorx1 -(motorxrange * (MagnetPos / 500) )
  ' mMagnet.X = motorx1 -(motorxrange * (MagnetPos / 600) )
  mMagnet.Y = motorslope * mMagnet.X + motoryint
  If MagnetPos MOD 33 = 0 Then
    MotorTimer.Interval = 80
  Else
    MotorTimer.Interval = 8
    'MotorTimer.Interval = 10
  End If
End Sub


'******************************************
' Use the motor callback to call div subs
'******************************************

Set MotorCallback = GetRef("RealTimeUpdates")

Sub RealTimeUpdates()
  LFLogo.RotY =  LeftFlipper.CurrentAngle
  RFlogo.RotY =  RightFlipper.CurrentAngle
  WireGateLR.RotX=Spinner2.currentangle
  WireGateLR1.RotX=Spinner1.currentangle
  WireGateLR3.RotY=Spinner3.currentangle

  If L61.State = 1 Then
    setflash 161,1
  else
    setflash 161,0
  End If

  If L62.State = 1 Then
    setflash 162,1
  else
    setflash 162,0
  End If

  If L63.State = 1 Then
    setflash 163,1
  else
    setflash 163,0
  End If

  If l58.state = 1 Then
    setflash 158,1
  else
    setflash 158,0
  End If

  If l21.state = 1 Then
    setflash 121,1
  else
    setflash 121,0
  End If

  If l22.state = 1 Then
    setflash 122,1
  else
    setflash 122,0
  End If

End Sub

Sub Trigger55off_Hit:sw55.Enabled=0:End Sub
Sub Trigger55on_Hit:sw55.Enabled=1:End Sub

Dim dirsrt

Sub shootramp_Timer()
  Select Case dirsrt
    Case 1:
      If ramp_sl.heightbottom = 60 Then
        me.enabled = 0
        ramp_sl.heightbottom = 60
      End If
      ramp_sl.heightbottom = ramp_sl.heightbottom + 1
      Liftramp.ObjRotx = LiftRamp.ObjRotx + 0.25
      LiftRampRod.Z = LiftRampRod.Z + 0.25
      Primitive108.ObjRotx = Primitive108.ObjRotx + 0.25
      Primitive285.ObjRotx = Primitive285.ObjRotx + 0.25
    Case 2:
      If ramp_sl.heightbottom = 0 Then
        me.enabled = 0
        ramp_sl.heightbottom = 0
      End If
      ramp_sl.heightbottom = ramp_sl.heightbottom - 1
      Liftramp.ObjRotx = LiftRamp.ObjRotx - 0.25
      LiftRampRod.Z = LiftRampRod.Z - 0.25
      Primitive108.ObjRotx = Primitive108.ObjRotx - 0.25
      Primitive285.ObjRotx = Primitive285.ObjRotx - 0.25
  End Select
End Sub

Sub sw55_UnHit(): StopSound "subway2" : End Sub

' *******************************************************************************************************
' Positional Sound Playback Functions by DJRobX, Rothbauerw, Thalamus and Herweh
' PlaySound sound, 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 0, 1, AudioFade(ActiveBall)
' *******************************************************************************************************

' Play a sound, depending on the X,Y position of the table element (especially cool for surround speaker setups, otherwise stereo panning only)
' parameters (defaults): loopcount (1), volume (1), randompitch (0), pitch (0), useexisting (0), restart (1))
' Note that this will not work (currently) for walls/slingshots as these do not feature a simple, single X,Y position

Sub PlayXYSound(soundname, tableobj, loopcount, volume, randompitch, pitch, useexisting, restart)
  PlaySound soundname, loopcount, volume, AudioPan(tableobj), randompitch, pitch, useexisting, restart, AudioFade(tableobj)
End Sub

' Set position as table object (Use object or light but NOT wall) and Vol to 1

Sub PlaySoundAt(soundname, tableobj)
  PlaySound soundname, 1, 1, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

' set position as table object and Vol + RndPitch manually

Sub PlaySoundAtVolPitch(sound, tableobj, Vol, RndPitch)
  PlaySound sound, 1, Vol, AudioPan(tableobj), RndPitch, 0, 0, 1, AudioFade(tableobj)
End Sub

'Set all as per ball position & speed.

Sub PlaySoundAtBall(soundname)
  PlaySoundAt soundname, ActiveBall
End Sub

'Set position as table object and Vol manually.

Sub PlaySoundAtVol(sound, tableobj, Volume)
  PlaySound sound, 1, Volume, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

'Set all as per ball position & speed, but Vol Multiplier may be used eg; PlaySoundAtBallVol "sound",3

Sub PlaySoundAtBallVol(sound, VolMult)
  PlaySound sound, 0, Vol(ActiveBall) * VolMult, AudioPan(ActiveBall), 0, Pitch(ActiveBall), 0, 1, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtBallAbsVol(sound, VolMult)
  PlaySound sound, 0, VolMult, AudioPan(ActiveBall), 0, Pitch(ActiveBall), 0, 1, AudioFade(ActiveBall)
End Sub

' requires rampbump1 to 7 in Sound Manager

Sub RandomBump(voladj, freq)
  Dim BumpSnd:BumpSnd= "rampbump" & CStr(Int(Rnd*7)+1)
  PlaySound BumpSnd, 0, Vol(ActiveBall)*voladj, AudioPan(ActiveBall), 0, freq, 0, 1, AudioFade(ActiveBall)
End Sub

' set position as bumperX and Vol manually. Allows rapid repetition/overlaying sound

Sub PlaySoundAtBumperVol(sound, tableobj, Vol)
  PlaySound sound, 1, Vol, AudioPan(tableobj), 0,0,1, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBOTBallZ(sound, BOT)
  PlaySound sound, 0, ABS(BOT.velz)/17, Pan(BOT), 0, Pitch(BOT), 1, 0, AudioFade(BOT)
End Sub

' play a looping sound at a location with volume
Sub PlayLoopSoundAtVol(sound, tableobj, Vol)
  PlaySound sound, -1, Vol, AudioPan(tableobj), 0, 0, 1, 0, AudioFade(tableobj)
End Sub

'*********************************************************************
'                     Supporting Ball & Sound Functions
'*********************************************************************

Function RndNum(min, max)
  RndNum = Int(Rnd() * (max-min + 1) ) + min ' Sets a random number between min and max
End Function

Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
  Dim tmp
  On Error Resume Next
  tmp = tableobj.y * 2 / table1.height-1
  If tmp > 0 Then
    AudioFade = Csng(tmp ^10)
  Else
    AudioFade = Csng(-((- tmp) ^10) )
  End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
  Dim tmp
  On Error Resume Next
  tmp = tableobj.x * 2 / table1.width-1
  If tmp > 0 Then
    AudioPan = Csng(tmp ^10)
  Else
    AudioPan = Csng(-((- tmp) ^10) )
  End If
End Function

Function Pan(ball) ' Calculates the pan for a ball based on the X position on the table. "table1" is the name of the table
  Dim tmp
  On Error Resume Next
  tmp = ball.x * 2 / table1.width-1
  If tmp > 0 Then
    Pan = Csng(tmp ^10)
  Else
    Pan = Csng(-((- tmp) ^10) )
  End If
End Function

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
  Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function VolMulti(ball,Multiplier) ' Calculates the Volume of the sound based on the ball speed
  VolMulti = Csng(BallVel(ball) ^2 / 150 ) * Multiplier
End Function

Function DVolMulti(ball,Multiplier) ' Calculates the Volume of the sound based on the ball speed
  DVolMulti = Csng(BallVel(ball) ^2 / 150 ) * Multiplier
  debug.print DVolMulti
End Function

Function BallRollVol(ball) ' Calculates the Volume of the sound based on the ball speed
  BallRollVol = Csng(BallVel(ball) ^2 / (80000 - (79900 * Log(RollVol) / Log(100))))
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
  Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
  BallVel = INT(SQR((ball.VelX ^2) + (ball.VelY ^2) ) )
End Function

Function BallVelZ(ball) 'Calculates the ball speed in the -Z
  BallVelZ = INT((ball.VelZ) * -1 )
End Function

Function VolZ(ball) ' Calculates the Volume of the sound based on the ball speed in the Z
  VolZ = Csng(BallVelZ(ball) ^2 / 200)*1.2
End Function

'*** Determines if a Points (px,py) is inside a 4 point polygon A-D in Clockwise/CCW order

Function InRect(px,py,ax,ay,bx,by,cx,cy,dx,dy)
  Dim AB, BC, CD, DA
  AB = (bx*py) - (by*px) - (ax*py) + (ay*px) + (ax*by) - (ay*bx)
  BC = (cx*py) - (cy*px) - (bx*py) + (by*px) + (bx*cy) - (by*cx)
  CD = (dx*py) - (dy*px) - (cx*py) + (cy*px) + (cx*dy) - (cy*dx)
  DA = (ax*py) - (ay*px) - (dx*py) + (dy*px) + (dx*ay) - (dy*ax)

  If (AB <= 0 AND BC <=0 AND CD <= 0 AND DA <= 0) Or (AB >= 0 AND BC >=0 AND CD >= 0 AND DA >= 0) Then
    InRect = True
  Else
    InRect = False
  End If
End Function

'*******************************************
'   JP's VP10 Rolling Sounds + Ballshadow
' uses a collection of shadows, aBallShadow
'*******************************************

Const tnob = 5 ' total number of balls
Const lob = 0  'number of locked balls
ReDim rolling(tnob)
InitRolling

Sub InitRolling
  Dim i
  For i = 0 to tnob
    rolling(i) = False
  Next
End Sub

Sub RollingTimer_Timer()
  Dim BOT, b
  BOT = GetBalls
  ' TextBox001.Text = (UBound(BOT))+1

  ' stop the sound of deleted balls
  For b = UBound(BOT) + 1 to tnob
    rolling(b) = False
	' On Error Resume Next
    aBallShadow(b).Visible = 0
    StopSound("fx_ballrolling" & b)
    StopSound("fx_Rolling_Plastic" & b)
    StopSound("fx_Rolling_Metal" & b)
  Next

  ' exit the sub if no balls on the table
  If UBound(BOT) = lob - 1 Then Exit Sub

    ' play the rolling sound for each ball and draw the shadow
    For b = lob to UBound(BOT)

      aBallShadow(b).X = BOT(b).X
      aBallShadow(b).Y = BOT(b).Y
      aBallShadow(b).Height = BOT(b).Z - (BallSize / 2)

      If BallVel(BOT(b)) > 1 Then
        rolling(b) = True

        'Playfield
        If BOT(b).z < 30 Then
          StopSound("fx_Rolling_Metal" & b):StopSound("fx_Rolling_Plastic" & b)
          PlaySound("fx_ballrolling" & b), -1, VolMulti((BOT(b)),VolBRol), Pan(BOT(b) ), 0, Pitch(BOT(b) ), 1, 0, AudioFade(BOT(b) )
        Else
          If InRect(BOT(b).x, BOT(b).y, 344,866,286,376,670,532,670,866) And BOT(b).z < 200 And BOT(b).z > 79 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
      ElseIf InRect(BOT(b).x, BOT(b).y, 293,378,556,176,617,211,363,407) And BOT(b).z < 200 And BOT(b).z > 79 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
      ElseIf InRect(BOT(b).x, BOT(b).y, 816,1183,388,867,529,867,855,1127) And BOT(b).z < 110 And BOT(b).z > 60 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
      ElseIf InRect(BOT(b).x, BOT(b).y, 857,1769,857,1380,944,1380,944,1769) And BOT(b).z < 100 And BOT(b).z > 30 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
      ElseIf InRect(BOT(b).x, BOT(b).y, 89,1476,64,771,275,771,159,1476) And BOT(b).z < 110 And BOT(b).z > 80 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
      ElseIf InRect(BOT(b).x, BOT(b).y, 191,770,210,286,446,771,278,770) And BOT(b).z < 110 And BOT(b).z > 80 Then
            StopSound("fx_ballrolling" & b):StopSound("fx_Rolling_Plastic" & b)
            PlaySound("fx_Rolling_Metal" & b), -1, VolMulti((BOT(b)),VolMRol), Pan(BOT(b) ), 0, Pitch(BOT(b) )*0.1, 1, 0, AudioFade(BOT(b) )
            'Plastic Ramps
          Else
            StopSound("fx_Rolling_Metal" & b):StopSound("fx_ballrolling" & b)
            PlaySound("fx_Rolling_Plastic" & b), -1, VolMulti((BOT(b)),VolPRol), Pan(BOT(b) ), 0, Pitch(BOT(b) ), 1, 0, AudioFade(BOT(b) )
          End If
        End If

      Else
        If rolling(b) = True Then
          StopSound("fx_ballrolling" & b)
          StopSound("fx_Rolling_Plastic" & b)
          StopSound("fx_Rolling_Metal" & b)
          rolling(b) = False
        End If
      End If

      ' play ball drop sounds
      If BOT(b).VelZ < -4 and BOT(b).VelY < 8 And BOT(b).z < 50 and BOT(b).z > 27 Then 'height adjust for ball drop sounds
        PlaySound ("fx_ball_drop" & b), 0, (ABS(BOT(b).velz)/17)*VolDrop, Pan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
      End If

      ' Ball Shadow
      If BallSHW = 1 Then
        aBallShadow(b).Visible = 1
      Else
        aBallShadow(b).Visible = 0
      End If

    Next
End Sub

'**********************
' Ball Collision Sound
'**********************

Sub OnBallBallCollision(ball1, ball2, velocity)
    PlaySound("fx_collide"), 0, Csng(velocity) ^2 / 200, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub

Sub Pins_Hit (idx)
  PlaySound "pinhit_low", 0, VolMulti(ActiveBall,VolPi), Pan(ActiveBall), 0, Pitch(ActiveBall), 0, 0, AudioFade(ActiveBall)
End Sub

Sub Targets_Hit (idx)
  PlaySound "target", 0, VolMulti(ActiveBall,VolTarg), Pan(ActiveBall), 0, Pitch(ActiveBall), 0, 0, AudioFade(ActiveBall)
End Sub

Sub Metals_Thin_Hit (idx)
  RandomSoundMetal()
End Sub

Sub Metals_Medium_Hit (idx)
  PlaySound "metalhit_medium", 0, VolMulti(ActiveBall,VolMetal), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Gates_Hit (idx)
  PlaySound "TOM_Gate3_3", 0, VolMulti(ActiveBall,VolGates), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Metalhit2_Hit (idx)
  PlaySound "fx_metalhit2", 0, VolMulti(ActiveBall,VolMetal), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Spinner_Spin
  PlaySoundAtVol "fx_spinner", Spinner, VolSpin
End Sub

Sub RubberPins_Hit(idx)
  dim finalspeed
    finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
  If finalspeed > 20 then
    PlaySound "rubber_hit_3", 0, VolMulti(ActiveBall,VoLRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
  End if
  If finalspeed >= 6 AND finalspeed <= 20 then
    RandomSoundRubber()
  End If
End Sub

Sub RubberBands_Hit(idx)
  RandomSoundRubber
End Sub

Sub RandomSoundRubber()
  Select Case Int(Rnd*3)+1
    Case 1 : PlaySound "rubber_hit_1", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
    Case 2 : PlaySound "rubber_hit_2", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
    Case 3 : PlaySound "rubber_hit_3", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
  End Select
End Sub

Sub LRubberPins_Hit(idx)
  dim finalspeed
    finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
  If finalspeed > 20 then
    PlaySound "rubber_hit_3", 0, VolMulti(ActiveBall,VoLRH), Pan(ActiveBall), 0, Pitch(ActiveBall)-20000, 1, 0, AudioFade(ActiveBall)
  End if
  If finalspeed >= 6 AND finalspeed <= 20 then
    LRandomSoundRubber()
  End If
End Sub

Sub LRandomSoundRubber()
  Select Case Int(Rnd*3)+1
    Case 1 : PlaySound "rubber_hit_1", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall)-20000, 1, 0, AudioFade(ActiveBall)
    Case 2 : PlaySound "rubber_hit_2", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall)-20000, 1, 0, AudioFade(ActiveBall)
    Case 3 : PlaySound "rubber_hit_3", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall)-20000, 1, 0, AudioFade(ActiveBall)
  End Select
End Sub

' Sub LeftFlipper_Collide(parm)
'   RandomSoundFlipper()
' End Sub
'
' Sub RightFlipper_Collide(parm)
'   RandomSoundFlipper()
' End Sub

Sub Trigger001_Hit
  PlaySound "ramp_hit3", 0, RndNum(50,100)/500 , Pan(ActiveBall), 0, Pitch(ActiveBall)*RndNum(1,8000), AudioFade(Trigger001)
End Sub

Sub Trigger002_Hit
  If RightRamp.Collidable = True Then PlaySound "ramp_hit3", 0, RndNum(50,100)/500 , Pan(ActiveBall), 0, Pitch(ActiveBall)*RndNum(1,8000), AudioFade(Trigger002)
End Sub

' Sub RandomSoundFlipper()
'   Select Case Int(Rnd*3)+1
'     Case 1 : PlaySound "flip_hit_1", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
'     Case 2 : PlaySound "flip_hit_2", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
'     Case 3 : PlaySound "flip_hit_3", 0, VolMulti(ActiveBall,VolRH), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
'   End Select
' End Sub

' Thalamus - shamelessly stolen from TOM

Sub RandomSoundMetal()
  Select Case Int(Rnd*13)+1
    Case 1 : PlaySoundAtVol "TOM_Metal_Touch_1", ActiveBall, VolMetal
    Case 2 : PlaySoundAtVol "TOM_Metal_Touch_2", ActiveBall, VolMetal
    Case 3 : PlaySoundAtVol "TOM_Metal_Touch_3", ActiveBall, VolMetal
    Case 4 : PlaySoundAtVol "TOM_Metal_Touch_4", ActiveBall, VolMetal
    Case 5 : PlaySoundAtVol "TOM_Metal_Touch_5", ActiveBall, VolMetal
    Case 6 : PlaySoundAtVol "TOM_Metal_Touch_6", ActiveBall, VolMetal
    Case 7 : PlaySoundAtVol "TOM_Metal_Touch_7", ActiveBall, VolMetal
    Case 8 : PlaySoundAtVol "TOM_Metal_Touch_8", ActiveBall, VolMetal
    Case 9 : PlaySoundAtVol "TOM_Metal_Touch_9", ActiveBall, VolMetal
    Case 10 : PlaySoundAtVol "TOM_Metal_Touch_10", ActiveBall, VolMetal
    Case 11 : PlaySoundAtVol "TOM_Metal_Touch_11", ActiveBall, VolMetal
    Case 12 : PlaySoundAtVol "TOM_Metal_Touch_12", ActiveBall, VolMetal
    Case 13 : PlaySoundAtVol "TOM_Metal_Touch_13", ActiveBall, VolMetal
  End Select
End Sub

Sub RandomSoundDrain()
  Select Case Int(Rnd*11)+1
    Case 1 : PlaySoundAtVol ("TOM_Drain_1"), Drain, VolDrain
    Case 2 : PlaySoundAtVol ("TOM_Drain_2"), Drain, VolDrain
    Case 3 : PlaySoundAtVol ("TOM_Drain_3"), Drain, VolDrain
    Case 4 : PlaySoundAtVol ("TOM_Drain_4"), Drain, VolDrain
    Case 5 : PlaySoundAtVol ("TOM_Drain_5"), Drain, VolDrain
    Case 6 : PlaySoundAtVol ("TOM_Drain_6"), Drain, VolDrain
    Case 7 : PlaySoundAtVol ("TOM_Drain_7"), Drain, VolDrain
    Case 8 : PlaySoundAtVol ("TOM_Drain_8"), Drain, VolDrain
    Case 9 : PlaySoundAtVol ("TOM_Drain_9"), Drain, VolDrain
    Case 10 : PlaySoundAtVol ("TOM_Drain_10"), Drain, VolDrain
    Case 11 : PlaySoundAtVol ("TOM_Drain_10"), Drain, VolDrain
  End Select
End Sub

Sub RandomSoundRollover()
  Select Case Int(Rnd*4)+1
    Case 1 : PlaySoundAtVol "TOM_Rollover_1", ActiveBall, VolRol
    Case 2 : PlaySoundAtVol "TOM_Rollover_2", ActiveBall, VolRol
    Case 3 : PlaySoundAtVol "TOM_Rollover_3", ActiveBall, VolRol
    Case 4 : PlaySoundAtVol "TOM_Rollover_4", ActiveBall, VolRol
  End Select
End Sub

Sub RandomSoundSlingshotLeft()
  Select Case Int(Rnd*10)+1
    Case 1 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L1_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 2 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L2_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 3 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L3_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 4 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L4_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 5 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L5_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 6 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L6_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 7 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L7_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 8 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L8_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 9 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L9_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 10 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_L10_Strong_Layered",DOFContactors), ActiveBall, VolSling
  End Select
End Sub

Sub RandomSoundSlingshotRight()
  Select Case Int(Rnd*8)+1
    Case 1 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R1_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 2 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R2_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 3 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R3_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 4 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R4_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 5 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R5_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 6 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R6_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 7 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R7_Strong_Layered",DOFContactors), ActiveBall, VolSling
    Case 8 : PlaySoundAtVol SoundFX("TOM_Calle_Sling_Rework_R9_Strong_Layered",DOFContactors), ActiveBall, VolSling
  End Select
End Sub

Sub RandomSoundBumperA()
  Select Case Int(Rnd*5)+1
    Case 1 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Top_1",DOFContactors), ActiveBall, VolBump
    Case 2 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Top_2",DOFContactors), ActiveBall, VolBump
    Case 3 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Top_3",DOFContactors), ActiveBall, VolBump
    Case 4 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Top_4",DOFContactors), ActiveBall, VolBump
    Case 5 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Top_5",DOFContactors), ActiveBall, VolBump
  End Select
End Sub

Sub RandomSoundBumperB()
  Select Case Int(Rnd*5)+1
    Case 1 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Middle_1",DOFContactors), ActiveBall, VolBump
    Case 2 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Middle_2",DOFContactors), ActiveBall, VolBump
    Case 3 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Middle_3",DOFContactors), ActiveBall, VolBump
    Case 4 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Middle_4",DOFContactors), ActiveBall, VolBump
    Case 5 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Middle_5",DOFContactors), ActiveBall, VolBump
  End Select
End Sub

Sub RandomSoundBumperC()
  Select Case Int(Rnd*5)+1
    Case 1 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Bottom_1",DOFContactors), ActiveBall, VolBump
    Case 2 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Bottom_2",DOFContactors), ActiveBall, VolBump
    Case 3 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Bottom_3",DOFContactors), ActiveBall, VolBump
    Case 4 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Bottom_4",DOFContactors), ActiveBall, VolBump
    Case 5 : PlaySoundAtVol SoundFX("TOM_Bumpers_Reworked_v2_Bottom_5",DOFContactors), ActiveBall, VolBump
  End Select
End Sub

Sub LeftFlipperCollide(parm)
	RandomSoundRubberFlipper(parm)
End Sub

Sub RightFlipperCollide(parm)
 	RandomSoundRubberFlipper(parm)
End Sub

Sub RandomSoundRubberFlipper(parm)
	Select Case Int(Rnd*7)+1
		Case 1 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_1", parm
		Case 2 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_2", parm
		Case 3 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_3", parm
		Case 4 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_4", parm
		Case 5 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_5", parm
		Case 6 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_6", parm
		Case 7 : PlaySoundAtBallVol "TOM_Rubber_Flipper_Normal_7", parm
	End Select
End Sub

Sub Table1_Exit
  Controller.Stop
End Sub

' RothFozzy - stuff

'*****************
' RFlipper Timer
'*****************

RightFlipper.timerinterval=1
Rightflipper.timerenabled=True

'********Need to have a flipper timer to check for these values
sub RightFlipper_timer()
	FlipperTricks LeftFlipper, LFPress, LFCount, LFEndAngle, LFState
	FlipperTricks RightFlipper, RFPress, RFCount, RFEndAngle, RFState
end sub

dim LFPress, RFPress, LFCount, RFCount
dim LFState, RFState
dim EOST, EOSA,Frampup, FElasticity,FReturn
dim RFEndAngle, LFEndAngle

EOST = leftflipper.eostorque
EOSA = leftflipper.eostorqueangle
Frampup = LeftFlipper.rampup
FElasticity = LeftFlipper.elasticity
FReturn = LeftFlipper.return
Const EOSTnew = 0.8 	'1.0 FEOST
Const EOSAnew = 1		'0.2
Const EOSRampup = 0	'0.5
Dim SOSRampup
	Select Case FlipperCoilRampupMode
		Case 0:
			SOSRampup = 2.5
		Case 1:
			SOSRampup = 8.5
	End Select
Const LiveCatch = 8
Const LiveElasticity = 0.45
Const SOSEM = 0.815
Const EOSReturn = 0.025

LFEndAngle = Leftflipper.endangle
RFEndAngle = RightFlipper.endangle

Sub FlipperActivate(Flipper, FlipperPress)
	FlipperPress = 1
	Flipper.Elasticity = FElasticity

	Flipper.eostorque = EOST 						'new
	Flipper.eostorqueangle = EOSA 			'new
End Sub

Sub FlipperDeactivate(Flipper, FlipperPress)
	FlipperPress = 0
	Flipper.eostorqueangle = EOSA
	Flipper.eostorque = EOST*EOSReturn/FReturn 	'EOST

	If Abs(Flipper.currentangle) <= Abs(Flipper.endangle) + 0.1 Then
		Dim BOT, b
		BOT = GetBalls

		For b = 0 to UBound(BOT)
			If Distance(BOT(b).x, BOT(b).y, Flipper.x, Flipper.y) < 55 Then 'check for cradle
				If BOT(b).vely >= -0.4 Then BOT(b).vely = -0.4
			End If
		Next
	End If
End Sub

Sub FlipperTricks (Flipper, FlipperPress, FCount, FEndAngle, FState)
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)	'-1 for Right Flipper

	If Abs(Flipper.currentangle) > Abs(Flipper.startangle) - 0.05 Then
		If FState <> 1 Then
			Flipper.rampup = SOSRampup
			Flipper.endangle = FEndAngle - 3*Dir
			Flipper.Elasticity = FElasticity * SOSEM
			FCount = 0
			FState = 1
		End If
	ElseIf Abs(Flipper.currentangle) <= Abs(Flipper.endangle) and FlipperPress = 1 then
		if FCount = 0 Then FCount = GameTime

		If FState <> 2 Then
			Flipper.eostorqueangle = EOSAnew
			Flipper.eostorque = EOSTnew
			Flipper.rampup = EOSRampup
			Flipper.endangle = FEndAngle
			FState = 2
		End If
	Elseif Abs(Flipper.currentangle) > Abs(Flipper.endangle) + 0.01 and FlipperPress = 1 Then
		If FState <> 3 Then
			Flipper.eostorque = EOST						'EOST
			Flipper.eostorqueangle = EOSA				'EOSA
			Flipper.rampup = Frampup
			Flipper.Elasticity = FElasticity
			FState = 3
		End If

	End If
End Sub

Const LiveDistanceMin = 30  'minimum distance in vp units from flipper base live catch dampening will occur
Const LiveDistanceMax = 114  'maximum distance in vp units from flipper base live catch dampening will occur (tip protection)

Sub CheckLiveCatch(ball, Flipper, FCount, parm) 'Experimental new live catch
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)	'-1 for Right Flipper

	if GameTime - FCount < LiveCatch and parm > 6 and ABS(Flipper.x - ball.x) > LiveDistanceMin and ABS(Flipper.x - ball.x) < LiveDistanceMax Then
		If ball.velx * Dir > 0 Then ball.velx = 0
		ball.vely = 0
		ball.angmomx= 0
		ball.angmomy= 0
		ball.angmomz= 0
	End If
End Sub

Sub LeftFlipper_Collide(parm)
	CheckDampen Activeball, LeftFlipper, parm
	CheckLiveCatch Activeball, LeftFlipper, LFCount, parm
	LeftFlipperCollide parm
End Sub

Sub RightFlipper_Collide(parm)
	CheckDampen Activeball, RightFlipper, parm
	CheckLiveCatch Activeball, RightFlipper, RFCount, parm
	RightFlipperCollide parm
End Sub

dim angdamp, veldamp
angdamp = 0.2
veldamp = 0.8

Sub CheckDampen(ball, Flipper, parm)
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)	'-1 for Right Flipper

	If parm > 4 and ABS(Flipper.x - ball.x) < LiveDistanceMin And  Flipper.currentangle = Flipper.endangle Then
		ball.angmomx=ball.angmomx*angdamp
		ball.angmomy=ball.angmomy*angdamp
		ball.angmomz=ball.angmomz*angdamp
		If  ball.velx*Dir > 0 Then ball.velx = ball.velx * veldamp
	End If
End Sub


'******************************************************
'				FLIPPER AND RUBBER CORRECTION
'******************************************************

dim LF : Set LF = New FlipperPolarity
dim RF : Set RF = New FlipperPolarity

InitPolarity

Sub InitPolarity()
	dim x, a : a = Array(LF, RF)
	for each x in a
		'safety coefficient (diminishes polarity correction only)
		'x.AddPoint "Ycoef", 0, RightFlipper.Y-65, 0	'don't mess with these
		x.AddPoint "Ycoef", 0, RightFlipper.Y-65, 1	'disabled
		x.AddPoint "Ycoef", 1, RightFlipper.Y-11, 1

		x.enabled = True
		'x.DebugOn = True : stickL.visible = True : tbpl.visible = True : vpmSolFlipsTEMP.DebugOn = True
		x.TimeDelay = 60

              'Important, this variable is an offset for the speed that the ball travels down the table to determine if the flippers have been fired
							'This is needed because the corrections to ball trajectory should only applied if the flippers have been fired and the ball is in the trigger zones.
							'FlipAT is set to GameTime when the ball enters the flipper trigger zones and if GameTime is less than FlipAT + this time delay then changes to velocity
							'and trajectory are applied.  If the flipper is fired before the ball enters the trigger zone then with this delay added to FlipAT the changes
							'to tragectory and velocity will not be applied.  Also if the flipper is in the final 20 degrees changes to ball values will also not be applied.
							'"Faster" tables will need a smaller value while "slower" tables will need a larger value to give the ball more time to get to the flipper.
							'If this value is not set high enough the Flipper Velocity and Polarity corrections will NEVER be applied.

	Next

	'rf.report "Velocity"
	addpt "Velocity", 0, 0, 	1
	addpt "Velocity", 1, 0.1, 	1.07
	addpt "Velocity", 2, 0.2, 	1.15
	addpt "Velocity", 3, 0.3, 	1.25
	addpt "Velocity", 4, 0.41, 1.05
	addpt "Velocity", 5, 0.65, 	1.0'0.982
	addpt "Velocity", 6, 0.702, 0.968
	addpt "Velocity", 7, 0.95,  0.968
	addpt "Velocity", 8, 1.03, 	0.945

	AddPt "Polarity", 0, 0, 0
	AddPt "Polarity", 1, 0.05, -5.5
	AddPt "Polarity", 2, 0.4, -5.5
	AddPt "Polarity", 3, 0.8, -5.5
	AddPt "Polarity", 4, 0.85, -5.25
	AddPt "Polarity", 5, 0.9, -4.25
	AddPt "Polarity", 6, 0.95, -3.75
	AddPt "Polarity", 7, 1, -3.25
	AddPt "Polarity", 8, 1.05, -2.25
	AddPt "Polarity", 9, 1.1, -1.5
	AddPt "Polarity", 10, 1.15, -1
	AddPt "Polarity", 11, 1.2, -0.5
	AddPt "Polarity", 12, 1.25, 0
	AddPt "Polarity", 13, 1.3, 0

	LF.Object = LeftFlipper
	LF.EndPoint = EndPointLp	'you can use just a coordinate, or an object with a .x property. Using a couple of simple primitive objects
	RF.Object = RightFlipper
	RF.EndPoint = EndPointRp
End Sub

Sub AddPt(aStr, idx, aX, aY)	'debugger wrapper for adjusting flipper script in-game
	dim a : a = Array(LF, RF)
	dim x : for each x in a
		x.addpoint aStr, idx, aX, aY
	Next
End Sub

'Trigger Hit - .AddBall activeball
'Trigger UnHit - .PolarityCorrect activeball

Sub TriggerLF_Hit() : LF.Addball activeball : End Sub
Sub TriggerLF_UnHit() : LF.PolarityCorrect activeball : End Sub
Sub TriggerRF_Hit() : RF.Addball activeball : End Sub
Sub TriggerRF_UnHit() : RF.PolarityCorrect activeball : End Sub

'Methods:
'.TimeDelay - Delay before trigger shuts off automatically. Default = 80 (ms)
'.AddPoint - "Polarity", "Velocity", "Ycoef" coordinate points. Use one of these 3 strings, keep coordinates sequential. x = %position on the flipper, y = output
'.Object - set to flipper reference. Optional.
'.StartPoint - set start point coord. Unnecessary, if .object is used.

'Called with flipper -
'ProcessBalls - catches ball data.
' - OR -
'.Fire - fires flipper.rotatetoend automatically + processballs. Requires .Object to be set to the flipper.

'***************This is flipperPolarity's addPoint Sub
Class FlipperPolarity
	Public DebugOn, Enabled
	Private FlipAt	'Timer variable (IE 'flip at 723,530ms...)
	Public TimeDelay	'delay before trigger turns off and polarity is disabled TODO set time!
	private Flipper, FlipperStart,FlipperEnd, FlipperEndY, LR, PartialFlipCoef
	Private Balls(20), balldata(20)

	dim PolarityIn, PolarityOut
	dim VelocityIn, VelocityOut
	dim YcoefIn, YcoefOut
	Public Sub Class_Initialize
		redim PolarityIn(0) : redim PolarityOut(0) : redim VelocityIn(0) : redim VelocityOut(0) : redim YcoefIn(0) : redim YcoefOut(0)
		Enabled = True : TimeDelay = 50 : LR = 1:  dim x : for x = 0 to uBound(balls) : balls(x) = Empty : set Balldata(x) = new SpoofBall : next
	End Sub

	Public Property let Object(aInput) : Set Flipper = aInput : StartPoint = Flipper.x : End Property
	Public Property Let StartPoint(aInput) : if IsObject(aInput) then FlipperStart = aInput.x else FlipperStart = aInput : end if : End Property
	Public Property Get StartPoint : StartPoint = FlipperStart : End Property
	Public Property Let EndPoint(aInput) : FlipperEnd = aInput.x: FlipperEndY = aInput.y: End Property
	Public Property Get EndPoint : EndPoint = FlipperEnd : End Property
	Public Property Get EndPointY: EndPointY = FlipperEndY : End Property


	Public Sub AddPoint(aChooseArray, aIDX, aX, aY) 'Index #, X position, (in) y Position (out)
		Select Case aChooseArray
			case "Polarity" : ShuffleArrays PolarityIn, PolarityOut, 1 : PolarityIn(aIDX) = aX : PolarityOut(aIDX) = aY : ShuffleArrays PolarityIn, PolarityOut, 0
			Case "Velocity" : ShuffleArrays VelocityIn, VelocityOut, 1 :VelocityIn(aIDX) = aX : VelocityOut(aIDX) = aY : ShuffleArrays VelocityIn, VelocityOut, 0
			Case "Ycoef" : ShuffleArrays YcoefIn, YcoefOut, 1 :YcoefIn(aIDX) = aX : YcoefOut(aIDX) = aY : ShuffleArrays YcoefIn, YcoefOut, 0
		End Select
		if gametime > 100 then Report aChooseArray
	End Sub

	Public Sub Report(aChooseArray) 	'debug, reports all coords in tbPL.text
		if not DebugOn then exit sub
		dim a1, a2 : Select Case aChooseArray
			case "Polarity" : a1 = PolarityIn : a2 = PolarityOut
			Case "Velocity" : a1 = VelocityIn : a2 = VelocityOut
			Case "Ycoef" : a1 = YcoefIn : a2 = YcoefOut
			case else :tbpl.text = "wrong string" : exit sub
		End Select
		dim str, x : for x = 0 to uBound(a1) : str = str & aChooseArray & " x: " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		tbpl.text = str
	End Sub

  '********Triggered by a ball hitting the flipper trigger area
	Public Sub AddBall(aBall) : dim x : for x = 0 to uBound(balls) : if IsEmpty(balls(x)) then set balls(x) = aBall : exit sub :end if : Next  : End Sub

	Private Sub RemoveBall(aBall)
		dim x : for x = 0 to uBound(balls)
			if TypeName(balls(x) ) = "IBall" then
				if aBall.ID = Balls(x).ID Then
					balls(x) = Empty
					Balldata(x).Reset
				End If
			End If
		Next
	End Sub

  '*********Used to rotate flipper since this is removed from the key down for the flippers
	Public Sub Fire()
		Flipper.RotateToEnd
		processballs
	End Sub

	Public Property Get Pos 'returns % position a ball. For debug stuff.
		dim x : for x = 0 to uBound(balls)
			if not IsEmpty(balls(x) ) then
				pos = pSlope(Balls(x).x, FlipperStart, 0, FlipperEnd, 1)
			End If
		Next
	End Property

	Public Sub ProcessBalls() 'save data of balls in flipper range
		FlipAt = GameTime
		dim x : for x = 0 to uBound(balls)
			if not IsEmpty(balls(x) ) then
				balldata(x).Data = balls(x)
			End If
		Next
		PartialFlipCoef = ((Flipper.StartAngle - Flipper.CurrentAngle) / (Flipper.StartAngle - Flipper.EndAngle))
		PartialFlipCoef = abs(PartialFlipCoef-1)
	End Sub

  '***********gameTime is a global variable of how long the game has progressed in ms
  '***********This function lets the table know if the flipper has been fired

	Private Function FlipperOn()
'		TB.text = gameTime & ":" & (FlipAT + TimeDelay) ' ******UNCOMMENT THIS WHEN THIS FLIPPER FUNCTIONALITY IS ADDED TO A NEW TABLE TO CHECK IF THE TIME DELAY IS LONG ENOUGH*****
		if gameTime < FlipAt + TimeDelay then FlipperOn = True
	End Function	'Timer shutoff for polaritycorrect

'***********This is turned on when a ball leaves the flipper trigger area
	Public Sub PolarityCorrect(aBall)
		if FlipperOn() then 'don't run this if the flippers are at rest
			dim tmp, BallPos, x, IDX, Ycoef : Ycoef = 1

			'y safety Exit
			if aBall.VelY > -8 then 'ball going down
				RemoveBall aBall
				exit Sub
			end if

			'Find balldata. BallPos = % on Flipper
			for x = 0 to uBound(Balls)
				if aBall.id = BallData(x).id AND not isempty(BallData(x).id) then
					idx = x
					BallPos = PSlope(BallData(x).x, FlipperStart, 0, FlipperEnd, 1)
					if ballpos > 0.65 then  Ycoef = LinearEnvelope(BallData(x).Y, YcoefIn, YcoefOut)				'find safety coefficient 'ycoef' data
				end if
			Next

			If BallPos = 0 Then 'no ball data meaning the ball is entering and exiting pretty close to the same position, use current values.
				BallPos = PSlope(aBall.x, FlipperStart, 0, FlipperEnd, 1)
				if ballpos > 0.65 then  Ycoef = LinearEnvelope(aBall.Y, YcoefIn, YcoefOut)						'find safety coefficient 'ycoef' data
			End If

			'Velocity correction
			if not IsEmpty(VelocityIn(0) ) then
				Dim VelCoef
	 : 			VelCoef = LinearEnvelope(BallPos, VelocityIn, VelocityOut)

				if partialflipcoef < 1 then VelCoef = PSlope(partialflipcoef, 0, 1, 1, VelCoef)

				if Enabled then aBall.Velx = aBall.Velx*VelCoef
				if Enabled then aBall.Vely = aBall.Vely*VelCoef
			End If

			'Polarity Correction (optional now)
			if not IsEmpty(PolarityIn(0) ) then
				If StartPoint > EndPoint then LR = -1	'Reverse polarity if left flipper
				dim AddX : AddX = LinearEnvelope(BallPos, PolarityIn, PolarityOut) * LR

				if Enabled then aBall.VelX = aBall.VelX + 1 * (AddX*ycoef*PartialFlipcoef)
				'debug.print BallPos & " " & AddX & " " & Ycoef & " "& PartialFlipcoef & " "& VelCoef
				'playsound "fx_knocker"
			End If
		End If
		RemoveBall aBall
	End Sub
End Class


'================================
'Helper Functions

Sub ShuffleArray(ByRef aArray, byVal offset) 'shuffle 1d array
	dim x, aCount : aCount = 0
	redim a(uBound(aArray) )
	for x = 0 to uBound(aArray)	'Shuffle objects in a temp array
		if not IsEmpty(aArray(x) ) Then
			if IsObject(aArray(x)) then
				Set a(aCount) = aArray(x)
			Else
				a(aCount) = aArray(x)
			End If
			aCount = aCount + 1
		End If
	Next
	if offset < 0 then offset = 0
	redim aArray(aCount-1+offset)	'Resize original array
	for x = 0 to aCount-1		'set objects back into original array
		if IsObject(a(x)) then
			Set aArray(x) = a(x)
		Else
			aArray(x) = a(x)
		End If
	Next
End Sub

Sub ShuffleArrays(aArray1, aArray2, offset)
	ShuffleArray aArray1, offset
	ShuffleArray aArray2, offset
End Sub

Function BallSpeed(ball) 'Calculates the ball speed
    BallSpeed = SQR(ball.VelX^2 + ball.VelY^2 + ball.VelZ^2)
End Function

Function PSlope(Input, X1, Y1, X2, Y2)	'Set up line via two points, no clamping. Input X, output Y
	dim x, y, b, m : x = input : m = (Y2 - Y1) / (X2 - X1) : b = Y2 - m*X2
	Y = M*x+b
	PSlope = Y
End Function

Function NullFunctionZ(aEnabled):End Function	'1 argument null function placeholder	 TODO move me or replac eme

Class spoofball
	Public X, Y, Z, VelX, VelY, VelZ, ID, Mass, Radius
	Public Property Let Data(aBall)
		With aBall
			x = .x : y = .y : z = .z : velx = .velx : vely = .vely : velz = .velz
			id = .ID : mass = .mass : radius = .radius
		end with
	End Property
	Public Sub Reset()
		x = Empty : y = Empty : z = Empty  : velx = Empty : vely = Empty : velz = Empty
		id = Empty : mass = Empty : radius = Empty
	End Sub
End Class

Function Distance(ax,ay,bx,by)
	Distance = SQR((ax - bx)^2 + (ay - by)^2)
End Function

Function DistancePL(px,py,ax,ay,bx,by) ' Distance between a point and a line where point is px,py
	DistancePL = ABS((by - ay)*px - (bx - ax) * py + bx*ay - by*ax)/Distance(ax,ay,bx,by)
End Function

'****************************************************************************
'PHYSICS DAMPENERS

'These are data mined bounce curves,
'dialed in with the in-game elasticity as much as possible to prevent angle / spin issues.
'Requires tracking ballspeed to calculate COR

' Thalamus - not used. No plans for it at this moment either.

Sub dPosts_Hit(idx)
	RubbersD.dampen Activeball
End Sub

Sub dSleeves_Hit(idx)
	SleevesD.Dampen Activeball
End Sub

dim RubbersD : Set RubbersD = new Dampener	'frubber
RubbersD.name = "Rubbers"
RubbersD.debugOn = False	'shows info in textbox "TBPout"
RubbersD.Print = False	'debug, reports in debugger (in vel, out cor)
'cor bounce curve (linear)
'for best results, try to match in-game velocity as closely as possible to the desired curve
'RubbersD.addpoint 0, 0, 0.935	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 0, 0, 0.935 '0.96	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 1, 3.77, 0.935 '0.96
RubbersD.addpoint 2, 5.76, 0.942 '0.967	'dont take this as gospel. if you can data mine rubber elasticitiy, please help!
RubbersD.addpoint 3, 15.84, 0.874
RubbersD.addpoint 4, 56, 0.64	'there's clamping so interpolate up to 56 at least

dim SleevesD : Set SleevesD = new Dampener	'this is just rubber but cut down to 85%...
SleevesD.name = "Sleeves"
SleevesD.debugOn = False	'shows info in textbox "TBPout"
SleevesD.Print = False	'debug, reports in debugger (in vel, out cor)
SleevesD.CopyCoef RubbersD, 0.85

Class Dampener
	Public Print, debugOn 'tbpOut.text
	public name, Threshold 	'Minimum threshold. Useful for Flippers, which don't have a hit threshold.
	Public ModIn, ModOut
	Private Sub Class_Initialize : redim ModIn(0) : redim Modout(0): End Sub

	Public Sub AddPoint(aIdx, aX, aY)
		ShuffleArrays ModIn, ModOut, 1 : ModIn(aIDX) = aX : ModOut(aIDX) = aY : ShuffleArrays ModIn, ModOut, 0
		if gametime > 100 then Report
	End Sub

	public sub Dampen(aBall)
		if threshold then if BallSpeed(aBall) < threshold then exit sub end if end if
		dim RealCOR, DesiredCOR, str, coef
		DesiredCor = LinearEnvelope(cor.ballvel(aBall.id), ModIn, ModOut )
		RealCOR = BallSpeed(aBall) / cor.ballvel(aBall.id)
		coef = desiredcor / realcor
		if debugOn then str = name & " in vel:" & round(cor.ballvel(aBall.id),2 ) & vbnewline & "desired cor: " & round(desiredcor,4) & vbnewline & _
		"actual cor: " & round(realCOR,4) & vbnewline & "ballspeed coef: " & round(coef, 3) & vbnewline
		if Print then debug.print Round(cor.ballvel(aBall.id),2) & ", " & round(desiredcor,3)

		aBall.velx = aBall.velx * coef : aBall.vely = aBall.vely * coef
		'playsound "fx_knocker"
		if debugOn then TBPout.text = str
	End Sub

	Public Sub CopyCoef(aObj, aCoef) 'alternative addpoints, copy with coef
		dim x : for x = 0 to uBound(aObj.ModIn)
			addpoint x, aObj.ModIn(x), aObj.ModOut(x)*aCoef
		Next
	End Sub

	Public Sub Report() 	'debug, reports all coords in tbPL.text
		if not debugOn then exit sub
		dim a1, a2 : a1 = ModIn : a2 = ModOut
		dim str, x : for x = 0 to uBound(a1) : str = str & x & ": " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		TBPout.text = str
	End Sub

End Class

'Tracks ball velocity for judging bounce calculations & angle
'apologies to JimmyFingers is this is what his script does. I know his tracks ball velocity too but idk how it works in particular
dim cor : set cor = New CoRTracker
cor.debugOn = False
'cor.update() - put this on a low interval timer
Class CoRTracker
	public DebugOn 'tbpIn.text
	public ballvel

	Private Sub Class_Initialize : redim ballvel(0) : End Sub
	'TODO this would be better if it didn't do the sorting every ms, but instead every time it's pulled for COR stuff
	Public Sub Update()	'tracks in-ball-velocity
		dim str, b, AllBalls, highestID : allBalls = getballs
		'if uBound(allballs) < 0 then if DebugOn then str = "no balls" : TBPin.text = str : exit Sub else exit sub end if: end if
		for each b in allballs
			if b.id >= HighestID then highestID = b.id
		Next

		if uBound(ballvel) < highestID then redim ballvel(highestID)	'set bounds

		for each b in allballs
			ballvel(b.id) = BallSpeed(b)
'			if DebugOn then
'				dim s, bs 'debug spacer, ballspeed
'				bs = round(BallSpeed(b),1)
'				if bs < 10 then s = " " else s = "" end if
'				str = str & b.id & ": " & s & bs & vbnewline
'				'str = str & b.id & ": " & s & bs & "z:" & b.z & vbnewline
'			end if
		Next
		'if DebugOn then str = "ubound ballvels: " & ubound(ballvel) & vbnewline & str : if TBPin.text <> str then TBPin.text = str : end if
	End Sub
End Class

Function LinearEnvelope(xInput, xKeyFrame, yLvl)
	dim y 'Y output
	dim L 'Line
	dim ii : for ii = 1 to uBound(xKeyFrame)	'find active line
		if xInput <= xKeyFrame(ii) then L = ii : exit for : end if
	Next
	if xInput > xKeyFrame(uBound(xKeyFrame) ) then L = uBound(xKeyFrame)	'catch line overrun
	Y = pSlope(xInput, xKeyFrame(L-1), yLvl(L-1), xKeyFrame(L), yLvl(L) )

	'Clamp if on the boundry lines
	'if L=1 and Y < yLvl(LBound(yLvl) ) then Y = yLvl(lBound(yLvl) )
	'if L=uBound(xKeyFrame) and Y > yLvl(uBound(yLvl) ) then Y = yLvl(uBound(yLvl) )
	'clamp 2.0
	if xInput <= xKeyFrame(lBound(xKeyFrame) ) then Y = yLvl(lBound(xKeyFrame) ) 	'Clamp lower
	if xInput >= xKeyFrame(uBound(xKeyFrame) ) then Y = yLvl(uBound(xKeyFrame) )	'Clamp upper

	LinearEnvelope = Y
End Function

