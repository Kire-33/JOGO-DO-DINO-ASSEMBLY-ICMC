; Nome: Erik Reis de Oliveira Santos NUSP: 16864139

; ===== JOGO DO DINOSSAURO =====
jmp main

; ===== VARIAVEIS =====
pos_ant_dino: var #1
static pos_ant_dino + #0, #1080

dino_pos: var #1
static dino_pos + #0, #1080

dino_vel_y: var #1
static dino_vel_y + #0, #0

dino_no_chao: var #1
static dino_no_chao + #0, #1

timer_gravidade: var #1
static timer_gravidade + #0, #0

; --- SISTEMA DE CACTOS ---
cacto1_pos: var #1
static cacto1_pos + #0, #0
cacto1_pos_ant: var #1
static cacto1_pos_ant + #0, #0
cacto1_tipo: var #1    
static cacto1_tipo + #0, #0

cacto2_pos: var #1
static cacto2_pos + #0, #0
cacto2_pos_ant: var #1
static cacto2_pos_ant + #0, #0
cacto2_tipo: var #1
static cacto2_tipo + #0, #0

cacto3_pos: var #1
static cacto3_pos + #0, #0
cacto3_pos_ant: var #1
static cacto3_pos_ant + #0, #0
cacto3_tipo: var #1
static cacto3_tipo + #0, #0


timer_spawn: var #1
static timer_spawn + #0, #5    
proximo_tipo: var #1
static proximo_tipo + #0, #0   

score: var #1
static score + #0, #0
game_over: var #1
static game_over + #0, #0

; --- VELOCIDADE INICIAL ---
velocidade: var #1
static velocidade + #0, #40   
contador_vel: var #1
static contador_vel + #0, #0
tecla_pressionada: var #1
static tecla_pressionada + #0, #0
chao_y: var #1
static chao_y + #0, #27

; ===== MAIN =====
main:
    loadn r1, #tela_inicio0
    loadn r2, #3584
    call print_tela
    call aguarda_enter
    
inicio_jogo:
    call inicializa_variaveis
    call desenha_cenario
    
loop_principal:
    call atualiza_dino
    call verifica_tecla
    call gerencia_cactos  
    call verifica_colisao
    call desenha_jogo
    call atualiza_score
    call aumenta_velocidade
    
    load r0, game_over
    loadn r1, #1
    cmp r0, r1
    jeq fim_jogo
    
    call delay_jogo
    jmp loop_principal

fim_jogo:
    loadn r1, #tela_gameover0
    loadn r2, #2304
    call print_tela
    call mostra_score_final
    call aguarda_enter
    jmp inicio_jogo

; ===== INICIALIZA =====
inicializa_variaveis:
    push r0
    
    loadn r0, #1080
    store dino_pos, r0
    store pos_ant_dino, r0
    
    loadn r0, #0
    store dino_vel_y, r0
    store game_over, r0
    store score, r0
    store contador_vel, r0
    store dino_no_chao, r0
    store timer_gravidade, r0
    
    loadn r0, #1
    store dino_no_chao, r0
    
    ; Limpa cactos (todos inativos = 0)
    loadn r0, #0
    store cacto1_pos, r0
    store cacto1_pos_ant, r0
    store cacto2_pos, r0
    store cacto2_pos_ant, r0
    store cacto3_pos, r0
    store cacto3_pos_ant, r0
    store proximo_tipo, r0
    
    ; Timer inicial para o primeiro cacto
    loadn r0, #20
    store timer_spawn, r0
    
    ; --- RESET DA VELOCIDADE ---
    loadn r0, #200     
    store velocidade, r0
    
    pop r0
    rts

; ===== VERIFICA TECLA =====
verifica_tecla:
    push r0
    push r1
    push r2
    
    inchar r0
    loadn r1, #' '
    cmp r0, r1
    jne verifica_tecla_fim
    
    load r2, dino_no_chao
    loadn r1, #1
    cmp r2, r1
    jne verifica_tecla_fim
   
    loadn r0, #3
    store dino_vel_y, r0
    loadn r0, #0
    store dino_no_chao, r0
    
