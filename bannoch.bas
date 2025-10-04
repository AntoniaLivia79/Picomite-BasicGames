' The Bannochburn Legacy
' Created by Tim Hartnell
' Refactored for MM Basic and Picomite Basic

Dim B$(12), MSTR$(6), M(7), S(7), W(7)

GoSub Initialise

MainLoop:
  Pause 500: Cls
  If M(7) = 0 And S(7) = 0 And W(7) = 0 Then
    Print "The adventure has ended."
    Print "You have exhausted all your powers."
    Print
    Print "You fought bravely and well"
    Print "but could not endure."
    End
  EndIf

  GoSub CharDescription
  GoSub PauseRoutine
  GoSub RoomDescriptions
  GoSub CheckEncounters
  If QV > 0 Then GoSub PressAnyKey
  If Z > 1 Then If Rnd > .5 Then GoSub Contents
  GoSub PauseRoutine
  GoSub Action
  GoSub PauseRoutine
  GoTo MainLoop

' ********************************
MeleeResolution:
  ' Melee resolution
  ROLL = Int(Rnd * 6) + 1
  VICTORY = 0
  If (DIFF < 0 And ROLL > Abs(DIFF)) Or (DIFF > 0 And ROLL <= DIFF) Or (DIFF = 0 And ROLL < 4) Then VICTORY = 1
  GoSub PauseRoutine
  Return

' ********************************
MonsterSubroutine:
  ' Monster subroutine
  If QV = 0 Then Return
  If QV = 1 Then GoSub Monster1
  If QV = 2 Then GoSub Monster2
  If QV = 3 Then GoSub Monster3
  If QV = 4 Then GoSub Monster4
  If QV = 5 Then GoSub Monster5
  GoSub PauseRoutine
  Return

Monster1:
  Print "There is an angry warlock in"
  Print "the room. He has a magic"
  Print "rating of"; M(1);
  Print ". His strength is"; S(1); " and"
  Print "his wisdom is"; W(1)
  Return

Monster2:
  Print "The room contains a fire-"
  Print "breathing Fearbringer. His"
  Print "wisdom is"; W(2); " while he"
  Print "has a strength rating of"; S(2)
  Print "and his magic skill is"; M(2)
  Return

Monster3:
  Print "Horrors! You've stumbled in on"
  Print "the hiding place of an awful"
  Print "Soulthreat. You can see at a"
  Print "glance his strength is"; S(3)
  Print "his magic ability rates"; M(3)
  Print "and his wisdom is"; W(3)
  Return

Monster4:
  Print "You've tripped in the dark."
  GoSub PauseRoutine
  Print "Something awakes. Oh, you're face"
  Print "to face with Gravelpit, the"
  Print "Kneecrusher, who has magic of"; M(4)
  Print "strength of"; S(4); " and wisdom of"; W(4)
  Return

Monster5:
  Print "This room holds the dreaded"
  Print "enemy of all who enter the"
  Print "castle, Wolvling of Wolf Glass"
  Print "with strength of"; S(5); " plus"
  Print "wisdom of"; W(5); " and"
  Print "magic rating of"; M(5)
  Return

' *********************
EndOfGame:
  ' End of Game
  Print "You have stumbled on to the"
  Print "marshy mud surrounding the"
  Print "Black Lagoon underneath the"
  Print "castle. To escape from the"
  Print "castle you must fight The"
  Print "Guardian of the Black Lagoon."
  Print
  Print "The fight must involve all"
  Print "attributes...and you'll need"
  Print "a total of 10 to escape..."
  GoSub PauseRoutine: GoSub PauseRoutine
  If MONEY > 0 Then Print "You have $"; MONEY; " worth of gold"
  GoSub PauseRoutine
  Print : Print "The Guardian's attributes:"
  Print "Magic:"; M(6)
  Print "Strength:"; S(6)
  Print "Wisdom:"; W(6)
  Print : Print "Your attributes are:"
  Print "Magic:"; M(7)
  Print "Strength:"; S(7)
  Print "Wisdom:"; W(7)
  GoSub PauseRoutine: GoSub PauseRoutine

  If MONEY >= 100 Then
