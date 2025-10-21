REM  Dog Star Adventure by Lance Micklus
REM  Ported to MMBasic

' ===========================================
' MAIN PROGRAM ENTRY POINT
' ===========================================
CLS:PRINT:PRINT:PRINT:PRINT
PRINT "DOG STAR"
PRINT "by Lance Micklus,"
PRINT "Winooski, Vt. 05404":PRINT:PRINT
PRINT "Copyright 1979":PRINT
GOSUB WaitForInput

GOSUB InitializeGameData
GOSUB InitializeGameVariables
GOTO MainGameLoop

' ===========================================
' GAME INITIALIZATION SECTION
' ===========================================
InitializeGameVariables:
  currentLocation=2:screenLineLength=64:blasterAmmo=4:guardFrequency=50:randomValue=16396
  turnCounter=0:tractorBeamOn=0:communicatorFound=0:flightDeckDoorsOpen=0
  hamburgerSpoilTime=0:doorUnlocked=0:itemsCarried=0
Return

' ===========================================
' MAIN GAME LOOP AND FLOW CONTROL
' ===========================================
MainGameLoop:
  CLS
  PRINT roomDescription$(currentLocation):displayString$=""
  IF currentLocation=35 THEN guardFrequency=10
  IF currentLocation=7 THEN GOSUB DisplayRoomContents
  GOSUB DisplayRoomContents
  GOSUB DisplayDirections
  GOSUB GetPlayerCommand
  GOSUB RandomGuardEncounter
  GOTO MainGameLoop
  

DisplayRoomContents:
  hasItems=0
  FOR objectIndex=1 TO totalObjects
    IF objectData(objectIndex,1)<>currentLocation THEN GOTO ContinueRoomScan
    IF hasItems=0 THEN hasItems=1:PRINT:PRINT "Around me I see:":displayString$=objectName$(objectIndex):GOTO ContinueRoomScan
    IF LEN(displayString$)+5+LEN(objectName$(objectIndex))>screenLineLength THEN PRINT displayString$:displayString$=objectName$(objectIndex):ELSE displayString$=displayString$+"     "+objectName$(objectIndex)
    ContinueRoomScan:
  NEXT objectIndex
  IF displayString$<>"" THEN PRINT displayString$
  RETURN

DisplayDirections:
  PRINT:PRINT "Obvious directions are ";
  hasDirections=0
  FOR directionIndex=0 TO 5
    IF roomConnections(currentLocation,directionIndex)<>0 THEN 
      IF hasDirections<>0 THEN PRINT ", ";
      PRINT nounList$(directionIndex+1);:hasDirections=1
    ENDIF
  NEXT directionIndex
  IF hasDirections=0 THEN PRINT "unknown";
  PRINT "."
  RETURN

' ===========================================
' RANDOM EVENTS AND ENCOUNTERS
' ===========================================
RandomGuardEncounter:
  IF turnCounter<25 OR INT(RND(1)*guardFrequency+1)<>1 THEN GOTO ProcessPlayerInput
  IF turnCounter=300 THEN guardFrequency=20
  IF currentLocation<3 OR currentLocation=9 OR currentLocation=26 OR currentLocation=36 OR currentLocation=37 THEN GOTO ProcessPlayerInput
  IF currentLocation>26 AND currentLocation<31 THEN GOTO ProcessPlayerInput
  PRINT "Holy smokes. An armed guard just walked in."
  GOSUB HandleGuardEncounter
  RETURN

HandleGuardEncounter:
  GOSUB GetPlayerCommand:IF verbNumber<>12 OR nounNumber<>15 THEN GOTO GameOver
  searchObject=13:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN GOTO GameOver
  IF blasterAmmo=0 THEN CLS:PRINT "I'm out of ammunition.":PRINT:GOTO EndGameSequence
  PRINT "zzZAP! No more guard."
  blasterAmmo=blasterAmmo-1:IF blasterAmmo=0 THEN PRINT "I'm out of ammunition."
  RETURN

' ===========================================
' PLAYER INPUT AND COMMAND PROCESSING
' ===========================================
ProcessPlayerInput:
  GOSUB CheckHamburgerStatus
  IF verbNumber=0 AND nounNumber=0 THEN GOTO UnknownCommand ELSE GOTO ProcessCommand
  RETURN

CheckHamburgerStatus:
  IF hamburgerSpoilTime<>turnCounter THEN GOSUB IncrementTimeCounter
  searchObject=22
  GOSUB CheckObjectLocation
  IF objectFoundLocation<>-1 THEN GOTO IncrementTimeCounter
  PRINT "Your McDonald's Hamburger is cold."
  RETURN

IncrementTimeCounter:
  turnCounter=turnCounter+1
  RETURN

