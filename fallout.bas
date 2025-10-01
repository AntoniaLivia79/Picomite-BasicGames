' Jumping Fallout - Picomite Version
' Original BASIC Game by Neal Cavalier-Smith

MODE 2
FONT 4

COLOR RGB(GREEN)

CONST W = 9
CONST H = 9

DIM a$(11,H)
DIM INTEGER s, v, l, p, c, x, y
DIM INTEGER hs
DIM STRING g$, n$, t$

SUB init
  hs = 0
  n$ = "Antonia"
END SUB

SUB newgame
  s = 200
  v = 0
  FOR x = 2 TO 9
    FOR y = 1 TO H
      a$(x,y) = " "
      IF RND > 0.16 THEN a$(x,y) = "#"
    NEXT y
    a$(x,INT(RND*8)+1) = " "
  NEXT x
  FOR c = 1 TO H
    a$(1,c) = RIGHT$(STR$(c),1)
    a$(10,c) = " "
  NEXT c
END SUB

SUB showgrid
  CLS
  COLOR RGB(MAGENTA)
  PRINT " JUMPING FALLOUT"
  FOR x = 1 TO H
    COLOR RGB(GREEN)
    PRINT x-1;" ";
    FOR y = 1 TO H
      COLOR RGB(PINK)
      IF a$(x,y) = "#" THEN COLOR RGB(YELLOW)
      PRINT a$(x,y);
    NEXT y
    PRINT
    COLOR RGB(GREEN)
  NEXT x
  PRINT "SCORE:";s
END SUB

SUB falldown
  FOR y = H-1 TO 1 STEP -1
    FOR x = 1 TO H
      IF a$(y,x) <> " " AND a$(y,x) <> "#" THEN
        DO WHILE y < H AND a$(y+1,x) = " "
          a$(y+1,x) = a$(y,x)
          a$(y,x) = " "
          y = y + 1
        LOOP
        IF y = H THEN
          a$(y,x) = " "
          v = v + 1
        END IF
      END IF
    NEXT x
  NEXT y
END SUB

SUB moverow
  IF v >= H THEN EXIT SUB
  PRINT "LEVEL TO MOVE (1-8)";
  INPUT l
  l = l + 1
  IF l>H OR l<2 THEN moverow:EXIT SUB
  PRINT "MOVES TO THE LEFT";
  INPUT p
  IF p<0 OR p>10 THEN moverow:EXIT SUB
  FOR c = 1 TO p
    t$ = a$(l,1)
    FOR x = 1 TO H-1
      a$(l,x)=a$(l,x+1)
    NEXT x
    a$(l,H)=t$
  NEXT c
  s = s - l - p
END SUB

SUB gameover
  COLOR RGB(MAGENTA)
  PRINT "CLEARED! SCORE:";s
  IF s > hs THEN
    PRINT "NEW HIGH SCORE! NAME?";
    INPUT n$
    hs = s
  END IF
  PRINT "BEST:";hs;" BY ";n$
  DO
    COLOR RGB(GREEN)
    PRINT "PLAY AGAIN (Y/N)";
    INPUT g$
    g$ = UCASE$(g$)
  LOOP UNTIL g$="Y" OR g$="N"
END SUB

SUB intro
  CLS
  PRINT
  COLOR RGB(MAGENTA)
  PRINT "      Jumping Fallout!"
  COLOR RGB(GREEN)
  PRINT "A game by Neal Cavalier-Smith"
  PRINT
  PRINT "Shuffle the digits from the top"
  PRINT "to the bottom. Score points are"
  PRINT "deducted for each move (more for"
  PRINT "moving lower levels)."
  PRINT "Get all the digits to fall out"
  PRINT "with the least number of moves."
  PRINT
  PRINT "(Press any key)"
  seedVal = 1
  DO
      key$ = INKEY$
      seedVal = seedVal + 1
  LOOP UNTIL key$ <> ""
  RANDOMIZE seedVal
  CLS
END SUB

SUB main
  intro
  init
  DO
    newgame
    showgrid
    PAUSE 1500 
    falldown
    DO
      showgrid
      moverow
      showgrid
      PAUSE 500
      falldown
      showgrid
    LOOP UNTIL v >= H
    gameover
  LOOP UNTIL g$="N"
END SUB

main
END
