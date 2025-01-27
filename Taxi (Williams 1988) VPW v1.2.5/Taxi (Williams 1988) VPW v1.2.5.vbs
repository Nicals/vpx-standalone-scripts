' Taxi - IPDB No. 2505
' © Williams 1988
' https://www.ipdb.org/machine.cgi?id=2505
'
'*** V-Pin Workshop TFTC Team ***
'Tomate - Project Manager, new primitives and textures.
'Bord - nFozzy flippers and physics
'apophis - Fleep sound, rtx shadows, general tweaks.
'Sixtoe - VR Stuff, lots of fiddling about.
'oqqsan - Playfield inserts and fading GI.
'UnclePaulie - VR backbox improvements & fixes.
'fluffhead35 - Physics tweaks.
'
'Based on the Taxi VPX v1.2 table by ICPJuggla, Mfuegemann, Dark & Ben Logan.
'
'**CHANGE LOG **
' 001 - bord -  Added nFozzy flippers and physics
' 002 - apophis - Added Fleep sound package
' 003 - apophis - Added missing knockerposition prim
' 004 - tomate - New flippers prims added
' 005 - tomate - Shadows flippers size fixed
' 006 - Sixtoe - VR stuff, fully operational built in backbox / dmd / backglass, fixed loads of light and glow weirdness, unified timers, added cabinet mode.
' 007 - tomate - upper left VUK direction corrected, exits of collidable wireRamps fixed, metal wall near express lane2 fixed, cab POV corrected
' 009 - tomate - new giOn baked textures added, warm lut added, plastic Ramps textures retouched with a warm photo filter to match 
' 010 - tomate - some giOff textures aded, slingshots missing sounds fixed, deformed slings rubbers replaced by prims
' 011 - oqqsan - inserts and 4step sidewalls and pf  .. needs adjustments 
' 012 - tomate - rest of giOff textures added, plastics textures added to 4 steps fade, some GI lights repositioned, textures size optimized
' 013 - Sixtoe - Removed one set of GI, hooked it all back up and dropped under playfield, tidied up assets, set old walls to non-visible to stop clashes, played with loads of lights, removed redundant scripts and images.
' 014 - iaakki - fiddled with GI steps and PF flasher. Fixed flip shadow DP and Z issues. tied some prims to gi steps
' 015 - apophis - Replaced the ringing_bell sound effect. Increased alpha mask on PF images to get rid of insert jaggies. Increased inserts DL. Fixed BS DB.
' 016 - apophis - Added RTX BS. Fixed GI lights so that ball reflection work now.
' 017 - UnclePaulie - Animated the VR backglass flasher Lights.  Fixed the jackpot displays.  Hid the desktop / cabinet mode backbox lights. Moved ball shadow primatives.  Added a VRCab bottom so you can't see the floor through cab.
' 018 - apophis - Updated RTX BS. Added target bouncer, flipper rubberizer, and flipper coil ramp up options. Fixed ball bouncing out left outlane after ramp drop.
' 019 - Sixtoe - Fixed playfield rendering weirdly, numerous other tweaks and adjustments, adjusted some lights, put the roof back on the spinout
' 020 - apophis - Fixed RTX shadow DB issue. Chnaged rampsDecals DL from below to 0 and DB to -100. Added a differnt ball HDR. Messed with the DT mode backglass.
' 021 - fluffhead35 - Updated Flipper Physics to be inline with nfozzy
' 022 - Sixtoe - Added physical wires under flippers and outlanes, hooked up bumpers to GI system, adjust shooter lane gate, messed around the table lights again including materials, set height walls to non-collidable.
' 023 - Sixtoe - Fixed GI, added bumper bulbs to GI system, some small tweaks and fixes here and there.
' 024 - apophis - Revered the DT backglass object positions. Force GI on at table initialization. Changed flipper DB. Increased plunger strength/speed. Increased target hit volume.
' 025 - iaakki - flip trigger areas reworked, rdampen 10ms timer added, rubberizer options added, catapult timer improved, tied drop target DL to GI, fixed insert fading for few inserts
' 026 - apophis - finished up fixing inserts fading
' 027 - Sixtoe - Target bounce set to 1.5
' 1.01 - iaakki - Null error fix workaround, Wall009 added near apron, Wall010, Wall011, Wall012 added everywhere, GI bulbs reworked, RTXBS adjusted.
' 1.02 - Sixtoe - Added denoised playfield, adjusted some gi things, fixed broken primitive shooter walls, removed duplicate post prim, hooked up bulb prims to GI system, fixed several duplicate and wrong position prims, added original red flipper optionm, updated description
' 1.1 - Sixtoe - Fixed blocker wall problems
' 1.2 - apophis - Fixed divide by zero bug
' 1.2.1 - apophis - removed ball shadow z-position dependency on ball z-position. Fixed walls_hit function.
' 1.2.2 - Hauntfreaks - New DT backdrop, and fixed up the DT lights (I didnt touch anything on the table)
' 1.2.3 - tomate - Clark Kent plastic ramps primitive added, collidable ramps fixed, some tweaks on decals, screws, plastics and wireramps prims to match the new geometry, some DB issues fixed
' 1.2.4 - tomate - Bumpers baked textures added, plastics divided in two to avoid DB issues
' 1.2.4c - oqqsan - Bumpers caps separated and DL randomness added
' 1.2.4d - tomate - Some fixes at the collidable ramps so when the ball drains doesn't touch the post

Option Explicit
 
On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the controller.vbs in order to run this table, available in the vp10 package"
On Error Goto 0

'///////////////////////-----General Sound Options-----///////////////////////
'// VolumeDial:
'// VolumeDial is the actual global volume multiplier for the mechanical sounds.
'// Values smaller than 1 will decrease mechanical sounds volume.
'// Recommended values should be no greater than 1.
Const VolumeDial = 0.8

'///////////////////////-----VR Room-----///////////////////////
Const VRRoom = 0			'0 - VR Room off, 1 - Minimal Room, 2 - Ultra Minimal

'/////////////////////-----Cabinet Mode-----/////////////////////
Const CabinetMode = 0		'0 - Off, 1 - Hides rails & scales side panels

'/////////////////////-----Ball Shadows-----/////////////////////
Const RtxBSon = 1			'0 = no RTX ball shadow, 1 = enable RTX ball shadow

'/////////////////////----Flipper Colour----/////////////////////
Const FlipperColour = 1		'0 = Blue / Yellow, 1 = Red / Yellow

'/////////////////////-----Physics Mods-----/////////////////////
Const RubberizerEnabled =	1 		'0 = normal flip rubber, 1 = more lively rubber for flips, 2 = different rubberizer
Const FlipperCoilRampupMode = 0     '0 = fast, 1 = medium, 2 = slow (tap passes should work)
Const TargetBouncerEnabled = 1 		'0 = normal standup targets, 1 = bouncy targets
Const TargetBouncerFactor = 1.0   	'Level of bounces. 0.2 - 1.5 are probably usable values.

Const cGameName = "taxi_l4"
Const UseSolenoids = 2
Const UseLamps = 0
Const UseSync = 1

Const BallSize = 50
Const BallMass = 1

LoadVPM "01560000", "S11.VBS", 3.26

Dim DesktopMode: DesktopMode = Taxi.ShowDT

'-----------------------------------
'------  Solenoid Assignment  ------
'-----------------------------------
SolCallback(1) = "bsTrough.SolIn"
SolCallback(2) = "bsTrough.SolOut"
SolCallback(3) = "SolCatapult"
SolCallback(4) = "CenterDTBank.SolDropUp"
SolCallback(5) = "bsTopHole.SolOut"
SolCallback(6) = "RightDTBank.SolDropUp"
SolCallback(7) = "SolSpinoutKicker"
SolCallback(8) = "bsRightHole.SolOut"
Solcallback(9) = "TopGateLeft.open ="
SolCallback(10) = "Sol10" 'Insert Gen Illum Relay
SolCallback(11) = "Sol11" 'Playfield Gen Illumination
'SolCallback(12) = 'A/C Select Relay
SolCallback(13) = "vpmSolSound SoundFX(""ringing_bell"",DOFBell),"
SolCallback(14) = "SolKnocker"
'SolCallback(15) = 'JACKPOT Flasher - handled in LampTimer
SolCallback(16) = "SetLamp 116,"	'JOYRIDE Flasher - handled in LampTimer too
'SolCallback(17) = 'Bumper
'SolCallback(18) = 'Sling
'SolCallback(19) = 'Bumper
'SolCallback(20) = 'Sling
'SolCallback(21) = 'Bumper
SolCallback(23) = "SolGameOn"
SolCallback(25) = "SetLamp 125,"   'Pinbot Insert - handled in LampTimer
SolCallback(26) = "SetLamp 126,"   'Drac Insert   - handled in LampTimer
SolCallback(27) = "SetLamp 127,"   'Lola Insert   - handled in LampTimer
SolCallback(28) = "SetLamp 128,"   'Santa Insert  - handled in LampTimer
SolCallback(29) = "SetLamp 129,"   'Gorby Insert  - handled in LampTimer
SolCallback(30) = "SetLamp 130,"	'Left Ramp Flasher
SolCallback(31) = "SetLamp 131,"	'Right Ramp Flasher
SolCallback(32) = "SetLamp 132,"	'Spinout Flasher


Dim FlipperActive
FlipperActive = False
Sub SolGameOn(enabled)
	FlipperActive = enabled
	VpmNudge.SolGameOn(enabled)
	if not FlipperActive then
		RightFlipper.RotateToStart
		LeftFlipper.RotateToStart	
	end if
End Sub

'Catapult
Sub SolCatapult(enabled)
	if enabled then
		FireCatapult
		if Controller.Switch(35) then
			bsCatapult.ExitSol_On
		end If
	end if
End Sub

Sub SolKnocker(Enabled)
    If enabled Then
        KnockerSolenoid 'Add knocker position object
    End If
End Sub

Dim CatapultDir
Sub FireCatapult
	catapultLaunchKicker.Timerenabled = False
	CatapultDir = 15
	catapultLaunchKicker.Timerenabled = True
End Sub

Sub catapultLaunchKicker_Timer
	P_Catapult.rotx = P_Catapult.rotx + CatapultDir
	if P_Catapult.rotx > 90 then
		P_Catapult.rotx = 90
		CatapultDir = -5
	end if
	if P_Catapult.rotx < 0 then
		catapultLaunchKicker.Timerenabled = False
		P_Catapult.rotx = 0
		CatapultDir = 0
	end if
end Sub

'Spinout Kicker
Sub SolSpinoutKicker(enabled)
	if enabled then
		bsSpinOutKicker.ExitSol_On
		P_Spinout.TransZ = -60
		SpinOutKicker.Timerenabled = True
	end if
End Sub

Sub SpinOutKicker_Timer
	P_Spinout.TransZ = P_Spinout.TransZ + 1
	if P_Spinout.TransZ >= 0 then
		SpinOutKicker.Timerenabled = False
		P_Spinout.TransZ = 0
	end if
end Sub

' GI
Sub Sol10(enabled)
	SetLamp 99,enabled	'#99 used for GI Inserts
End Sub

Dim bumperpower1, bumperpower2, bumperpower3
Dim GIstep : GIstep=2
Dim GiTarget : GiTarget=1
Dim BumpGI
Sub Imagetimer



	if Gistep = -1 then
		If bumperpower1=2 Then bumperpower1=0 : caps_prim001.blenddisablelighting = rnd(1)/8+1
		If bumperpower1=1 Then bumperpower1=2 : caps_prim001.blenddisablelighting = rnd(1)/2+0.5
		If bumperpower2=2 Then bumperpower2=0 : caps_prim002.blenddisablelighting = rnd(1)/8+1
		If bumperpower2=1 Then bumperpower2=2 : caps_prim002.blenddisablelighting = rnd(1)/2+0.5
		If bumperpower3=2 Then bumperpower3=0 : caps_prim003.blenddisablelighting = rnd(1)/8+1
		If bumperpower3=1 Then bumperpower3=2 : caps_prim003.blenddisablelighting = rnd(1)/2+0.5
	Else

		If Gistep>GITarget Then
			GIstep=GIstep-1
	'		Taxi.image="Taxi_PF0" & GIstep : debug.print GIstep 
			SideWood1.image="giCab_" & GIstep
			SideWood.image="giCab_" & GIstep
			plastics.image="giPlastics_" & GIstep
			plasticsUpper.image="giPlastics_" & GIstep
			caps_prim001.image="giCaps_" & GIstep
			caps_prim002.image="giCaps_" & GIstep
			caps_prim003.image="giCaps_" & GIstep

		End If

		If Gistep<GITarget Then
			GIstep=GIstep+1
	'		Taxi.image="Taxi_PF0" & GIstep : debug.print gistep 
			SideWood1.image="giCab_" & GIstep
			SideWood.image="giCab_" & GIstep
			plastics.image="giPlastics_" & GIstep
			plasticsUpper.image="giPlastics_" & GIstep
			caps_prim001.image="giCaps_" & GIstep
			caps_prim002.image="giCaps_" & GIstep
			caps_prim003.image="giCaps_" & GIstep
		End If
		caps_prim001.blenddisablelighting = (5-gistep)*0.25
		
		if GIstep = 1 Then
			Playfield_Flasher.opacity=0
			Playfield_Flasher.visible = False
			Primitive_Ramp2.blenddisablelighting = 1.3
			Primitive_SpintoutRamp.blenddisablelighting = 0.2
			for each BumpGI in Bumperlamps:BumpGI.blenddisablelighting = 20:Next
			for each BumpGI in Bumper_Col:BumpGI.blenddisablelighting = 2:Next
			RFLogo.blenddisablelighting = 0.5 : LFLogo.blenddisablelighting = 0.5
'			caps_prim.blenddisablelighting = 1
			GIstep = -1
		elseif GIstep = 4 Then
			Playfield_Flasher.opacity=100
			Playfield_Flasher.visible = True
			Primitive_Ramp2.blenddisablelighting = 0.3
			Primitive_SpintoutRamp.blenddisablelighting = 0
			for each BumpGI in Bumperlamps:BumpGI.blenddisablelighting = 0:Next
			for each BumpGI in Bumper_Col:BumpGI.blenddisablelighting = 0:Next
			RFLogo.blenddisablelighting = 0.3 : LFLogo.blenddisablelighting = 0.3