ProcessCommand:
  IF verbNumber=1 THEN GOTO HandleMovement
  IF verbNumber=2 THEN GOTO HandleTakeItem
  IF verbNumber=3 THEN GOTO MainGameLoop
  IF verbNumber=4 THEN GOTO HandleInventoryCommand
  IF verbNumber=5 THEN GOTO HandleScoreCommand
  IF verbNumber=6 THEN GOTO HandleDropCommand
  IF verbNumber=7 THEN GOTO HandleHelpCommand
  IF verbNumber=8 THEN GOTO HandleSaveCommand
  IF verbNumber=9 THEN GOTO HandleLoadCommand
  IF verbNumber=10 THEN GOTO HandleQuitCommand
  IF verbNumber=11 THEN GOTO HandlePressCommand
  IF verbNumber=12 THEN GOTO HandleShootCommand
  IF verbNumber=13 THEN GOTO HandleSayCommand
  IF verbNumber=14 THEN GOTO HandleReadCommand
  IF verbNumber=15 THEN GOTO HandleEatCommand
  IF verbNumber=16 THEN GOTO HandleCSaveCommand
  IF verbNumber=17 THEN GOTO HandleShowCommand
  IF verbNumber=18 THEN GOTO HandleOpenCommand
  IF verbNumber=19 THEN GOTO HandleFeedCommand
  IF verbNumber=20 THEN GOTO HandleHitCommand
  IF verbNumber=21 THEN GOTO HandleKillCommand
  GOTO UnknownCommand

' ===========================================
' MOVEMENT COMMANDS
' ===========================================
HandleMovement:
  IF nounNumber=0 THEN GOTO UnknownCommand
  IF roomConnections(currentLocation,nounNumber-1)=0 THEN PRINT "I can't go that way!":GOTO RandomGuardEncounter
  GOSUB CheckMovementRestrictions
  GOTO ProcessMovement

CheckMovementRestrictions:
  IF flightDeckDoorsOpen AND roomConnections(currentLocation,nounNumber-1)>2 AND roomConnections(currentLocation,nounNumber-1)<6 THEN 
    PRINT "I can't go that way.  Flight deck doors are open."
    PRINT "NO AIR!!!":GOTO RandomGuardEncounter
  ENDIF
  IF nounNumber=3 AND currentLocation=31 AND NOT doorUnlocked THEN PRINT doorLockedMessage$:GOTO RandomGuardEncounter
  IF currentLocation=35 AND roomConnections(currentLocation,nounNumber-1)=36 AND objectData(21,1)<>0 THEN
    PRINT "The robot won't let me through.":GOTO RandomGuardEncounter
  ENDIF
  IF currentLocation=17 AND objectData(13,1)=17 THEN GOTO GameOver
  IF currentLocation=9 AND objectData(5,1)=9 THEN GOTO GameOver
  RETURN

ProcessMovement:
  IF currentLocation=9 OR currentLocation=17 THEN roomHint$(currentLocation)=""
  currentLocation=roomConnections(currentLocation,nounNumber-1)
  IF currentLocation=34 THEN roomHint$(currentLocation)=""
  IF currentLocation=26 THEN GOTO Victory
  GOTO CheckCharismaDepletion
  GOTO MainGameLoop

CheckCharismaDepletion:
  itemsCarried=itemsCarried+1:IF itemsCarried=25 THEN GOTO GameOver
  RETURN

' ===========================================
' INVENTORY MANAGEMENT COMMANDS
' ===========================================
HandleTakeItem:
  Print "HandleTakeItem"
  IF nounNumber=0 THEN PRINT "I don't know what a ";CHR$(34);inputNoun$;CHR$(34);" is.":GOTO RandomGuardEncounter
  IF itemsCarried>5 THEN PRINT "I can't carry any more.":PRINT "HINT: Drop something.":GOTO RandomGuardEncounter
  GOTO FindObjectToTake
  RETURN

FindObjectToTake:
  Print "FindObjectToTake"
  FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=nounNumber THEN GOTO ProcessTakeItem ELSE NEXT objectIndex
  GOTO UnknownCommand

ProcessTakeItem:
  Print "ProcessTakeItem"
  IF objectData(objectIndex,1)=-1 THEN PRINT "I'm already carrying it.":GOTO RandomGuardEncounter
  IF objectData(objectIndex,1)<>currentLocation THEN PRINT "I don't see it.":GOTO RandomGuardEncounter
  IF nounNumber=37 THEN HandleAmmunitionReload:RETURN
  IF nounNumber=15 OR nounNumber=25 OR nounNumber=34 THEN PRINT "He looks pretty mean to me.":GOTO RandomGuardEncounter
  GOTO ExecuteTakeAction
  RETURN

HandleAmmunitionReload:
  searchObject=13:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT "I don't have a blaster to put it in.":GOTO RandomGuardEncounter
  blasterAmmo=4:objectData(objectIndex,1)=0:PRINT "My BLASTER's reloaded.":GOTO RandomGuardEncounter

ExecuteTakeAction:
  Print "ExecuteTakeAction"
  itemsCarried=itemsCarried+1:objectData(objectIndex,1)=-1:PRINT "O.K."
  GOTO ProcessSpecialTakeEffects
  GOTO RandomGuardEncounter

ProcessSpecialTakeEffects:
  IF nounNumber=14 AND NOT communicatorFound THEN PRINT "A voice says ";CHR$(34);"SESAME";CHR$(34);".":communicatorFound=-1
  IF nounNumber=22 AND hamburgerSpoilTime=0 THEN hamburgerSpoilTime=turnCounter+50
  IF nounNumber=12 THEN roomHint$(2)=""
  IF nounNumber=13 THEN roomHint$(7)=""
  RETURN