BuyAttributes:
    Print : Print "You can buy attribute points"
    Print "for $100 each..."
    Print "If you want to buy any, enter"
    Print "the initial of the attribute"
    Print "followed by the number of"
    Print "of that attribute you want."
    Print "Enter 'N' when you've got"
    Print "all the attributes you want"
    Input "Attribute (M, S or W)"; E$
    If UCase$(E$) = "N" Then GoTo UltimateTest
    Input "Amount"; AM
    If MONEY - AM < 0 Or AM < 100 Then GoTo BuyAttributes
    MONEY = MONEY - AM
    If UCase$(E$) = "M" Then M(7) = M(7) + Int(AM / 100)
    If UCase$(E$) = "S" Then S(7) = S(7) + Int(AM / 100)
    If UCase$(E$) = "W" Then W(7) = W(7) + Int(AM / 100)
    Print "Magic:"; M(7); "Strength:"; S(7); "Wisdom:"; W(7)
    If MONEY > 99 Then GoTo BuyAttributes
  EndIf

UltimateTest:
  Pause 500: Cls
  Print "Now for the Ultimate Test..."
  GoSub PauseRoutine
  Print "Press RETURN when you're"
  Input "brave enough to fight", E$
  GoSub PauseRoutine: Cls

  ' First, magic...
  Print : Print "First, magic..."
  Print : Print "You:"; M(7); "Guardian"; M(6)
  DIFF = Abs(M(7) - M(6))
  Print : Print "The difference is"; DIFF
  If M(7) > M(6) Then Print "in your favour"
  If M(6) > M(7) Then Print "and the Guardian has the edge"
  GoSub PauseRoutine
  K = M(6) + M(7)
  COST = Int(Rnd * K) + 1
  Print : Print "This round carries a penalty"
  Print "of"; COST; "attribute points": GoSub PauseRoutine
  GoSub FightEffects
  DIFF = M(7) - M(6)
  While DIFF > 5 : DIFF = DIFF - 6 : Wend
  While DIFF < -5 : DIFF = DIFF + 6 : Wend
  GoSub MeleeResolution
  If VICTORY = 1 Then
    M(7) = M(7) + COST
    Print "And you've won...and so"
  Else
    M(7) = M(7) - COST
    Print "And you lost...and so"
  EndIf
  If M(7) < 1 Then M(7) = 0
  Print "now have"; M(7); "magic points..."
  GoSub PauseRoutine
  Print "Press RETURN when you're ready"
  Input "to continue this epic struggle"; E$
  Cls

  ' Now it's time for a match of strength
  Print "Now it's time for a match of"
  Print "strength, where your rating"
  Print "is"; S(7); "and the Guardian's"
  Print "strength rating is"; S(6)
  DIFF = Abs(S(7) - S(6))
  Print : Print "The difference is"; DIFF
  If S(6) > S(7) Then Print "in the Guardian's favour"
  If S(7) > S(6) Then Print "in your favour, "; N$
  GoSub PauseRoutine
  K = S(6) + S(7)
  COST = Int(Rnd * K) + 1
  Print : Print "This round carries a penalty"
  Print "of"; COST; "attribute points": GoSub PauseRoutine
  GoSub FightEffects
  DIFF = S(7) - S(6)
  While DIFF > 5 : DIFF = DIFF - 6 : Wend
  While DIFF < -5 : DIFF = DIFF + 6 : Wend
  GoSub MeleeResolution
  If VICTORY = 1 Then
    S(7) = S(7) + COST
    Print "You're the victor, and so"
  Else
    S(7) = S(7) - COST
    Print "You're the loser, and so"
  EndIf
  If S(7) < 0 Then S(7) = 0
  Print "you now have"; S(7); "strength points"
  GoSub PauseRoutine
  Print : Print "Press the RETURN key when"
  Print "you have stopped trembling"
  Print "enough to face the third, and"
  Input "final challenge.."; E$
  GoSub PauseRoutine
  Cls

  ' Now it's time for a match of wisdom
  Print "Now it's time for a match of"
  Print "wisdom, where your rating"
  Print "is"; W(7); "and the Guardian's"
  Print "wisdom rating is"; W(6)
  DIFF = Abs(W(7) - W(6))
  Print : Print "The difference is"; DIFF
  If W(6) > W(7) Then Print "in the Guardian's favour"
  If W(7) > W(6) Then Print "in your favour, "; N$
  GoSub PauseRoutine
  K = W(6) + W(7)
  COST = Int(Rnd * K) + 1
  Print "Now, this final challenge"
  Print "carries a huge penalty"
  Print "of"; COST; "attribute points": GoSub PauseRoutine
  DIFF = W(7) - W(6)
  While DIFF > 5 : DIFF = DIFF - 6 : Wend
  While DIFF < -5 : DIFF = DIFF + 6 : Wend
  GoSub MeleeResolution
  GoSub FightEffects
  If VICTORY = 1 Then
    W(7) = W(7) + COST
    Print "And you defeated the Guardian!"
  Else
    W(7) = W(7) - COST
    Print "But the Guardian got the"
    Print "better of you, "; N$; "!!"
  EndIf
  If W(7) < 0 Then W(7) = 0
  GoSub PauseRoutine
  Cls : Print

  ' Final battle results
  Print "And now, at the end of the"
  Print "final battle, your position"
  Print "is:   Magic..."; M(7)
  Print "      Wisdom..."; W(7)
  Print "    Strength..."; S(7)
  SUM = M(7) + W(7) + S(7)
  Print : Print "Well, "; N$; ", your"
  Print "attribute total is"; SUM
  GoSub PauseRoutine

  If SUM >= 10 Then
    Print "You needed at least 10 points"
    Print "to win the game, and you've"
    Print "done it, "; N$; "!"
    GoSub PauseRoutine
    Cls : Print
    Print "You've succeeded, O hero of"
    Print "these dark and dangerous"
    Print "times. I hereby dub thee"
    Print "Sir "; N$; ".... Arise..."
    End
  Else
    Print "Unfortunately, you did not"
    Print "end up with the 10 points"
    Print "you needed, so it is all over"
    Print : Print "You fail to escape the clutches"
    Print "of the Guardian....": GoSub PauseRoutine
    Print "You fought valiantly, but will"
    Print "now be consumed......"
    GoSub PauseRoutine: GoSub FightEffects: GoSub FightEffects: End
  EndIf