'			caps_prim.blenddisablelighting = 0.3
			GIstep = -1
		Else
			Playfield_Flasher.opacity= (GIstep-1)*33
			Playfield_Flasher.visible = True
			Primitive_Ramp2.blenddisablelighting = (1-(((GIstep-1)*33)/100)) + 0.3
			Primitive_SpintoutRamp.blenddisablelighting = 0.2 * (1-(((GIstep-1)*33)/100))
			for each BumpGI in Bumperlamps:BumpGI.blenddisablelighting = (1-(((GIstep-1)*33)/100)) + 19:Next
			for each BumpGI in Bumper_Col:BumpGI.blenddisablelighting = (1-(((GIstep-1)*33)/100)) + 1:Next
			LFLogo.blenddisablelighting = 0.2 * (1-(((GIstep-1)*33)/100)) + 0.3
			RFLogo.blenddisablelighting = 0.2 * (1-(((GIstep-1)*33)/100)) + 0.3
'			caps_prim.blenddisablelighting = 0.2 * (1-(((GIstep-1)*33)/100)) + 0.3
		end if


		'debug.print Gistep & " - " & (((GIstep-1)*33)/100) & " --> " & Primitive_Ramp2.blenddisablelighting

	end if

		

End Sub

dim obj
Sub Sol11(enabled)		'inverse action, GI is Off if Solenoid is enabled
	dim x

	If enabled Then
		GiTarget=4 : GIstep=1
		debug.print "GIOFF"
		Primitive_Ramp2.image = "giOff_ramps"
		expressLanes.image="giOff_expressLanes"
		rampsDecals.image="giOff_expressLanes"
		metals01.image="giOff_metals"
		backwallPrim.image="giOff_backwall"
		wireRamps.image="giOff_wireramps"
		rubbers_prim.image="giOff_rubbers"
		LSling.image="giOff_rubbers"
		LSling1.image="giOff_rubbers"
		LSling2.image="giOff_rubbers"
		RSling.image="giOff_rubbers"
		RSling1.image="giOff_rubbers"
		RSling2.image="giOff_rubbers"
		screws.image="giOff_screws"
		bumpers_prim.image="giOff_bumperBody"

		For each x in Targets
			x.blenddisablelighting = 0
		Next

		For each x in GI
			x.State = 0
		Next
	Else
		GiTarget=1 : Gistep=4
		debug.print "GION"
		Primitive_Ramp2.image = "giOn_ramps"
		expressLanes.image="giOn_expressLanes"
		rampsDecals.image="giOn_expressLanes"
		metals01.image="giOn_metals"
		backwallPrim.image="giOn_backwall"
		wireRamps.image="giOn_wireramps"
		rubbers_prim.image="giOn_rubbers"
		LSling.image="giOn_rubbers"
		LSling1.image="giOn_rubbers"
		LSling2.image="giOn_rubbers"
		RSling.image="giOn_rubbers"
		RSling1.image="giOn_rubbers"
		RSling2.image="giOn_rubbers"
		screws.image="giOn_screws"
		bumpers_prim.image="giOn_bumperBody"

		For each x in Targets
			x.blenddisablelighting = 0.3
		Next

		For each x in GI
			x.State = 1
		Next
	end If	
End Sub


Sub Gametimer_Timer()
	FlipperTimer
	DTCheckTimer
	RollingTimer
	LampTimer
	'rdampen
	Displaytimer
	Imagetimer

	If VRRoom<>0 then

		If Controller.Lamp(1) = 0 Then: bg_f1.visible=0: else: bg_f1.visible=1
		If Controller.Lamp(2) = 0 Then: bg_f2.visible=0: else: bg_f2.visible=1
		If Controller.Lamp(3) = 0 Then: bg_f3.visible=0: else: bg_f3.visible=1
		If Controller.Lamp(4) = 0 Then: bg_f4.visible=0: else: bg_f4.visible=1
		If Controller.Lamp(5) = 0 Then: bg_f5.visible=0: else: bg_f5.visible=1

		If Controller.Lamp(24) = 0 Then: PinCab_BG_s24.visible=0: else: PinCab_BG_s24.visible=1
		If Controller.Lamp(25) = 0 Then: PinCab_BG_s25.visible=0: else: PinCab_BG_s25.visible=1
		If Controller.Lamp(26) = 0 Then: PinCab_BG_s26.visible=0: else: PinCab_BG_s26.visible=1
		If Controller.Lamp(27) = 0 Then: PinCab_BG_s27.visible=0: else: PinCab_BG_s27.visible=1
		If Controller.Lamp(28) = 0 Then: PinCab_BG_s28.visible=0: else: PinCab_BG_s28.visible=1
		If Controller.Lamp(29) = 0 Then: PinCab_BG_s29.visible=0: else: PinCab_BG_s29.visible=1

		If Controller.Lamp(31) = 0 Then: PinCab_BG_s31.visible=0: else: PinCab_BG_s31.visible=1
		If Controller.Lamp(32) = 0 Then: PinCab_BG_s32.visible=0: else: PinCab_BG_s32.visible=1
		If Controller.Lamp(53) = 0 Then: PinCab_BG_s53.visible=0: else: PinCab_BG_s53.visible=1
		If Controller.Lamp(54) = 0 Then: PinCab_BG_s54.visible=0: else: PinCab_BG_s54.visible=1
		If Controller.Lamp(55) = 0 Then: PinCab_BG_s55.visible=0: else: PinCab_BG_s55.visible=1

		PinCab_BG_s30.visible=l30.state

		DIM VRThings
		for each VRThings in BackboxLED:VRThings.visible = 0:Next
		for each VRThings in Backboxlights:VRThings.visible = 0:Next

	End If

	Pincab_Shooter.Y = -126.3382 + (5* Plunger.Position) -20

End Sub

'--------------------------
'------  Table Init  ------
'--------------------------
Dim bsTrough,bsTopEject,bsRightHole,bsTopHole,bsCatapult,bsSpinoutKicker,RightDTBank,CenterDTBank
Sub Taxi_Init()

	Dim DesktopMode: DesktopMode = Taxi.ShowDT
	If DesktopMode = True Then 'Show Desktop components
		for Each obj in Backboxlights 
			obj.state = Lightstateon
		next	
		LEDTimer.enabled = True
	Else
		for Each obj in Backboxlights 
			obj.state = Lightstateoff
		next		
		LEDTimer.enabled = False
	End if

	vpmInit Me
    With Controller
		.GameName = cGameName
        'If Err Then MsgBox "Can't start Game " & cGameName & vbNewLine & Err.Description:Exit Sub
        .SplashInfoLine = "Taxi"
        .HandleKeyboard = 0
        .ShowTitle = 0
        .ShowDMDOnly = 1
        .ShowFrame = 0
        .HandleMechanics = 0
        .Hidden = 0
 		.Dip(0) = &H00


	    'DMD position for 3 Monitor Setup
		Controller.Games(cGameName).Settings.Value("dmd_pos_x")=0
		Controller.Games(cGameName).Settings.Value("dmd_pos_y")=0
		'Controller.Games(cGameName).Settings.Value("dmd_width")=505
		'Controller.Games(cGameName).Settings.Value("dmd_height")=155
		'Controller.Games(cGameName).Settings.Value("rol")=0

        On Error Resume Next
        .Run GetPlayerHWnd
        If Err Then MsgBox Err.Description
        On Error Goto 0
	End With
 
    On Error Goto 0
 
	' Nudging
	vpmNudge.TiltSwitch = 1
	vpmNudge.Sensitivity = 1
	vpmNudge.TiltObj = Array(Bumper1,Bumper2,Bumper3,LeftSlingshot,RightSlingshot)
 
    ' Trough handler
    Set bsTrough = New cvpmBallStack
    bsTrough.InitSw 10,11,12,0,0,0,0,0
	bsTrough.InitKick BallRelease,60,8
	'bsTrough.InitEntrySnd SoundFX("BallRelease",DOFContactors),SoundFX("Solon",DOFContactors)
	'bsTrough.InitExitSnd SoundFX("BallRelease",DOFContactors), SoundFX("Solon",DOFContactors)
	bsTrough.Balls=2
 
 	'Right Hole
    set bsRightHole = new cvpmSaucer
	bsRightHole.InitKicker RightHole,36,180,12,0
	bsRightHole.InitExitVariance 5,2
	'bsRightHole.InitSounds SoundFX("kicker_enter_center",DOFContactors),SoundFX("solon",DOFContactors),SoundFX("popper_ball",DOFContactors)

	'Top Hole - Joy Ride
    set bsTopHole = new cvpmSaucer
	bsTopHole.InitKicker TopHole,13,184,20,0
	bsTopHole.InitExitVariance 2, 2
	'bsTopHole.InitSounds SoundFX("kicker_enter_center",DOFContactors),SoundFX("solon",DOFContactors),SoundFX("popper_ball",DOFContactors)

	'Catapult
    Set bsCatapult = New cvpmSaucer
    bsCatapult.InitKicker CatapultLaunchKicker,35,0,40,0
    bsCatapult.InitSounds SoundFX("kicker_enter_center",DOFContactors),SoundFX("solon",DOFContactors),SoundFX("popper_ball",DOFContactors)

	'SpinOut Kicker
    Set bsSpinoutKicker = New cvpmSaucer
    bsSpinoutKicker.InitKicker SpinoutKicker,43,0,42,0
	bsSpinoutKicker.InitExitVariance 5,2
	'bsSpinoutKicker.InitSounds SoundFX("soloff",DOFContactors),SoundFX("solon",DOFContactors),SoundFX("popper_ball",DOFContactors)
 
    Set RightDTBank = New cvpmDropTarget
    RightDTBank.InitDrop Array(DT30,DT31,DT32),Array(30,31,32)
    RightDTBank.InitSnd SoundFX("",DOFDropTargets),SoundFX("fx_resetdrop",DOFContactors)
    RightDTBank.CreateEvents "RightDTBank"
 
    Set CenterDTBank = New cvpmDropTarget
    CenterDTBank.InitDrop Array(DT27,DT28,DT29),Array(27,28,29)
    CenterDTBank.InitSnd SoundFX("",DOFDropTargets),SoundFX("fx_resetdrop",DOFContactors)
    CenterDTBank.CreateEvents "CenterDTBank"
 
    PinMAMETimer.Interval = PinMAMEInterval
    PinMAMETimer.Enabled = 1

	vpmtimer.PulseSW 24

	center_digits()

	'force GI on initially
	Sol11 0

End Sub
 


'------------------------------
'------  Switch Handler  ------
'------------------------------
Sub SpinoutKicker_Hit:bsSpinOutKicker.addball Me:SoundSaucerLock:End Sub
Sub RightHole_Hit:bsRightHole.addball Me:SoundSaucerLock:End Sub
Sub TopHole_Hit:bsTopHole.addball Me:SoundSaucerLock:End Sub
Sub CatapultKicker_Hit:bsCatapult.addball Me:SoundSaucerLock:End Sub

Sub BallRelease_UnHit: RandomSoundBallRelease BallRelease: End Sub
Sub RightHole_UnHit: SoundSaucerKick 1, RightHole: End Sub
Sub TopHole_UnHit: SoundSaucerKick 1, TopHole: End Sub
Sub CatapultKicker_UnHit: SoundSaucerKick 1, CatapultKicker: End Sub
Sub CatapultLaunchKicker_UnHit: SoundSaucerKick 1, CatapultLaunchKicker: End Sub
Sub SpinoutKicker_UnHit: SoundSaucerKick 1, SpinoutKicker: End Sub



Sub Bumper1_Hit:vpmTimer.PulseSw 21:RandomSoundBumperTop Bumper1:bumperpower1=1:End Sub
Sub Bumper2_Hit:vpmTimer.PulseSw 17:RandomSoundBumperMiddle Bumper2:bumperpower2=1:End Sub
Sub Bumper3_Hit:vpmTimer.PulseSw 19:RandomSoundBumperBottom Bumper3:bumperpower3=1:End Sub

Sub SW14_Hit:Controller.Switch(14) = True:End Sub
Sub SW14_Unhit:Controller.Switch(14) = False:End Sub
Sub SW15_Hit:Controller.Switch(15) = True:End Sub
Sub SW15_Unhit:Controller.Switch(15) = False:End Sub
Sub SW16_Hit:Controller.Switch(16) = True:End Sub
Sub SW16_Unhit:Controller.Switch(16) = False:End Sub

Sub SW22_Hit:Controller.Switch(22) = True:End Sub
Sub SW22_Unhit:Controller.Switch(22) = False:End Sub
Sub SW23_Hit:Controller.Switch(23) = True:End Sub
Sub SW23_Unhit:Controller.Switch(23) = False:End Sub
Sub Target24_Hit:vpmtimer.PulseSW 24:End Sub
Sub SW25_Hit:vpmtimer.PulseSW 25:End Sub
Sub SW26_Hit:vpmtimer.PulseSW 26:End Sub

Sub SW33_Hit:Controller.Switch(33) = True:Primitive_SwitchArm33.objrotz = -15:End Sub
Sub SW33_Unhit:Controller.Switch(33) = False:SW33.Timerenabled = True:End Sub
Sub SW34_Hit:Controller.Switch(34) = True:Primitive_SwitchArm34.objrotz = 18:End Sub
Sub SW34_Unhit:Controller.Switch(34) = False:SW34.Timerenabled = True:End Sub
Sub SW37_Hit:Controller.Switch(37) = True:End Sub
Sub SW37_Unhit:Controller.Switch(37) = False:End Sub
Sub SW38_Hit:Controller.Switch(38) = True:End Sub
Sub SW38_Unhit:Controller.Switch(38) = False:End Sub
Sub SW39_Hit:Controller.Switch(39) = True:End Sub
Sub SW39_Unhit:Controller.Switch(39) = False:End Sub
Sub SW40_Hit:Controller.Switch(40) = True:End Sub
Sub SW40_Unhit:Controller.Switch(40) = False:End Sub
'SW43 handled via saucer
Sub SW44_Hit:vpmtimer.PulseSW 44 End Sub


Sub SW33_Timer
	Primitive_SwitchArm33.objrotz = Primitive_SwitchArm33.objrotz + 3
	if Primitive_SwitchArm33.objrotz >= 0 then
		SW33.Timerenabled = False
		Primitive_SwitchArm33.objrotz = 0
	end If
End Sub
Sub SW34_Timer
	Primitive_SwitchArm34.objrotz = Primitive_SwitchArm34.objrotz - 3
	if Primitive_SwitchArm34.objrotz <= 0 then
		SW34.Timerenabled = False
		Primitive_SwitchArm34.objrotz = 0
	end If
End Sub

'###########################################
'Sub SpinoutHelper_Hit
'	if ActiveBall.Velx > 9 then
'		ActiveBall.Velx = 1.01 * ActiveBall.Velx
'	end if
'End Sub

Sub RampHelper1_Hit
	ActiveBall.velZ = 0
End Sub
Sub RampHelper2_Hit
	ActiveBall.velZ = 0
End Sub


Const ReflipAngle = 20