HandleDropCommand:
  IF nounNumber=0 THEN GOTO HandleTakeItem
  IF currentLocation=2 THEN PRINT "There's no room here.":GOTO RandomGuardEncounter
  GOTO CheckRoomCapacity
  GOTO FindObjectToDrop
  RETURN

CheckRoomCapacity:
  roomItemCount=0:FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,1)=currentLocation THEN roomItemCount=roomItemCount+1:NEXT objectIndex
  IF roomItemCount>12 THEN PRINT "There not enough room. Get rid of something.":GOTO RandomGuardEncounter
  RETURN

FindObjectToDrop:
  FOR objectIndex=0 TO totalObjects:IF objectData(objectIndex,0)=nounNumber THEN GOTO ExecuteDropAction ELSE NEXT objectIndex
  GOTO UnknownCommand

ExecuteDropAction:
  IF objectData(objectIndex,1)<>-1 THEN PRINT "I'm not carrying it.":GOTO RandomGuardEncounter
  itemsCarried=itemsCarried-1:objectData(objectIndex,1)=currentLocation:PRINT "O.K.":GOTO RandomGuardEncounter

HandleInventoryCommand:
  PRINT "I'm carrying:"
  hasItems=0:FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,1)=-1 THEN PRINT objectName$(objectIndex):hasItems=1:NEXT objectIndex
  IF hasItems=0 THEN PRINT "NOTHING"
  PRINT:verbNumber=0:nounNumber=0:GOSUB WaitForInput:GOTO MainGameLoop

' ===========================================
' GAME STATE COMMANDS
' ===========================================
HandleScoreCommand:
  GOSUB CalculateScore:GOTO RandomGuardEncounter

HandleHelpCommand:
  IF roomHint$(currentLocation)="" THEN PRINT "How am I supposed to know what to do?":GOTO RandomGuardEncounter
  PRINT roomHint$(currentLocation):GOTO RandomGuardEncounter

HandleQuitCommand:
  CLS:playerScore=0:GOTO EndGameWithScore

' ===========================================
' SAVE/LOAD SYSTEM
' ===========================================
HandleSaveCommand:
  IF NOT usingTape THEN GOTO HandleSaveToFile ELSE PRINT "Press (ENTER) when ready to RECORD :":GOSUB WaitForInput:GOTO SaveGameData

HandleSaveToFile:
  IF inputNoun$="" THEN inputNoun$="DOGSTAR.DAT"
  OPEN"O",1,inputNoun$
  GOTO SaveGameData

SaveGameData:
  FOR objectIndex=0 TO totalObjects:PRINT #1,objectData(objectIndex,0);objectData(objectIndex,1);objectData(objectIndex,2):NEXT objectIndex
  PRINT #1,tractorBeamOn;turnCounter;communicatorFound;flightDeckDoorsOpen;blasterAmmo;hamburgerSpoilTime;guardFrequency;doorUnlocked;itemsCarried;currentLocation
  CLOSE:PRINT "O.K.":GOTO RandomGuardEncounter

HandleLoadCommand:
  GOTO HandleLoadFromFile

HandleLoadFromFile:
  IF inputNoun$="" THEN inputNoun$="DOGSTAR.DAT"
  OPEN"I",1,inputNoun$
  GOTO LoadGameData

LoadGameData:
  FOR objectIndex=0 TO totalObjects:INPUT #1,objectData(objectIndex,0),objectData(objectIndex,1),objectData(objectIndex,2):NEXT objectIndex
  INPUT #1,tractorBeamOn,turnCounter,communicatorFound,flightDeckDoorsOpen,blasterAmmo,hamburgerSpoilTime,guardFrequency,doorUnlocked,itemsCarried,currentLocation
  CLOSE:GOTO MainGameLoop

' ===========================================
' INTERACTION COMMANDS
' ===========================================
HandlePressCommand:
  IF nounNumber<>10 THEN GOTO UnknownCommand
  IF currentLocation<>2 AND currentLocation<>11 THEN PRINT "What button,":GOTO RandomGuardEncounter
  GOTO ProcessButtonPress
  RETURN

ProcessButtonPress:
  IF currentLocation=11 AND NOT tractorBeamOn THEN tractorBeamOn=-1:PRINT tractorBeamOffMessage$:GOTO RandomGuardEncounter
  IF currentLocation=11 AND tractorBeamOn THEN tractorBeamOn=0:PRINT tractorBeamOnMessage$:GOTO RandomGuardEncounter
  GOTO CheckLaunchConditions
  RETURN

CheckLaunchConditions:
  searchObject=12:GOSUB CheckObjectLocation:IF objectFoundLocation<>1 THEN GOTO NothingHappened
  searchObject=24:GOSUB CheckObjectLocation:IF objectFoundLocation<>1 THEN GOTO NothingHappened
  IF NOT tractorBeamOn THEN PRINT tractorBeamOnMessage$:GOTO NothingHappened
  IF NOT flightDeckDoorsOpen THEN PRINT flightDeckClosedMessage$:GOTO NothingHappened
  GOTO LaunchSequence

