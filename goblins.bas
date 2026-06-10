' goblins - picomite basic for picocalc
' 40 columns x 26 rows
' goal: find TREASURE then reach EXIT

Option Base 0
FONT 4
Dim w(99)

' colour constants (rgb888 for picomite)
Const RED      = RGB(255,0,0)
Const YELLOW   = RGB(255,255,0)
Const BLUE     = RGB(80,80,255)
Const GREEN    = RGB(0,255,0)
Const BROWN    = RGB(165,82,42)
Const PURPLE   = RGB(180,0,200)
Const LIGHTRED = RGB(255,120,120)
Const WHITE    = RGB(255,255,255)
Const DARK     = RGB(100,100,100)
Const BG       = RGB(0,0,0)
Const CYAN     = RGB(0,220,220)

' tile IDs
Const T_EMPTY   = 0
Const T_PLAYER  = 1
Const T_LOOT    = 2
Const T_KEY     = 3
Const T_DOOR    = 4
Const T_GOBLIN  = 5
Const T_TREASURE = 6
Const T_EXIT    = 7

Randomize Timer
CLS BG

' player position
p = 50
op = p
l = 0
k = 0
tf = 0
msg$ = ""

' init world
For i = 0 To 99
  w(i) = T_EMPTY
Next i


' place door/key pairs outward from center
minStep = 1
maxStep = 12
maxPairs = 3
cum = 0
For i = 1 To maxPairs
  stepVal = Int(Rnd * (maxStep - minStep + 1)) + minStep
  cum = cum + stepVal
  leftIdx = p - cum
  rightIdx = p + cum
  If leftIdx < 0 Or rightIdx > 99 Then Exit For
  If w(leftIdx) <> T_EMPTY Or w(rightIdx) <> T_EMPTY Then Exit For
  If Rnd < 0.5 Then
    w(leftIdx) = T_DOOR
    w(rightIdx) = T_KEY
  Else
    w(leftIdx) = T_KEY
    w(rightIdx) = T_DOOR
  EndIf
Next i

' place EXIT strictly at start or end
If Rnd < 0.5 Then
  exitIdx = 0
Else
  exitIdx = 99
EndIf
If w(exitIdx) = T_EMPTY Or w(exitIdx) = T_LOOT Then
  w(exitIdx) = T_EXIT
Else
  otherEnd = 99
  If exitIdx = 99 Then otherEnd = 0
  If w(otherEnd) = T_EMPTY Or w(otherEnd) = T_LOOT Then
    w(otherEnd) = T_EXIT
  Else
    If w(exitIdx) <> T_PLAYER Then
      If w(exitIdx) <> T_TREASURE Then
        w(exitIdx) = T_EXIT
      EndIf
    EndIf
  EndIf
EndIf

' place TREASURE (prefer along EXIT side beyond outermost door)
placedT = 0
If exitIdx = 0 Then
  leftMostDoor = -1
  For j = p - 1 To 0 Step -1
    If w(j) = T_DOOR Then
      leftMostDoor = j
      Exit For
    EndIf
  Next j
  target = p - 1
  If leftMostDoor <> -1 Then target = leftMostDoor - 1
  If target >= 1 Then
    If w(target) = T_EMPTY Then
      w(target) = T_TREASURE
      placedT = 1
    EndIf
  EndIf
Else
  rightMostDoor = -1
  For j = p + 1 To 99
    If w(j) = T_DOOR Then
      rightMostDoor = j
      Exit For
    EndIf
  Next j
  target = p + 1
  If rightMostDoor <> -1 Then target = rightMostDoor + 1
  If target <= 98 Then
    If w(target) = T_EMPTY Then
      w(target) = T_TREASURE
      placedT = 1
    EndIf
  EndIf
EndIf
If placedT = 0 Then
  For j = 1 To 98
    If j <> p Then
      If w(j) = T_EMPTY Then
        w(j) = T_TREASURE
        placedT = 1
        Exit For
      EndIf
    EndIf
  Next j
EndIf

' place remaining loot and goblins
ptile = T_LOOT
For i = 1 To 8
  GoSub place
Next i
ptile = T_GOBLIN
For i = 1 To 5
  GoSub place