Sub Taxi_KeyDown(ByVal keycode)
	If keycode = PlungerKey Then
		Plunger.PullBack
		SoundPlungerPull()
	End If

	If keycode = LeftFlipperKey Then
		if FlipperActive then
			lf.fire 'LeftFlipper.RotateToEnd
			lfpress = 1
            If leftflipper.currentangle < leftflipper.endangle + ReflipAngle Then 
                RandomSoundReflipUpLeft LeftFlipper
            Else 
                SoundFlipperUpAttackLeft LeftFlipper
                RandomSoundFlipperUpLeft LeftFlipper
            End If  
		end if
	End If
    
	If keycode = RightFlipperKey Then
		if FlipperActive then
			rf.fire 'RightFlipper.RotateToEnd
			rfpress = 1
            If rightflipper.currentangle > rightflipper.endangle - ReflipAngle Then
                RandomSoundReflipUpRight RightFlipper
            Else 
                SoundFlipperUpAttackRight RightFlipper
                RandomSoundFlipperUpRight RightFlipper
            End If
		end if
	End If

    If keycode = LeftTiltKey Then Nudge 90, 5:SoundNudgeLeft()
    If keycode = RightTiltKey Then Nudge 270, 5:SoundNudgeRight()
    If keycode = CenterTiltKey Then Nudge 0, 3:SoundNudgeCenter()
    If keycode = keyInsertCoin1 or keycode = keyInsertCoin2 or keycode = keyInsertCoin3 or keycode = keyInsertCoin4 Then
        Select Case Int(rnd*3)
            Case 0: PlaySound ("Coin_In_1"), 0, CoinSoundLevel, 0, 0.25
            Case 1: PlaySound ("Coin_In_2"), 0, CoinSoundLevel, 0, 0.25
            Case 2: PlaySound ("Coin_In_3"), 0, CoinSoundLevel, 0, 0.25
        End Select
    End If
    If keycode=StartGameKey Then soundStartButton()

	'If keycode = RightMagnaSave Then sol11 true
	'If keycode = LeftMagnaSave Then sol11 false


	If vpmKeyDown(keycode) Then Exit Sub
End Sub


Sub Taxi_KeyUp(ByVal keycode)

	If keycode = PlungerKey Then
		Plunger.Fire
		SoundPlungerReleaseBall()
	End If
    
	If keycode = LeftFlipperKey Then
		lfpress = 0
		leftflipper.eostorqueangle = EOSA
		leftflipper.eostorque = EOST
		LeftFlipper.RotateToStart
		if FlipperActive then
            If LeftFlipper.currentangle < LeftFlipper.startAngle - 5 Then
                RandomSoundFlipperDownLeft LeftFlipper
            End If
            FlipperLeftHitParm = FlipperUpSoundLevel
		end if
	End If
    
	If keycode = RightFlipperKey Then
		rfpress = 0
		rightflipper.eostorqueangle = EOSA
		rightflipper.eostorque = EOST
		RightFlipper.RotateToStart
		if FlipperActive then
            If RightFlipper.currentangle > RightFlipper.startAngle + 5 Then
                RandomSoundFlipperDownRight RightFlipper
            End If        
            FlipperRightHitParm = FlipperUpSoundLevel
		end if
	End If

	

	If vpmKeyUp(keycode) Then Exit Sub
End Sub

Sub Drain_Hit()
	RF.PolarityCorrect Activeball: LF.PolarityCorrect Activeball
	RandomSoundDrain Drain
	bsTrough.AddBall Me
	'Drain.DestroyBall
End Sub



'-----------------------------------
' Flipper Primitives
'-----------------------------------
sub FlipperTimer()
	pleftFlipper.rotz=leftFlipper.CurrentAngle
	prightFlipper.rotz=rightFlipper.CurrentAngle

    LFLogo.RotZ = LeftFlipper.CurrentAngle
    RFLogo.RotZ = RightFlipper.CurrentAngle

	Primitive_LGateWire.rotx = LGate.currentangle
	Primitive_RGateWire.rotx = RGate.currentangle
end sub



'**********Sling Shot Animations
' Rstep and Lstep  are the variables that increment the animation
'****************
Dim RStep, Lstep

Sub RightSlingShot_Slingshot
	vpmtimer.pulsesw 20
    RandomSoundSlingshotRight SLING1
    RSling.Visible = 0
    RSling1.Visible = 1
    sling1.TransZ = -20
    RStep = 0
    RightSlingShot.TimerEnabled = 1
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.TransZ = -10
        Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.TransZ = 0:RightSlingShot.TimerEnabled = 0
    End Select
    RStep = RStep + 1
End Sub

Sub LeftSlingShot_Slingshot
	vpmtimer.pulsesw 18
    RandomSoundSlingshotLeft SLING2
    LSling.Visible = 0
    LSling1.Visible = 1
    sling2.TransZ = -20
    LStep = 0
    LeftSlingShot.TimerEnabled = 1
End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.TransZ = -10
        Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.TransZ = 0:LeftSlingShot.TimerEnabled = 0
    End Select
    LStep = LStep + 1
End Sub






'******************************************************
'		BALL ROLLING AND DROP SOUNDS
'******************************************************
Const tnob = 5
Const lob = 0
ReDim rolling(tnob)
InitRolling
Dim isBallOnWireRamp : isBallOnWireRamp = False

Dim DropCount
ReDim DropCount(tnob)

Sub InitRolling
	Dim i
	For i = 0 to (tnob)
		rolling(i) = False
	Next
End Sub

Sub RollingTimer()
	Dim BOT, b
	BOT = GetBalls

	' stop the sound of deleted balls
	For b = UBound(BOT) + 1 to tnob
		rolling(b) = False
		StopSound "BallRoll_" & b
        StopSound "fx_plasticrolling" & b
		StopSound "fx_metalrolling" & b
	Next

	' exit the sub if no balls on the table
	If UBound(BOT) = -1 Then Exit Sub

	' play the rolling sound for each ball

	For b = 0 to UBound(BOT)
		If BallVel(BOT(b)) > 1 Then
			rolling(b) = True
			If isBallOnWireRamp Then
				' ball on wire ramp
				StopSound "BallRoll_" & b
				StopSound "fx_plasticrolling" & b
				PlaySound "fx_metalrolling" & b, -1, VolPlayfieldRoll(BOT(b)) * 1.1 * VolumeDial, AudioPan(BOT(b)), 0, PitchPlayfieldRoll(BOT(b)), 1, 0, AudioFade(BOT(b))
			ElseIf BOT(b).Z > 30 Then
				' ball on plastic ramp
				StopSound "BallRoll_" & b
				StopSound "fx_metalrolling" & b
				PlaySound "fx_plasticrolling" & b, -1, VolPlayfieldRoll(BOT(b)) * 0.4 * VolumeDial, AudioPan(BOT(b)), 0, PitchPlayfieldRoll(BOT(b)), 1, 0, AudioFade(BOT(b))
			Else
				' ball on playfield
				StopSound "fx_plasticrolling" & b
				StopSound "fx_metalrolling" & b
				PlaySound "BallRoll_" & b, -1, VolPlayfieldRoll(BOT(b)) * 1.2 * VolumeDial, AudioPan(BOT(b)), 0, PitchPlayfieldRoll(BOT(b)), 1, 0, AudioFade(BOT(b))
			End If
		Else
			If rolling(b) = True Then
				StopSound "BallRoll_" & b 
				StopSound "fx_plasticrolling" & b
				StopSound "fx_metalrolling" & b
				rolling(b) = False
			End If
		End If

		'***Ball Drop Sounds***
		If BOT(b).VelZ < -1 and BOT(b).z < 55 and BOT(b).z > 27 Then 'height adjust for ball drop sounds
			If DropCount(b) >= 5 Then
				DropCount(b) = 0
				If BOT(b).velz > -7 Then
					RandomSoundBallBouncePlayfieldSoft BOT(b)
				Else
					RandomSoundBallBouncePlayfieldHard BOT(b)
				End If				
			End If
		End If
		If DropCount(b) < 5 Then
			DropCount(b) = DropCount(b) + 1
		End If
	Next
End Sub



'*****************************************************
' RtxBS - Ray Tracing Ball Shadows by iaakki and Wylte
'*****************************************************

Dim fovY:		fovY		= 10	'Offset y axis to account for layback or inclination
Dim SizeOfBall:	SizeOfBall	= BallSize	'Regular ballsize isn't working right, as it's pulled from vpm?
Const RTXFactor 			= 0.9	'0 to 1, higher is darker

Dim sourcenames, currentShadowCount

sourcenames = Array ("","","","","","","","","","","","")
currentShadowCount = Array (0,0,0,0,0,0,0,0,0,0,0,0)

Sub BallShadowUpdate_Timer()
	If RtxBSon=1 Then
		RtxBSUpdate
	Else
		me.enabled=false
	End If
End Sub

dim objrtx1(20), objrtx2(20), RtxBScnt
dim objBallShadow(20)
RtxInit

sub RtxInit()
	Dim iii
	For Each iii in RtxBS
		RtxBScnt = RtxBScnt + 1		'count lights
'		iii.state = 1 				'lights on
	next

	for iii = 0 to tnob
		Set objrtx1(iii) = Eval("RtxBallShadow" & iii)
		objrtx1(iii).material = "RtxBallShadow" & iii
		objrtx1(iii).z = iii/1000 + 0.10
		objrtx1(iii).visible = 0
		'objrtx1(iii).uservalue=0

		Set objrtx2(iii) = Eval("RtxBall2Shadow" & iii)
		objrtx2(iii).material = "RtxBallShadow2_" & iii
		objrtx2(iii).z = (iii)/1000 + 0.12
		objrtx2(iii).visible = 0
		'objrtx2(iii).uservalue=0
		currentShadowCount(iii) = 0
		Set objBallShadow(iii) = Eval("BallShadow" & iii)
	Next
	'msgbox RtxBScnt
end sub


Sub RtxBSUpdate
	Dim falloff:        falloff 		= 200			'Max distance to light source for RTX BS calcs
	Dim ShadowOpacity, ShadowOpacity2 
	Dim s, Source, LSd, CntDwn, b, currentMat, AnotherSource, BOT
	BOT = GetBalls

	' hide shadow of deleted balls
	For s = UBound(BOT) + 1 to tnob
		objrtx1(s).visible = 0
		objrtx2(s).visible = 0
		objBallShadow(s).visible = 0
	Next

	If UBound(BOT) = lob - 1 Then Exit Sub		'No balls in play exit, same as JP's

	For s = lob to UBound(BOT)
		'Normal ambient shadow
		If BOT(s).X < tablewidth/2 Then
			objBallShadow(s).X = ((BOT(s).X) - (SizeOfBall/6) + ((BOT(s).X - (tablewidth/2))/10)) + 6
		Else
			objBallShadow(s).X = ((BOT(s).X) + (SizeOfBall/6) + ((BOT(s).X - (tablewidth/2))/10)) - 6
		End If
		objBallShadow(s).Y = BOT(s).Y + fovY
		'objBallShadow(s).Z = BOT(s).Z - (SizeOfBall/2) + s/1000 + 0.04 'make ball shadows to be on different z-order
		objBallShadow(s).Z = s/1000 + 0.04 'make ball shadows to be on different z-order

		If BOT(s).Z < 30 Then 'or BOT(s).Z > 105 Then
			objBallShadow(s).visible = 1
		Else
			'other rules here, like ramps and upper pf
			objBallShadow(s).visible = 0
		end if

		'RTX shadows
		For Each Source in RtxBS							'Rename this to match your collection name
			'LSd=((BOT(s).x-Source.x)^2+(BOT(s).y-Source.y)^2)^0.5			'Calculating the Linear distance to the Source
			LSd=DistanceFast((BOT(s).x-Source.x),(BOT(s).y-Source.y))			'Calculating the Linear distance to the Source
			If BOT(s).Z < 30 Then 'Or BOT(s).Z > 105 Then
				If LSd < falloff and Source.state=1 Then	    'If the ball is within the falloff range of a light and light is on
					CntDwn = RtxBScnt
					currentShadowCount(s) = currentShadowCount(s) + 1

					if currentShadowCount(s) = 1 Then
						sourcenames(s) = source.name
						currentMat = objrtx1(s).material
						objrtx2(s).visible = 0 : objrtx1(s).visible = 1 : objrtx1(s).X = BOT(s).X : objrtx1(s).Y = BOT(s).Y + fovY
						'objrtx1(s).Z = BOT(s).Z - (SizeOfBall/2) + s/1000 + 0.01
						objrtx1(s).Z = s/1000 + 0.01
						objrtx1(s).rotz = AnglePP(Source.x, Source.y, BOT(s).X, BOT(s).Y) + 90
						ShadowOpacity = (falloff-LSd)/falloff
						objrtx1(s).size_y = 15*ShadowOpacity+5
						UpdateMaterial currentMat,1,0,0,0,0,0,ShadowOpacity*RTXFactor^2,RGB(0,0,0),0,0,False,True,0,0,0,0
						'debug.print "update1" & source.name & " at:" & ShadowOpacity

						'currentMat = objBallShadow(s).material
						'UpdateMaterial currentMat,1,0,0,0,0,0,1-ShadowOpacity,RGB(0,0,0),0,0,False,True,0,0,0,0

					Elseif currentShadowCount(s) = 2 Then
						currentMat = objrtx1(s).material
						set AnotherSource = Eval(sourcenames(s))
						objrtx1(s).visible = 1 : objrtx1(s).X = BOT(s).X : objrtx1(s).Y = BOT(s).Y + fovY
						'objrtx1(s).Z = BOT(s).Z - (SizeOfBall/2) + s/1000 + 0.01
						objrtx1(s).Z = s/1000 + 0.01
						objrtx1(s).rotz = AnglePP(AnotherSource.x, AnotherSource.y, BOT(s).X, BOT(s).Y) + 90
						ShadowOpacity = (falloff-(((BOT(s).x-AnotherSource.x)^2+(BOT(s).y-AnotherSource.y)^2)^0.5))/falloff
						objrtx1(s).size_y = 15*ShadowOpacity+5
						UpdateMaterial currentMat,1,0,0,0,0,0,ShadowOpacity*RTXFactor^3,RGB(0,0,0),0,0,False,True,0,0,0,0

						currentMat = objrtx2(s).material
						objrtx2(s).visible = 1 : objrtx2(s).X = BOT(s).X : objrtx2(s).Y = BOT(s).Y + fovY
						'objrtx2(s).Z = BOT(s).Z - (SizeOfBall/2) + s/1000 + 0.02
						objrtx2(s).Z = s/1000 + 0.02
						objrtx2(s).rotz = AnglePP(Source.x, Source.y, BOT(s).X, BOT(s).Y) + 90
						ShadowOpacity2 = (falloff-LSd)/falloff
						objrtx2(s).size_y = 15*ShadowOpacity2+5
						UpdateMaterial currentMat,1,0,0,0,0,0,ShadowOpacity2*RTXFactor^3,RGB(0,0,0),0,0,False,True,0,0,0,0
						'debug.print "update2: " & source.name & " at:" & ShadowOpacity & " and "  & Eval(sourcenames(s)).name & " at:" & ShadowOpacity2

						'currentMat = objBallShadow(s).material
						'UpdateMaterial currentMat,1,0,0,0,0,0,1-max(ShadowOpacity,ShadowOpacity2),RGB(0,0,0),0,0,False,True,0,0,0,0
					end if
				Else
					CntDwn = CntDwn - 1				'If ball is not in range of any light, this will hit 0
					currentShadowCount(s) = 0
				End If
			Else
			'other rules here, like ramps and upper pf
				objrtx2(s).visible = 0 : objrtx1(s).visible = 0
			End If

		Next
		If CntDwn <= 0 Then
			if CntDwn = -(RtxBScnt) Then
				For b = lob to UBound(BOT)
					objrtx1(b).visible = 0
					objrtx2(b).visible = 0
				Next
			end if

		End If
	Next