HandleShootCommand:
  IF nounNumber=0 THEN GOTO HandleSayCommand
  IF blasterAmmo=0 THEN PRINT "But I don't have any ammunition left.":GOTO RandomGuardEncounter
  GOTO ProcessShootAction
  RETURN

ProcessShootAction:
  searchObject=13:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT "But I'm not carrying a BLASTER.":GOTO RandomGuardEncounter
  searchObject=nounNumber:GOSUB CheckObjectLocation:IF objectFoundLocation=-1 THEN PRINT "I can't. I'm holding it.":GOTO RandomGuardEncounter
  IF nounNumber=34 THEN PRINT "zzZAP!":blasterAmmo=blasterAmmo-1:GOTO RandomGuardEncounter
  IF objectFoundLocation<>currentLocation THEN PRINT "I don't see it.":GOTO RandomGuardEncounter
  GOTO ExecuteShootAction
  RETURN

ExecuteShootAction:
  FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=nounNumber THEN GOTO DestroyTarget ELSE NEXT objectIndex
  GOTO UnknownCommand

DestroyTarget:
  objectData(objectIndex,1)=0:PRINT "zzZAP!!!  The ";nounList$(nounNumber);" vaporized."
  blasterAmmo=blasterAmmo-1:IF blasterAmmo=0 THEN PRINT "I'm out of ammunition."
  GOTO RandomGuardEncounter

' ===========================================
' COMMUNICATION COMMANDS
' ===========================================
HandleSayCommand:
  IF nounNumber=0 THEN PRINT "Say what?":GOTO RandomGuardEncounter
  searchObject=14:GOSUB CheckObjectLocation
  IF objectFoundLocation<>-1 OR nounNumber<>19 THEN PRINT "O.K.   ";nounList$(nounNumber):GOTO RandomGuardEncounter
  GOTO ProcessSecurityCommand
  RETURN

ProcessSecurityCommand:
  IF flightDeckDoorsOpen THEN GOTO NothingHappened
  flightDeckDoorsOpen=-1:PRINT "A voice comes over the P.A. system and says"
  PRINT "OPENNING FLIGHT DECK DOORS":PRINT
  IF currentLocation>2 AND currentLocation<6 THEN PRINT:PRINT "Yips!!! There's no air!!!  CROAK...":END
  GOTO RandomGuardEncounter

' ===========================================
' OBJECT INTERACTION COMMANDS
' ===========================================
HandleReadCommand:
  IF nounNumber<>20 AND nounNumber<>16 AND nounNumber<>11 AND nounNumber<>33 THEN GOTO UnknownCommand
  GOTO ProcessReadAction
  RETURN

ProcessReadAction:
  IF nounNumber=20 THEN GOTO HandleReadGraffiti:RETURN
  IF nounNumber<>16 THEN GOTO HandleReadOtherItems:RETURN
  GOTO ProcessMapReading
  RETURN

HandleReadGraffiti:
  PRINT:PRINT "It says on the wall,"
  PRINT ">> YOUR MOTHER'S GOT A BIG NOSE <<"
  PRINT ">> KILROY MADE IT HERE, TOO <<"
  PRINT ">> SAY SECURITY <<"
  GOTO RandomGuardEncounter

HandleReadOtherItems:
  searchObject=nounNumber:GOSUB CheckObjectLocation
  IF objectFoundLocation<>currentLocation AND objectFoundLocation<>-1 THEN GOTO HandleReadNotFound:RETURN
  IF nounNumber=11 THEN PRINT "It says >> NEEDS TURBO <<"
  IF nounNumber=33 THEN PRINT "It says >> OUT OF  ORDER <<"
  GOTO RandomGuardEncounter

HandleReadNotFound:
  IF currentLocation<>13 THEN PRINT "I don't see any."
  GOTO RandomGuardEncounter

ProcessMapReading:
  IF objectData(6,1)=-1 THEN PRINT "Sorry. I'm not a cartographer.":GOTO RandomGuardEncounter
  IF objectData(6,1)=currentLocation THEN PRINT "Try GET MAP.":GOTO RandomGuardEncounter
  PRINT "It's not here.":GOTO RandomGuardEncounter

HandleEatCommand:
  IF nounNumber=0 THEN PRINT "What's a ";inputNoun$;"?":GOTO RandomGuardEncounter
  IF nounNumber<>22 THEN PRINT "Don't be rediculous.":GOTO RandomGuardEncounter
  GOTO ProcessEatHamburger
  RETURN

ProcessEatHamburger:
  searchObject=22:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT "I'm not holding it.":GOTO RandomGuardEncounter
  FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=22 THEN GOTO ExecuteEatAction ELSE NEXT objectIndex
  PRINT "I don't know where it is.":GOTO RandomGuardEncounter

ExecuteEatAction:
  objectData(objectIndex,1)=0:PRINT "Chump - Chump.  Hummm, good.":GOTO RandomGuardEncounter

