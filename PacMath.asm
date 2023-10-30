; PacMath - Organization and Architecture of Computers
; Gabriel Balbao Bazon
; Giovanna de Freitas Velasco

; ------ to run  -----------
; ./montador PacMath.asm PacMath.mif
; ./sim PacMath.mif charmapac.mif

jmp Main

; ------ vectors -----------
posF : var #1 ; current position of F
eatenX: var #1 ; number of x eaten

; youWin_message: string "Congratulations!!! You Won!"


; there is 321 x

Blocks: var #16

  static Blocks + #0, #3078
  static Blocks + #1, #3079
  static Blocks + #2, #3080
  static Blocks + #3, #3081
  static Blocks + #4, #3082
  static Blocks + #5, #3083
  static Blocks + #6, #3084
  static Blocks + #7, #3085
  static Blocks + #8, #3086
  static Blocks + #9, #3087
  static Blocks + #10, #3088
  static Blocks + #11, #3089
  static Blocks + #12, #3090
  static Blocks + #13, #3091
  static Blocks + #14, #3103 ; porta do i 
  static Blocks + #15, #3898 ; dois pontos em preto nos cantos


;posD1: var #1
;posD2: var #1
;posD3: var #1
;posD4: var #1

; ------ main function -----------
Main:
    call printScreen ; Print the labyrinth

    push r0
    push r3
    loadn r0, #938 ; the register 0 receives the initial position of F
    store posF, r0 ; we store the variable positionF with the position in r0
    loadn r3, #0;
    store eatenX, r3

    call PrintF
    jmp Verify_Key_Pressed
    pop r0;
    pop r3
    halt

; ------ moveF function -----------

MoveF: 
  push r2 ; a w s d to compare with r1 (inchar)

  loadn r2, #'a'
  cmp r2, r1
  jeq MoveF_Left

  loadn r2, #'w'
  cmp r2, r1
  jeq MoveF_Up

  loadn r2, #'s'
  cmp r2, r1
  jeq MoveF_Down

  loadn r2, #'d'
  cmp r2, r1
  jeq MoveF_Right

  pop r2

  halt ; return to main (line 28)
  
;-----------------------------

MoveF_Left:
  call Delay
  call Verify_Walls_Left

  call EraseF
  dec r0
  store posF, r0
  call Verify_x
  call PrintF
  push r2
  loadn r2, #255
  inchar r1
  cmp r1, r2
  jeq MoveF_Left

  jmp MoveF


Verify_Walls_Left:
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r1, #3867
  dec r0
  loadn r2, #Blocks ; local memory of the first block
  loadn r3, #0
  loadn r4, #16 ; size of the blocks vector

  loadn r6, #Screen
  
  add r7, r6, r0 ; acess the memory os the pixel on the screen
  loadi r7, r7 ; put the icon in the screen in the register
  inc r0

  Verify_Walls_Left_Loop:
    add r5, r2, r3
    loadi r5, r5

    cmp r5, r7 ; check if it is wall on the screen
      jeq Is_Wall
    cmp r1, r7
      ceq Teleport_F_Left

    inc r3
    cmp r3, r4
    jne Verify_Walls_Left_Loop

  pop r1
  pop r2
  pop r3
  pop r4
  pop r5
  pop r6
  pop r7

  rts

;-------------------------------------

MoveF_Right:
  call Delay
  call Verify_Walls_Right
  call EraseF
  inc r0
  store posF, r0
  call Verify_x
  call PrintF
  push r2
  loadn r2, #255
  inchar r1
  cmp r1, r2
  jeq MoveF_Right

  jmp MoveF


Verify_Walls_Right:
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r1, #3867
  inc r0
  loadn r2, #Blocks ; Local de memoria do primeiro bloco (ASCII)
  loadn r3, #0
  loadn r4, #16 ; Tamanho do vetor de blocos

  loadn r6, #Screen
  
  add r7, r6, r0 ; acess the memory os the pixel on the screen
  loadi r7, r7 ; put he icon in the screen in the register
  dec r0

  Verify_Walls_Right_Loop:
    add r5, r2, r3
    loadi r5, r5

    cmp r5, r7 ; check if it is a corner on the screen
      jeq Is_Wall
    cmp r1, r7
      ceq Teleport_F_Right

    inc r3
    cmp r3, r4
    jne Verify_Walls_Right_Loop

  pop r1
  pop r2
  pop r3
  pop r4
  pop r5
  pop r6
  pop r7

  rts

;--------------------------

MoveF_Up:
  call Delay
  call Verify_Walls_Up
  call EraseF 
  push r4
  loadn r4, #40
  sub r0, r0, r4
  store posF, r0
  call Verify_x
  call PrintF
  push r2
  loadn r2, #255
  inchar r1
  cmp r1, r2
  jeq MoveF_Up

  jmp MoveF


Verify_Walls_Up:
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r1, #40
  sub r0, r0, r1
  loadn r2, #Blocks ; Local de memoria do primeiro bloco (ASCII)
  loadn r3, #0
  loadn r4, #16 ; Tamanho do vetor de blocos

  loadn r6, #Screen
  
  add r7, r6, r0 ; acess the memory os the pixel on the screen
  loadi r7, r7 ; put he icon in the screen in the register
  add r0, r0, r1

  Verify_Walls_Up_Loop:
    add r5, r2, r3
    loadi r5, r5

    cmp r5, r7 ; check if it is a corner on the screen
      jeq Is_Wall

    inc r3
    cmp r3, r4
    jne Verify_Walls_Up_Loop

  pop r1
  pop r2
  pop r3
  pop r4
  pop r5
  pop r6
  pop r7

  rts

;-------------------------------

MoveF_Down:
  call Delay
  call Verify_Walls_Down
  call EraseF 
  push r4
  loadn r4, #40
  add r0, r0, r4
  store posF, r0
  call Verify_x
  call PrintF
  push r2
  loadn r2, #255
  inchar r1
  cmp r1, r2
  jeq MoveF_Down

  jmp MoveF