' *******************************
Action:
  ' Action
ActionLoop:
  D = 4
  If Mid$(B$(Z), 9, 1) = "0" Or Mid$(B$(Z), 9, 1) = " " Then
    D = 1
    If Rnd > .8 And Z > 1 Then GoSub Contents: GoTo ActionLoop
  EndIf

  Print "What do you want to do now";
  Input ZSTR$
  If ZSTR$ = "?" Then 
    GoSub ShowHelp
    GoSub CharDescription
    GoSub PauseRoutine
    GoSub RoomDescriptions
    GoTo ActionLoop
  EndIf
  If UCase$(ZSTR$) = "Q" Then End
  If ZSTR$ = "" Then Cls : ZSTR$ = "#"

  If D = 4 And UCase$(Left$(ZSTR$, 1)) <> "F" Then
    D = 0
    GoTo MustFight
  EndIf

  If UCase$(Left$(ZSTR$, 1)) = "F" Then GoTo Fight
  If UCase$(ZSTR$) = "N" And Left$(B$(Z), 2) = "00" Then Print , "No exit": GoTo ActionLoop
  If UCase$(ZSTR$) = "S" And Mid$(B$(Z), 3, 2) = "00" Then Print "There is no door that way": GoTo ActionLoop
  If UCase$(ZSTR$) = "E" And Mid$(B$(Z), 5, 2) = "00" Then Print "That is not possible": GoTo ActionLoop
  If UCase$(ZSTR$) = "W" And Mid$(B$(Z), 7, 2) = "00" Then Print "You can't walk through walls!": GoTo ActionLoop
  If UCase$(ZSTR$) = "L" Then GoSub RoomDescriptions : GoTo ActionLoop
  If UCase$(ZSTR$) = "N" Then Z = Val(Left$(B$(Z), 2)): Return
  If UCase$(ZSTR$) = "S" Then Z = Val(Mid$(B$(Z), 3, 2)): Return
  If UCase$(ZSTR$) = "E" Then Z = Val(Mid$(B$(Z), 5, 2)): Return
  If UCase$(ZSTR$) = "W" Then Z = Val(Mid$(B$(Z), 7, 2)): Return

  If UCase$(Left$(ZSTR$, 1)) <> "F" Then Return