verifica_tecla_fim:
    pop r2
    pop r1
    pop r0
    rts

; ===== ATUALIZA DINO =====
atualiza_dino:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    load r0, dino_pos
    store pos_ant_dino, r0
    
    load r0, dino_no_chao
    loadn r1, #1
    cmp r0, r1
    jeq atualiza_dino_fim
    
    load r0, dino_pos
    load r1, dino_vel_y
    
    loadn r2, #40
    mul r3, r1, r2      
    sub r4, r0, r3      
    store dino_pos, r4  
    
atualiza_dino_gravidade:
    load r5, timer_gravidade
    inc r5
    store timer_gravidade, r5
    
    loadn r2, #2
    mod r5, r5, r2
    loadn r2, #0
    cmp r5, r2
    jne atualiza_dino_check_chao
    
    load r1, dino_vel_y
    dec r1              
    store dino_vel_y, r1
    
atualiza_dino_check_chao:
    load r0, dino_pos
    loadn r2, #1080
    cmp r0, r2
    jle atualiza_dino_fim
    
atualiza_dino_pouso:
    loadn r0, #1080
    store dino_pos, r0
    loadn r0, #0
    store dino_vel_y, r0
    loadn r0, #1
    store dino_no_chao, r0
    
atualiza_dino_fim:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ===== GERENCIA CACTOS =====
gerencia_cactos:
    push r0
    push r1
    push r2
    push r3
    
    ; 1. Move Cacto 1 se ativo
    load r0, cacto1_pos
    loadn r2, #0
    cmp r0, r2
    jeq move_cacto2 ; Se 0, esta inativo
    store cacto1_pos_ant, r0
    dec r0
    loadn r1, #1080
    cmp r0, r1
    jle desativa_cacto1 ; Se chegou na esquerda, desativa
    store cacto1_pos, r0
    jmp move_cacto2
desativa_cacto1:
    store cacto1_pos, r2 ; Salva 0
    
move_cacto2:
    load r0, cacto2_pos
    loadn r2, #0
    cmp r0, r2
    jeq move_cacto3
    store cacto2_pos_ant, r0
    dec r0
    loadn r1, #1080
    cmp r0, r1
    jle desativa_cacto2
    store cacto2_pos, r0
    jmp move_cacto3
desativa_cacto2:
    store cacto2_pos, r2

move_cacto3:
    load r0, cacto3_pos
    loadn r2, #0
    cmp r0, r2
    jeq tenta_spawnar
    store cacto3_pos_ant, r0
    dec r0
    loadn r1, #1080
    cmp r0, r1
    jle desativa_cacto3
    store cacto3_pos, r0
    jmp tenta_spawnar
desativa_cacto3:
    store cacto3_pos, r2

tenta_spawnar:
    ; Decrementa timer
    load r0, timer_spawn
    dec r0
    store timer_spawn, r0
    loadn r1, #0
    cmp r0, r1
    jgr gerencia_cactos_fim
    
    ; Timer zerou! Tentar nascer um cacto novo
    ; Procura slot livre (pos == 0)
    
    load r0, cacto1_pos
    cmp r0, r1
    jeq nascer_cacto1
    
    load r0, cacto2_pos
    cmp r0, r1
    jeq nascer_cacto2
    
    load r0, cacto3_pos
    cmp r0, r1
    jeq nascer_cacto3
    
    loadn r0, #5
    store timer_spawn, r0
    jmp gerencia_cactos_fim

nascer_cacto1:
    loadn r0, #1119 
    store cacto1_pos, r0
    store cacto1_pos_ant, r0 
    call define_tipo_e_reset
    store cacto1_tipo, r0
    jmp gerencia_cactos_fim

nascer_cacto2:
    loadn r0, #1119
    store cacto2_pos, r0
    store cacto2_pos_ant, r0
    call define_tipo_e_reset
    store cacto2_tipo, r0
    jmp gerencia_cactos_fim