' ===========================================
' SPECIAL ACTION COMMANDS
' ===========================================
HandleCSaveCommand:
  IF nounNumber<>23 OR currentLocation<>16 THEN GOTO HandleShowCommand
  searchObject=23:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT message1$:GOTO RandomGuardEncounter
  objectData(11,1)=0:objectData(14,1)=16:itemsCarried=itemsCarried-1:PRINT message2$:GOTO RandomGuardEncounter

HandleOpenCommand:
  IF nounNumber<>36 OR currentLocation<>31 THEN GOTO HandleFeedCommand
  searchObject=17:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT message3$:GOTO RandomGuardEncounter
  roomHint$(31)="":doorUnlocked=-1:PRINT message4$:GOTO RandomGuardEncounter

HandleFeedCommand:
  IF nounNumber=0 THEN GOTO HandleHitCommand
  GOTO ProcessFeedAction
  RETURN

ProcessFeedAction:
  IF currentLocation<>35 AND nounNumber=34 THEN PRINT message5$:GOTO RandomGuardEncounter
  searchObject=22:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN PRINT message6$:GOTO RandomGuardEncounter
  GOTO ExecuteFeedAction
  RETURN

ExecuteFeedAction:
  searchObject=35:GOSUB CheckObjectLocation
  IF objectFoundLocation=1 OR objectFoundLocation=currentLocation AND nounNumber=35 THEN PRINT"I don't see her.":GOTO RandomGuardEncounter
  IF nounNumber=35 THEN PRINT message7$
  GOTO ProcessFeedWithFood
  RETURN

ProcessFeedWithFood:
  robotIndex=objectIndex:FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=22 THEN GOTO CompleteFeedAction ELSE NEXT objectIndex
  GOTO UnknownCommand

CompleteFeedAction:
  IF nounNumber<>34 THEN PRINT inputNoun$;message8$:GOTO RandomGuardEncounter
  IF turnCounter>hamburgerSpoilTime THEN PRINT message9$:GOTO RandomGuardEncounter
  FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=34 THEN GOTO FeedRobot ELSE NEXT objectIndex
  GOTO UnknownCommand

FeedRobot:
  robotIndex=objectIndex:FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,0)=22 THEN GOTO DestroyRobotWithFood ELSE NEXT objectIndex
  GOTO UnknownCommand

DestroyRobotWithFood:
  PRINT robotDestroyedMessage$:roomHint$(35)="":objectData(robotIndex,1)=0:objectData(objectIndex,1)=0:GOTO RandomGuardEncounter

HandleShowCommand:
  PRINT inputNoun$:GOTO RandomGuardEncounter

HandleHitCommand:
  IF nounNumber=0 THEN GOTO UnknownCommand
  GOTO ProcessHitAction
  RETURN

ProcessHitAction:
  searchObject=nounNumber:GOSUB CheckObjectLocation:IF objectFoundLocation=-1 THEN PRINT "I'm carrying it. That's impossible.":GOTO RandomGuardEncounter
  IF objectFoundLocation=currentLocation THEN GOTO ExecuteHitAction:RETURN
  IF nounNumber<11 OR nounNumber=19 OR nounNumber=20 OR nounNumber=30 THEN GOTO UnknownCommand
  PRINT "I can't hit something I can't see."
  GOTO RandomGuardEncounter

ExecuteHitAction:
  IF nounNumber=15 OR nounNumber=25 OR nounNumber=34 THEN PRINT "I'd rather not. He might hit me back!":GOTO RandomGuardEncounter
  IF nounNumber=35 THEN PRINT "That's not nice!"
  GOTO RandomGuardEncounter
  GOTO NothingHappened

HandleKillCommand:
  PRINT "I'm not strong enough to kill anything."
  GOTO RandomGuardEncounter

' ===========================================
' UTILITY FUNCTIONS
' ===========================================
UnknownCommand:
  PRINT "I don't know how to do that."
  PRINT:verbNumber=0:nounNumber=0:GOSUB WaitForInput:GOTO MainGameLoop

NothingHappened:
  PRINT "Nothing happened."
  GOTO RandomGuardEncounter

GetPlayerCommand:
  PRINT
  INPUT "What should I do";commandString$
  PRINT
  GOSUB ProcessInputAbbreviations
  GOSUB ParseCommand
  Return

ProcessInputAbbreviations:
  IF commandString$="N" THEN commandString$="NORTH"
  IF commandString$="S" THEN commandString$="SOUTH"
  IF commandString$="E" THEN commandString$="EAST"
  IF commandString$="W" THEN commandString$="WEST"
  IF commandString$="U" THEN commandString$="UP"
  IF commandString$="D" THEN commandString$="DOWN"
  IF commandString$="L" THEN commandString$="LOOK"
  IF commandString$="I" THEN commandString$="INVENTORY"
  IF commandString$="H" THEN commandString$="HELP"
  Return

ParseCommand:
  inputVerb$=""
  inputNoun$=""
  verbNumber=0
  nounNumber=0
  IF LEN(commandString$)=0 THEN GOSUB GetPlayerCommand
  GOSUB ExtractVerb
  GOSUB ProcessVerbMatch
  GOSUB ExtractNoun
  GOSUB ProcessNounMatch
  Return

ExtractVerb:
  FOR stringLength=1 TO LEN(commandString$)
    IF MID$(commandString$,stringLength,1)<>" " THEN inputVerb$=inputVerb$+MID$(commandString$,stringLength,1) ELSE Return
  NEXT stringLength
  Return

ProcessVerbMatch:
  FOR verbIndex=1 TO totalVerbs
    IF verbList$(verbIndex)<>"" AND LEFT$(inputVerb$,LEN(verbList$(verbIndex)))=verbList$(verbIndex) THEN verbNumber=verbIndex:GOTO ExtractNoun
  NEXT verbIndex
  verbNumber=0
  'inputNoun$=inputVerb$
  Return

ExtractNoun:
  IF LEN(inputVerb$)+1>=LEN(commandString$) THEN nounNumber=0: Return
  inputNoun$=RIGHT$(commandString$,LEN(commandString$)-1-LEN(inputVerb$))
  Return
  

ProcessNounMatch:
  FOR nounIndex=1 TO totalNouns
    IF nounList$(nounIndex)<>"" AND LEFT$(inputNoun$,LEN(nounList$(nounIndex)))=nounList$(nounIndex) THEN nounNumber=nounIndex:RETURN
  NEXT nounIndex
  nounNumber=0
  Return

CheckObjectLocation:
  FOR searchIndex=0 TO totalObjects
    IF objectData(searchIndex,0)=searchObject THEN objectFoundLocation=objectData(searchIndex,1):RETURN
  NEXT searchIndex
  objectFoundLocation=-99
  Return

CalculateScore:
  playerScore=0:FOR objectIndex=1 TO totalObjects:IF objectData(objectIndex,1)=1 THEN playerScore=playerScore+objectData(objectIndex,2):NEXT objectIndex
  PRINT "Out of a maximum of";maxScore;"points, you have";playerScore;"points."
  IF playerScore=0 THEN PRINT "We're not doing too good."
  Return

WaitForInput:
  PRINT "(Press any key to continue)"
  DO: LOOP WHILE INKEY$=""
  Return

' ===========================================
' GAME ENDING SEQUENCES
' ===========================================
GameOver:
  CLS:PRINT "H E L P ! ! !":PRINT

EndGameSequence:
  PRINT "Roche Soldiers are everywhere. I've been captured."
  PRINT "I'm now a prisoner. Woe is me...":PRINT
  GOTO PlayAgainPrompt

LaunchSequence:
  CLS:GOSUB CalculateScore

EndGameWithScore:
  IF playerScore=0 THEN PRINT "We have FAILED our mission. The forces of Princess Leya will be conquered."
  IF playerScore=maxScore THEN PRINT:PRINT "We are HEROS. The forces of Princess Leya will conquer the evil Roche soldiers, and freedom will prevail throughout the galaxy."
  IF playerScore>0 AND playerScore<maxScore THEN PRINT"We have helped the forces of Princess Leya defend the galaxy. Long live the forces of freedom!"

PlayAgainPrompt:
  PRINT:INPUT "Do you want to play again (Y or N)";userResponse$:userResponse$=LEFT$(userResponse$,1)
  IF userResponse$="Y" OR userResponse$="y" THEN RUN ELSE END

Victory:
  CLS:PRINT"A voice booms out, ";CHR$(34);"WHO GOES THERE";CHR$(34)
  GOSUB GetPlayerCommand:IF verbNumber<>13 OR nounNumber<>30 THEN GOTO GameOver
  PRINT identificationMessage$:GOSUB GetPlayerCommand
  searchObject=31:GOSUB CheckObjectLocation:IF objectFoundLocation<>-1 THEN GOTO GameOver
  IF verbNumber<>17 OR nounNumber<>31 THEN GOTO GameOver ELSE GOTO MainGameLoop

' ===========================================
' GAME DATA INITIALIZATION
' ===========================================
InitializeGameData:
  maxScore=215:totalVerbs=21:DIM verbList$(totalVerbs)
  GOSUB InitializeVerbs
  GOSUB InitializeNouns
  GOSUB InitializeRoomDescriptions
  GOSUB InitializeObjectData
  GOSUB InitializeHelpMessages
  GOSUB InitializeGameMessages
  Return

InitializeVerbs:
  verbList$(1)="GO":verbList$(2)="GET":verbList$(3)="LOOK":verbList$(4)="INVEN":verbList$(5)="SCORE":verbList$(6)="DROP"
  verbList$(7)="HELP":verbList$(8)="SAVE":verbList$(9)="LOAD":verbList$(10)="QUIT":verbList$(11)="PRESS":verbList$(12)="SHOOT"
  verbList$(13)="SAY":verbList$(14)="read":verbList$(15)="EAT":verbList$(16)="CSAVE":verbList$(17)="SHOW":verbList$(18)="OPEN"
  verbList$(19)="FEED":verbList$(20)="HIT":verbList$(21)="KILL"
  Return