Next i

w(p) = T_PLAYER

' tile legend:
' 0=empty 1=player 2=loot 3=key
' 4=door  5=goblin 6=treasure 7=exit

main:
  GoSub draw
  Do
    a$ = UCase$(Inkey$)
  Loop While a$ = ""

  If a$ = "A" Then
    If p > 0 Then
      op = p
      w(p) = T_EMPTY
      p = p - 1
      GoSub collide
    EndIf
  ElseIf a$ = "D" Then
    If p < 99 Then
      op = p
      w(p) = T_EMPTY
      p = p + 1
      GoSub collide
    EndIf
  ElseIf a$ = "Q" Then
    Colour GREEN, BG
    Print "bye!"
    End
  EndIf
  GoTo main

draw:
  CLS BG
  ' viewport: 21 cells (-10..+10) fits in 40 cols
  For x = -10 To 10
    c = p + x
    If c < 0 Or c > 99 Then
      Colour RED, BG
      Print "X";
    ElseIf w(c) = T_EMPTY Then
      Colour DARK, BG
      Print ".";
    ElseIf w(c) = T_PLAYER Then
      Colour BLUE, BG
      Print "@";
    ElseIf w(c) = T_LOOT Then
      Colour YELLOW, BG
      Print "l";
    ElseIf w(c) = T_KEY Then
      Colour RED, BG
      Print "k";
    ElseIf w(c) = T_DOOR Then
      Colour BROWN, BG
      Print "d";
    ElseIf w(c) = T_GOBLIN Then
      Colour GREEN, BG
      Print "g";
    ElseIf w(c) = T_TREASURE Then
      Colour PURPLE, BG
      Print "T";
    ElseIf w(c) = T_EXIT Then
      Colour CYAN, BG
      Print "E";
    EndIf
  Next x
  Print
  Colour YELLOW, BG
  If tf = 1 Then ts$ = "YES" Else ts$ = "no"
  Print "loot:" + Str$(l) + " keys:" + Str$(k) + " TREASURE:" + ts$
  Colour LIGHTRED, BG
  Print msg$
  msg$ = ""
  Colour WHITE, BG
  Print "a=left  d=right  q=quit"
  Return

bumpback:
  p = op
  w(p) = T_PLAYER
  Return

collide:
  If w(p) = T_EMPTY Then
    w(p) = T_PLAYER
  ElseIf w(p) = T_LOOT Then
    l = l + 1 : w(p) = T_PLAYER
    msg$ = "You picked up loot!"
  ElseIf w(p) = T_KEY Then
    k = k + 1 : w(p) = T_PLAYER
    msg$ = "You found a key!"
  ElseIf w(p) = T_DOOR Then
    If k > 0 Then
      k = k - 1 : w(p) = T_PLAYER
      msg$ = "Door opened!"
    Else
      GoSub bumpback
      msg$ = "No key! Door is locked."
    EndIf
  ElseIf w(p) = T_GOBLIN Then
    If l > 0 Then
      l = l - 1 : w(p) = T_PLAYER
      msg$ = "A goblin stole your loot!"
    Else
      GoSub bumpback
      msg$ = "Goblin blocks you! (no loot)"
    EndIf
  ElseIf w(p) = T_TREASURE Then
    tf = 1 : w(p) = T_PLAYER
    msg$ = "TREASURE found! Reach the EXIT!"
  ElseIf w(p) = T_EXIT Then
    If tf = 1 Then
      CLS BG
      Colour YELLOW, BG
      Print
      Print "  *** YOU WIN! ***"
      Print
      Print "  You found the treasure"
      Print "  and escaped the dungeon!"
      Print
      Colour WHITE, BG
      Print "  loot: " + Str$(l) + "   keys: " + Str$(k)
      End
    Else
      GoSub bumpback
      msg$ = "Exit sealed! Find TREASURE first."
    EndIf
  EndIf
  Return

place:
  placeTries = 0
  Do
    pr = Int(Rnd * 100)
    placeTries = placeTries + 1 
  Loop While w(pr) <> T_EMPTY Or pr = p
  w(pr) = ptile
  Return