Verify_Walls_Down:
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r1, #40
  add r0, r0, r1
  loadn r2, #Blocks ; Local de memoria do primeiro bloco (ASCII)
  loadn r3, #0
  loadn r4, #16 ; Tamanho do vetor de blocos

  loadn r6, #Screen
  
  add r7, r6, r0 ; acess the memory os the pixel on the screen
  loadi r7, r7 ; put he icon in the screen in the register
  sub r0, r0, r1

  Verify_Walls_Down_Loop:
    add r5, r2, r3
    loadi r5, r5

    cmp r5, r7 ; check if it is a corner on the screen
      jeq Is_Wall

    inc r3
    cmp r3, r4
    jne Verify_Walls_Down_Loop

  pop r1
  pop r2
  pop r3
  pop r4
  pop r5
  pop r6
  pop r7

  rts
;----------- auxiliary moveF functions --------------

Teleport_F_Right:
  call EraseF
  loadn r0, #602
  rts

;---------------------------

Teleport_F_Left:
  call EraseF
  loadn r0, #638
  rts

;---------------------------
  
Is_Wall:
    pop r1
    pop r2
    pop r3
    pop r4
    pop r5
    pop r6
    pop r7

    jmp Verify_Key_Pressed

;-------------------------------------------

Verify_x:
  push r4
  push r5
  push r6

  loadn r4, #Screen
  loadn r6, #24
  
  add r5, r4, r0 ; acess the memory os the pixel on the screen
  loadi r5, r5 ; put the icon in the screen in the register
  cmp r5, r6
    ceq x_Eaten

  pop r4
  pop r5
  pop r6
  
  rts

;-------------------------------------------

x_Eaten:
  push r4
  push r3

  load r3, eatenX
  loadn r4, #319
  call Erase_x_and_sum
  inc r3
  store eatenX, r3
  cmp r4, r3
    jeq You_Won

  pop r4
  pop r3
  rts

;-------------------------------------------

Erase_x_and_sum:
  push r1
  push r2

  loadn r2, #Screen
  add r2, r2, r0

  loadn r1, #32
  storei r2, r1
  outchar r1, r0

  pop r1
  pop r2

  rts

;-------------------------------------------

You_Won:
  call PrintF

  halt

;-------------------------
Verify_Key_Pressed: ; receives the first key pressed with delay
  push r1
  push r2
  loadn r2, #255

  call Delay
  inchar r1
  cmp r1, r2
  jeq Verify_Key_Pressed
  
  jmp MoveF


;---------------------------

EraseF: ; Erase the F on the previous position
  push r1


  loadn r1, #32
  outchar r1, r0

  pop r1

  rts

;---------------------------

PrintF:
    push r1 ; has the position where the f will be draw
    push r2 ; has the code of f in the charmap
    
    load r1, posF 
    loadn r2, #2839
    outchar r2, r1 ; pritns the simbol in r1 on the position r0
    
    pop r2
    pop r1
    
    rts

;---------------------------

Delay: 
	push r0
	push r1
	
	loadn r1, #500  ; a
   Delay_loop2:
	loadn r0, #8000	; b
   Delay_loop: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  in a clock of 1MHz
	jnz Delay_loop	
	dec r1
	jnz Delay_loop2
	
	pop r1
	pop r0
	
	rts

;---------------------------