InitializeNouns:
  totalNouns=37:DIM nounList$(totalNouns)
  nounList$(1)="NORTH":nounList$(2)="EAST":nounList$(3)="SOUTH":nounList$(4)="WEST":nounList$(5)="UP":nounList$(6)="DOWN"
  nounList$(10)="BUTTON":nounList$(11)="TAG":nounList$(12)="FUEL":nounList$(13)="BLASTER":nounList$(14)="COMMUNICATOR":nounList$(15)="GUARD"
  nounList$(16)="MAP":nounList$(17)="KEYS":nounList$(18)="NECKLACE":nounList$(19)="SESAME":nounList$(20)="GRAFFITI":nounList$(21)="CAPE"
  nounList$(22)="HAMBURGER":nounList$(23)="TAPE":nounList$(24)="TURBO":nounList$(25)="SCIENTIST":nounList$(26)="PLANS"
  nounList$(27)="SCHEMATIC":nounList$(28)="DEVICE":nounList$(29)="GUN":nounList$(30)="SECURITY":nounList$(31)="I.D."
  nounList$(32)="CRYSTALS":nounList$(33)="SIGN":nounList$(34)="ROBOT":nounList$(35)="PRINCESS":nounList$(36)="DOOR":nounList$(37)="AMMUNITION"
  Return

InitializeRoomDescriptions:
  totalRooms=37:DIM roomDescription$(totalRooms)
  roomDescription$(1)="I'm in the passenger & storage compartment of my space ship. There's an exit here to leave the ship."
  roomDescription$(2)="I'm in the cockpit of my space ship. A large red button says >> PRESS TO BLAST OFF <<"
  roomDescription$(3)="I'm standing next to my space ship which is located on a huge flight deck."
  roomDescription$(4)="I'm out on the flight deck of General Doom's Battle Cruiser."
  roomDescription$(5)="I'm out on the flight deck of General Doom's Battle Cruiser."
  roomDescription$(6)="I'm in a hallway. There are doors on all sides. The door to the north says >> CLOSED FOR THE DAY <<"
  roomDescription$(7)="I'm in the SUPPLY DEPOT. around me I see all kinds of things"
  roomDescription$(8)="I'm at the end of one of the hallways. I can here voices nearby. Sounds like guards."
  roomDescription$(9)="I'm in the STRATEGY PLANNING room."
  roomDescription$(10)="I'm in the DECONTAMINATION area."
  roomDescription$(11)="This area is the tractor beam control room. A large sign warns >> DO NOT PRESS ANY BUTTONS <<"
  roomDescription$(12)="I'm in another hallway. To the EAST is a restroom."
  roomDescription$(13)="This is what is commonly called on earth, the BATHROOM. There's graffiti written all over the wall. Pipes lead up through the ceiling."
  roomDescription$(14)="This appears to be an interrogation room."
  roomDescription$(15)="I'm in a LOUNGE."
  roomDescription$(16)="This is a computer room. There's a TRS-80 in here. On the screen it says:  >> CSAVE TAPE <<"
  roomDescription$(17)="I'm in a testing laboratory."
  roomDescription$(18)="I'm in a hallway. A large arrow points EAST and says >> TO THE VAULT <<"
  roomDescription$(19)="This is the entrance to the DEVELOPMENT LAB SECTION"
  roomDescription$(20)="I'm in a long corridor. There are laboratories all around me."
  roomDescription$(21)="I'm in a research lab."
  roomDescription$(22)="I'm lost!"
  roomDescription$(23)="I'm in a research lab."
  roomDescription$(24)="I'm in a research lab."
  roomDescription$(25)="I'm near the entrance to the vault. A sign here says >> AUTHORIZED PERSONEL ONLY <<"
  roomDescription$(26)="I'm in the vault."
  roomDescription$(27)="I'm in a pipe tunnel which leads in every direction."
  roomDescription$(28)="I'm in a pipe tunnel which leads in every direction."
  roomDescription$(29)="I'm lost in a maze of pipes."
  roomDescription$(30)="I'm in the pipe maze. Below me I think I can see the jail."
  roomDescription$(31)="I'm in the jail."
  roomDescription$(32)="I'm in a jail cell."
  roomDescription$(33)="I'm in a jail cell."
  roomDescription$(34)="I'm in a jail cell."
  roomDescription$(35)="I'm at the security desk. To the north an elevator."
  roomDescription$(36)="I'm in the elevator."
  roomDescription$(37)="I'm in the elevator."
  Return