End Sub

Function DistanceFast(x, y)
	dim ratio, ax, ay
	'Get absolute value of each vector
	ax = abs(x)
	ay = abs(y)
	'Create a ratio
	ratio = 1 / max(ax, ay)
	ratio = ratio * (1.29289 - (ax + ay) * ratio * 0.29289)
	if ratio > 0 then
		DistanceFast = 1/ratio
	Else
		DistanceFast = 0
	End if
end Function

Function max(a,b)
	if a > b then 
		max = a
	Else
		max = b
	end if
end Function




''*****************************************
''	Ball Shadow
''*****************************************
'
'Dim BallShadow
'BallShadow = Array (BallShadow1, BallShadow2, BallShadow3, BallShadow4, BallShadow5, BallShadow6)
'
'Sub BallShadowUpdate()
'    Dim BOT, b, shadowZ
'    BOT = GetBalls
'
'	' render the shadow for each ball
'    For b = 0 to UBound(BOT)
'		BallShadow(b).X = BOT(b).X
'		BallShadow(b).Y = BOT(b).Y + 10
'		If BOT(b).Z > 0 and BOT(b).Z < 30 Then
'			BallShadow(b).visible = 1
'		Else
'			BallShadow(b).visible = 0
'		End If
'	Next
'End Sub



Sub Spinner_Spin
	PlaySound "fx_spinner",0,.25,0,0.25
End Sub


Sub DTCheckTimer
	'Drop Target GI Lights
	if DT27.isdropped then
		Light22a.state = Light22.state
		Light26a.state = Light26.state
	Else
		Light22a.state = Lightstateoff
		Light26a.state = Lightstateoff
	end If
	if DT28.isdropped then
		Light22b.state = Light22.state
		Light26b.state = Light26.state
	Else
		Light22b.state = Lightstateoff
		Light26b.state = Lightstateoff
	end If
	if DT29.isdropped then
		Light22c.state = Light22.state
		Light26c.state = Light26.state
	Else
		Light22c.state = Lightstateoff
		Light26c.state = Lightstateoff
	end If

	if DT30.isdropped then
		Light27a.state = Light27.state
		Light28a.state = Light28.state
	Else
		Light27a.state = Lightstateoff
		Light28a.state = Lightstateoff
	end If
	if DT31.isdropped then
		Light27b.state = Light27.state
		Light28b.state = Light28.state
	Else
		Light27b.state = Lightstateoff
		Light28b.state = Lightstateoff
	end If
	if DT32.isdropped then
		Light27c.state = Light27.state
		Light28c.state = Light28.state
	Else
		Light27c.state = Lightstateoff
		Light28c.state = Lightstateoff
	end If
End Sub

'***************************************************
'       JP's VP10 Fading Lamps & Flashers
'       Based on PD's Fading Light System
' SetLamp 0 is Off
' SetLamp 1 is On
' fading for non opacity objects is 4 steps
'***************************************************

Dim LampState(200), FadingLevel(200)
Dim FlashSpeedUp(200), FlashSpeedDown(200), FlashMin(200), FlashMax(200), FlashLevel(200)
Dim ccount

InitLamps()             ' turn off the lights and flashers and reset them to the default parameters
'LampTimer.Interval = 10 'lamp fading speed
'LampTimer.Enabled = 1

Dim chgLamp, num, chg, ii
Sub LampTimer()
    chgLamp = Controller.ChangedLamps
    If Not IsEmpty(chgLamp) Then
        For ii = 0 To UBound(chgLamp)
            LampState(chgLamp(ii, 0) ) = chgLamp(ii, 1)       'keep the real state in an array
			FadingLevel(chgLamp(ii, 0) ) = chgLamp(ii, 1) + 4 'actual fading step
		Next
    End If

	'Multi-LampStates
	LampState(43) = controller.Lamp(43) or controller.solenoid(16)	'Joyride
	LampState(44) = controller.Lamp(44) or controller.solenoid(15)	'Jackpot
	LampState(25) = controller.Lamp(25) or controller.solenoid(25) or controller.solenoid(10)	'Pinbot Insert
	LampState(26) = controller.Lamp(26) or controller.solenoid(26) or controller.solenoid(10)	'Drac Insert
	LampState(27) = controller.Lamp(27) or controller.solenoid(27) or controller.solenoid(10)	'Lola Insert
	LampState(28) = controller.Lamp(28) or controller.solenoid(28) or controller.solenoid(10)	'Santa Insert
	LampState(29) = controller.Lamp(29) or controller.solenoid(29) or controller.solenoid(10)	'Gorby Insert
    UpdateLamps
End Sub

Sub InitLamps()
    Dim x
    For x = 0 to 200
        LampState(x) = 0         ' current light state, independent of the fading level. 0 is off and 1 is on
        FadingLevel(x) = 4       ' used to track the fading state
        FlashSpeedUp(x) = 0.3    ' faster speed when turning on the flasher
        FlashSpeedDown(x) = 0.15 ' slower speed when turning off the flasher
        FlashMax(x) = 1          ' the maximum value when on, usually 1
        FlashMin(x) = 0          ' the minimum value when off, usually 0
        FlashLevel(x) = 0        ' the intensity of the flashers, usually from 0 to 1
    Next
End Sub

Sub UpdateLamps
	If DesktopMode = True Then
		'Joy Ride
		NFadeLm 1, L1
		NFadeL 1, L1a
		NFadeLm 2, L2
		NFadeL 2, L2a
		NFadeLm 3, L3
		NFadeL 3, L3a
		NFadeLm 4, L4
		NFadeL 4, L4a
		NFadeLm 5, L5
		NFadeL 5, L5a

		'Backbox
		NFadeL 6, L6
		NFadeL 7, L7
		NFadeL 8, L8
		NFadeL 6, L6
		NFadeL 49, L49
		NFadeL 50, L50
		NFadeL 51, L51
		NFadeL 52, L52
		NFadeL 53, L53
		NFadeL 54, L54
		NFadeL 55, L55
		NFadeL 56, L56
		NFadeL 64, L64
	end If

	'Inserts
	NFadeLm 9, L9
	NFadeLm 9, L9b
	FadeDisableLighting 9, p9, 10
	NFadeLm 10, L10
	NFadeLm 10, L10b
	FadeDisableLighting 10, p10, 10
	NFadeLm 11, L11
	NFadeLm 11, L11b
	FadeDisableLighting 11, p11, 10
	NFadeLm 12, L12
	NFadeLm 12, L12b
	FadeDisableLighting 12, p12, 10
	NFadeLm 13, L13
	NFadeLm 13, L13b
	FadeDisableLighting 13, p13, 10
	NFadeLm 14, L14
	NFadeLm 14, L14b
	FadeDisableLighting 14, p14, 10
	NFadeLm 15, L15
	NFadeLm 15, L15b
	FadeDisableLighting 15, p15, 10
	NFadeLm 16, L16
	NFadeLm 16, L16b
	FadeDisableLighting 16, p16, 10


	NFadeL 17, L17
'	Flash 17, L17a

	NFadeLm 18, L18
	NfadeLm 18, L18b
	FadeDisableLighting 18, p18, 5
	NFadeLm 19, L19
	NFadeLm 19, L19b
	FadeDisableLighting 19, p19, 5
	NFadeLm 20, L20
	NfadeLm 20, L20b
	FadeDisableLighting 20, p20, 5
	NFadeLm 21, L21
	NfadeLm 21, L21b
	FadeDisableLighting 21, p21, 5


	NFadeLm 22, L22
	NfadeLm 22, L22b
	FadeDisableLighting 22, p22, 10
	NFadeLm 23, L23b
	NFadeLm 23, L23
	NfadeLm 23, L23C
	FadeDisableLighting 23, p23, 10
	NFadeLm 24, L24
	NfadeLm 24, L24b
	FadeDisableLighting 24, p24, 10

	NFadeL 25, L25
'	Flash 25, L25a


	NFadeLm 26, L26
	NfadeLm 26, L26b
	FadeDisableLighting 26, p26, 10
	NFadeLm 27, L27
	NFadeLm 27, L27b
	FadeDisableLighting 27, p27, 5
	NFadeLm 28, L28
	NFadeLm 28, L28b
	FadeDisableLighting 28, p28, 10
	NFadeLm 29, L29
	NFadeLm 29, L29b
	FadeDisableLighting 29, p29, 10
	NFadeLm 30, L30
	NFadeLm 30, L30b
	FadeDisableLighting 30, p30, 10
	NFadeLm 31, L31
	NFadeLm 31, L31b
	FadeDisableLighting 31, p31, 10
	NFadeLm 32, L32b
	NFadeLm 32, L32
	NFadeLm 32, L32c
	FadeDisableLighting 32, p32, 10
	NFadeLm 33, L33
	NFadeLm 33, L33b
	FadeDisableLighting 33, p33, 10
	NFadeLm 34, L34
	NFadeLm 34, L34b
	FadeDisableLighting 34, p34, 10
	NFadeLm 35, L35
	NFadeLm 35, L35b
	FadeDisableLighting 35, p35, 10
	NFadeLm 36, L36
	NFadeLm 36, L36b
	FadeDisableLighting 36, p36, 10
	NFadeLm 37, L37
	NFadeLm 37, L37b
	FadeDisableLighting 37, p37, 10
	NFadeLm 38, L38
	NFadeLm 38, L38b
	FadeDisableLighting 38, p38, 10
	NFadeLm 39, L39
	NFadeLm 39, L39b
	FadeDisableLighting 39, p39, 10
	NFadeLm 40, L40
	NFadeLm 40, L40b
	FadeDisableLighting 40, p40, 10
	NFadeLm 41, L41
	NFadeLm 41, L41b
	FadeDisableLighting 41, p41, 10
	NFadeLm 42, L42
	NFadeLm 42, L42b
	FadeDisableLighting 42, p42, 10
	NFadeLm 43, L43
	NFadeLm 43, L43b
	FadeDisableLighting 43, p43, 10
	NFadeLm 44, L44
	NFadeLm 44, L44b
	FadeDisableLighting 44, p44, 10
	NFadeLm 45, L45
	NFadeLm 45, L45b
	FadeDisableLighting 45, p45, 10
	NFadeLm 46, L46
	NFadeLm 46, L46b
	FadeDisableLighting 46, p46, 10
	NFadeLm 47, L47
	NFadeLm 47, L47b
	FadeDisableLighting 47, p47, 10
	NFadeLm 48, L48
	NFadeLm 48, L48b
	FadeDisableLighting 48, p48, 10



	NFadeLm 57, L57
	Flash 57, L57f
	NFadeLm 58, L58
	Flash 58, L58f
	NFadeLm 59, L59
	Flash 59, L59f
	NFadeLm 60, L60
	Flash 60, L60f
	NFadeLm 61, L61
	Flash 61, L61f
	NFadeLm 62, L62
	Flash 62, L62f
	NFadeLm 63, L63
	Flash 63, L63f

	'GI Flashers
	NFadeLm 25, F25
'	NFadeLm 26, F26
'	NFadeLm 27, F27
'	NFadeLm 28, F28
'	NFadeLm 29, F29

	'Flashers
	NFadeL 116, F16
	NFadeL 130, F30
	NFadeL 131, F31
	NFadeL 132, F32
 End Sub

Sub SetLamp(nr, value)
    If value <> LampState(nr) Then
        LampState(nr) = abs(value)
        FadingLevel(nr) = abs(value) + 4
    End If
End Sub

Sub FadeDisableLightingM(nr, a, alvl)
	Select Case FadingLevel(nr)
		Case 4
			'debug.print a.UserValue
			a.UserValue = a.UserValue - 0.07
			If a.UserValue < 0 Then 
				a.UserValue = 0
				'FadingLevel(nr) = 0
			end If
			a.BlendDisableLighting = alvl * a.UserValue 'brightness
		Case 5
			'debug.print a.UserValue
			a.UserValue = a.UserValue + 0.50
			If a.UserValue > 1 Then 
				a.UserValue = 1
				'FadingLevel(nr) = 1
			end If
			a.BlendDisableLighting = alvl * a.UserValue 'brightness
	End Select
End Sub

Sub FadeDisableLighting(nr, a, alvl)
	Select Case FadingLevel(nr)
		Case 4
			'if nr = 58 then debug.print "down: " & a.UserValue
			a.UserValue = a.UserValue - 0.07
			If a.UserValue < 0 Then 
				a.UserValue = 0
				FadingLevel(nr) = 0
			end If
			a.BlendDisableLighting = alvl * a.UserValue 'brightness
		Case 5
			'if nr = 58 then debug.print "up: " & a.UserValue
			a.UserValue = a.UserValue + 0.50
			If a.UserValue > 1 Then 
				a.UserValue = 1
				FadingLevel(nr) = 1
			end If
			a.BlendDisableLighting = alvl * a.UserValue 'brightness
	End Select
End Sub


' Lights: used for VP10 standard lights, the fading is handled by VP itself
Sub NFadeL(nr, object)
    Select Case FadingLevel(nr)
        Case 4:object.state = 0:FadingLevel(nr) = 0
        Case 5:object.state = 1:FadingLevel(nr) = 1
    End Select
End Sub

Sub NFadeLm(nr, object) ' used for multiple lights
    Select Case FadingLevel(nr)
        Case 4:object.state = 0
        Case 5:object.state = 1
    End Select
End Sub

Sub NFadeLmb(nr, object) ' used for multiple lights with blinking
    Select Case FadingLevel(nr)
        Case 4:object.state = 0
        Case 5:object.state = 2
    End Select