Screen : var #1200
  ;Line 0
  static Screen + #0, #3967
  static Screen + #1, #3967
  static Screen + #2, #3967
  static Screen + #3, #3455
  static Screen + #4, #3967
  static Screen + #5, #3967
  static Screen + #6, #3967
  static Screen + #7, #3199
  static Screen + #8, #127
  static Screen + #9, #3967
  static Screen + #10, #3967
  static Screen + #11, #3199
  static Screen + #12, #3199
  static Screen + #13, #2943
  static Screen + #14, #2943
  static Screen + #15, #2943
  static Screen + #16, #2943
  static Screen + #17, #2943
  static Screen + #18, #2943
  static Screen + #19, #2943
  static Screen + #20, #2943
  static Screen + #21, #2943
  static Screen + #22, #2943
  static Screen + #23, #2943
  static Screen + #24, #2943
  static Screen + #25, #2943
  static Screen + #26, #2943
  static Screen + #27, #3967
  static Screen + #28, #3967
  static Screen + #29, #3967
  static Screen + #30, #3967
  static Screen + #31, #3967
  static Screen + #32, #127
  static Screen + #33, #127
  static Screen + #34, #3967
  static Screen + #35, #3967
  static Screen + #36, #3967
  static Screen + #37, #127
  static Screen + #38, #2943
  static Screen + #39, #3967

  ;Line 1
  static Screen + #40, #3967
  static Screen + #41, #3967
  static Screen + #42, #2943
  static Screen + #43, #3455
  static Screen + #44, #3455
  static Screen + #45, #3455
  static Screen + #46, #3455
  static Screen + #47, #3455
  static Screen + #48, #3455
  static Screen + #49, #127
  static Screen + #50, #127
  static Screen + #51, #127
  static Screen + #52, #127
  static Screen + #53, #2943
  static Screen + #54, #2943
  static Screen + #55, #2842
  static Screen + #56, #2896
  static Screen + #57, #2881
  static Screen + #58, #2883
  static Screen + #59, #2943
  static Screen + #60, #2893
  static Screen + #61, #2845
  static Screen + #62, #2900
  static Screen + #63, #2888
  static Screen + #64, #2842
  static Screen + #65, #2943
  static Screen + #66, #2943
  static Screen + #67, #3967
  static Screen + #68, #3967
  static Screen + #69, #3967
  static Screen + #70, #3967
  static Screen + #71, #3967
  static Screen + #72, #127
  static Screen + #73, #127
  static Screen + #74, #127
  static Screen + #75, #127
  static Screen + #76, #127
  static Screen + #77, #2943
  static Screen + #78, #3967
  static Screen + #79, #3967

  ;Line 2
  static Screen + #80, #3967
  static Screen + #81, #3199
  static Screen + #82, #2943
  static Screen + #83, #2943
  static Screen + #84, #2943
  static Screen + #85, #2943
  static Screen + #86, #2943
  static Screen + #87, #2943
  static Screen + #88, #2943
  static Screen + #89, #2943
  static Screen + #90, #2943
  static Screen + #91, #2943
  static Screen + #92, #2943
  static Screen + #93, #2943
  static Screen + #94, #2943
  static Screen + #95, #2943
  static Screen + #96, #2943
  static Screen + #97, #2943
  static Screen + #98, #2943
  static Screen + #99, #2943
  static Screen + #100, #2943
  static Screen + #101, #2943
  static Screen + #102, #2943
  static Screen + #103, #2943
  static Screen + #104, #2943
  static Screen + #105, #2943
  static Screen + #106, #2943
  static Screen + #107, #2943
  static Screen + #108, #2943
  static Screen + #109, #3199
  static Screen + #110, #2839
  static Screen + #111, #2839
  static Screen + #112, #2839
  static Screen + #113, #2943
  static Screen + #114, #2943
  static Screen + #115, #2943
  static Screen + #116, #2943
  static Screen + #117, #3199
  static Screen + #118, #3199
  static Screen + #119, #3199

  ;Line 3
  static Screen + #120, #3967
  static Screen + #121, #3078
  static Screen + #122, #3079
  static Screen + #123, #3079
  static Screen + #124, #3079
  static Screen + #125, #3079
  static Screen + #126, #3079
  static Screen + #127, #3079
  static Screen + #128, #3079
  static Screen + #129, #3079
  static Screen + #130, #3079
  static Screen + #131, #3079
  static Screen + #132, #3079
  static Screen + #133, #3079
  static Screen + #134, #3080
  static Screen + #135, #1919
  static Screen + #136, #1919
  static Screen + #137, #1919
  static Screen + #138, #1919
  static Screen + #139, #1919
  static Screen + #140, #1919
  static Screen + #141, #1919
  static Screen + #142, #1919
  static Screen + #143, #1919
  static Screen + #144, #1919
  static Screen + #145, #3078
  static Screen + #146, #3079
  static Screen + #147, #3079
  static Screen + #148, #3079
  static Screen + #149, #3079
  static Screen + #150, #3079
  static Screen + #151, #3079
  static Screen + #152, #3079
  static Screen + #153, #3079
  static Screen + #154, #3079
  static Screen + #155, #3079
  static Screen + #156, #3079
  static Screen + #157, #3079
  static Screen + #158, #3080
  static Screen + #159, #3199

  ;Line 4
  static Screen + #160, #3967
  static Screen + #161, #3081
  static Screen + #162, #2329
  static Screen + #163, #24
  static Screen + #164, #24
  static Screen + #165, #24
  static Screen + #166, #24
  static Screen + #167, #24
  static Screen + #168, #24
  static Screen + #169, #24
  static Screen + #170, #24
  static Screen + #171, #24
  static Screen + #172, #24
  static Screen + #173, #24
  static Screen + #174, #3082
  static Screen + #175, #3079
  static Screen + #176, #3079
  static Screen + #177, #3079
  static Screen + #178, #3079
  static Screen + #179, #3079
  static Screen + #180, #3079
  static Screen + #181, #3079
  static Screen + #182, #3079
  static Screen + #183, #3079
  static Screen + #184, #3079
  static Screen + #185, #3083
  static Screen + #186, #24
  static Screen + #187, #24
  static Screen + #188, #24
  static Screen + #189, #24
  static Screen + #190, #24
  static Screen + #191, #24
  static Screen + #192, #24
  static Screen + #193, #24
  static Screen + #194, #24
  static Screen + #195, #24
  static Screen + #196, #24
  static Screen + #197, #2329
  static Screen + #198, #3081
  static Screen + #199, #3199

  ;Line 5
  static Screen + #200, #3967
  static Screen + #201, #3081
  static Screen + #202, #24
  static Screen + #203, #3090
  static Screen + #204, #3079
  static Screen + #205, #3079
  static Screen + #206, #3079
  static Screen + #207, #3087
  static Screen + #208, #3091
  static Screen + #209, #24
  static Screen + #210, #3078
  static Screen + #211, #3079
  static Screen + #212, #3080
  static Screen + #213, #24
  static Screen + #214, #24
  static Screen + #215, #24
  static Screen + #216, #1816
  static Screen + #217, #1816
  static Screen + #218, #1816
  static Screen + #219, #1816
  static Screen + #220, #24
  static Screen + #221, #24
  static Screen + #222, #24
  static Screen + #223, #24
  static Screen + #224, #24
  static Screen + #225, #24
  static Screen + #226, #24
  static Screen + #227, #3090
  static Screen + #228, #3080
  static Screen + #229, #24
  static Screen + #230, #3090
  static Screen + #231, #3079
  static Screen + #232, #3087
  static Screen + #233, #3079
  static Screen + #234, #3079
  static Screen + #235, #3079
  static Screen + #236, #3091
  static Screen + #237, #24
  static Screen + #238, #3081
  static Screen + #239, #3967

  ;Line 6
  static Screen + #240, #3967
  static Screen + #241, #3081
  static Screen + #242, #24
  static Screen + #243, #24
  static Screen + #244, #24
  static Screen + #245, #24
  static Screen + #246, #24
  static Screen + #247, #3081
  static Screen + #248, #24
  static Screen + #249, #24
  static Screen + #250, #3081
  static Screen + #251, #24
  static Screen + #252, #3088
  static Screen + #253, #24
  static Screen + #254, #3090
  static Screen + #255, #3079
  static Screen + #256, #3079
  static Screen + #257, #3091
  static Screen + #258, #24
  static Screen + #259, #3089
  static Screen + #260, #24
  static Screen + #261, #3090
  static Screen + #262, #3079
  static Screen + #263, #3080
  static Screen + #264, #24
  static Screen + #265, #3089
  static Screen + #266, #24
  static Screen + #267, #24
  static Screen + #268, #3081
  static Screen + #269, #24
  static Screen + #270, #24
  static Screen + #271, #24
  static Screen + #272, #3081
  static Screen + #273, #24
  static Screen + #274, #24
  static Screen + #275, #24
  static Screen + #276, #24
  static Screen + #277, #24
  static Screen + #278, #3081
  static Screen + #279, #3967

  ;Line 7
  static Screen + #280, #3967
  static Screen + #281, #3085
  static Screen + #282, #3079
  static Screen + #283, #3091
  static Screen + #284, #24
  static Screen + #285, #3089
  static Screen + #286, #24
  static Screen + #287, #3088
  static Screen + #288, #24
  static Screen + #289, #3090
  static Screen + #290, #3083
  static Screen + #291, #24
  static Screen + #292, #24
  static Screen + #293, #24
  static Screen + #294, #24
  static Screen + #295, #24
  static Screen + #296, #24
  static Screen + #297, #24
  static Screen + #298, #24
  static Screen + #299, #3081
  static Screen + #300, #24
  static Screen + #301, #24
  static Screen + #302, #24
  static Screen + #303, #3088
  static Screen + #304, #24
  static Screen + #305, #3082
  static Screen + #306, #3079
  static Screen + #307, #3079
  static Screen + #308, #3084
  static Screen + #309, #3079
  static Screen + #310, #3091
  static Screen + #311, #24
  static Screen + #312, #3088
  static Screen + #313, #24
  static Screen + #314, #3089
  static Screen + #315, #24
  static Screen + #316, #3090
  static Screen + #317, #3079
  static Screen + #318, #3086
  static Screen + #319, #3967

  ;Line 8
  static Screen + #320, #3967
  static Screen + #321, #3081
  static Screen + #322, #24
  static Screen + #323, #24
  static Screen + #324, #24
  static Screen + #325, #3081
  static Screen + #326, #24
  static Screen + #327, #24
  static Screen + #328, #24
  static Screen + #329, #24
  static Screen + #330, #24
  static Screen + #331, #24
  static Screen + #332, #3078
  static Screen + #333, #3079
  static Screen + #334, #3103
  static Screen + #335, #3103
  static Screen + #336, #3079
  static Screen + #337, #3080
  static Screen + #338, #24
  static Screen + #339, #3082
  static Screen + #340, #3079
  static Screen + #341, #3091
  static Screen + #342, #24
  static Screen + #343, #24
  static Screen + #344, #24
  static Screen + #345, #24
  static Screen + #346, #24
  static Screen + #347, #24
  static Screen + #348, #24
  static Screen + #349, #24
  static Screen + #350, #24
  static Screen + #351, #24
  static Screen + #352, #24
  static Screen + #353, #24
  static Screen + #354, #3081
  static Screen + #355, #24
  static Screen + #356, #24
  static Screen + #357, #24
  static Screen + #358, #3081
  static Screen + #359, #3967

  ;Line 9
  static Screen + #360, #3967
  static Screen + #361, #3081
  static Screen + #362, #24
  static Screen + #363, #3090
  static Screen + #364, #3079
  static Screen + #365, #3083
  static Screen + #366, #24
  static Screen + #367, #3078
  static Screen + #368, #3079
  static Screen + #369, #3079
  static Screen + #370, #3080
  static Screen + #371, #24
  static Screen + #372, #3081
  static Screen + #373, #3864
  static Screen + #374, #533
  static Screen + #375, #2325
  static Screen + #376, #3852
  static Screen + #377, #3081
  static Screen + #378, #24
  static Screen + #379, #24
  static Screen + #380, #24
  static Screen + #381, #24
  static Screen + #382, #24
  static Screen + #383, #24
  static Screen + #384, #3078
  static Screen + #385, #3079
  static Screen + #386, #3080
  static Screen + #387, #1816
  static Screen + #388, #3078
  static Screen + #389, #3079
  static Screen + #390, #3079
  static Screen + #391, #3079
  static Screen + #392, #3080
  static Screen + #393, #24
  static Screen + #394, #3082
  static Screen + #395, #3079
  static Screen + #396, #3091
  static Screen + #397, #24
  static Screen + #398, #3081
  static Screen + #399, #3967

  ;Line 10
  static Screen + #400, #3967
  static Screen + #401, #3081
  static Screen + #402, #24
  static Screen + #403, #24
  static Screen + #404, #24
  static Screen + #405, #24
  static Screen + #406, #24
  static Screen + #407, #3081
  static Screen + #408, #3199
  static Screen + #409, #3199
  static Screen + #410, #3081
  static Screen + #411, #24
  static Screen + #412, #3081
  static Screen + #413, #3848
  static Screen + #414, #3349
  static Screen + #415, #1557
  static Screen + #416, #3848
  static Screen + #417, #3081
  static Screen + #418, #24
  static Screen + #419, #3078
  static Screen + #420, #3079
  static Screen + #421, #3079
  static Screen + #422, #3080
  static Screen + #423, #24
  static Screen + #424, #3082
  static Screen + #425, #3079
  static Screen + #426, #3083
  static Screen + #427, #1816
  static Screen + #428, #3082
  static Screen + #429, #3079
  static Screen + #430, #3079
  static Screen + #431, #3079
  static Screen + #432, #3083
  static Screen + #433, #24
  static Screen + #434, #1816
  static Screen + #435, #1816
  static Screen + #436, #24
  static Screen + #437, #1816
  static Screen + #438, #3081
  static Screen + #439, #3967

  ;Line 11
  static Screen + #440, #3967
  static Screen + #441, #3082
  static Screen + #442, #3079
  static Screen + #443, #3079
  static Screen + #444, #3079
  static Screen + #445, #3080
  static Screen + #446, #24
  static Screen + #447, #3081
  static Screen + #448, #3199
  static Screen + #449, #3199
  static Screen + #450, #3081
  static Screen + #451, #24
  static Screen + #452, #3082
  static Screen + #453, #3079
  static Screen + #454, #3079
  static Screen + #455, #3079
  static Screen + #456, #3079
  static Screen + #457, #3083
  static Screen + #458, #24
  static Screen + #459, #3081
  static Screen + #460, #3199
  static Screen + #461, #3199
  static Screen + #462, #3081
  static Screen + #463, #24
  static Screen + #464, #24
  static Screen + #465, #24
  static Screen + #466, #24
  static Screen + #467, #24
  static Screen + #468, #24
  static Screen + #469, #24
  static Screen + #470, #24
  static Screen + #471, #24
  static Screen + #472, #24
  static Screen + #473, #24
  static Screen + #474, #3078
  static Screen + #475, #3079
  static Screen + #476, #3079
  static Screen + #477, #3079
  static Screen + #478, #3083
  static Screen + #479, #3967

  ;Line 12
  static Screen + #480, #3967
  static Screen + #481, #3199
  static Screen + #482, #3199
  static Screen + #483, #3199
  static Screen + #484, #3199
  static Screen + #485, #3081
  static Screen + #486, #24
  static Screen + #487, #3081
  static Screen + #488, #3199
  static Screen + #489, #3199
  static Screen + #490, #3081
  static Screen + #491, #24
  static Screen + #492, #24
  static Screen + #493, #24
  static Screen + #494, #24
  static Screen + #495, #24
  static Screen + #496, #24
  static Screen + #497, #24
  static Screen + #498, #24
  static Screen + #499, #3081
  static Screen + #500, #3199
  static Screen + #501, #3199
  static Screen + #502, #3082
  static Screen + #503, #3079
  static Screen + #504, #3079
  static Screen + #505, #3079
  static Screen + #506, #3079
  static Screen + #507, #3079
  static Screen + #508, #3079
  static Screen + #509, #3079
  static Screen + #510, #3079
  static Screen + #511, #3079
  static Screen + #512, #3080
  static Screen + #513, #24
  static Screen + #514, #3081
  static Screen + #515, #127
  static Screen + #516, #127
  static Screen + #517, #127
  static Screen + #518, #127
  static Screen + #519, #127

  ;Line 13
  static Screen + #520, #3967
  static Screen + #521, #3199
  static Screen + #522, #3199
  static Screen + #523, #3199
  static Screen + #524, #127
  static Screen + #525, #3081
  static Screen + #526, #24
  static Screen + #527, #3081
  static Screen + #528, #3967
  static Screen + #529, #3199
  static Screen + #530, #3081
  static Screen + #531, #24
  static Screen + #532, #3089
  static Screen + #533, #24
  static Screen + #534, #3078
  static Screen + #535, #3079
  static Screen + #536, #3079
  static Screen + #537, #3080
  static Screen + #538, #24
  static Screen + #539, #3081
  static Screen + #540, #3199
  static Screen + #541, #2943
  static Screen + #542, #2943
  static Screen + #543, #3199
  static Screen + #544, #3199
  static Screen + #545, #3967
  static Screen + #546, #3967
  static Screen + #547, #3967
  static Screen + #548, #3967
  static Screen + #549, #3967
  static Screen + #550, #3967
  static Screen + #551, #3199
  static Screen + #552, #3081
  static Screen + #553, #24
  static Screen + #554, #3081
  static Screen + #555, #127
  static Screen + #556, #127
  static Screen + #557, #127
  static Screen + #558, #127
  static Screen + #559, #127

  ;Line 14
  static Screen + #560, #127
  static Screen + #561, #3898
  static Screen + #562, #3079
  static Screen + #563, #3079
  static Screen + #564, #3079
  static Screen + #565, #3083
  static Screen + #566, #24
  static Screen + #567, #3081
  static Screen + #568, #3967
  static Screen + #569, #3199
  static Screen + #570, #3081
  static Screen + #571, #24
  static Screen + #572, #3081
  static Screen + #573, #24
  static Screen + #574, #3081
  static Screen + #575, #3199
  static Screen + #576, #3199
  static Screen + #577, #3081
  static Screen + #578, #24
  static Screen + #579, #3081
  static Screen + #580, #3199
  static Screen + #581, #3199
  static Screen + #582, #3199
  static Screen + #583, #3199
  static Screen + #584, #3199
  static Screen + #585, #3199
  static Screen + #586, #3199
  static Screen + #587, #3199
  static Screen + #588, #3199
  static Screen + #589, #3199
  static Screen + #590, #3199
  static Screen + #591, #3199
  static Screen + #592, #3081
  static Screen + #593, #24
  static Screen + #594, #3082
  static Screen + #595, #3079
  static Screen + #596, #3079
  static Screen + #597, #3079
  static Screen + #598, #3898
  static Screen + #599, #127

  ;Line 15
  static Screen + #600, #127
  static Screen + #601, #3898
  static Screen + #602, #3867
  static Screen + #603, #24
  static Screen + #604, #24
  static Screen + #605, #24
  static Screen + #606, #24
  static Screen + #607, #3081
  static Screen + #608, #3967
  static Screen + #609, #3199
  static Screen + #610, #3081
  static Screen + #611, #24
  static Screen + #612, #3081
  static Screen + #613, #24
  static Screen + #614, #3081
  static Screen + #615, #3199
  static Screen + #616, #3199
  static Screen + #617, #3081
  static Screen + #618, #24
  static Screen + #619, #3081
  static Screen + #620, #3199
  static Screen + #621, #3199
  static Screen + #622, #3078
  static Screen + #623, #3079
  static Screen + #624, #3080
  static Screen + #625, #3199
  static Screen + #626, #3199
  static Screen + #627, #3078
  static Screen + #628, #3079
  static Screen + #629, #3080
  static Screen + #630, #3199
  static Screen + #631, #3199
  static Screen + #632, #3081
  static Screen + #633, #24
  static Screen + #634, #24
  static Screen + #635, #24
  static Screen + #636, #24
  static Screen + #637, #3867
  static Screen + #638, #3898
  static Screen + #639, #127

  ;Line 16
  static Screen + #640, #127
  static Screen + #641, #3898
  static Screen + #642, #3079
  static Screen + #643, #3079
  static Screen + #644, #3079
  static Screen + #645, #3080
  static Screen + #646, #24
  static Screen + #647, #3081
  static Screen + #648, #3967
  static Screen + #649, #3967
  static Screen + #650, #3081
  static Screen + #651, #24
  static Screen + #652, #3081
  static Screen + #653, #24
  static Screen + #654, #3081
  static Screen + #655, #3199
  static Screen + #656, #3199
  static Screen + #657, #3081
  static Screen + #658, #24
  static Screen + #659, #3081
  static Screen + #660, #3199
  static Screen + #661, #3199
  static Screen + #662, #3081
  static Screen + #663, #2329
  static Screen + #664, #3081
  static Screen + #665, #3199
  static Screen + #666, #3199
  static Screen + #667, #3081
  static Screen + #668, #24
  static Screen + #669, #3081
  static Screen + #670, #3199
  static Screen + #671, #3199
  static Screen + #672, #3081
  static Screen + #673, #24
  static Screen + #674, #3078
  static Screen + #675, #3079
  static Screen + #676, #3079
  static Screen + #677, #3079
  static Screen + #678, #3898
  static Screen + #679, #127

  ;Line 17
  static Screen + #680, #3967
  static Screen + #681, #3199
  static Screen + #682, #3199
  static Screen + #683, #3199
  static Screen + #684, #3199
  static Screen + #685, #3081
  static Screen + #686, #24
  static Screen + #687, #3081
  static Screen + #688, #3199
  static Screen + #689, #3967
  static Screen + #690, #3081
  static Screen + #691, #24
  static Screen + #692, #3088
  static Screen + #693, #24
  static Screen + #694, #3081
  static Screen + #695, #3199
  static Screen + #696, #3199
  static Screen + #697, #3081
  static Screen + #698, #24
  static Screen + #699, #3081
  static Screen + #700, #3199
  static Screen + #701, #3199
  static Screen + #702, #3081
  static Screen + #703, #24
  static Screen + #704, #3081
  static Screen + #705, #3199
  static Screen + #706, #3199
  static Screen + #707, #3081
  static Screen + #708, #24
  static Screen + #709, #3081
  static Screen + #710, #3199
  static Screen + #711, #3199
  static Screen + #712, #3081
  static Screen + #713, #24
  static Screen + #714, #3081
  static Screen + #715, #127
  static Screen + #716, #127
  static Screen + #717, #127
  static Screen + #718, #127
  static Screen + #719, #127

  ;Line 18
  static Screen + #720, #3199
  static Screen + #721, #3199
  static Screen + #722, #3199
  static Screen + #723, #3199
  static Screen + #724, #3199
  static Screen + #725, #3081
  static Screen + #726, #24
  static Screen + #727, #3081
  static Screen + #728, #3199
  static Screen + #729, #3967
  static Screen + #730, #3081
  static Screen + #731, #2329
  static Screen + #732, #24
  static Screen + #733, #24
  static Screen + #734, #3081
  static Screen + #735, #3199
  static Screen + #736, #3199
  static Screen + #737, #3081
  static Screen + #738, #24
  static Screen + #739, #3081
  static Screen + #740, #3199
  static Screen + #741, #3199
  static Screen + #742, #3081
  static Screen + #743, #24
  static Screen + #744, #3081
  static Screen + #745, #3199
  static Screen + #746, #3199
  static Screen + #747, #3081
  static Screen + #748, #24
  static Screen + #749, #3081
  static Screen + #750, #3199
  static Screen + #751, #3199
  static Screen + #752, #3081
  static Screen + #753, #24
  static Screen + #754, #3081
  static Screen + #755, #3199
  static Screen + #756, #127
  static Screen + #757, #127
  static Screen + #758, #127
  static Screen + #759, #3967

  ;Line 19
  static Screen + #760, #3967
  static Screen + #761, #3078
  static Screen + #762, #3079
  static Screen + #763, #3079
  static Screen + #764, #3079
  static Screen + #765, #3083
  static Screen + #766, #24
  static Screen + #767, #3081
  static Screen + #768, #3967
  static Screen + #769, #3967
  static Screen + #770, #3082
  static Screen + #771, #3079
  static Screen + #772, #3080
  static Screen + #773, #24
  static Screen + #774, #3081
  static Screen + #775, #3199
  static Screen + #776, #3199
  static Screen + #777, #3081
  static Screen + #778, #24
  static Screen + #779, #3081
  static Screen + #780, #3199
  static Screen + #781, #3199
  static Screen + #782, #3081
  static Screen + #783, #24
  static Screen + #784, #3081
  static Screen + #785, #3199
  static Screen + #786, #3199
  static Screen + #787, #3081
  static Screen + #788, #24
  static Screen + #789, #3081
  static Screen + #790, #3199
  static Screen + #791, #3199
  static Screen + #792, #3081
  static Screen + #793, #24
  static Screen + #794, #3082
  static Screen + #795, #3079
  static Screen + #796, #3079
  static Screen + #797, #3079
  static Screen + #798, #3080
  static Screen + #799, #3967

  ;Line 20
  static Screen + #800, #3967
  static Screen + #801, #3081
  static Screen + #802, #24
  static Screen + #803, #24
  static Screen + #804, #24
  static Screen + #805, #24
  static Screen + #806, #24
  static Screen + #807, #3081
  static Screen + #808, #3967
  static Screen + #809, #3967
  static Screen + #810, #3967
  static Screen + #811, #3967
  static Screen + #812, #3081
  static Screen + #813, #24
  static Screen + #814, #3081
  static Screen + #815, #3199
  static Screen + #816, #3199
  static Screen + #817, #3081
  static Screen + #818, #24
  static Screen + #819, #3081
  static Screen + #820, #3199
  static Screen + #821, #3199
  static Screen + #822, #3081
  static Screen + #823, #24
  static Screen + #824, #3081
  static Screen + #825, #3199
  static Screen + #826, #3199
  static Screen + #827, #3081
  static Screen + #828, #24
  static Screen + #829, #3081
  static Screen + #830, #3199
  static Screen + #831, #3199
  static Screen + #832, #3081
  static Screen + #833, #24
  static Screen + #834, #1816
  static Screen + #835, #1816
  static Screen + #836, #1816
  static Screen + #837, #1816
  static Screen + #838, #3081
  static Screen + #839, #3967

  ;Line 21
  static Screen + #840, #3967
  static Screen + #841, #3081
  static Screen + #842, #24
  static Screen + #843, #3090
  static Screen + #844, #3079
  static Screen + #845, #3080
  static Screen + #846, #24
  static Screen + #847, #3081
  static Screen + #848, #3967
  static Screen + #849, #3967
  static Screen + #850, #3967
  static Screen + #851, #3967
  static Screen + #852, #3081
  static Screen + #853, #24
  static Screen + #854, #3081
  static Screen + #855, #3199
  static Screen + #856, #3199
  static Screen + #857, #3081
  static Screen + #858, #24
  static Screen + #859, #3081
  static Screen + #860, #3199
  static Screen + #861, #3199
  static Screen + #862, #3081
  static Screen + #863, #24
  static Screen + #864, #3081
  static Screen + #865, #3199
  static Screen + #866, #3199
  static Screen + #867, #3081
  static Screen + #868, #24
  static Screen + #869, #3081
  static Screen + #870, #3199
  static Screen + #871, #3199
  static Screen + #872, #3081
  static Screen + #873, #24
  static Screen + #874, #3078
  static Screen + #875, #3079
  static Screen + #876, #3091
  static Screen + #877, #24
  static Screen + #878, #3081
  static Screen + #879, #3967

  ;Line 22
  static Screen + #880, #3967
  static Screen + #881, #3081
  static Screen + #882, #24
  static Screen + #883, #24
  static Screen + #884, #24
  static Screen + #885, #3081
  static Screen + #886, #24
  static Screen + #887, #3082
  static Screen + #888, #3079
  static Screen + #889, #3079
  static Screen + #890, #3079
  static Screen + #891, #3079
  static Screen + #892, #3083
  static Screen + #893, #24
  static Screen + #894, #3082
  static Screen + #895, #3079
  static Screen + #896, #3079
  static Screen + #897, #3083
  static Screen + #898, #24
  static Screen + #899, #3082
  static Screen + #900, #3079
  static Screen + #901, #3079
  static Screen + #902, #3083
  static Screen + #903, #24
  static Screen + #904, #3082
  static Screen + #905, #3079
  static Screen + #906, #3079
  static Screen + #907, #3083
  static Screen + #908, #1816
  static Screen + #909, #3082
  static Screen + #910, #3079
  static Screen + #911, #3079
  static Screen + #912, #3083
  static Screen + #913, #24
  static Screen + #914, #3081
  static Screen + #915, #24
  static Screen + #916, #24
  static Screen + #917, #24
  static Screen + #918, #3081
  static Screen + #919, #3967

  ;Line 23
  static Screen + #920, #3967
  static Screen + #921, #3085
  static Screen + #922, #3079
  static Screen + #923, #3091
  static Screen + #924, #24
  static Screen + #925, #3081
  static Screen + #926, #24
  static Screen + #927, #24
  static Screen + #928, #24
  static Screen + #929, #24
  static Screen + #930, #24
  static Screen + #931, #24
  static Screen + #932, #24
  static Screen + #933, #24
  static Screen + #934, #24
  static Screen + #935, #24
  static Screen + #936, #24
  static Screen + #937, #24
  static Screen + #938, #2943
  static Screen + #939, #24
  static Screen + #940, #24
  static Screen + #941, #1816
  static Screen + #942, #1816
  static Screen + #943, #1816
  static Screen + #944, #1816
  static Screen + #945, #1816
  static Screen + #946, #24
  static Screen + #947, #24
  static Screen + #948, #24
  static Screen + #949, #24
  static Screen + #950, #24
  static Screen + #951, #24
  static Screen + #952, #24
  static Screen + #953, #24
  static Screen + #954, #3081
  static Screen + #955, #24
  static Screen + #956, #3090
  static Screen + #957, #3079
  static Screen + #958, #3086
  static Screen + #959, #3967

  ;Line 24
  static Screen + #960, #3967
  static Screen + #961, #3081
  static Screen + #962, #24
  static Screen + #963, #24
  static Screen + #964, #24
  static Screen + #965, #3088
  static Screen + #966, #24
  static Screen + #967, #3089
  static Screen + #968, #24
  static Screen + #969, #3090
  static Screen + #970, #3079
  static Screen + #971, #3080
  static Screen + #972, #24
  static Screen + #973, #3078
  static Screen + #974, #3079
  static Screen + #975, #3080
  static Screen + #976, #24
  static Screen + #977, #3078
  static Screen + #978, #3079
  static Screen + #979, #3079
  static Screen + #980, #3079
  static Screen + #981, #3079
  static Screen + #982, #3080
  static Screen + #983, #24
  static Screen + #984, #3078
  static Screen + #985, #3079
  static Screen + #986, #3079
  static Screen + #987, #3080
  static Screen + #988, #24
  static Screen + #989, #3078
  static Screen + #990, #3091
  static Screen + #991, #24
  static Screen + #992, #3089
  static Screen + #993, #24
  static Screen + #994, #3088
  static Screen + #995, #24
  static Screen + #996, #24
  static Screen + #997, #24
  static Screen + #998, #3081
  static Screen + #999, #3967

  ;Line 25
  static Screen + #1000, #3967
  static Screen + #1001, #3081
  static Screen + #1002, #24
  static Screen + #1003, #3089
  static Screen + #1004, #24
  static Screen + #1005, #24
  static Screen + #1006, #24
  static Screen + #1007, #3081
  static Screen + #1008, #24
  static Screen + #1009, #24
  static Screen + #1010, #24
  static Screen + #1011, #3081
  static Screen + #1012, #24
  static Screen + #1013, #3081
  static Screen + #1014, #2904
  static Screen + #1015, #3081
  static Screen + #1016, #24
  static Screen + #1017, #3081
  static Screen + #1018, #2836
  static Screen + #1019, #2836
  static Screen + #1020, #2836
  static Screen + #1021, #2878
  static Screen + #1022, #3081
  static Screen + #1023, #24
  static Screen + #1024, #3081
  static Screen + #1025, #2844
  static Screen + #1026, #2844
  static Screen + #1027, #3081
  static Screen + #1028, #24
  static Screen + #1029, #3081
  static Screen + #1030, #24
  static Screen + #1031, #24
  static Screen + #1032, #3081
  static Screen + #1033, #24
  static Screen + #1034, #24
  static Screen + #1035, #24
  static Screen + #1036, #3089
  static Screen + #1037, #24
  static Screen + #1038, #3081
  static Screen + #1039, #3967

  ;Line 26
  static Screen + #1040, #3967
  static Screen + #1041, #3081
  static Screen + #1042, #24
  static Screen + #1043, #3082
  static Screen + #1044, #3079
  static Screen + #1045, #3079
  static Screen + #1046, #3079
  static Screen + #1047, #3084
  static Screen + #1048, #3079
  static Screen + #1049, #3091
  static Screen + #1050, #24
  static Screen + #1051, #3088
  static Screen + #1052, #24
  static Screen + #1053, #3082
  static Screen + #1054, #3079
  static Screen + #1055, #3083
  static Screen + #1056, #24
  static Screen + #1057, #3082
  static Screen + #1058, #3079
  static Screen + #1059, #3079
  static Screen + #1060, #3079
  static Screen + #1061, #3079
  static Screen + #1062, #3083
  static Screen + #1063, #24
  static Screen + #1064, #3082
  static Screen + #1065, #3079
  static Screen + #1066, #3079
  static Screen + #1067, #3083
  static Screen + #1068, #24
  static Screen + #1069, #3088
  static Screen + #1070, #24
  static Screen + #1071, #3090
  static Screen + #1072, #3084
  static Screen + #1073, #3079
  static Screen + #1074, #3079
  static Screen + #1075, #3079
  static Screen + #1076, #3083
  static Screen + #1077, #24
  static Screen + #1078, #3081
  static Screen + #1079, #3967

  ;Line 27
  static Screen + #1080, #3967
  static Screen + #1081, #3081
  static Screen + #1082, #2329
  static Screen + #1083, #24
  static Screen + #1084, #24
  static Screen + #1085, #24
  static Screen + #1086, #24
  static Screen + #1087, #24
  static Screen + #1088, #24
  static Screen + #1089, #24
  static Screen + #1090, #24
  static Screen + #1091, #24
  static Screen + #1092, #24
  static Screen + #1093, #24
  static Screen + #1094, #24
  static Screen + #1095, #24
  static Screen + #1096, #24
  static Screen + #1097, #24
  static Screen + #1098, #24
  static Screen + #1099, #24
  static Screen + #1100, #24
  static Screen + #1101, #24
  static Screen + #1102, #24
  static Screen + #1103, #24
  static Screen + #1104, #24
  static Screen + #1105, #24
  static Screen + #1106, #24
  static Screen + #1107, #24
  static Screen + #1108, #24
  static Screen + #1109, #24
  static Screen + #1110, #24
  static Screen + #1111, #24
  static Screen + #1112, #24
  static Screen + #1113, #24
  static Screen + #1114, #24
  static Screen + #1115, #24
  static Screen + #1116, #24
  static Screen + #1117, #2329
  static Screen + #1118, #3081
  static Screen + #1119, #3967

  ;Line 28
  static Screen + #1120, #3967
  static Screen + #1121, #3082
  static Screen + #1122, #3079
  static Screen + #1123, #3079
  static Screen + #1124, #3079
  static Screen + #1125, #3079
  static Screen + #1126, #3079
  static Screen + #1127, #3079
  static Screen + #1128, #3079
  static Screen + #1129, #3079
  static Screen + #1130, #3079
  static Screen + #1131, #3079
  static Screen + #1132, #3079
  static Screen + #1133, #3079
  static Screen + #1134, #3079
  static Screen + #1135, #3079
  static Screen + #1136, #3079
  static Screen + #1137, #3079
  static Screen + #1138, #3079
  static Screen + #1139, #3079
  static Screen + #1140, #3079
  static Screen + #1141, #3079
  static Screen + #1142, #3079
  static Screen + #1143, #3079
  static Screen + #1144, #3079
  static Screen + #1145, #3079
  static Screen + #1146, #3079
  static Screen + #1147, #3079
  static Screen + #1148, #3079
  static Screen + #1149, #3079
  static Screen + #1150, #3079
  static Screen + #1151, #3079
  static Screen + #1152, #3079
  static Screen + #1153, #3079
  static Screen + #1154, #3079
  static Screen + #1155, #3079
  static Screen + #1156, #3079
  static Screen + #1157, #3079
  static Screen + #1158, #3083
  static Screen + #1159, #3967

  ;Line 29
  static Screen + #1160, #3967
  static Screen + #1161, #3967
  static Screen + #1162, #3967
  static Screen + #1163, #3199
  static Screen + #1164, #3199
  static Screen + #1165, #3199
  static Screen + #1166, #3199
  static Screen + #1167, #3199
  static Screen + #1168, #3199
  static Screen + #1169, #3199
  static Screen + #1170, #3199
  static Screen + #1171, #3199
  static Screen + #1172, #3199
  static Screen + #1173, #3199
  static Screen + #1174, #3199
  static Screen + #1175, #3199
  static Screen + #1176, #3199
  static Screen + #1177, #3967
  static Screen + #1178, #3967
  static Screen + #1179, #3967
  static Screen + #1180, #3967
  static Screen + #1181, #3967
  static Screen + #1182, #3967
  static Screen + #1183, #3967
  static Screen + #1184, #3967
  static Screen + #1185, #3967
  static Screen + #1186, #3967
  static Screen + #1187, #3967
  static Screen + #1188, #3967
  static Screen + #1189, #3967
  static Screen + #1190, #3967
  static Screen + #1191, #3967
  static Screen + #1192, #3967
  static Screen + #1193, #3967
  static Screen + #1194, #3967
  static Screen + #1195, #3967
  static Screen + #1196, #3967
  static Screen + #1197, #3967
  static Screen + #1198, #3967
  static Screen + #1199, #3967

printScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #Screen
  loadn R1, #0
  loadn R2, #1200

  printScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts