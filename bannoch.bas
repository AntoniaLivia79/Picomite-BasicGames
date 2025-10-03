5 Dim B$(12), MSTR$(6), M(7), S(7), W(7)
10 Rem   The Bannochburn Legacy
20 Rem    All inputs must be in upper case
30 GoSub 4480
40 Pause 500: Cls
50 If M(7) = 0 And S(7) = 0 And W(7) = 0 Then Print "The adventure has ended.": Print "You have exhausted all your powers.": Print : Print "You fought bravely and well": Print "but could not endure.": Print : Print "Farewell...": End
60 Print N$; ", your attributes are:"
70 If M(7) > 0 Then Print "Magic:"; M(7)
80 If S(7) > 0 Then Print "Strength:"; S(7)
90 If W(7) > 0 Then Print "Wisdom:"; W(7)
100 If MONEY > 0 Then Print "Wealth: $"; MONEY
110 GoSub 4990: Rem   Pause
120 GoSub 3420: Rem   Room
130 If Z > 1 Then If Rnd > .5 Then GoSub 2740
140 GoSub 4990
150 GoSub 1900
160 GoSub 4990
170 GoTo 40
180 Rem   ********************************
190 Rem   Melee resolution
200 ROLL = Int(Rnd * 6) + 1
210 VICTORY = 0
220 If (DIFF < 0 And ROLL > Abs(DIFF)) Or (DIFF > 0 And ROLL <= DIFF) Or (DIFF = 0 And ROLL < 4) Then VICTORY = 1
230 GoSub 4990
240 Return
250 Rem   ********************************
260 Rem   Monster subroutine
270 If QV= 0 Then Return
280 On QV GoSub 310, 320, 330, 340, 350
290 GoSub 4990
300 Return
310 Print "There is an angry warlock in": Print "the room. He has a magic": Print "rating of"; M(1); Print ".": Print "His strength is"; S(1); " and": Print "his wisdom is"; W(1): Return
320 Print "The room contains a fire-": Print "breathing Fearbringer. His": Print "wisdom is"; W(2); " while he": Print "has a strength rating of"; S(2): Print "and his magic skill": Print "is"; M(2): Return
330 Print "Horrors! You've stumbled in on": Print "the hiding place of an awful": Print "Soulthreat. You can see at a": Print "glance his strength is"; S(3): Print "his magic ability rates"; M(3): Print "and his wisdom is"; W(3): Return
340 Print "You've tripped in the dark.": GoSub 4990: Print "Something awakes. Oh, you're face": Print "to face with Gravelpit, the": Print "Kneecrusher, who has magic of"; M(4): Print "strength of"; S(4); " and wisdom": Print "of"; W(4): Return
350 Print "This room holds the dreaded": Print "enemy of all who enter the": Print "castle, Wolvling of Wolf Glass": Print "with strength of"; S(5); " plus": Print "wisdom of"; W(5); " and": Print "magic of"; M(5): Return
360 Rem   *********************
370 Rem   End of Game
380 Print "You have stumbled on to the"
390 Print "marshy mud surrounding the"
400 Print "Black Lagoon underneath the"
410 Print "castle. To escape from the"
420 Print "castle you must fight The"
430 Print "Guardian of the Black Lagoon."
440 Print
450 Print "The fight must involve all"
460 Print "attributes...and you'll need"
470 Print "a total of 10 to escape..."
480 GoSub 4990: GoSub 4990
490 If MONEY > 0 Then Print "You have $"; MONEY; " worth of gold"
500 GoSub 4990
510 Print : Print "The Guardian's attributes:"
520 Print "Magic:"; M(6)
530 Print "Strength:"; S(6)
540 Print "Wisdom:"; W(6)
550 Print : Print "Your attributes are:"
560 Print "Magic:"; M(7)
570 Print "Strength:"; S(7)
580 Print "Wisdom:"; W(7)
590 GoSub 4990: GoSub 4990
600 If MONEY < 100 Then 790
610 Print : Print "You can buy attribute points"
620 Print "for $100 each..."
630 Print "If you want to buy any, enter"
640 Print "the initial of the attribute"
650 Print "followed by the number of"
660 Print "of that attribute you want."
670 Print "Enter 'N' when you've got"
680 Print "all the attributes you want"
690 Input "Attribute (M, S or W)"; E$
700 If E$ = "N" Then 790
710 Input "Amount"; AM
720 If MONEY - AM < 1 Or AM < 100 Then 710
730 MONEY = MONEY - AM
740 If E$ = "M" Then M(7) = M(7) + Int(AM / 100)
750 If E$ = "S" Then S(7) = S(7) + Int(AM / 100)
760 If E$ = "W" Then W(7) = W(7) + Int(AM / 100)
770 Print "Magic:"; M(7); "Strength:"; S(7)
780 If MONEY > 99 Then 690
790 Pause 500: Cls
800 Print "Now for the Ultimate Test..."
810 GoSub 4990
820 Print "Press RETURN when you're"
830 Input "brave enough to fight", E$
840 GoSub 4990: Cls
850 Print : Print "First, magic..."
860 Print : Print "You:"; M(7); "Guardian"; M(6)
870 DIFF = Abs(M(7) - M(6))
880 Print : Print "The difference is"; DIFF
890 If M(7) > M(6) Then Print "in your favour"
900 If M(6) > M(7) Then Print "and the Guardian has the edge"
910 GoSub 4990
920 K = M(6) + M(7)
930 COST = Int(Rnd * K) + 1
940 Print : Print "This round carries a penalty"
950 Print "of"; COST; "attribute points": GoSub 4990
960 GoSub 2600
970 DIFF = M(7) - M(6)
980 If DIFF > 5 Then DIFF = DIFF - 6: GoTo 980
990 If DIFF < -5 Then DIFF = DIFF + 6: GoTo 990
1000 GoSub 190
1010 If VICTORY = 1 Then M(7) = M(7) + COST: Print "And you've won...and so"
1020 If VICTORY = 0 Then M(7) = M(7) - COST: Print "And you lost...and so"
1030 If M(7) < 1 Then M(7) = 0
1040 Print "now have"; M(7); "magic points..."
1050 GoSub 4990
1060 Print "Press RETURN when you're ready"
1070 Input "to continue this epic struggle"; E$
1080 Cls
1090 Print "Now it's time for a match of"
1100 Print "strength, where your rating"
1110 Print "is"; S(7); "and the Guardian's"
1120 Print "strength rating is"; S(6)
1130 DIFF = Abs(S(7) - S(6))
1140 Print : Print "The difference is"; DIFF
1150 If S(6) > S(7) Then Print "in the Guardian's favour"
1160 If S(7) > S(6) Then Print "in your favour, "; N$
1170 GoSub 4990
1180 K = S(6) + S(7)
1190 COST = Int(Rnd * K) + 1
1200 Print : Print "This round carries a penalty"
1210 Print "of"; COST; "attribute points": GoSub 4990
1220 DIFF = S(7) - S(6)
1230 GoSub 2600
1240 If DIFF > 5 Then DIFF = DIFF - 6: GoTo 1240
1250 If DIFF < -5 Then DIFF = DIFF + 6: GoTo 1250
1260 GoSub 190
1270 If VICTORY = 1 Then S(7) = S(7) + COST: Print "You're the victor, and so"
1280 If VICTORY = 0 Then S(7) = S(7) - COST: Print "You're the loser, and so"
1290 If S(7) < 0 Then S(7) = 0
1300 Print "you now have"; S(7); "strength points"
1310 GoSub 4990
1320 Print : Print "Press the RETURN key when"
1330 Print "you have stopped trembling"
1340 Print "enough to face the third, and"
1350 Input "final challenge.."; E$
1360 GoSub 4990
1370 Cls
1380 Print "Now it's time for a match of"
1390 Print "wisdom, where your rating"
1400 Print "is"; W(7); "and the Guardian's"
1410 Print "wisdom rating is"; W(6)
1420 DIFF = Abs(W(7) - W(6))
1430 Print : Print "The difference is"; DIFF
1440 If W(6) > W(7) Then Print "in the Guardian's favour"
1450 If W(7) > W(6) Then Print "in your favour, "; N$
1460 GoSub 4990
1470 K = W(6) + W(7)
1480 COST = Int(Rnd * K) + 1
1490 Print "Now, this final challenge"
1500 Print "carries a huge penalty"
1510 Print "of"; COST; "attribute points": GoSub 4990
1520 DIFF = W(7) - W(6)
1530 If DIFF > 5 Then DIFF = DIFF - 6: GoTo 1530
1540 If DIFF < -5 Then DIFF = DIFF + 6: GoTo 1540
1550 GoSub 190
1560 GoSub 2600
1570 If VICTORY = 1 Then W(7) = W(7) + COST: Print "And you defeated the Guardian!"
1580 If VICTORY = 0 Then W(7) = W(7) - COST: Print "But the Guardian got the": Print "better of you, "; N$; "!!"
1590 If W(7) < 0 Then W(7) = 0
1600 GoSub 4990
1610 Cls : Print
1620 Print "And now, at the end of the"
1630 Print "final battle, your position"
1640 Print "is:   Magic..."; M(7)
1650 Print "      Wisdom..."; W(7)
1660 Print "    Strength..."; S(7)
1670 SUM = M(7) + W(7) + S(7)
1680 Print : Print "Well, "; N$; ", your"
1690 Print "attribute total is"; SUM
1700 GoSub 4990
1710 If SUM < 10 Then 1810
1720 Print "You needed at least 10 points"
1730 Print "to win the game, and you've"
1740 Print "done it, "; N$; "!": GoSub 4990
1750 Cls : Print
1760 Print "You've succeeded, O hero of"
1770 Print "these dark and dangerous"
1780 Print "times. I hereby dub thee"
1790 Print "Sir "; N$; ".... Arise..."
1800 End
1810 Print "Unfortunately, you did not"
1820 Print "end up with the 10 points"
1830 Print "you needed, so it is all over"
1840 Print : Print "You fail to escape the clutches"
1850 Print "of the Guardian....": GoSub 4990
1860 Print "You fought valiantly, but will"
1870 Print "now be consumed......"
1880 GoSub 4990: GoSub 2600: GoSub 2600: End
1890 Rem   *******************************
1900 Rem   Action
1910 D = 4: If Mid$(B$(Z), 9, 1) = "0" Or Mid$(B$(Z), 9, 1) = " " Then D = 1: If Rnd > .8 And Z > 1 Then GoSub 2740: GoTo 1910
1920 Print "What do you want to do now";
1930 Input ZSTR$: If ZSTR$ = "Q" Then End
1940 If ZSTR$ = "" Then Cls : ZSTR$ = "#"
1950 If D = 4 And Left$(ZSTR$, 1) <> "F" Then D = 0: GoTo 2090
1960 If Left$(ZSTR$, 1) = "F" Then 2060
1970 If ZSTR$ = "N" And Left$(B$(Z), 2) = "00" Then Print , "No exit": GoTo 1920
1980 If ZSTR$ = "S" And Mid$(B$(Z), 3, 2) = "00" Then Print "There is no door that way": GoTo 1920
1990 If ZSTR$ = "E" And Mid$(B$(Z), 5, 2) = "00" Then Print "That is not possible": GoTo 1920
2000 If ZSTR$ = "W" And Mid$(B$(Z), 7, 2) = "00" Then Print "You can't walk through walls!": GoTo 1920
2010 If ZSTR$ = "N" Then Z = Val(Left$(B$(Z), 2)): Return
2020 If ZSTR$ = "S" Then Z = Val(Mid$(B$(Z), 3, 2)): Return
2030 If ZSTR$ = "E" Then Z = Val(Mid$(B$(Z), 5, 2)): Return
2040 If ZSTR$ = "W" Then Z = Val(Mid$(B$(Z), 7, 2)): Return
2050 If Left$(ZSTR$, 1) <> "F" Then Return
2060 If Right$(B$(Z), 1) = "0" Then Print "There is nothing to fight against": GoTo 1920
2070 If ZSTR$ = "FL" Then D = Int(Rnd * 2)
2080 If D = 1 Then Print "Which direction?": GoTo 1930
2090 If D = 0 Then Print "No!! You must stand and fight"
2100 Print : Print "Which characteristic will you fight with?"
2110 Print "Your magic is"; M(7); ", strength is"; S(7): Print "and your wisdom is"; W(7)
2120 Input ZSTR$: If ZSTR$ <> "M" And ZSTR$ <> "S" And ZSTR$ <> "W" Then 2120
2130 If ZSTR$ = "M" Then HUM = M(7): MON = M(QV)
2140 If ZSTR$ = "S" Then HUM = S(7): MON = S(QV)
2150 If ZSTR$ = "W" Then HUM = W(7): MON = W(QV)
2160 DIFF = HUM - MON
2170 If DIFF > 5 Then DIFF = DIFF - 6: GoTo 2170
2180 If DIFF < -5 Then DIFF = DIFF + 6: GoTo 2180
2190 Print "The fight table for this melee reads "; DIFF
2200 COST = Abs(DIFF) + Int(Rnd * 6) + 1
2210 GoSub 4990
2220 Print "The melee carries a cost/reward of"; COST
2230 FI = Int(Rnd * 2): GoSub 4990
2240 If FI = 0 Then Print "The monster attacks and the": Print "fight is underway"
2250 If FI = 1 Then Print "You attack first, and the": Print "battle is joined..."
2260 GoSub 2600
2270 ROLL = Int(Rnd * 6) + 1
2280 VICTORY = 0
2290 If (DIFF < 0 And ROLL > Abs(DIFF)) Or (DIFF > 0 And ROLL <= DIFF) Or (DIFF = 0 And ROLL < 4) Then VICTORY = 1
2300 If VICTORY = 1 Then GoSub 2460
2310 If VICTORY = 0 Then GoSub 2530
2320 GoSub 4990
2330 Print "After that fight, your"
2340 Print "attributes are:"
2350 Print "Magic:"; M(7)
2360 Print "Strength:"; S(7)
2370 Print "& Wisdom:"; W(7)
2380 GoSub 4990: Print
2390 Print "And those of the "; MSTR$(QV); " are:"
2400 Print "Magic:"; M(QV)
2410 Print "Strength:"; S(QV)
2420 Print "& Wisdom:"; W(QV)
2430 B$(Z)=LEFT$(B$(Z),8)+"0" + MID$(B$(Z),10)
2440 GoSub 4990: GoSub 4990: Print
2450 GoTo 2740
2460 Rem   Human victory
2470 If QV= 0 Then D = 1
2480 Print : Print "You defeated the "; MSTR$(QV)
2490 If ZSTR$ = "M" Then M(7) = M(7) + COST: M(QV) = M(QV) - COST: If M(QV) < 1 Then M(QV) = 0
2500 If ZSTR$ = "W" Then W(7) = W(7) + COST: W(QV) = W(QV) - COST: If W(QV) < 1 Then W(QV) = 0
2510 If ZSTR$ = "S" Then S(7) = S(7) + COST: S(QV) = S(QV) - COST: If S(QV) < 1 Then S(QV) = 0
2520 Return
2530 Rem   Monster victory
2540 Print : Print "The "; MSTR$(QV); " defeated you"
2550 If ZSTR$ = "M" Then M(QV) = M(QV) + COST: M(7) = M(7) - COST: If M(7) < 1 Then M(7) = 0
2560 If ZSTR$ = "W" Then W(QV) = W(QV) + COST: W(7) = W(7) - COST: If W(7) < 1 Then W(7) = 0
2570 If ZSTR$ = "S" Then S(QV) = S(QV) + COST: S(7) = S(7) - COST: If S(7) < 1 Then S(7) = 0
2580 Return
2590 Rem   *****************
2600 Rem   Fight effects
2610 For J = 1 To Rnd * 10 + 2
2620 On (Int(Rnd * 6 + 1)) GoSub 2610, 2680, 2690, 2700, 2710, 2720
2630 XX = 0.2: GoSub 6000
2640 Print
2650 Next J
2660 Cls : Return
2670 Print "    Bash!!!!": XX = 0.1: GoSub 6000: Return
2680 Print , "Aaaaaarghhh!": XX = 0.1: GoSub 6000: Return
2690 Print "Rip": For P = 1 To 100: Next P: Print , , "Tear!": XX = 0.1: GoSub 6000: Return
2700 For ETRN = 1 To 3: Print "!!! ";: Pause 250: Next ETRN: Return
2710 Return
2720 For ETRN = 1 To 3: Print "!*&&*@!!   ";: Pause 500: Next ETRN: XX = 0.1: GoSub 6000: Return
2730 Rem   *******************************
2740 Rem   Contents
2750 K = 2 + Int(Rnd * 8)
2760 If K = Z Then 2750
2770 If Right$(B$(Z), 1) <> "0" Then Return
2780 KSTR$ = Mid$(B$(Z), 9, 1): B$(K) = LEFT$(B$(K),8) + KSTR$ + MID$(B$(K),10)
2790 B$(Z)=LEFT$(B$(Z),8) + "0" + MID$(B$(Z),10)
2800 If Rnd > .5 Then Return
2810 Print
2820 CT = Int(Rnd * 5) + 1
2830 On CT GoSub 2870, 2980, 3100, 3210, 2870: Rem   this double 7100 is correct
2840 GoSub 4990
2850 Return
2860 Rem   ************
2870 CHEST = CHEST + 1: If CHEST = 5 Then Return
2880 Print "In front of you is a chest"
2890 Print "labelled with a large #"; CHEST
2900 Print : Print "Will you open it?"
2910 GoSub 3380
2920 If ZSTR$ = "N" Then Return
2930 J = Int(Rnd * 3): GoSub 4990
2940 If J = 0 Then CASH = 100 + Int(Rnd * 300): Print "It holds dragon's gold worth $"; CASH; Print ".": MONEY = MONEY + CASH: GoSub 4990: Return
2950 If J = 1 Then Print "A goblin leaps out, stabbing you!": LOSS = Int(Rnd * 6) + 1: MONEY = MONEY - Int(Rnd * 200): If MONEY < 1 Then MONEY = 0: GoSub 4990: Return
2960 If J = 2 Then Print "A strange smoke comes out": Print "making you sleepy and": Print "sapping your magic power.": LOSS = Int(Rnd * 8) + 1: M(7) = M(7) - LOSS: If M(7) < 1 Then M(7) = 0: GoSub 4990: Return
2970 Rem   ******************
2980 If POTION = 1 Then 2820
2990 POTION = 1
3000 Print "You see a small bottle engraved"
3010 Print "with curious, twisted letters..."
3020 Print : Print "Will you drink the potion which"
3030 Print "you can see inside the bottle?"
3040 GoSub 3380
3050 If ZSTR$ = "N" Then Return
3060 GoSub 4990
3070 If Rnd > .6 Then Print "It contained a potion to": Print "enhance your wisdom.": W(7) = W(7) + Int(Rnd * 6) + 1: GoSub 4990: Return
3080 Print "It contained a potion which": Print "weakens you further ....": GoSub 4990: S(7) = S(7) - (Int(Rnd * 6) + 1): If S(7) < 1 Then S(7) = 0: GoSub 4990: Return
3090 Rem   ******************
3100 If SCROLL = 1 Then Return
3110 SCROLL = 1
3120 Print "You see a papyrus scroll."
3130 Print : Print "Do you wish to try to read it?"
3140 GoSub 3380: If ZSTR$ = "N" Then Return
3150 If Rnd > .5 Then Print "You cannot understand": Print "the language...": GoSub 4990: Return
3160 Print "It contains a magic spell. Do": Print "you wish to read it?"
3170 GoSub 3380: If ZSTR$ = "N" Then Return
3180 If Rnd > .5 Then Print "It was a beneficent spell": GoSub 4990: M(7) = M(7) + Int(Rnd * 6) + 1: Return
3190 Print "It was an evil spell": GoSub 4990: M(7) = 0: S(7) = Int(S(7) / 2): Return
3200 Rem   ******************
3210 If SAFE = 1 Then 2820
3220 SAFE = 1
3230 Print "On the wall is a small, gilded": Print "safe, and in front of": Print "it is a key..."
3240 Print "Do you want to open the safe?"
3250 GoSub 3380
3260 If ZSTR$ = "N" Then Return
3270 If Rnd > .3 Then 3330
3280 GoSub 4990: Print "A shrieking harpy flies out": Print "and sinks its teeth into": Print "your throat!"
3290 GoSub 4990
3300 Print "You grapple with it, and...": GoSub 4990: Print "...finally wring its neck."
3310 S(7) = S(7) - Int(Rnd * 6) + 1: If S(7) < 1 Then S(7) = 0
3320 GoSub 4990: Return
3330 Print "A choir of angelic voices is": Print "heard.....": GoSub 4990
3340 Print : Print "You are healed and refreshed..."
3350 M(7) = M(7) + 2: S(7) = S(7) + 2: W(7) = W(7) + 2
3360 GoSub 4990
3370 Return
3380 ZSTR$ = Inkey$
3390 If ZSTR$ <> "N" And ZSTR$ <> "Y" Then 3380
3400 Print : Return
3410 Rem   ******************
3420 Rem   Room descriptions
3430 On Z GoSub 3480, 3570, 3630, 3680, 3770, 3850, 3950, 4080, 4210, 4270, 4350, 4440
3440 QV= 0: If Rnd > .81 And Z > 1 Then QV= Int(Rnd * 6): QVSTR$ = Mid$(Str$(QV), 2, 1): B$(Z) = LEFT$(B$(K),8) + QVSTR$ + MID$(B$(K),10): GoTo 260
3450 E$ = Mid$(B$(Z), 9, 1): If E$ > "0" And E$ < "6" Then QV= Val(E$)
3460 If QV> 0 Then GoSub 260
3470 Return
3480 Print "You are at the entrance to an"
3490 Print "ancient, forbidding-looking"
3500 Print "castle. You are standing on"
3510 Print "the north side of the castle,"
3520 Print "and as you look south, towards"
3530 Print "the tumbling structure, you"
3540 Print "notice the entrance portal"
3550 Print "is open and unguarded."
3560 Return
3570 Print "You are in the entrance hall,"
3580 Print "which is hung with rich"
3590 Print "fabrics. Doors lead to the"
3600 Print "east and the south, and there"
3610 Print "is an open portal to the west"
3620 Return
3630 Print "This is only a store room."
3640 Print "There is a single exit, back"
3650 Print "the way you came in,"
3660 Print "to the west"
3670 Return
3680 Print "This small room, which"
3690 Print "features an ornate sculpture"
3700 Print "of the moon goddess on a"
3710 Print "pedestal in the north-east"
3720 Print "corner, is the Royal"
3730 Print "Presence Chamber. Doors lead"
3740 Print "to the south, the west and"
3750 Print "to the east..."
3760 Return
3770 Print "The Hall of Plots, a"
3780 Print "wooden-pannelled room"
3790 Print "redolent with whispers and"
3800 Print "rumours, with exits to the east"
3810 Print "and to the south from which"
3820 Print "comes the smell of sulphur and"
3830 Print "a weird chanting..."
3840 Return
3850 Print "You have entered the Wizard's"
3860 Print "Den, with a cauldron bubbling"
3870 Print "over a fire with green flames"
3880 Print "in the south-west corner."
3890 Print "This room reeks of burning"
3900 Print "sulphur, and the echo of"
3910 Print "ancient spells. You can leave"
3920 Print "to the north, the south, or"
3930 Print "to the east."
3940 Return
3950 Print "You find yourself in a place"
3960 Print "which seems quiet and peaceful."
3970 Print "This is the castle's Picture"
3980 Print "Gallery, with a large painting"
3990 Print "of the Legendary Guardian of"
4000 Print "the Black Lagoon to the left of"
4010 Print "the window in the east wall. Through"
4020 Print "the window you can see the mullioned"
4030 Print "windows of the Great Hall across the"
4040 Print "Contoured Garden.  Exits from the"
4050 Print "Gallery  are to the north and"
4060 Print "to the east....."
4070 Return
4080 Print "This is the most magnificent"
4090 Print "room in the castle, the Great"
4100 Print "Hall, with a massive hammerbeam"
4110 Print "roof. You can leave it by the"
4120 Print "double doors to the north or by"
4130 Print "those to the east behind which"
4140 Print "you can hear music playing. "
4150 Print "Through the windows in the west"
4160 Print "wall, you can see the Contoured"
4170 Print "Garden, and beyond that, through"
4180 Print "windows of a room hung with"
4190 Print "many, many fine paintings"
4200 Return
4210 Print "Sounds of a string quartet"
4220 Print "fill this room, the Musicians'"
4230 Print "Chamber. You can leave by"
4240 Print "doors to the west or by one"
4250 Print "to the south..."
4260 Return
4270 Print "You are now in the Sanctuary"
4280 Print "of Silence, a room whose"
4290 Print "calmness may be a deception."
4300 Print "The room is damp and cold. An"
4310 Print "exit leaves the room to the"
4320 Print "north ";
4330 If Mid$(B$(10), 3, 2) = "12" Then Print "and one leaves to the south."
4340 Print : Return
4350 Print "This must be the Vestibule"
4360 Print "of Sighs, a dank and clammy"
4370 Print "room where legend says the"
4380 Print "Guardian of the Black Lagoon"
4390 Print "can sometimes be heard at"
4400 Print "night. There is a door to"
4410 Print "north ";
4420 If Mid$(B$(11), 3, 2) = "12" Then Print "and one leaves to the south."
4430 Print : Return
4440 GoTo 370
4450 If Mid$(B$(Z), 9, 1) <> "0" Then QV= Val(Mid$(B$(Z), 9, 1)): GoSub 260
4460 Return
4470 Rem   ********************
4480 Rem   Initialise
4490 Randomize Val(Right$(Time$, 2))
4500 Z = 1
4510 MONEY = 0
4520 CHEST = 0
4530 POTION = 0
4540 SCROLL = 0
4550 SAFE = 0
4570 Cls : Print "The Bannochburn Legacy" : Print "Created by Tim Hartnell"
4575 Print : Print "Find and defeat the Guardian"
4576 Print "of the Black Lagoon to free"
4577 Print "Bannochburn Castle of it's curse." : Print
4580 Input "Please enter your first name"; N$
4590 Cls : Print "Hi there, "; N$
4600 Print "Please stand by..."
4610 Rem   Fill rooms
4620 For T = 1 To 12
4630 Read B$(T)
4640 L = Rnd
4650 Q$ = Str$(Int(Rnd * 5) + 1)
4660 If T > 1 And T < 11 And L < .63 Then B$(T) = B$(T) + Right$(Q$, 1)
4670 If T > 10 Or L >= .63 Then B$(T) = B$(T) + "0"
4680 Next T
4690 L = Rnd
4700 If L < .5 Then B$(11) = "091200000"
4710 If L >= .5 Then B$(10) = "061200000"
4720 Rem   Create monsters
4730 For T = 1 To 6
4740 Read MSTR$(T)
4750 S(T) = Int(Rnd * 6) + 1
4760 M(T) = Int(Rnd * 6) + 1
4770 W(T) = Int(Rnd * 6) + 1
4780 Next T
4790 Rem   Human characteristics
4800 S(7) = Int(Rnd * 6) + 1
4810 M(7) = Int(Rnd * 6) + 1
4820 W(7) = Int(Rnd * 6) + 1
4830 Rem   Room data
4840 Data "000200000"
4850 Data "00080304"
4860 Data "00000002"
4870 Data "00070205"
4880 Data "00060400"
4890 Data "05100700"
4900 Data "04000600"
4910 Data "02000900"
4920 Data "00110008"
4930 Data "06000000"
4940 Data "09000000"
4950 Data "00000000"
4960 Rem   Monster data
4970 Data "Warlock","Fearbringer","Soulthreat","Kneecrusher","Wolvling","Guardian"
4980 Rem   ***********************
4990 Rem   Pause routine
5000 Pause 500: GoSub 6000
5020 Return
6000 Pause 500
6020 Return