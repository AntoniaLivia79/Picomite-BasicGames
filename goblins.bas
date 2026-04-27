' goblins - picomite basic for picocalc
' 40 columns x 26 rows
' goal: find TREASURE then reach EXIT

Option Base 0
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
Cls BG

' player position
p = Int(Rnd * 100)
op = p
l = 0 : k = 0 : tf = 0
msg$ = ""

' init world
For i = 0 To 99 : w(i) = T_EMPTY : Next i

' place items one at a time on empty cells
ptile = T_LOOT     : For i = 1 To 10 : GoSub place : Next i
ptile = T_KEY      : For i = 1 To 3  : GoSub place : Next i
ptile = T_DOOR     : For i = 1 To 3  : GoSub place : Next i
ptile = T_GOBLIN   : For i = 1 To 5  : GoSub place : Next i
ptile = T_TREASURE : GoSub place
ptile = T_EXIT     : GoSub place
w(p) = T_PLAYER

' tile legend:
' 0=empty 1=player 2=loot 3=key
' 4=door  5=goblin 6=treasure 7=exit

main:
  GoSub draw
  Do
    a$ = Inkey$
  Loop While a$ = ""

  If a$ = "a" Or a$ = "A" Then
    If p > 0 Then
      op = p : w(p) = T_EMPTY : p = p - 1 : GoSub collide
    EndIf
  ElseIf a$ = "d" Or a$ = "D" Then
    If p < 99 Then
      op = p : w(p) = T_EMPTY : p = p + 1 : GoSub collide
    EndIf
  ElseIf a$ = "q" Or a$ = "Q" Then
    Colour GREEN, BG
    Print "bye!"
    End
  EndIf
  GoTo main

draw:
  Cls BG
  ' viewport: 21 cells (-10..+10) fits in 40 cols
  For x = -10 To 10
    c = p + x
    If c < 0 Or c > 99 Then
      Colour RED, BG      : Print "X";
    ElseIf w(c) = T_EMPTY Then
      Colour DARK, BG     : Print ".";
    ElseIf w(c) = T_PLAYER Then
      Colour BLUE, BG     : Print "@";
    ElseIf w(c) = T_LOOT Then
      Colour YELLOW, BG   : Print "l";
    ElseIf w(c) = T_KEY Then
      Colour RED, BG      : Print "k";
    ElseIf w(c) = T_DOOR Then
      Colour BROWN, BG    : Print "d";
    ElseIf w(c) = T_GOBLIN Then
      Colour GREEN, BG    : Print "g";
    ElseIf w(c) = T_TREASURE Then
      Colour PURPLE, BG   : Print "T";
    ElseIf w(c) = T_EXIT Then
      Colour CYAN, BG     : Print "E";
    EndIf
  Next x
  Print
  Colour YELLOW, BG
  If tf = 1 Then
    Print "loot:" + Str$(l) + " keys:" + Str$(k) + " TREASURE:YES"
  Else
    Print "loot:" + Str$(l) + " keys:" + Str$(k) + " TREASURE:no"
  EndIf
  Colour LIGHTRED, BG
  Print msg$
  msg$ = ""
  Colour WHITE, BG
  Print "a=left  d=right  q=quit"
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
      p = op : w(p) = T_PLAYER
      msg$ = "No key! Door is locked."
    EndIf
  ElseIf w(p) = T_GOBLIN Then
    If l > 0 Then
      l = l - 1 : w(p) = T_PLAYER
      msg$ = "A goblin stole your loot!"
    Else
      p = op : w(p) = T_PLAYER
      msg$ = "Goblin blocks you! (no loot)"
    EndIf
  ElseIf w(p) = T_TREASURE Then
    tf = 1 : w(p) = T_PLAYER
    msg$ = "TREASURE found! Reach the EXIT!"
  ElseIf w(p) = T_EXIT Then
    If tf = 1 Then
      Cls BG
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
      p = op : w(p) = T_PLAYER
      msg$ = "Exit sealed! Find TREASURE first."
    EndIf
  EndIf
  Return

place:
  Do
    pi = Int(Rnd * 100)
  Loop While w(pi) <> T_EMPTY Or pi = p
  w(pi) = ptile
  Return