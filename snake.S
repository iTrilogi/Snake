.org $8000
.define AppleCol           #03    
.define TailPos            $04
.define MoveToPos          $05 
.define CleanerPos         $06
.define CleanerTail        $07 
.define GetRandom          $08
.define ApplePosition      $09


CheckIsPressed:
LDX $10
JMP Down

Start:

LDA CleanerPos
clc
ADC #24
STA CleanerPos

LDA $00
clc
ADC #24
STA $00

LDA ApplePosition
CLC
ADC #$8E
STA ApplePosition

Loop:
JSR Random

LDX ApplePosition 
LDA AppleCol
STA $0200,X

LDX $4000
CPX #00
BEQ CheckIsPressed
STX $10


Up: 
CPX #01
BNE Left
JSR PixelToCleanerPos
SBC #16
STA $00
TAX
LDA #00
CMP $0200,X
BNE Tail_Increment
LDX #01
JSR CleanerGotPixel
JSR PixelPlot
JMP CleaningPixel


Down:
CPX #02
BNE Up 
JSR PixelToCleanerPos
CLC
ADC #16
STA $00
TAX
LDA #00
CMP $0200,X
BNE Tail_Increment
LDX #01
JSR CleanerGotPixel
JSR PixelPlot
JMP CleaningPixel


Right:
CPX #08
BNE Loop
JSR PixelToCleanerPos
CLC
ADC #1
STA $00
TAX
LDA #00
CMP $0200,X
BNE Tail_Increment
LDX #01
JSR CleanerGotPixel
JSR PixelPlot
JMP CleaningPixel


Left: 
CPX #04
BNE Right
JSR PixelToCleanerPos
SBC #1
STA $00
TAX
LDA #00
CMP $0200,X
BNE Tail_Increment
LDX #01
JSR CleanerGotPixel
JSR PixelPlot
JMP CleaningPixel


Tail_Increment:
LDA #01
CMP $0200,X
BEQ GameOver
LDY #00 
INY
LDA #01
STA $0200,X
LDA #03
LDX GetRandom
STA $0200,X
STX ApplePosition 
JMP AppleCollision


AppleCollision:
LDA $02
CPY #0
BNE WrapTail
JMP Loop


WrapTail:
CLC
ADC #16
STA $02
LDA $03
ADC #01
STA $03
DEY
JMP AppleCollision

GameOver:
JMP GameOver


PixelPlot:
LDA #01
LDY $00 
STA $0200, Y
JSR Clear
RTS


Clear:
LDA #00
LDX CleanerPos
STA $0200,X
LDX #01
RTS

PixelToCleanerPos:
LDY TailPos 
TXA 
STA $0300,Y
LDA $00
INY
STY TailPos
RTS

CleanerGotPixel:
LDY MoveToPos 
LDA $0300,Y
STA CleanerTail
LDA #00
STA $0300,Y
INY
STY MoveToPos
RTS

CleaningPixel:
LDY CleanerTail
CPY #08
BEQ NextClean_right
CPY #04
BEQ NextClean_left
CPY #02
BEQ NextClean_down
CPY #01
BEQ NextClean_up
JMP Loop

NextClean_up:
LDA CleanerPos
SBC #16
STA CleanerPos
JMP Loop

NextClean_down:
LDA CleanerPos
CLC
ADC #16
STA CleanerPos
JMP Loop

NextClean_left:
LDA CleanerPos
SBC #1
STA CleanerPos
JMP Loop

NextClean_right:
LDA CleanerPos
CLC
ADC #1
STA CleanerPos
JMP Loop


Random:
LDA GetRandom
CLC
ADC CleanerTail
ADC TailPos
ADC MoveToPos
STA GetRandom
RTS


.goto $FFFA
.dw Start ; non maskable
.dw Start ; reset
.dw Start ; interrupt