End Sub

Sub MFadeL(nr, object, state)
    Select Case FadingLevel(nr)
        Case 4:object.state = 0:If LampState(state) =1 Then SetLamp state, 1
        Case 5:object.state = 1
    End Select
End Sub


'Lights, Ramps & Primitives used as 4 step fading lights
'a,b,c,d are the images used from on to off

Sub FadeObj(nr, object, a, b, c, d)
	Select Case FadingLevel(nr)
		Case 2:object.image = d:FadingLevel(nr) = 0 'Off
		Case 3:object.image = c:FadingLevel(nr) = 2 'fading...
		Case 4:object.image = b:FadingLevel(nr) = 3 'fading...
		Case 5:object.image = a:FadingLevel(nr) = 1 'ON
 End Select
End Sub

Sub FadeObjm(nr, object, a, b, c, d)
    Select Case FadingLevel(nr)
        Case 2:object.image = d
        Case 3:object.image = c
        Case 4:object.image = b
        Case 5:object.image = d
    End Select
End Sub

Sub NFadeObj(nr, object, a, b)
    Select Case FadingLevel(nr)
        Case 4:object.image = b:FadingLevel(nr) = 0 'off
        Case 5:object.image = a:FadingLevel(nr) = 1 'on
    End Select
End Sub

Sub NFadeObjm(nr, object, a, b)
    Select Case FadingLevel(nr)
        Case 4:object.image = b
        Case 5:object.image = a
    End Select
End Sub

' Flasher objects

Sub Flash(nr, object)
    Select Case FadingLevel(nr)
        Case 4 'off
            FlashLevel(nr) = FlashLevel(nr) - FlashSpeedDown(nr)
            If FlashLevel(nr) < FlashMin(nr) Then
                FlashLevel(nr) = FlashMin(nr)
                FadingLevel(nr) = 0 'completely off
				
            End if
            Object.IntensityScale = FlashLevel(nr)
        Case 5 ' on
            FlashLevel(nr) = FlashLevel(nr) + FlashSpeedUp(nr)
            If FlashLevel(nr) > FlashMax(nr) Then
                FlashLevel(nr) = FlashMax(nr)
                FadingLevel(nr) = 1 'completely on
            End if
            Object.IntensityScale = FlashLevel(nr)
    End Select
End Sub

Sub Flashm(nr, object) 'multiple flashers, it just sets the flashlevel
    Object.IntensityScale = FlashLevel(nr)
End Sub


'--------------------------------------
'------  Destruk's Display Code  ------
'--------------------------------------

Dim DigitsDT(39)
Const DigitsOffset=32
DigitsDT(DigitsOffset+0)=Array(LED1,LED2,LED3,LED4,LED5,LED6,LED7,LED8)'ok
DigitsDT(DigitsOffset+1)=Array(LED9,LED10,LED11,LED12,LED13,LED14,LED15)'ok
DigitsDT(DigitsOffset+2)=Array(LED16,LED17,LED18,LED19,LED20,LED21,LED22)'ok
DigitsDT(DigitsOffset+3)=Array(LED23,LED24,LED25,LED26,LED27,LED28,LED29,LED30)'ok
DigitsDT(DigitsOffset+4)=Array(LED31,LED32,LED33,LED34,LED35,LED36,LED37)'ok
DigitsDT(DigitsOffset+5)=Array(LED38,LED39,LED40,LED41,LED42,LED43,LED44)'ok
DigitsDT(DigitsOffset+6)=Array(LED45,LED46,LED47,LED48,LED49,LED50,LED51)'ok

Dim Digits(39)
Digits(0)=Array(ax00, ax05, ax0c, ax0d, ax08, ax01, ax06, ax0f, ax02, ax03, ax04, ax07, ax0b, ax0a, ax09, ax0e)
Digits(1)=Array(ax10, ax15, ax1c, ax1d, ax18, ax11, ax16, ax1f, ax12, ax13, ax14, ax17, ax1b, ax1a, ax19, ax1e)
Digits(2)=Array(ax20, ax25, ax2c, ax2d, ax28, ax21, ax26, ax2f, ax22, ax23, ax24, ax27, ax2b, ax2a, ax29, ax2e)
Digits(3)=Array(ax30, ax35, ax3c, ax3d, ax38, ax31, ax36, ax3f, ax32, ax33, ax34, ax37, ax3b, ax3a, ax39, ax3e)
Digits(4)=Array(ax40, ax45, ax4c, ax4d, ax48, ax41, ax46, ax4f, ax42, ax43, ax44, ax47, ax4b, ax4a, ax49, ax4e)
Digits(5)=Array(ax50, ax55, ax5c, ax5d, ax58, ax51, ax56, ax5f, ax52, ax53, ax54, ax57, ax5b, ax5a, ax59, ax5e)
Digits(6)=Array(ax60, ax65, ax6c, ax6d, ax68, ax61, ax66, ax6f, ax62, ax63, ax64, ax67, ax6b, ax6a, ax69, ax6e)
Digits(7)=Array(ax70, ax75, ax7c, ax7d, ax78, ax71, ax76, ax7f, ax72, ax73, ax74, ax77, ax7b, ax7a, ax79, ax7e)
Digits(8)=Array(ax80, ax85, ax8c, ax8d, ax88, ax81, ax86, ax8f, ax82, ax83, ax84, ax87, ax8b, ax8a, ax89, ax8e)
Digits(9)=Array(ax90, ax95, ax9c, ax9d, ax98, ax91, ax96, ax9f, ax92, ax93, ax94, ax97, ax9b, ax9a, ax99, ax9e)
Digits(10)=Array(axa0, axa5, axac, axad, axa8, axa1, axa6, axaf, axa2, axa3, axa4, axa7, axab, axaa, axa9, axae)
Digits(11)=Array(axb0, axb5, axbc, axbd, axb8, axb1, axb6, axbf, axb2, axb3, axb4, axb7, axbb, axba, axb9, axbe)
Digits(12)=Array(axc0, axc5, axcc, axcd, axc8, axc1, axc6, axcf, axc2, axc3, axc4, axc7, axcb, axca, axc9, axce)
Digits(13)=Array(axd0, axd5, axdc, axdd, axd8, axd1, axd6, axdf, axd2, axd3, axd4, axd7, axdb, axda, axd9, axde)
Digits(14)=Array(axe0, axe5, axec, axed, axe8, axe1, axe6, axef, axe2, axe3, axe4, axe7, axeb, axea, axe9, axee)
Digits(15)=Array(axf0, axf5, axfc, axfd, axf8, axf1, axf6, axff, axf2, axf3, axf4, axf7, axfb, axfa, axf9, axfe)

Digits(16) = Array(LED1x0,LED1x1,LED1x2,LED1x3,LED1x4,LED1x5,LED1x6)
Digits(17) = Array(LED2x0,LED2x1,LED2x2,LED2x3,LED2x4,LED2x5,LED2x6)
Digits(18) = Array(LED3x0,LED3x1,LED3x2,LED3x3,LED3x4,LED3x5,LED3x6)
Digits(19) = Array(LED4x0,LED4x1,LED4x2,LED4x3,LED4x4,LED4x5,LED4x6)
Digits(20) = Array(LED5x0,LED5x1,LED5x2,LED5x3,LED5x4,LED5x5,LED5x6)
Digits(21) = Array(LED6x0,LED6x1,LED6x2,LED6x3,LED6x4,LED6x5,LED6x6)
Digits(22) = Array(LED7x0,LED7x1,LED7x2,LED7x3,LED7x4,LED7x5,LED7x6)
Digits(23) = Array(LED8x0,LED8x1,LED8x2,LED8x3,LED8x4,LED8x5,LED8x6)
Digits(24) = Array(LED9x0,LED9x1,LED9x2,LED9x3,LED9x4,LED9x5,LED9x6)
Digits(25) = Array(LED10x0,LED10x1,LED10x2,LED10x3,LED10x4,LED10x5,LED10x6)
Digits(26) = Array(LED11x0,LED11x1,LED11x2,LED11x3,LED11x4,LED11x5,LED11x6)
Digits(27) = Array(LED12x0,LED12x1,LED12x2,LED12x3,LED12x4,LED12x5,LED12x6)
Digits(28) = Array(LED13x0,LED13x1,LED13x2,LED13x3,LED13x4,LED13x5,LED13x6)
Digits(29) = Array(LED14x0,LED14x1,LED14x2,LED14x3,LED14x4,LED14x5,LED14x6)
Digits(30) = Array(LEDax300,LEDax301,LEDax302,LEDax303,LEDax304,LEDax305,LEDax306)
Digits(31) = Array(LEDbx400,LEDbx401,LEDbx402,LEDbx403,LEDbx404,LEDbx405,LEDbx406)

' Jackpot Digits

Digits(32)=Array(byg1, byg2, byg3 ,byg4, byg5, byg6, byg7, bygg)
Digits(33)=Array(byh1, byh2, byh3 ,byh4, byh5, byh6, byh7, byhg)
Digits(34)=Array(bya1, bya2, bya3, bya4, bya5, bya6, bya7, byag)
Digits(35)=Array(byb1, byb2, byb3, byb4, byb5, byb6, byb7, bybg)
Digits(36)=Array(byc1, byc2, byc3, byc4, byc5, byc6, byc7, bycg)
Digits(37)=Array(byd1, byd2, byd3, byd4, byd5, byd6, byd7, bydg)
Digits(38)=Array(bye1, bye2, bye3, bye4, bye5, bye6, bye7, byeg)

 
Sub DisplayTimer()
    Dim ChgLED, ii, jj, num, chg, stat, obj, b, x
    ChgLED=Controller.ChangedLEDs(&Hffffffff, &Hffffffff)
    If Not IsEmpty(ChgLED)Then
       For ii=0 To UBound(chgLED)
          num=chgLED(ii, 0) : chg=chgLED(ii, 1) : stat=chgLED(ii, 2)
			if (num < 39) then
				if VRRoom > 0 Then
				For Each obj In Digits(num)
                   If chg And 1 Then obj.visible=stat And 1
                   chg=chg\2 : stat=stat\2
                  Next
				end If
				if DesktopMode = True and VRRoom < 1 Then
					if (num >= DigitsOffset+0) and (num <= DigitsOffset+6) then
						For Each obj In DigitsDT(num)
						If chg And 1 Then obj.State=stat And 1
						chg=chg\2 : stat=stat\2
						Next
					end If
				end If
				else
			end if
		Next
    End If
 End Sub



'******************************************************
'iaakki - TargetBouncer for targets and posts
'******************************************************
Dim zMultiplier

sub TargetBouncer(aBall,defvalue)
	if TargetBouncerEnabled <> 0 and aball.z < 30 then
		'debug.print "velz: " & activeball.velz
		Select Case Int(Rnd * 4) + 1
			Case 1: zMultiplier = defvalue+1.1
			Case 2: zMultiplier = defvalue+1.05
			Case 3: zMultiplier = defvalue+0.7
			Case 4: zMultiplier = defvalue+0.3
		End Select
		aBall.velz = aBall.velz * zMultiplier * TargetBouncerFactor
		'debug.print "----> velz: " & activeball.velz
	end if
end sub


'******************************************************
'		TRACK ALL BALL VELOCITIES
' 		FOR RUBBER DAMPENER AND DROP TARGETS
'******************************************************

dim cor : set cor = New CoRTracker

Class CoRTracker
	public ballvel, ballvelx, ballvely

	Private Sub Class_Initialize : redim ballvel(0) : redim ballvelx(0): redim ballvely(0) : End Sub 

	Public Sub Update()	'tracks in-ball-velocity
		dim str, b, AllBalls, highestID : allBalls = getballs

		for each b in allballs
			if b.id >= HighestID then highestID = b.id
		Next

		if uBound(ballvel) < highestID then redim ballvel(highestID)	'set bounds
		if uBound(ballvelx) < highestID then redim ballvelx(highestID)	'set bounds
		if uBound(ballvely) < highestID then redim ballvely(highestID)	'set bounds

		for each b in allballs
			ballvel(b.id) = BallSpeed(b)
			ballvelx(b.id) = b.velx
			ballvely(b.id) = b.vely
		Next
	End Sub
End Class

Sub RDampen_timer()
	Cor.Update
End Sub

'****************************************************************************
'PHYSICS DAMPENERS

'These are data mined bounce curves, 
'dialed in with the in-game elasticity as much as possible to prevent angle / spin issues.
'Requires tracking ballspeed to calculate COR


Sub dPosts_Hit(idx) 
	RubbersD.dampen Activeball
	TargetBouncer Activeball, 1
End Sub

Sub dSleeves_Hit(idx) 
	SleevesD.Dampen Activeball
	TargetBouncer Activeball, 0.7
End Sub


dim RubbersD : Set RubbersD = new Dampener	'frubber
RubbersD.name = "Rubbers"
RubbersD.debugOn = False	'shows info in textbox "TBPout"
RubbersD.Print = False	'debug, reports in debugger (in vel, out cor)
'cor bounce curve (linear)
'for best results, try to match in-game velocity as closely as possible to the desired curve
'RubbersD.addpoint 0, 0, 0.935	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 0, 0, 0.96	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 1, 3.77, 0.96
RubbersD.addpoint 2, 5.76, 0.967	'dont take this as gospel. if you can data mine rubber elasticitiy, please help!
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
'		RealCOR = BallSpeed(aBall) / cor.ballvel(aBall.id)
		RealCOR = BallSpeed(aBall) / (cor.ballvel(aBall.id)+0.00000000001)
		coef = desiredcor / realcor 
		if debugOn then str = name & " in vel:" & round(cor.ballvel(aBall.id),2 ) & vbnewline & "desired cor: " & round(desiredcor,4) & vbnewline & _
		"actual cor: " & round(realCOR,4) & vbnewline & "ballspeed coef: " & round(coef, 3) & vbnewline 
		if Print then debug.print Round(cor.ballvel(aBall.id),2) & ", " & round(desiredcor,3)
		
		aBall.velx = aBall.velx * coef : aBall.vely = aBall.vely * coef
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


'******************************************************
'                        FLIPPER CORRECTION FUNCTIONS
'******************************************************

Sub AddPt(aStr, idx, aX, aY)        'debugger wrapper for adjusting flipper script in-game
        dim a : a = Array(LF, RF)
        dim x : for each x in a
                x.addpoint aStr, idx, aX, aY
        Next
End Sub