Fight:
  If Mid$(B$(Z), 9, 1) = "0" Then Print "There is nothing to fight against": GoTo ActionLoop
  If UCase$(ZSTR$) = "FL" Then D = Int(Rnd * 2)
  If D = 1 Then Print "Which direction?": GoTo ActionLoop

MustFight:
  If D = 0 Then Print "No!! You must stand and fight"
  Print : Print "Which characteristic will you fight with?"
  Print "Your Magic is"; M(7); ", Strength is"; S(7)
  Print "and your Wisdom is"; W(7)
ChooseCharacteristic:
  Print"Your choice (M/S/W)";
  Input ZSTR$
  If UCase$(ZSTR$) <> "M" And UCase$(ZSTR$) <> "S" And UCase$(ZSTR$) <> "W" Then GoTo ChooseCharacteristic
  If UCase$(ZSTR$) = "M" Then HUM = M(7): MON = M(QV)
  If UCase$(ZSTR$) = "S" Then HUM = S(7): MON = S(QV)
  If UCase$(ZSTR$) = "W" Then HUM = W(7): MON = W(QV)
  DIFF = HUM - MON
  While DIFF > 5 : DIFF = DIFF - 6 : Wend
  While DIFF < -5 : DIFF = DIFF + 6 : Wend
  Print "The fight table for this melee reads "; DIFF
  COST = Abs(DIFF) + Int(Rnd * 6) + 1
  GoSub PauseRoutine
  Print "The melee carries a cost/reward of"; COST
  FI = Int(Rnd * 2): GoSub PauseRoutine
  If FI = 0 Then
    Print "The monster attacks and the"
    Print "fight is underway"
  Else
    Print "You attack first, and the"
    Print "battle is joined..."
  EndIf
  GoSub FightEffects
  ROLL = Int(Rnd * 6) + 1
  VICTORY = 0
  If (DIFF < 0 And ROLL > Abs(DIFF)) Or (DIFF > 0 And ROLL <= DIFF) Or (DIFF = 0 And ROLL < 4) Then VICTORY = 1
  If VICTORY = 1 Then GoSub HumanVictory
  If VICTORY = 0 Then GoSub MonsterVictory
  GoSub PauseRoutine
  GoSub PressAnyKey
  Print "After that fight, your"
  Print "attributes are:"
  Print "Magic:"; M(7)
  Print "Strength:"; S(7)
  Print "& Wisdom:"; W(7)
  GoSub PauseRoutine: Print
  Print "And those of the "; MSTR$(QV); " are:"
  Print "Magic:"; M(QV)
  Print "Strength:"; S(QV)
  Print "& Wisdom:"; W(QV)
  B$(Z) = LEFT$(B$(Z), 8) + "0" + MID$(B$(Z), 10)
  GoSub PauseRoutine:
  GoTo Contents