nascer_cacto3:
    loadn r0, #1119
    store cacto3_pos, r0
    store cacto3_pos_ant, r0
    call define_tipo_e_reset
    store cacto3_tipo, r0
    jmp gerencia_cactos_fim

gerencia_cactos_fim:
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; Subrotina auxiliar para rodar o tipo e resetar timer
define_tipo_e_reset:
    ; Retorna o tipo em r0
    push r1
    push r2
    
    ; Define proximo tipo (0->1->2->0)
    load r0, proximo_tipo
    loadn r1, #1
    add r0, r0, r1
    loadn r1, #3
    mod r0, r0, r1
    store proximo_tipo, r0
    
    ; Define tempo para o PROXIMO cacto (ESPAÇAMENTO)
   
    loadn r1, #65
    store timer_spawn, r1
    
    pop r2
    pop r1
    rts

; ===== VERIFICA COLISAO =====
verifica_colisao:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    load r0, dino_pos
    loadn r1, #40
    mod r2, r0, r1 ; r2 = Coluna do Dino
    
    ; Colisao Cacto 1
    load r3, cacto1_pos
    cmp r3, r1     ; Se pos < 40 (ou 0), ignora
    jle check_cacto2
    mod r3, r3, r1 ; r3 = Coluna Cacto 1
    sub r3, r3, r2 ; r3 = Distancia
    call abs_r3
    loadn r4, #1   ; Distancia de colisao (1 bloco)
    cmp r3, r4
    jgr check_cacto2
    ; Colisao X ok, checar Y
    call checa_altura_dino
    
check_cacto2:
    load r3, cacto2_pos
    cmp r3, r1
    jle check_cacto3
    mod r3, r3, r1
    sub r3, r3, r2
    call abs_r3
    loadn r4, #1
    cmp r3, r4
    jgr check_cacto3
    call checa_altura_dino

check_cacto3:
    load r3, cacto3_pos
    cmp r3, r1
    jle verifica_colisao_fim
    mod r3, r3, r1
    sub r3, r3, r2
    call abs_r3
    loadn r4, #1
    cmp r3, r4
    jgr verifica_colisao_fim
    call checa_altura_dino
    
verifica_colisao_fim:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

abs_r3:
    loadn r4, #0
    cmp r3, r4
    jgr abs_fim ; Se for Maior que 0, fim
    jeq abs_fim ; Se for Igual a 0, fim
    sub r3, r4, r3 ; Se chegou aqui, é negativo. Inverte sinal.
abs_fim:
    rts

checa_altura_dino:
    ; Se chegou aqui, colidiu no X. Se o dino estiver baixo, morre.
    load r0, dino_pos
    loadn r1, #40
    div r0, r0, r1 ; r0 = Linha do dino
    loadn r1, #27  ; Linha do chao
    cmp r0, r1
    jeq morre
    rts

morre:
    loadn r0, #1
    store game_over, r0
    pop r4 ; Limpa pilha antes de sair forçado (gambiarra segura aqui)
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ===== DESENHA JOGO =====
desenha_jogo:
    push r0
    push r1
    push r2
    call desenha_chao
    call desenha_dino
    call desenha_cactos_visuais
    call desenha_score
    pop r2
    pop r1
    pop r0
    rts

; ===== DESENHA CACTOS =====
desenha_cactos_visuais:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    ; Desenha Cacto 1
    load r0, cacto1_pos_ant
    loadn r4, #0
    cmp r0, r4
    jeq draw_c1_new
    loadn r1, #' '
    outchar r1, r0
draw_c1_new:
    load r0, cacto1_pos
    cmp r0, r4
    jeq desenha_c2
    load r3, cacto1_tipo
    call get_char_cacto
    outchar r1, r0
    
desenha_c2:
    load r0, cacto2_pos_ant
    cmp r0, r4
    jeq draw_c2_new
    loadn r1, #' '
    outchar r1, r0