Class FlipperPolarity
        Public DebugOn, Enabled
        Private FlipAt        'Timer variable (IE 'flip at 723,530ms...)
        Public TimeDelay        'delay before trigger turns off and polarity is disabled TODO set time!
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

        Public Sub Report(aChooseArray)         'debug, reports all coords in tbPL.text
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
        Private Function FlipperOn() : if gameTime < FlipAt+TimeDelay then FlipperOn = True : End If : End Function        'Timer shutoff for polaritycorrect
        
        Public Sub PolarityCorrect(aBall)
                if FlipperOn() then 
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
                                        if ballpos > 0.65 then  Ycoef = LinearEnvelope(BallData(x).Y, YcoefIn, YcoefOut)                                'find safety coefficient 'ycoef' data
                                end if
                        Next

                        If BallPos = 0 Then 'no ball data meaning the ball is entering and exiting pretty close to the same position, use current values.
                                BallPos = PSlope(aBall.x, FlipperStart, 0, FlipperEnd, 1)
                                if ballpos > 0.65 then  Ycoef = LinearEnvelope(aBall.Y, YcoefIn, YcoefOut)                                                'find safety coefficient 'ycoef' data
                        End If

                        'Velocity correction
                        if not IsEmpty(VelocityIn(0) ) then
                                Dim VelCoef
         :                         VelCoef = LinearEnvelope(BallPos, VelocityIn, VelocityOut)

                                if partialflipcoef < 1 then VelCoef = PSlope(partialflipcoef, 0, 1, 1, VelCoef)

                                if Enabled then aBall.Velx = aBall.Velx*VelCoef
                                if Enabled then aBall.Vely = aBall.Vely*VelCoef
                        End If

                        'Polarity Correction (optional now)
                        if not IsEmpty(PolarityIn(0) ) then
                                If StartPoint > EndPoint then LR = -1        'Reverse polarity if left flipper
                                dim AddX : AddX = LinearEnvelope(BallPos, PolarityIn, PolarityOut) * LR
        
                                if Enabled then aBall.VelX = aBall.VelX + 1 * (AddX*ycoef*PartialFlipcoef)
                                'playsound "fx_knocker"
                        End If
                End If
                RemoveBall aBall
        End Sub
End Class

'******************************************************
'                FLIPPER POLARITY AND RUBBER DAMPENER
'                        SUPPORTING FUNCTIONS 
'******************************************************

' Used for flipper correction and rubber dampeners
Sub ShuffleArray(ByRef aArray, byVal offset) 'shuffle 1d array
        dim x, aCount : aCount = 0
        redim a(uBound(aArray) )
        for x = 0 to uBound(aArray)        'Shuffle objects in a temp array
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
        redim aArray(aCount-1+offset)        'Resize original array
        for x = 0 to aCount-1                'set objects back into original array
                if IsObject(a(x)) then 
                        Set aArray(x) = a(x)
                Else
                        aArray(x) = a(x)
                End If
        Next
End Sub

' Used for flipper correction and rubber dampeners
Sub ShuffleArrays(aArray1, aArray2, offset)
        ShuffleArray aArray1, offset
        ShuffleArray aArray2, offset
End Sub

' Used for flipper correction, rubber dampeners, and drop targets
Function BallSpeed(ball) 'Calculates the ball speed
    BallSpeed = SQR(ball.VelX^2 + ball.VelY^2 + ball.VelZ^2)
End Function

' Used for flipper correction and rubber dampeners
Function PSlope(Input, X1, Y1, X2, Y2)        'Set up line via two points, no clamping. Input X, output Y
        dim x, y, b, m : x = input : m = (Y2 - Y1) / (X2 - X1) : b = Y2 - m*X2
        Y = M*x+b
        PSlope = Y
End Function

' Used for flipper correction
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

' Used for flipper correction and rubber dampeners
Function LinearEnvelope(xInput, xKeyFrame, yLvl)
        dim y 'Y output
        dim L 'Line
        dim ii : for ii = 1 to uBound(xKeyFrame)        'find active line
                if xInput <= xKeyFrame(ii) then L = ii : exit for : end if
        Next
        if xInput > xKeyFrame(uBound(xKeyFrame) ) then L = uBound(xKeyFrame)        'catch line overrun
        Y = pSlope(xInput, xKeyFrame(L-1), yLvl(L-1), xKeyFrame(L), yLvl(L) )

        if xInput <= xKeyFrame(lBound(xKeyFrame) ) then Y = yLvl(lBound(xKeyFrame) )         'Clamp lower
        if xInput >= xKeyFrame(uBound(xKeyFrame) ) then Y = yLvl(uBound(xKeyFrame) )        'Clamp upper

        LinearEnvelope = Y
End Function

' Used for drop targets and flipper tricks
Function Distance(ax,ay,bx,by)
        Distance = SQR((ax - bx)^2 + (ay - by)^2)
End Function


'******************************************************
'		FLIPPER CORRECTION INITIALIZATION
'******************************************************

dim LF : Set LF = New FlipperPolarity
dim RF : Set RF = New FlipperPolarity

InitPolarity

Sub InitPolarity()
	dim x, a : a = Array(LF, RF)
	for each x in a
		x.AddPoint "Ycoef", 0, RightFlipper.Y-65, 1	'disabled
		x.AddPoint "Ycoef", 1, RightFlipper.Y-11, 1
		x.enabled = True
		x.TimeDelay = 80
	Next

	AddPt "Polarity", 0, 0, 0
	AddPt "Polarity", 1, 0.05, -3.7	
	AddPt "Polarity", 2, 0.33, -3.7
	AddPt "Polarity", 3, 0.37, -3.7
	AddPt "Polarity", 4, 0.41, -3.7
	AddPt "Polarity", 5, 0.45, -3.7 
	AddPt "Polarity", 6, 0.576,-3.7
	AddPt "Polarity", 7, 0.66, -2.3
	AddPt "Polarity", 8, 0.743, -1.5
	AddPt "Polarity", 9, 0.81, -1
	AddPt "Polarity", 10, 0.88, 0

	addpt "Velocity", 0, 0, 	1
	addpt "Velocity", 1, 0.16, 1.06
	addpt "Velocity", 2, 0.41, 	1.05
	addpt "Velocity", 3, 0.53, 	1'0.982
	addpt "Velocity", 4, 0.702, 0.968
	addpt "Velocity", 5, 0.95,  0.968
	addpt "Velocity", 6, 1.03, 	0.945

	LF.Object = LeftFlipper	
	LF.EndPoint = EndPointLp
	RF.Object = RightFlipper
	RF.EndPoint = EndPointRp
End Sub

Sub TriggerLF_Hit() : LF.Addball activeball : End Sub
Sub TriggerLF_UnHit() : LF.PolarityCorrect activeball : End Sub
Sub TriggerRF_Hit() : RF.Addball activeball : End Sub
Sub TriggerRF_UnHit() : RF.PolarityCorrect activeball : End Sub


'******************************************************
'                        FLIPPER TRICKS
'******************************************************

RightFlipper.timerinterval=1
Rightflipper.timerenabled=True

sub RightFlipper_timer()
        FlipperTricks LeftFlipper, LFPress, LFCount, LFEndAngle, LFState
        FlipperTricks RightFlipper, RFPress, RFCount, RFEndAngle, RFState
        FlipperNudge RightFlipper, RFEndAngle, RFEOSNudge, LeftFlipper, LFEndAngle
        FlipperNudge LeftFlipper, LFEndAngle, LFEOSNudge,  RightFlipper, RFEndAngle
end sub

Dim LFEOSNudge, RFEOSNudge

Sub FlipperNudge(Flipper1, Endangle1, EOSNudge1, Flipper2, EndAngle2)
        Dim BOT, b

        If Flipper1.currentangle = Endangle1 and EOSNudge1 <> 1 Then
                EOSNudge1 = 1
                'debug.print Flipper1.currentangle &" = "& Endangle1 &"--"& Flipper2.currentangle &" = "& EndAngle2
                If Flipper2.currentangle = EndAngle2 Then 
                        BOT = GetBalls
                        For b = 0 to Ubound(BOT)
                                If FlipperTrigger(BOT(b).x, BOT(b).y, Flipper1) Then
                                        'Debug.Print "ball in flip1. exit"
                                         exit Sub
                                end If
                        Next
                        For b = 0 to Ubound(BOT)
                                If FlipperTrigger(BOT(b).x, BOT(b).y, Flipper2) Then
                                        BOT(b).velx = BOT(b).velx / 1.3
                                        BOT(b).vely = BOT(b).vely - 0.5
                                end If
                        Next
                End If
        Else 
                If Flipper1.currentangle <> EndAngle1 then 
                        EOSNudge1 = 0
                end if
        End If
End Sub

'*****************
' Maths
'*****************
Const PI = 3.1415927

Function dSin(degrees)
        dsin = sin(degrees * Pi/180)
End Function

Function dCos(degrees)
        dcos = cos(degrees * Pi/180)
End Function

'*************************************************
' Check ball distance from Flipper for Rem
'*************************************************

Function Distance(ax,ay,bx,by)
        Distance = SQR((ax - bx)^2 + (ay - by)^2)
End Function

Function DistancePL(px,py,ax,ay,bx,by) ' Distance between a point and a line where point is px,py
        DistancePL = ABS((by - ay)*px - (bx - ax) * py + bx*ay - by*ax)/Distance(ax,ay,bx,by)
End Function

Function Radians(Degrees)
        Radians = Degrees * PI /180
End Function

Function AnglePP(ax,ay,bx,by)
        AnglePP = Atn2((by - ay),(bx - ax))*180/PI
End Function

Function DistanceFromFlipper(ballx, bally, Flipper)
        DistanceFromFlipper = DistancePL(ballx, bally, Flipper.x, Flipper.y, Cos(Radians(Flipper.currentangle+90))+Flipper.x, Sin(Radians(Flipper.currentangle+90))+Flipper.y)
End Function

Function FlipperTrigger(ballx, bally, Flipper)
        Dim DiffAngle
        DiffAngle  = ABS(Flipper.currentangle - AnglePP(Flipper.x, Flipper.y, ballx, bally) - 90)
        If DiffAngle > 180 Then DiffAngle = DiffAngle - 360

        If DistanceFromFlipper(ballx,bally,Flipper) < 48 and DiffAngle <= 90 and Distance(ballx,bally,Flipper.x,Flipper.y) < Flipper.Length Then
                FlipperTrigger = True
        Else
                FlipperTrigger = False
        End If        
End Function

' Used for drop targets and stand up targets
Function Atn2(dy, dx)
        dim pi
        pi = 4*Atn(1)

        If dx > 0 Then
                Atn2 = Atn(dy / dx)
        ElseIf dx < 0 Then
                If dy = 0 Then 
                        Atn2 = pi
                Else
                        Atn2 = Sgn(dy) * (pi - Atn(Abs(dy / dx)))
                end if
        ElseIf dx = 0 Then
                if dy = 0 Then
                        Atn2 = 0
                else
                        Atn2 = Sgn(dy) * pi / 2
                end if
        End If
End Function

'*************************************************
' End - Check ball distance from Flipper for Rem
'*************************************************

dim LFPress, RFPress, LFCount, RFCount
dim LFState, RFState
dim EOST, EOSA,Frampup, FElasticity,FReturn
dim RFEndAngle, LFEndAngle

EOST = leftflipper.eostorque
EOSA = leftflipper.eostorqueangle
Frampup = LeftFlipper.rampup
FElasticity = LeftFlipper.elasticity
FReturn = LeftFlipper.return
Const EOSTnew = 0.8 
Const EOSAnew = 1
Const EOSRampup = 0
Dim SOSRampup
Select Case FlipperCoilRampupMode 
	Case 0:
		SOSRampup = 2.5
	Case 1:
		SOSRampup = 6
	Case 2:
		SOSRampup = 8.5
End Select
Const LiveCatch = 16
Const LiveElasticity = 0.45
Const SOSEM = 0.815
Const EOSReturn = 0.025

LFEndAngle = Leftflipper.endangle
RFEndAngle = RightFlipper.endangle

Sub FlipperActivate(Flipper, FlipperPress)
        FlipperPress = 1
        Flipper.Elasticity = FElasticity

        Flipper.eostorque = EOST         
        Flipper.eostorqueangle = EOSA         
End Sub

Sub FlipperDeactivate(Flipper, FlipperPress)
        FlipperPress = 0
        Flipper.eostorqueangle = EOSA
        Flipper.eostorque = EOST*EOSReturn/FReturn

        
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
        Dir = Flipper.startangle/Abs(Flipper.startangle)        '-1 for Right Flipper

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
                        Flipper.eostorque = EOST        
                        Flipper.eostorqueangle = EOSA
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
        Dir = Flipper.startangle/Abs(Flipper.startangle)    '-1 for Right Flipper
        Dim LiveCatchBounce                                                                                                                        'If live catch is not perfect, it won't freeze ball totally
        Dim CatchTime : CatchTime = GameTime - FCount

        if CatchTime <= LiveCatch and parm > 6 and ABS(Flipper.x - ball.x) > LiveDistanceMin and ABS(Flipper.x - ball.x) < LiveDistanceMax Then
                if CatchTime <= LiveCatch*0.5 Then                                                'Perfect catch only when catch time happens in the beginning of the window
                        LiveCatchBounce = 0
                else
                        LiveCatchBounce = Abs((LiveCatch/2) - CatchTime)        'Partial catch when catch happens a bit late
                end If

                If LiveCatchBounce = 0 and ball.velx * Dir > 0 Then ball.velx = 0
                ball.vely = LiveCatchBounce * (32 / LiveCatch) ' Multiplier for inaccuracy bounce
                ball.angmomx= 0
                ball.angmomy= 0
                ball.angmomz= 0
        End If
End Sub

Sub LeftFlipper_Collide(parm)
	CheckLiveCatch Activeball, LeftFlipper, LFCount, parm
	LeftFlipperCollide parm
	if RubberizerEnabled = 1 then Rubberizer(parm)
	if RubberizerEnabled = 2 then Rubberizer2(parm)
End Sub

Sub RightFlipper_Collide(parm)
	CheckLiveCatch Activeball, RightFlipper, RFCount, parm
	RightFlipperCollide parm
	if RubberizerEnabled = 1 then Rubberizer(parm)
	if RubberizerEnabled = 2 then Rubberizer2(parm)
End Sub

sub Rubberizer2(parm)
	if parm < 10 And parm > 2 And Abs(activeball.angmomz) < 10 then
		'debug.print "parm: " & parm & " momz: " & activeball.angmomz &" vely: "& activeball.vely
		activeball.angmomz = -activeball.angmomz * 2
		activeball.vely = activeball.vely * 1.2
		'debug.print ">> newmomz: " & activeball.angmomz&" newvely: "& activeball.vely
	Elseif parm <= 2 and parm > 0.2 Then
		'debug.print "* parm: " & parm & " momz: " & activeball.angmomz &" vely: "& activeball.vely
		activeball.angmomz = -activeball.angmomz * 0.5
		activeball.vely = activeball.vely * (1.2 + rnd(1)/3 )
		'debug.print "**** >> newmomz: " & activeball.angmomz&" newvely: "& activeball.vely
	end if
end sub

' iaakki Rubberizer
sub Rubberizer(parm)
	if parm < 10 And parm > 2 And Abs(activeball.angmomz) < 10 then
		'debug.print "parm: " & parm & " momz: " & activeball.angmomz &" vely: "& activeball.vely
		activeball.angmomz = activeball.angmomz * 1.2
		activeball.vely = activeball.vely * 1.2
		'debug.print ">> newmomz: " & activeball.angmomz&" newvely: "& activeball.vely
	Elseif parm <= 2 and parm > 0.2 Then
		'debug.print "* parm: " & parm & " momz: " & activeball.angmomz &" vely: "& activeball.vely
		activeball.angmomz = activeball.angmomz * -1.1
		activeball.vely = activeball.vely * 1.4
		'debug.print "**** >> newmomz: " & activeball.angmomz&" newvely: "& activeball.vely
	end if
end sub




'////////////////////////////  MECHANICAL SOUNDS  ///////////////////////////
'//  This part in the script is an entire block that is dedicated to the physics sound system.
'//  Various scripts and sounds that may be pretty generic and could suit other WPC systems, but the most are tailored specifically for this table.

'///////////////////////////////  SOUNDS PARAMETERS  //////////////////////////////
Dim GlobalSoundLevel, CoinSoundLevel, PlungerReleaseSoundLevel, PlungerPullSoundLevel, NudgeLeftSoundLevel
Dim NudgeRightSoundLevel, NudgeCenterSoundLevel, StartButtonSoundLevel, RollingSoundFactor

CoinSoundLevel = 1                                                                                                                'volume level; range [0, 1]
NudgeLeftSoundLevel = 1                                                                                                        'volume level; range [0, 1]
NudgeRightSoundLevel = 1                                                                                                'volume level; range [0, 1]
NudgeCenterSoundLevel = 1                                                                                                'volume level; range [0, 1]
StartButtonSoundLevel = 0.1                                                                                                'volume level; range [0, 1]
PlungerReleaseSoundLevel = 0.8 '1 wjr                                                                                        'volume level; range [0, 1]
PlungerPullSoundLevel = 1                                                                                                'volume level; range [0, 1]
RollingSoundFactor = 1.1/5                

'///////////////////////-----Solenoids, Kickers and Flash Relays-----///////////////////////
Dim FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel, FlipperUpAttackLeftSoundLevel, FlipperUpAttackRightSoundLevel
Dim FlipperUpSoundLevel, FlipperDownSoundLevel, FlipperLeftHitParm, FlipperRightHitParm
Dim SlingshotSoundLevel, BumperSoundFactor, KnockerSoundLevel

FlipperUpAttackMinimumSoundLevel = 0.010                                                           'volume level; range [0, 1]
FlipperUpAttackMaximumSoundLevel = 0.635                                                                'volume level; range [0, 1]
FlipperUpSoundLevel = 1.0                                                                        'volume level; range [0, 1]
FlipperDownSoundLevel = 0.45                                                                      'volume level; range [0, 1]
FlipperLeftHitParm = FlipperUpSoundLevel                                                                'sound helper; not configurable
FlipperRightHitParm = FlipperUpSoundLevel                                                                'sound helper; not configurable
SlingshotSoundLevel = 0.95                                                                                                'volume level; range [0, 1]
BumperSoundFactor = 4.25                                                                                                'volume multiplier; must not be zero
KnockerSoundLevel = 1                                                                                                         'volume level; range [0, 1]

'///////////////////////-----Ball Drops, Bumps and Collisions-----///////////////////////
Dim RubberStrongSoundFactor, RubberWeakSoundFactor, RubberFlipperSoundFactor,BallWithBallCollisionSoundFactor
Dim BallBouncePlayfieldSoftFactor, BallBouncePlayfieldHardFactor, PlasticRampDropToPlayfieldSoundLevel, WireRampDropToPlayfieldSoundLevel, DelayedBallDropOnPlayfieldSoundLevel
Dim WallImpactSoundFactor, MetalImpactSoundFactor, SubwaySoundLevel, SubwayEntrySoundLevel, ScoopEntrySoundLevel
Dim SaucerLockSoundLevel, SaucerKickSoundLevel

BallWithBallCollisionSoundFactor = 3.2                                                                        'volume multiplier; must not be zero
RubberStrongSoundFactor = 0.055/5                                                                                        'volume multiplier; must not be zero
RubberWeakSoundFactor = 0.075/5                                                                                        'volume multiplier; must not be zero
RubberFlipperSoundFactor = 0.075/5                                                                                'volume multiplier; must not be zero
BallBouncePlayfieldSoftFactor = 0.025                                                                        'volume multiplier; must not be zero
BallBouncePlayfieldHardFactor = 0.025                                                                        'volume multiplier; must not be zero
DelayedBallDropOnPlayfieldSoundLevel = 0.8                                                                        'volume level; range [0, 1]
WallImpactSoundFactor = 0.075                                                                                        'volume multiplier; must not be zero
MetalImpactSoundFactor = 0.075/3
SaucerLockSoundLevel = 0.8
SaucerKickSoundLevel = 0.8

'///////////////////////-----Gates, Spinners, Rollovers and Targets-----///////////////////////

Dim GateSoundLevel, TargetSoundFactor, SpinnerSoundLevel, RolloverSoundLevel, DTSoundLevel

GateSoundLevel = 0.5/5                                                                                                        'volume level; range [0, 1]
TargetSoundFactor = 0.0025 * 100                                                                                        'volume multiplier; must not be zero
DTSoundLevel = 0.25                                                                                                                'volume multiplier; must not be zero
RolloverSoundLevel = 0.25                                                                      'volume level; range [0, 1]

'///////////////////////-----Ball Release, Guides and Drain-----///////////////////////
Dim DrainSoundLevel, BallReleaseSoundLevel, BottomArchBallGuideSoundFactor, FlipperBallGuideSoundFactor 

DrainSoundLevel = 0.8                                                                                                                'volume level; range [0, 1]
BallReleaseSoundLevel = 1                                                                                                'volume level; range [0, 1]
BottomArchBallGuideSoundFactor = 0.2                                                                        'volume multiplier; must not be zero
FlipperBallGuideSoundFactor = 0.015                                                                                'volume multiplier; must not be zero

'///////////////////////-----Loops and Lanes-----///////////////////////
Dim ArchSoundFactor
ArchSoundFactor = 0.025/5                                                                                                        'volume multiplier; must not be zero


'/////////////////////////////  SOUND PLAYBACK FUNCTIONS  ////////////////////////////
'/////////////////////////////  POSITIONAL SOUND PLAYBACK METHODS  ////////////////////////////
' Positional sound playback methods will play a sound, depending on the X,Y position of the table element or depending on ActiveBall object position
' These are similar subroutines that are less complicated to use (e.g. simply use standard parameters for the PlaySound call)
' For surround setup - positional sound playback functions will fade between front and rear surround channels and pan between left and right channels
' For stereo setup - positional sound playback functions will only pan between left and right channels
' For mono setup - positional sound playback functions will not pan between left and right channels and will not fade between front and rear channels

' PlaySound full syntax - PlaySound(string, int loopcount, float volume, float pan, float randompitch, int pitch, bool useexisting, bool restart, float front_rear_fade)
' Note - These functions will not work (currently) for walls/slingshots as these do not feature a simple, single X,Y position
Sub PlaySoundAtLevelStatic(playsoundparams, aVol, tableobj)
    PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelExistingStatic(playsoundparams, aVol, tableobj)
    PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 1, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticLoop(playsoundparams, aVol, tableobj)
    PlaySound playsoundparams, -1, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelExistingLoop(playsoundparams, aVol, tableobj)
    PlaySound playsoundparams, -1, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 1, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticRandomPitch(playsoundparams, aVol, randomPitch, tableobj)
    PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelActiveBall(playsoundparams, aVol)
        PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ActiveBall), 0, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLevelExistingActiveBall(playsoundparams, aVol)
        PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ActiveBall), 0, 0, 1, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLeveTimerActiveBall(playsoundparams, aVol, ballvariable)
        PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ballvariable), 0, 0, 0, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelTimerExistingActiveBall(playsoundparams, aVol, ballvariable)
        PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ballvariable), 0, 0, 1, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelRoll(playsoundparams, aVol, pitch)
    PlaySound playsoundparams, -1, aVol * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

' Previous Positional Sound Subs

Sub PlaySoundAt(soundname, tableobj)
    PlaySound soundname, 1, 1 * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtVol(soundname, tableobj, aVol)
    PlaySound soundname, 1, aVol * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname)
    PlaySoundAt soundname, ActiveBall
End Sub

Sub PlaySoundAtBallVol (Soundname, aVol)
        Playsound soundname, 1,aVol * VolumeDial, AudioPan(ActiveBall), 0,0,0, 1, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtBallVolM (Soundname, aVol)
        Playsound soundname, 1,aVol * VolumeDial, AudioPan(ActiveBall), 0,0,0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtVolLoops(sound, tableobj, Vol, Loops)
        PlaySound sound, Loops, Vol * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub


' *********************************************************************
'                     Fleep  Supporting Ball & Sound Functions
' *********************************************************************

Dim tablewidth, tableheight : tablewidth = Taxi.width : tableheight = Taxi.height

Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
        Dim tmp
    tmp = tableobj.y * 2 / tableheight-1
    If tmp > 0 Then
                AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10) )
    End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = tableobj.x * 2 / tablewidth-1
    If tmp > 0 Then
        AudioPan = Csng(tmp ^10)
    Else
        AudioPan = Csng(-((- tmp) ^10) )
    End If
End Function

Function Vol(ball) ' Calculates the volume of the sound based on the ball speed
        Vol = Csng(BallVel(ball) ^2)
End Function

Function Volz(ball) ' Calculates the volume of the sound based on the ball speed
        Volz = Csng((ball.velz) ^2)
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
    Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
    BallVel = INT(SQR((ball.VelX ^2) + (ball.VelY ^2) ) )
End Function

Function VolPlayfieldRoll(ball) ' Calculates the roll volume of the sound based on the ball speed
        VolPlayfieldRoll = RollingSoundFactor * 0.0005 * Csng(BallVel(ball) ^3)
End Function

Function PitchPlayfieldRoll(ball) ' Calculates the roll pitch of the sound based on the ball speed
    PitchPlayfieldRoll = BallVel(ball) ^2 * 15
End Function

Function RndInt(min, max)
    RndInt = Int(Rnd() * (max-min + 1) + min)' Sets a random number integer between min and max
End Function

Function RndNum(min, max)
    RndNum = Rnd() * (max-min) + min' Sets a random number between min and max
End Function

'/////////////////////////////  GENERAL SOUND SUBROUTINES  ////////////////////////////
Sub SoundStartButton()
        PlaySound ("Start_Button"), 0, StartButtonSoundLevel, 0, 0.25
End Sub

Sub SoundNudgeLeft()
        PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeLeftSoundLevel * VolumeDial, -0.1, 0.25
End Sub

Sub SoundNudgeRight()
        PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
End Sub

Sub SoundNudgeCenter()
        PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeCenterSoundLevel * VolumeDial, 0, 0.25
End Sub


Sub SoundPlungerPull()
        PlaySoundAtLevelStatic ("Plunger_Pull_1"), PlungerPullSoundLevel, Plunger
End Sub

Sub SoundPlungerReleaseBall()
        PlaySoundAtLevelStatic ("Plunger_Release_Ball"), PlungerReleaseSoundLevel, Plunger        
End Sub

Sub SoundPlungerReleaseNoBall()
        PlaySoundAtLevelStatic ("Plunger_Release_No_Ball"), PlungerReleaseSoundLevel, Plunger
End Sub


'/////////////////////////////  KNOCKER SOLENOID  ////////////////////////////
Sub KnockerSolenoid()
        PlaySoundAtLevelStatic SoundFX("Knocker_1",DOFKnocker), KnockerSoundLevel, KnockerPosition
End Sub

'/////////////////////////////  DRAIN SOUNDS  ////////////////////////////
Sub RandomSoundDrain(drainswitch)
        PlaySoundAtLevelStatic ("Drain_" & Int(Rnd*11)+1), DrainSoundLevel, drainswitch
End Sub

'/////////////////////////////  TROUGH BALL RELEASE SOLENOID SOUNDS  ////////////////////////////

Sub RandomSoundBallRelease(drainswitch)
        PlaySoundAtLevelStatic SoundFX("BallRelease" & Int(Rnd*7)+1,DOFContactors), BallReleaseSoundLevel, drainswitch
End Sub