HumanVictory:
  ' Human victory
  If QV = 0 Then D = 1
  Print : Print "You defeated the "; MSTR$(QV); "."
  If UCase$(ZSTR$) = "M" Then M(7) = M(7) + COST: M(QV) = M(QV) - COST: If M(QV) < 1 Then M(QV) = 0
  If UCase$(ZSTR$) = "W" Then W(7) = W(7) + COST: W(QV) = W(QV) - COST: If W(QV) < 1 Then W(QV) = 0
  If UCase$(ZSTR$) = "S" Then S(7) = S(7) + COST: S(QV) = S(QV) - COST: If S(QV) < 1 Then S(QV) = 0
  Return

MonsterVictory:
  ' Monster victory
  Print : Print "The "; MSTR$(QV); " defeated you."
  If UCase$(ZSTR$) = "M" Then M(QV) = M(QV) + COST: M(7) = M(7) - COST: If M(7) < 1 Then M(7) = 0
  If UCase$(ZSTR$) = "W" Then W(QV) = W(QV) + COST: W(7) = W(7) - COST: If W(7) < 1 Then W(7) = 0
  If UCase$(ZSTR$) = "S" Then S(QV) = S(QV) + COST: S(7) = S(7) - COST: If S(7) < 1 Then S(7) = 0
  Return

' *****************
FightEffects:
  ' Fight effects
  For J = 1 To Rnd * 10 + 2
    Select Case Int(Rnd * 5 + 1)
      Case 1
        GoSub FightEffects
      Case 2
        Print "    Bash!!!!": GoSub ShortPause:
      Case 3
        Print , "Aaaaaarghhh!": GoSub ShortPause:
      Case 4
        Print "Rip": For P = 1 To 100: Next P: Print , , "Tear!": GoSub ShortPause:
      Case 5
        Print "!*&&*@!!   ";: GoSub ShortPause:
    End Select
    Print
  Next J
  GoSub ShortPause
  Cls : Return

' *******************************
Contents:
  ' Contents
  K = 2 + Int(Rnd * 8)
  If K = Z Then GoTo Contents
  If Mid$(B$(Z), 9, 1) <> "0" Then Return
  KSTR$ = Mid$(B$(Z), 9, 1)
  B$(K) = LEFT$(B$(K), 8) + KSTR$ + MID$(B$(K), 10)
  B$(Z) = LEFT$(B$(Z), 8) + "0" + MID$(B$(Z), 10)
  If Rnd > .5 Then Return
  GoSub PressAnyKey
  CT = Int(Rnd * 5) + 1
  Select Case CT
    Case 1: GoSub OpenChest
    Case 2: GoSub DrinkPotion
    Case 3: GoSub ReadScroll
    Case 4: GoSub OpenSafe
    Case 5: GoSub OpenChest
  End Select
  GoSub PauseRoutine
  Return

' ************
OpenChest:
  ' Open a chest
  CHEST = CHEST + 1
  If CHEST = 5 Then Return
  Print "In front of you is a chest"
  Print "labelled with a large #"; CHEST
  Print : Print "Will you open it?";
  GoSub GetYesNo
  If UCase$(ZSTR$) = "N" Then Return
  J = Int(Rnd * 3)
  GoSub PauseRoutine
  If J = 0 Then
    CASH = 100 + Int(Rnd * 300)
    Print "It holds dragon's gold worth $"; CASH; "." : Print
    MONEY = MONEY + CASH
    GoSub PauseRoutine
    Return
  EndIf
  If J = 1 Then
    Print "A goblin leaps out, stabbing you!" : Print
    LOSS = Int(Rnd * 6) + 1
    MONEY = MONEY - Int(Rnd * 200)
    If MONEY < 1 Then MONEY = 0
    GoSub PauseRoutine
    Return
  EndIf
  If J = 2 Then
    Print "A strange smoke comes out"
    Print "making you sleepy and"
    Print "sapping your magic power." : Print
    LOSS = Int(Rnd * 8) + 1
    M(7) = M(7) - LOSS
    If M(7) < 1 Then M(7) = 0
    GoSub PauseRoutine
    Return
  EndIf