draw_c2_new:
    load r0, cacto2_pos
    cmp r0, r4
    jeq desenha_c3
    load r3, cacto2_tipo
    call get_char_cacto
    outchar r1, r0

desenha_c3:
    load r0, cacto3_pos_ant
    cmp r0, r4
    jeq draw_c3_new
    loadn r1, #' '
    outchar r1, r0
draw_c3_new:
    load r0, cacto3_pos
    cmp r0, r4
    jeq desenha_cactos_fim
    load r3, cacto3_tipo
    call get_char_cacto
    outchar r1, r0
    
desenha_cactos_fim:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

get_char_cacto:
    ; Entrada: r3 (tipo), Saida: r1 (char colorido)
    ; Tipo 0: 'i' 
    loadn r2, #0
    cmp r3, r2
    jne try_tipo1
    loadn r1, #'i'
    loadn r2, #512
    add r1, r1, r2
    rts
try_tipo1:
    ; Tipo 1: 'Y' 
    loadn r2, #1
    cmp r3, r2
    jne try_tipo2
    loadn r1, #'Y'
    loadn r2, #768
    add r1, r1, r2
    rts
try_tipo2:
    ; Tipo 2: '#' 
    loadn r1, #'#'
    loadn r2, #2304
    add r1, r1, r2
    rts

; ===== OUTRAS SUBROTINAS =====
desenha_cenario:
    push r0
    push r1
    push r2
    loadn r0, #' '
    loadn r1, #0
    loadn r2, #1200
desenha_cenario_loop:
    outchar r0, r1
    inc r1
    cmp r1, r2
    jle desenha_cenario_loop
    call desenha_chao
    pop r2
    pop r1
    pop r0
    rts

desenha_chao:
    push r0
    push r1
    push r2
    push r3
    loadn r0, #1120
    loadn r1, #'_'
    loadn r2, #512
    add r1, r1, r2
    loadn r2, #40
    loadn r3, #0
desenha_chao_loop:
    outchar r1, r0
    inc r0
    inc r3
    cmp r3, r2
    jle desenha_chao_loop
    pop r3
    pop r2
    pop r1
    pop r0
    rts

desenha_dino:
    push r0
    push r1
    push r2
    push r3
    load r0, pos_ant_dino
    loadn r1, #' '
    outchar r1, r0
    inc r0
    outchar r1, r0
    load r0, dino_pos
    loadn r1, #'D'
    loadn r2, #2816
    add r1, r1, r2
    outchar r1, r0
    loadn r3, #1
    add r0, r0, r3
    loadn r1, #'>'
    add r1, r1, r2
    outchar r1, r0
    pop r3
    pop r2
    pop r1
    pop r0
    rts

atualiza_score:
    push r0
    load r0, score
    inc r0
    store score, r0
    pop r0
    rts

desenha_score:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    loadn r0, #10
    loadn r1, #'S'
    loadn r2, #3072
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'C'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #':'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    inc r0
    load r3, score
    loadn r4, #10
    loadn r5, #'0'
    div r1, r3, r4
    div r1, r1, r4
    div r1, r1, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    div r1, r3, r4
    div r1, r1, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    div r1, r3, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    mod r1, r3, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

aumenta_velocidade:
    push r0
    push r1
    load r0, contador_vel
    inc r0
    store contador_vel, r0
    loadn r1, #40
    cmp r0, r1
    jle aumenta_velocidade_fim
    loadn r0, #0
    store contador_vel, r0
    load r0, velocidade
    loadn r1, #10
    cmp r0, r1
    jle aumenta_velocidade_fim
    dec r0
    store velocidade, r0
aumenta_velocidade_fim:
    pop r1
    pop r0
    rts

; ===== DELAY =====
delay_jogo:
    push r0
    push r1
    load r0, velocidade
    
delay_jogo_loop:

    loadn r1, #2000
    
delay_jogo_inner:
    dec r1
    jnz delay_jogo_inner
    
    dec r0
    jnz delay_jogo_loop 
    
    pop r1
    pop r0
    rts

aguarda_enter:
    push r0
    push r1
