# JOGO-DO-DINO-ASSEMBLY-ICMC
Projeto de criação de um jogo em assembly no processador do ICMC para a disciplina SSC0513Organizacao e Arquitetura de Computadores

Uma recriação do clássico jogo do dinossauro do Google Chrome ("No Internet Game"), desenvolvida inteiramente em **Assembly** para o processador/simulador do ICMC-USP.
Este projeto foi desenvolvido como um exercício de lógica de programação em baixo nível. O jogo implementa mecânicas de física básica, renderização de vídeo por manipulação direta de memória e gerenciamento de estados de jogo.

* **Física de Pulo:** Implementação de gravidade e inércia para o salto do dinossauro.
* **Geração de Obstáculos:** Sistema de spawn de cactos.
* **Dificuldade Progressiva:** O jogo acelera automaticamente conforme o jogador sobrevive por mais tempo.
* **Sistema de Pontuação:** Score exibido em tempo real na tela.
* **Detecção de Colisão:** Hitbox precisa que considera a largura variável dos obstáculos.
* **Correção de Clock:** Algoritmo de delay ajustado ("Heavy Delay") para rodar suavemente em simuladores modernos de alta velocidade.

## Comandos
| Tecla | Ação |
| **ESPAÇO** | Pular |
| **ENTER** | Iniciar Jogo / Reiniciar após Game Over |

## Detalhes Técnicos
* **Linguagem:** Assembly (Conjunto de instruções do Simulador ICMC).
* **Renderização:** O cenário e os personagens são desenhados manipulando caracteres ASCII e cores diretamente na memória de vídeo.
* **Lógica de Jogo:** Loop principal com verificação de input (polling), atualização de física e renderização frame a frame.
*Desenvolvido para a disciplina de SSC0513Organizacao e Arquitetura de Computadores.*

 Jogo desenvolvido para o processador do ICMC https://github.com/simoesusp/Processador-ICMC
 Para instalar o simulador e rodar o jogo acesse este link para Linux  https://github.com/simoesusp/Processador-ICMC/tree/master/Simple_Simulator e esse para Windows https://github.com/miguel-filippo/Simple_Simulator_Windows/tree/v1.0.0