'/////////////////////////////  SLINGSHOT SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundSlingshotLeft(sling)
        PlaySoundAtLevelStatic SoundFX("Sling_L" & Int(Rnd*10)+1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

Sub RandomSoundSlingshotRight(sling)
        PlaySoundAtLevelStatic SoundFX("Sling_R" & Int(Rnd*8)+1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

'/////////////////////////////  BUMPER SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundBumperTop(Bump)
        PlaySoundAtLevelStatic SoundFX("Bumpers_Top_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperMiddle(Bump)
        PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperBottom(Bump)
        PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

'/////////////////////////////  FLIPPER BATS SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  FLIPPER BATS SOLENOID ATTACK SOUND  ////////////////////////////
Sub SoundFlipperUpAttackLeft(flipper)
        FlipperUpAttackLeftSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
        PlaySoundAtLevelStatic ("Flipper_Attack-L01"), FlipperUpAttackLeftSoundLevel, flipper
End Sub

Sub SoundFlipperUpAttackRight(flipper)
        FlipperUpAttackRightSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
                PlaySoundAtLevelStatic ("Flipper_Attack-R01"), FlipperUpAttackLeftSoundLevel, flipper
End Sub

'/////////////////////////////  FLIPPER BATS SOLENOID CORE SOUND  ////////////////////////////
Sub RandomSoundFlipperUpLeft(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_L0" & Int(Rnd*9)+1,DOFFlippers), FlipperLeftHitParm, Flipper
End Sub

Sub RandomSoundFlipperUpRight(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_R0" & Int(Rnd*9)+1,DOFFlippers), FlipperRightHitParm, Flipper
End Sub

Sub RandomSoundReflipUpLeft(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L0" & Int(Rnd*3)+1,DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundReflipUpRight(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R0" & Int(Rnd*3)+1,DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownLeft(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_" & Int(Rnd*7)+1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownRight(flipper)
        PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_" & Int(Rnd*8)+1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

'/////////////////////////////  FLIPPER BATS BALL COLLIDE SOUND  ////////////////////////////

Sub LeftFlipperCollide(parm)
        FlipperLeftHitParm = parm/10
        If FlipperLeftHitParm > 1 Then
                FlipperLeftHitParm = 1
        End If
        FlipperLeftHitParm = FlipperUpSoundLevel * FlipperLeftHitParm
        RandomSoundRubberFlipper(parm)
End Sub

Sub RightFlipperCollide(parm)
        FlipperRightHitParm = parm/10
        If FlipperRightHitParm > 1 Then
                FlipperRightHitParm = 1
        End If
        FlipperRightHitParm = FlipperUpSoundLevel * FlipperRightHitParm
         RandomSoundRubberFlipper(parm)
End Sub

Sub RandomSoundRubberFlipper(parm)
        PlaySoundAtLevelActiveBall ("Flipper_Rubber_" & Int(Rnd*7)+1), parm  * RubberFlipperSoundFactor
End Sub

'/////////////////////////////  ROLLOVER SOUNDS  ////////////////////////////
Sub RandomSoundRollover()
        PlaySoundAtLevelActiveBall ("Rollover_" & Int(Rnd*4)+1), RolloverSoundLevel
End Sub

Sub Rollovers_Hit(idx)
        RandomSoundRollover
End Sub

'/////////////////////////////  VARIOUS PLAYFIELD SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  RUBBERS AND POSTS  ////////////////////////////
'/////////////////////////////  RUBBERS - EVENTS  ////////////////////////////
Sub Rubbers_Hit(idx)
         dim finalspeed
          finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
         If finalspeed > 5 then                
                 RandomSoundRubberStrong 1
        End if
        If finalspeed <= 5 then
                 RandomSoundRubberWeak()
         End If        
End Sub

'/////////////////////////////  RUBBERS AND POSTS - STRONG IMPACTS  ////////////////////////////
Sub RandomSoundRubberStrong(voladj)
        Select Case Int(Rnd*10)+1
                Case 1 : PlaySoundAtLevelActiveBall ("Rubber_Strong_1"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 2 : PlaySoundAtLevelActiveBall ("Rubber_Strong_2"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 3 : PlaySoundAtLevelActiveBall ("Rubber_Strong_3"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 4 : PlaySoundAtLevelActiveBall ("Rubber_Strong_4"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 5 : PlaySoundAtLevelActiveBall ("Rubber_Strong_5"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 6 : PlaySoundAtLevelActiveBall ("Rubber_Strong_6"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 7 : PlaySoundAtLevelActiveBall ("Rubber_Strong_7"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 8 : PlaySoundAtLevelActiveBall ("Rubber_Strong_8"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 9 : PlaySoundAtLevelActiveBall ("Rubber_Strong_9"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
                Case 10 : PlaySoundAtLevelActiveBall ("Rubber_1_Hard"), Vol(ActiveBall) * RubberStrongSoundFactor * 0.6*voladj
        End Select
End Sub

'/////////////////////////////  RUBBERS AND POSTS - WEAK IMPACTS  ////////////////////////////
Sub RandomSoundRubberWeak()
        PlaySoundAtLevelActiveBall ("Rubber_" & Int(Rnd*9)+1), Vol(ActiveBall) * RubberWeakSoundFactor
End Sub

'/////////////////////////////  WALL IMPACTS  ////////////////////////////
Sub Walls_Hit(idx)
	RandomSoundWall()      
End Sub

Sub RandomSoundWall()
         dim finalspeed
          finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
         If finalspeed > 16 then 
                Select Case Int(Rnd*5)+1
                        Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_1"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_2"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_5"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 4 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_7"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 5 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_9"), Vol(ActiveBall) * WallImpactSoundFactor
                End Select
        End if
        If finalspeed >= 6 AND finalspeed <= 16 then
                Select Case Int(Rnd*4)+1
                        Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_3"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 4 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
                End Select
         End If
        If finalspeed < 6 Then
                Select Case Int(Rnd*3)+1
                        Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
                        Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
                End Select
        End if
End Sub

'/////////////////////////////  METAL TOUCH SOUNDS  ////////////////////////////
Sub RandomSoundMetal()
        PlaySoundAtLevelActiveBall ("Metal_Touch_" & Int(Rnd*13)+1), Vol(ActiveBall) * MetalImpactSoundFactor
End Sub

'/////////////////////////////  METAL - EVENTS  ////////////////////////////

Sub Metals_Hit (idx)
        RandomSoundMetal
End Sub

Sub ShooterDiverter_collide(idx)
        RandomSoundMetal
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE  ////////////////////////////
'/////////////////////////////  BOTTOM ARCH BALL GUIDE - SOFT BOUNCES  ////////////////////////////
Sub RandomSoundBottomArchBallGuide()
         dim finalspeed
          finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
         If finalspeed > 16 then 
                PlaySoundAtLevelActiveBall ("Apron_Bounce_"& Int(Rnd*2)+1), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
        End if
        If finalspeed >= 6 AND finalspeed <= 16 then
                 Select Case Int(Rnd*2)+1
                        Case 1 : PlaySoundAtLevelActiveBall ("Apron_Bounce_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
                        Case 2 : PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
                End Select
         End If
        If finalspeed < 6 Then
                 Select Case Int(Rnd*2)+1
                        Case 1 : PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
                        Case 2 : PlaySoundAtLevelActiveBall ("Apron_Medium_3"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
                End Select
        End if
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE - HARD HITS  ////////////////////////////
Sub RandomSoundBottomArchBallGuideHardHit()
        PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_" & Int(Rnd*3)+1), BottomArchBallGuideSoundFactor * 0.25
End Sub

Sub Apron_Hit (idx)
        If Abs(cor.ballvelx(activeball.id) < 4) and cor.ballvely(activeball.id) > 7 then
                RandomSoundBottomArchBallGuideHardHit()
        Else
                RandomSoundBottomArchBallGuide
        End If
End Sub

'/////////////////////////////  FLIPPER BALL GUIDE  ////////////////////////////
Sub RandomSoundFlipperBallGuide()
         dim finalspeed
          finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
         If finalspeed > 16 then 
                 Select Case Int(Rnd*2)+1
                        Case 1 : PlaySoundAtLevelActiveBall ("Apron_Hard_1"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
                        Case 2 : PlaySoundAtLevelActiveBall ("Apron_Hard_2"),  Vol(ActiveBall) * 0.8 * FlipperBallGuideSoundFactor
                End Select
        End if
        If finalspeed >= 6 AND finalspeed <= 16 then
                PlaySoundAtLevelActiveBall ("Apron_Medium_" & Int(Rnd*3)+1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
         End If
        If finalspeed < 6 Then
                PlaySoundAtLevelActiveBall ("Apron_Soft_" & Int(Rnd*7)+1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
        End If
End Sub

'/////////////////////////////  TARGET HIT SOUNDS  ////////////////////////////
Sub RandomSoundTargetHitStrong()
        PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd*4)+5,DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
End Sub

Sub RandomSoundTargetHitWeak()                
        PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd*4)+1,DOFTargets), Vol(ActiveBall) * TargetSoundFactor
End Sub

Sub PlayTargetSound()
         dim finalspeed
          finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
         If finalspeed > 10 then
                 RandomSoundTargetHitStrong()
                RandomSoundBallBouncePlayfieldSoft Activeball
        Else 
                 RandomSoundTargetHitWeak()
         End If        
End Sub

Sub Targets_Hit (idx)
    PlayTargetSound
	TargetBouncer Activeball, 1.5
End Sub

'/////////////////////////////  BALL BOUNCE SOUNDS  ////////////////////////////
Sub RandomSoundBallBouncePlayfieldSoft(aBall)
        Select Case Int(Rnd*9)+1
                Case 1 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_1"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
                Case 2 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
                Case 3 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_3"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.8, aBall
                Case 4 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_4"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
                Case 5 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_5"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
                Case 6 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_1"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
                Case 7 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
                Case 8 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_5"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
                Case 9 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_7"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.3, aBall
        End Select
End Sub

Sub RandomSoundBallBouncePlayfieldHard(aBall)
        PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_" & Int(Rnd*7)+1), volz(aBall) * BallBouncePlayfieldHardFactor, aBall
End Sub

'/////////////////////////////  DELAYED DROP - TO PLAYFIELD - SOUND  ////////////////////////////
Sub RandomSoundDelayedBallDropOnPlayfield(aBall)
        Select Case Int(Rnd*5)+1
                Case 1 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_1_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
                Case 2 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_2_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
                Case 3 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_3_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
                Case 4 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_4_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
                Case 5 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_5_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
        End Select
End Sub

'/////////////////////////////  BALL GATES AND BRACKET GATES SOUNDS  ////////////////////////////

Sub SoundPlayfieldGate()                        
        PlaySoundAtLevelStatic ("Gate_FastTrigger_" & Int(Rnd*2)+1), GateSoundLevel, Activeball
End Sub

Sub SoundHeavyGate()
        PlaySoundAtLevelStatic ("Gate_2"), GateSoundLevel, Activeball
End Sub

Sub Gates_hit(idx)
        SoundHeavyGate
End Sub

Sub GatesWire_hit(idx)        
        SoundPlayfieldGate        
End Sub        

'/////////////////////////////  LEFT LANE ENTRANCE - SOUNDS  ////////////////////////////

Sub RandomSoundLeftArch()
        PlaySoundAtLevelActiveBall ("Arch_L" & Int(Rnd*4)+1), Vol(ActiveBall) * ArchSoundFactor
End Sub

Sub RandomSoundRightArch()
        PlaySoundAtLevelActiveBall ("Arch_R" & Int(Rnd*4)+1), Vol(ActiveBall) * ArchSoundFactor
End Sub


Sub Arch1_hit()
        If Activeball.velx > 1 Then SoundPlayfieldGate
        StopSound "Arch_L1"
        StopSound "Arch_L2"
        StopSound "Arch_L3"
        StopSound "Arch_L4"
End Sub

Sub Arch1_unhit()
        If activeball.velx < -8 Then
                RandomSoundRightArch
        End If
End Sub

Sub Arch2_hit()
        If Activeball.velx < 1 Then SoundPlayfieldGate
        StopSound "Arch_R1"
        StopSound "Arch_R2"
        StopSound "Arch_R3"
        StopSound "Arch_R4"
End Sub

Sub Arch2_unhit()
        If activeball.velx > 10 Then
                RandomSoundLeftArch
        End If
End Sub

'/////////////////////////////  SAUCERS (KICKER HOLES)  ////////////////////////////

Sub SoundSaucerLock()
        PlaySoundAtLevelStatic ("Saucer_Enter_" & Int(Rnd*2)+1), SaucerLockSoundLevel, Activeball
End Sub

Sub SoundSaucerKick(scenario, saucer)
        Select Case scenario
                Case 0: PlaySoundAtLevelStatic SoundFX("Saucer_Empty", DOFContactors), SaucerKickSoundLevel, saucer
                Case 1: PlaySoundAtLevelStatic SoundFX("Saucer_Kick", DOFContactors), SaucerKickSoundLevel, saucer
        End Select
End Sub

'/////////////////////////////  BALL COLLISION SOUND  ////////////////////////////
Sub OnBallBallCollision(ball1, ball2, velocity)
        Dim snd
        Select Case Int(Rnd*7)+1
                Case 1 : snd = "Ball_Collide_1"
                Case 2 : snd = "Ball_Collide_2"
                Case 3 : snd = "Ball_Collide_3"
                Case 4 : snd = "Ball_Collide_4"
                Case 5 : snd = "Ball_Collide_5"
                Case 6 : snd = "Ball_Collide_6"
                Case 7 : snd = "Ball_Collide_7"
        End Select

        PlaySound (snd), 0, Csng(velocity) ^2 / 200 * BallWithBallCollisionSoundFactor * VolumeDial, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub


'/////////////////////////////////////////////////////////////////
'                                        End Mechanical Sounds
'/////////////////////////////////////////////////////////////////

'Digits
Sub center_digits()

Dim xoff, yoff, zoff, xcen, ycen, ii, xx, yy, xfact, yfact, obj, xrot, zscale

xoff = 450 ' xoffset of destination (screen coords)
yoff = -60 ' yoffset of destination (screen coords) 
zoff = 1000 ' zoffset of destination (screen coords)
xrot = -87
zscale = .14

xcen =(1133 /2) - (53 / 2)
ycen =(1183 /2) + (133 /2)
yfact =80 'y fudge factor (ycen was wrong so fix)
xfact =80


for ii = 0 to 31
	For Each obj In Digits(ii)
	xx = obj.x
		
'	obj.x = (xoff -xcen) + (xx * 0.95) +xfact
	obj.x = (xoff -xcen) + (xx) +xfact
	yy = obj.y ' get the yoffset before it is changed
	obj.y =yoff 

		If(yy < 0.) then
		yy = yy * -1
		end if

	obj.height =( zoff - ycen) + yy - (yy * zscale) + yfact
	
	obj.rotx = xrot
	Next
	Next

for ii = 32 to 38
	For Each obj In Digits(ii)
	xx = obj.x
		
'	obj.x = (xoff -xcen) + (xx * 0.95) +xfact
	obj.x = (xoff -xcen) + (xx) +xfact
	yy = obj.y ' get the yoffset before it is changed
	obj.y =yoff -60

		If(yy < 0.) then
		yy = yy * -1
		end if

	obj.height =( zoff - ycen) + yy - (yy * zscale) + yfact
	
	obj.rotx = xrot
	Next
	Next
end sub

'////////////////////// Options //////////////////////

If FlipperColour = 1 Then
	RFLogo.image = "williamsbat"
	LFLogo.image = "williamsbat"
	Else
	RFLogo.image = "williamsbatyellowblue"
	LFLogo.image = "williamsbatyellowblue"
End If

If CabinetMode = 1 Then
	PinCab_Rails.visible = 0
	SideWood.visible=0
	SideWood1.visible=1
Else
	PinCab_Rails.visible = 1
	SideWood.visible=1
	SideWood1.visible=0
End If

DIM VRThings
If VRRoom > 0 Then
	Pincab_Rails.visible = 1
	If VRRoom = 1 Then
		for each VRThings in VRCab:VRThings.visible = 1:Next
	End If
	If VRRoom = 2 Then
		for each VRThings in VRCab:VRThings.visible = 0:Next
		PinCab_Backglass.visible = 1
		PinCab_Backbox.visible = 1
	End If
Else
	for each VRThings in VRCab:VRThings.visible = 0:Next
	If DesktopMode then Pincab_Rails.visible = 1 else Pincab_Rails.visible = 0 End If
End if