aguarda_enter_loop:
    inchar r0
    loadn r1, #13
    cmp r0, r1
    jne aguarda_enter_loop
aguarda_enter_limpa:
    inchar r0
    loadn r1, #255
    cmp r0, r1
    jne aguarda_enter_limpa
    pop r1
    pop r0
    rts

print_tela:
    push r0
    push r1
    push r2
    push r3
    push r4
    loadn r0, #0
    loadn r3, #1200
    loadn r4, #40
print_tela_loop:
    call print_linha
    add r0, r0, r4
    add r1, r1, r4
    inc r1
    cmp r0, r3
    jle print_tela_loop
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

print_linha:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    loadn r3, #'\0'
    mov r5, r0
print_linha_loop:
    loadi r4, r1
    cmp r4, r3
    jeq print_linha_fim
    add r4, r2, r4
    outchar r4, r5
    inc r5
    inc r1
    jmp print_linha_loop
print_linha_fim:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

mostra_score_final:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    loadn r0, #593
    loadn r2, #2816
    load r3, score
    loadn r4, #10
    loadn r5, #'0'
    div r1, r3, r4
    div r1, r1, r4
    div r1, r1, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    div r1, r3, r4
    div r1, r1, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    div r1, r3, r4
    mod r1, r1, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    inc r0
    mod r1, r3, r4
    add r1, r1, r5
    add r1, r1, r2
    outchar r1, r0
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ===== STRINGS =====
tela_inicio0:  string "                                        "
tela_inicio1:  string "                                        "
tela_inicio2:  string "                                        "
tela_inicio3:  string "                                        "
tela_inicio4:  string "                                        "
tela_inicio5:  string "          JOGO DO DINOSSAURO            "
tela_inicio6:  string "                                        "
tela_inicio7:  string "                                        "
tela_inicio8:  string "            D> -------- |               "
tela_inicio9:  string "          ____________|___              "
tela_inicio10: string "                                        "
tela_inicio11: string "                                        "
tela_inicio12: string "         PRESSIONE ESPACO               "
tela_inicio13: string "             PARA PULAR                 "
tela_inicio14: string "                                        "
tela_inicio15: string "                                        "
tela_inicio16: string "        DESVIE DOS CACTOS!              "
tela_inicio17: string "                                        "
tela_inicio18: string "                                        "
tela_inicio19: string "                                        "
tela_inicio20: string "                                        "
tela_inicio21: string "                                        "
tela_inicio22: string "                                        "
tela_inicio23: string "        ENTER PARA COMECAR              "
tela_inicio24: string "                                        "
tela_inicio25: string "                                        "
tela_inicio26: string "                                        "
tela_inicio27: string "                                        "
tela_inicio28: string "                                        "
tela_inicio29: string "                                        "

tela_gameover0:  string "                                        "
tela_gameover1:  string "                                        "
tela_gameover2:  string "                                        "
tela_gameover3:  string "                                        "
tela_gameover4:  string "                                        "
tela_gameover5:  string "                                        "
tela_gameover6:  string "            GAME OVER!                  "
tela_gameover7:  string "                                        "
tela_gameover8:  string "                                        "
tela_gameover9:  string "                X                       "
tela_gameover10: string "             D> |                       "
tela_gameover11: string "           _______                      "
tela_gameover12: string "                                        "
tela_gameover13: string "                                        "
tela_gameover14: string "          SEU SCORE:                    "
tela_gameover15: string "                                        "
tela_gameover16: string "                                        "
tela_gameover17: string "                                        "
tela_gameover18: string "                                        "
tela_gameover19: string "                                        "
tela_gameover20: string "                                        "
tela_gameover21: string "                                        "
tela_gameover22: string "       ENTER PARA JOGAR NOVAMENTE       "
tela_gameover23: string "                                        "
tela_gameover24: string "                                        "
tela_gameover25: string "                                        "
tela_gameover26: string "                                        "
tela_gameover27: string "                                        "
tela_gameover28: string "                                        "
tela_gameover29: string "                                        "