InitializeObjectData:
  totalObjects=23:DIM objectName$(totalObjects):DIM roomConnections(50,5):RESTORE
  FOR roomIndex=1 TO totalRooms:FOR directionIndex=0 TO 5:read roomConnections(roomIndex,directionIndex):NEXT directionIndex:NEXT roomIndex
  ' objectData - element 0 (the noun which represents the object)
  ' element 1 (location of object, this will be a room or -1 if in player inventory), element 2 is for scoring
  DIM objectData(25,2):FOR objectIndex=1 TO totalObjects:read objectData(objectIndex,0),objectData(objectIndex,1),objectData(objectIndex,2):NEXT objectIndex
  objectName$(1)="a TAG which says: >> NEEDS TURBO <<"
  objectName$(2)="Anti-matter FUEL"
  objectName$(3)="BLASTER"
  objectName$(4)="COMMUNICATOR"
  objectName$(5)="A very surprised GUARD"
  objectName$(6)="MAP of the ship"
  objectName$(7)="some KEYS"
  objectName$(8)="a shinestone NECKLACE"
  objectName$(9)="Princess Leya's CAPE"
  objectName$(10)="McDonald's HAMBURGER"
  objectName$(11)="a cassette TAPE"
  objectName$(12)="a TURBOENCABULATOR"
  objectName$(13)="an evil looking SCIENTIST"
  objectName$(14)="secret attack PLANS"
  objectName$(15)="Death Ray SCHEMATIC"
  objectName$(16)="Cloaking DEVICE"
  objectName$(17)="Micro Laser GUN"
  objectName$(18)="I.D. card"
  objectName$(19)="Malidium CRYSTALS (the Treasury!)"
  objectName$(20)="a SIGN which says: >> OUT OF ORDER <<"
  objectName$(21)="attack ROBOT"
  objectName$(22)="PRINCESS Leya"
  objectName$(23)="AMMUNITION"
  Return

InitializeHelpMessages:
  DIM roomHint$(totalRooms)
  roomHint$(1)="I think we're suppose to leave the stuff here."
  roomHint$(2)="I wonder if we have enough fuel?"
  roomHint$(7)="How 'bout a BLASTER."
  roomHint$(9)="Try SHOOT GUARD."
  roomHint$(13)="It might be interesting to read the graffiti."
  roomHint$(17)="Try SHOOT SCIENTIST."
  roomHint$(22)="I'm as confused as you are."
  roomHint$(29)=roomHint$(22)
  roomHint$(31)="It might help if we had some keys to OPEN any locked DOORs."
  roomHint$(35)="Did you bring anything to eat?"
  Return

InitializeGameMessages:
  doorLockedMessage$="I can't go there. The door is locked."
  message1$="I'm not carrying any blank tape."
  message2$="The TRS-80 recorded something on the tape, and then it printed >> ATTACK PLANS -- VERY SECRET <<"
  message3$="I can't. I'm not carrying any keys."
  message4$="O.K. The door to the jail cell is unlocked."
  message5$="There's no robot here."
  message6$="But I don't have any hamburgers."
  message7$="Chomp...chomp   BURP! The princess thanks you for a delicious meal."
  message8$=" doesn't eat hamburger."
  message9$="Nothing happened. The hamburger is cold you know."
  robotDestroyedMessage$="The attack robot eats the hamburger and disappears."
  identificationMessage$="I'm at the identification terminal. On the screen it says >> SHOW I.D. <<"
  tractorBeamOffMessage$="The tractor beam is off."
  tractorBeamOnMessage$="The tractor beam is on."
  flightDeckClosedMessage$="You forgot to open the flight deck doors."
  Return

END

' ===========================================
' GAME DATA TABLES
' ===========================================
' ROOM DATA (DIRECTION/ROOM)
DATA 2,0,0,0,0,3
DATA 0,0,1,0,0,0
DATA 18,0,4,0,1,0
DATA 3,5,4,4,0,0
DATA 4,6,5,4,0,0
DATA 7,0,8,5,0,0
DATA 0,0,6,0,0,0
DATA 6,10,0,9,0,12
DATA 11,8,0,0,0,0
DATA 0,14,0,8,0,0
DATA 0,0,9,0,0,0
DATA 15,13,0,0,8,0
DATA 15,0,0,12,27,0
DATA 0,0,0,10,0,0
DATA 0,0,13,12,0,0
DATA 17,0,18,0,0,0
DATA 0,0,16,0,0,0
DATA 16,25,3,19,0,0
DATA 20,18,21,20,22,0
DATA 19,23,21,20,22,24
DATA 20,0,0,0,0,0
DATA 22,22,22,22,22,20
DATA 0,0,0,20,0,0
DATA 0,0,0,0,20,0
DATA 0,26,0,18,0,0
DATA 0,0,0,25,0,0
DATA 28,27,27,27,27,13
DATA 29,29,29,29,30,29
DATA 28,29,29,29,29,27
DATA 29,29,28,29,29,31
DATA 32,33,34,35,0,0
DATA 0,0,31,0,0,0
DATA 0,0,0,31,0,0
DATA 31,0,0,0,0,0
DATA 36,31,0,0,0,0
DATA 0,0,35,0,37,0
DATA 0,0,14,0,0,36
' OBJECT DATA
DATA 11,5,0
DATA 12,5,5
DATA 13,7,0
DATA 14,9,0
DATA 15,9,0
DATA 16,29,20
DATA 17,9,0
DATA 18,10,20
DATA 21,14,5
DATA 22,15,0
DATA 23,7,0
DATA 24,17,5
DATA 25,17,0
DATA 26,0,20
DATA 27,9,20
DATA 28,17,20
DATA 29,24,20
DATA 31,17,0
DATA 32,26,30
DATA 33,3,0
DATA 34,35,0
DATA 35,34,50
DATA 37,7,0
