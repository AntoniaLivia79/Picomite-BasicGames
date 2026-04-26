' goblins - picomite basic for picocalc
' 40 columns x 26 rows

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

Randomize Timer
Cls BG

' player position
p = Int(Rnd * 100)
op = p
l = 0 : k = 0

' init world
For i = 0 To 99 : w(i) = 0 : Next i

' scatter 10 items, value 2..5
For i = 1 To 10
  w(Int(Rnd * 100)) = Int(Rnd * 4) + 2
Next i
w(p) = 1

' 1=player 2=loot 3=key 4=door 5=goblin

main:
  GoSub draw
  Do
    a$ = Inkey$
  Loop While a$ = ""

  If a$ = "a" And p > 0 Then
    op = p : w(p) = 0 : p = p - 1 : GoSub collide
  ElseIf a$ = "d" And p < 99 Then
    op = p : w(p) = 0 : p = p + 1 : GoSub collide
  ElseIf a$ = "q" Then
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
      Colour RED, BG  : Print "X";
    ElseIf w(c) = 0 Then
      Colour DARK, BG : Print ".";
    ElseIf w(c) = 1 Then
      Colour BLUE, BG : Print "@";
    ElseIf w(c) = 2 Then
      Colour YELLOW, BG : Print "l";
    ElseIf w(c) = 3 Then
      Colour RED, BG : Print "k";
    ElseIf w(c) = 4 Then
      Colour BROWN, BG : Print "d";
    ElseIf w(c) = 5 Then
      Colour GREEN, BG : Print "g";
    EndIf
  Next x
  Print
  Colour YELLOW, BG
  Print "loot: " + Str$(l) + "  keys: " + Str$(k)
  Colour GREEN, BG
  Print "player position: " + Str$(p)
  Colour WHITE, BG
  Print
  Print "a=left  d=right  q=quit"
  Return

collide:
  If w(p) = 0 Then
    w(p) = 1
  ElseIf w(p) = 2 Then
    l = l + 1 : w(p) = 1
  ElseIf w(p) = 3 Then
    k = k + 1 : w(p) = 1
  ElseIf w(p) = 4 Then
    If k > 0 Then
      k = k - 1 : w(p) = 1
    Else
      p = op : w(p) = 1
      Colour LIGHTRED, BG
      Print "no key!"
      Pause 800
    EndIf
  ElseIf w(p) = 5 Then
    If l > 0 Then
      l = l - 1 : w(p) = 1
      Colour LIGHTRED, BG
      Print "goblin!"
      Pause 800
    Else
      Colour LIGHTRED, BG
      Print "goblins made you broke!"
      p = op : w(p) = 1
      Pause 1500
    EndIf
  EndIf
  Return