' ******************
DrinkPotion:
  ' Drink a potion
  If POTION = 1 Then GoTo Contents
  POTION = 1
  Print "You see a small bottle engraved"
  Print "with curious, twisted letters..."
  Print : Print "Will you drink the potion which"
  Print "you can see inside the bottle?";
  GoSub GetYesNo
  If UCase$(ZSTR$) = "N" Then Return
  GoSub PauseRoutine
  If Rnd > .6 Then
    Print "It contained a potion to"
    Print "enhance your wisdom."
    W(7) = W(7) + Int(Rnd * 6) + 1
    GoSub PauseRoutine
    Return
  Else
    Print "It contained a potion which"
    Print "weakens you further ...."
    GoSub PauseRoutine
    S(7) = S(7) - (Int(Rnd * 6) + 1)
    If S(7) < 1 Then S(7) = 0
    GoSub PauseRoutine
    Return
  EndIf

' ******************
ReadScroll:
  ' Read a scroll
  If SCROLL = 1 Then Return
  SCROLL = 1
  Print "You see a papyrus scroll."
  Print : Print "Do you wish to try to read it?";
  GoSub GetYesNo
  If UCase$(ZSTR$) = "N" Then Return
  If Rnd > .5 Then
    Print "You cannot understand"
    Print "the language..."
    GoSub PauseRoutine
    Return
  EndIf
  Print "It contains a magic spell. Do"
  Print "you wish to read it?";
  GoSub GetYesNo
  If UCase$(ZSTR$) = "N" Then Return
  If Rnd > .5 Then
    Print "It was a beneficent spell"
    GoSub PauseRoutine
    M(7) = M(7) + Int(Rnd * 6) + 1
    Return
  Else
    Print "It was an evil spell"
    GoSub PauseRoutine
    M(7) = 0
    S(7) = Int(S(7) / 2)
    Return
  EndIf

' ******************
OpenSafe:
  ' Open a safe
  If SAFE = 1 Then GoTo Contents
  SAFE = 1
  Print "On the wall is a small, gilded"
  Print "safe, and in front of"
  Print "it is a key..."
  Print "Do you want to open the safe?";
  GoSub GetYesNo
  If UCase$(ZSTR$) = "N" Then Return
  If Rnd > .3 Then
    Print "A choir of angelic voices is"
    Print "heard....."
    GoSub PauseRoutine
    Print : Print "You are healed and refreshed..."
    M(7) = M(7) + 2: S(7) = S(7) + 2: W(7) = W(7) + 2
    GoSub PauseRoutine
    Return
  Else
    GoSub PauseRoutine
    Print "A shrieking harpy flies out"
    Print "and sinks its teeth into"
    Print "your throat!"
    GoSub PauseRoutine
    Print "You grapple with it, and..."
    GoSub PauseRoutine
    Print "...finally wring its neck."
    S(7) = S(7) - Int(Rnd * 6) + 1
    If S(7) < 1 Then S(7) = 0
    GoSub PauseRoutine
    Return
  EndIf

GetYesNo:
  Print " (Y/N)"
  ZSTR$ = ""
  While UCase$(ZSTR$) <> "N" And UCase$(ZSTR$) <> "Y"
    ZSTR$ = Inkey$
  Wend
  Print : Return


' ******************
CharDescription:
  Print "Your character description:"
  Print "Name:"; N$
  If M(7) > 0 Then Print "Magic:"; M(7)
  If S(7) > 0 Then Print "Strength:"; S(7)
  If W(7) > 0 Then Print "Wisdom:"; W(7)
  If MONEY > 0 Then Print "Wealth: $"; MONEY
  Return

' ******************
RoomDescriptions:
  ' Room descriptions
  Print
  Select Case Z
    Case 1: GoSub Room1
    Case 2: GoSub Room2
    Case 3: GoSub Room3
    Case 4: GoSub Room4
    Case 5: GoSub Room5
    Case 6: GoSub Room6
    Case 7: GoSub Room7
    Case 8: GoSub Room8
    Case 9: GoSub Room9
    Case 10: GoSub Room10
    Case 11: GoSub Room11
    Case 12: GoSub Room12
  End Select
  Return

CheckEncounters:

  QV = 0
  ' Check if a monster is already in the room
  E$ = Mid$(B$(Z), 9, 1)
  If E$ > "0" And E$ < "6" Then
    QV = Val(E$)
  ' If not, maybe add one randomly
  ElseIf Rnd > .81 And Z > 1 Then
    QV = Int(Rnd * 5) + 1
    QVSTR$ = Mid$(Str$(QV), 2, 1)
    B$(Z) = LEFT$(B$(Z), 8) + QVSTR$ + MID$(B$(Z), 10)
  EndIf

  If QV > 0 Then GoSub MonsterSubroutine
  Return

Room1:
  Print "You are at the entrance to an"
  Print "ancient, forbidding-looking"
  Print "castle. You are standing on"
  Print "the north side of the castle,"
  Print "and as you look south, towards"
  Print "the tumbling structure, you"
  Print "notice the entrance portal"
  Print "is open and unguarded."
  Return

Room2:
  Print "You are in the entrance hall,"
  Print "which is hung with rich"
  Print "fabrics. Doors lead to the"
  Print "east and the south, and there"
  Print "is an open portal to the west."
  Return

Room3:
  Print "This is only a store room."
  Print "There is a single exit, back"
  Print "the way you came in,"
  Print "to the west."
  Return

Room4:
  Print "This small room, which"
  Print "features an ornate sculpture"
  Print "of the moon goddess on a"
  Print "pedestal in the north-east"
  Print "corner, is the Royal"
  Print "Presence Chamber. Doors lead"
  Print "to the south, the west and"
  Print "to the east..."
  Return

Room5:
  Print "The Hall of Plots, a"
  Print "wooden-pannelled room"
  Print "redolent with whispers and"
  Print "rumours, with exits to the east"
  Print "and to the south from which"
  Print "comes the smell of sulphur and"
  Print "a weird chanting..."
  Return

Room6:
  Print "You have entered the Wizard's"
  Print "Den, with a cauldron bubbling"
  Print "over a fire with green flames"
  Print "in the south-west corner."
  Print "This room reeks of burning"
  Print "sulphur, and the echo of"
  Print "ancient spells. You can leave"
  Print "to the north, the south, or"
  Print "to the east."
  Return

Room7:
  Print "You find yourself in a place"
  Print "which seems quiet and peaceful."
  Print "This is the castle's Picture"
  Print "Gallery, with a large painting"
  Print "of the Legendary Guardian of"
  Print "the Black Lagoon to the left of"
  GoSub PressAnyKey
  Print "the window in the east wall. Through"
  Print "the window you can see the mullioned"
  Print "windows of the Great Hall across the"
  Print "Contoured Garden.  Exits from the"
  Print "Gallery  are to the north and"
  Print "to the east....."
  Return

Room8:
  Print "This is the most magnificent"
  Print "room in the castle, the Great"
  Print "Hall, with a massive hammerbeam"
  Print "roof. You can leave it by the"
  Print "double doors to the north or by"
  Print "those to the east behind which"
  GoSub PressAnyKey
  Print "you can hear music playing. "
  Print "Through the windows in the west"
  Print "wall, you can see the Contoured"
  Print "Garden, and beyond that, through"
  Print "windows of a room hung with"
  Print "many, many fine paintings."
  Return

Room9:
  Print "Sounds of a string quartet"
  Print "fill this room, the Musicians'"
  Print "Chamber. You can leave by"
  Print "doors to the west or by one"
  Print "to the south..."
  Return

Room10:
  Print "You are now in the Sanctuary"
  Print "of Silence, a room whose"
  Print "calmness may be a deception."
  Print "The room is damp and cold. An"
  Print "exit leaves the room to the"
  Print "north";
  If Mid$(B$(10), 3, 2) = "12" Then 
    Print " and one leaves to the south."
  Else:
    Print "."
  EndIf
  Print : Return

Room11:
  Print "This must be the Vestibule"
  Print "of Sighs, a dank and clammy"
  Print "room where legend says the"
  Print "Guardian of the Black Lagoon"
  Print "can sometimes be heard at"
  Print "night. There is a door to"
  Print "north";
  If Mid$(B$(11), 3, 2) = "12" Then 
    Print " and one leaves to the south."
  Else:
    Print "."
  EndIf
  Print : Return

Room12:
  GoTo EndOfGame

' ********************
Initialise:
  ' Initialise
  Randomize Timer
  Z = 1
  MONEY = 0
  CHEST = 0
  POTION = 0
  SCROLL = 0
  SAFE = 0
  Cls : Print "The Bannochburn Legacy" : Print "Created by Tim Hartnell"
  Print : Print "Find and defeat the Guardian"
  Print "of the Black Lagoon to free"
  Print "Bannochburn Castle of its curse." : Print
  Print "Commands: N, S, E, W to move"
  Print "F to fight, FL to flee, ? for help" : Print
  Input "Please enter your first name"; N$
  Cls : Print "Hi there, "; N$
  Print "Please stand by..."

  ' Fill rooms
  For T = 1 To 12
    Read B$(T)
    L = Rnd
    Q$ = Str$(Int(Rnd * 5) + 1)
    If T > 1 And T < 11 And L < .63 Then
      B$(T) = B$(T) + Right$(Q$, 1)
    Else
      B$(T) = B$(T) + "0"
    EndIf
  Next T

  L = Rnd
  If L < .5 Then
    B$(11) = "09120000" + Right$(B$(11), 1)
  Else
    B$(10) = "06120000" + Right$(B$(10), 1)
  EndIf

  ' Create monsters
  For T = 1 To 6
    Read MSTR$(T)
    S(T) = Int(Rnd * 6) + 1
    M(T) = Int(Rnd * 6) + 1
    W(T) = Int(Rnd * 6) + 1
  Next T

  ' Human characteristics
  S(7) = Int(Rnd * 6) + 1
  M(7) = Int(Rnd * 6) + 1
  W(7) = Int(Rnd * 6) + 1

  ' Room data
  Data "000200000", "00080304", "00000002", "00070205", "00060400"
  Data "05100700", "04000600", "02000900", "00110008", "06000000"
  Data "09000000", "00000000"

  ' Monster data
  Data "Warlock", "Fearbringer", "Soulthreat", "Kneecrusher", "Wolvling", "Guardian"
  Return

' ***********************
ShowHelp:
  ' Display help text
  Cls
  Print "--- Bannochburn Legacy Help ---"
  Print
  Print "Movement Commands:"
  Print " N - Move North"
  Print " S - Move South"
  Print " E - Move East"
  Print " W - Move West"
  Print
  Input "Press Enter to continue...", E$
  Cls
  Print "Combat Commands:"
  Print " F - Fight a monster in the room"
  Print " FL- Attempt to flee from a monster"
  Print " M - Use Magic"
  Print " S - Use Strength"
  Print " W - Use Wisdom"
  Print
  Input "Press Enter to continue...", E$
  Cls
  Print "Other Commands:"
  Print " L - Get a description of the room"
  Print " Y - Answer Yes to a question"
  Print " N - Answer No to a question"
  Print " Q - Quit the game"
  Print " ? - Show this help screen"
  Print
  Input "Press Enter to continue...", E$
  Cls
  Return

' ***********************
PauseRoutine:
  Pause 600
  Return

ShortPause:
  Pause 200
  Return

PressAnyKey:
  Print "(Press any key to continue...)"
  While Inkey$ = "" : Wend
  Return