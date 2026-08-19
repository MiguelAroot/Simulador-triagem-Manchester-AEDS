# Simulador-triagem-Manchester-AEDS
Simulação hospitalar multiagente em Processing para a disciplina de Algoritmos e Estruturas de Dados. Implementa o Protocolo de Manchester via Árvore de Decisão mapeada em vetor (Heap Binário), navegação por algoritmo Wavefront e modelos estocásticos (Exponencial e Gaussianos).

# Árvore de Decisão no Vetor & Navegação Wavefront

Um simulador gráfico que modela a triagem e o atendimento de pacientes em um ambiente hospitalar. O sistema utiliza estruturas de dados e algoritmos de navegação em grid.

---

* **Árvore de Decisão:** Mapeamento estático da Árvore do Protocolo de Manchester dentro de um vetor contíguo de memória;
* **Navegação Multiagente:** Algoritmo **Wavefront** para geração de caminhos mínimos no grid com tomada de decisão em duas fases (sem colisão);
* **Modelagem Estocástica:** Distribuição Exponencial para tempo de "spawn" e Distribuição Gaussiana (randomGaussian) para tempos de triagem e consulta;
* **Estruturas de Dados Autônomos:** Lista encadeada própria para controle de agentes, gerenciamento de filas e alocação dinâmica de assentos.

---

## Arquitetura e Estruturas de Dados

**Triagem (Manchester)** / Árvore Binária em Vetor / Avaliação de sinais vitais e classificação em 5 sprites diferentes (ideia original em cores mesmo).
**Movimentação** / Wavefront (BFS em Grid 2D) / Cálculo de mapa de distâncias para navegação dinâmica de pacientes até assentos/consultórios. 
**Fila de Agentes** / Lista Encadeada Dinâmica (Manual) / Gerenciamento de memória de pacientes ativos sem uso de `ArrayList`/`LinkedList` nativos. 
**Escolha de Assento** / Algoritmo de Ordenação Manual / Ordenação das opções de assentos por distância real do caminho antes da alocação física. 
**Tempos de Spawn** / Distribuição Exponencial / para modelar chegadas imprevisíveis no pronto-socorro. 

---

## Árvore de Decisão no Vetor

A navegação na árvore de triagem utiliza o mapeamento clássico de Heap Binário no vetor estático de objetos `NoManchester`:
* **Filho Esquerdo (Teste VERDADEIRO):** Índice $2i + 1$
* **Filho Direito (Teste FALSO):** Índice $2i + 2$

```text
               [Nó 0: Consciência Alterada == 1?]
                      /                      \
        (V) [Nó 1: VERMELHO]          (F) [Nó 2: Saturação < 92?]
                                                 /              \
                                   (V) [Nó 5: LARANJA]   (F) [Nó 6: Dor >= 8?]
                                                               /         \
                                                (V) [Nó 13: AMARELO]  (F) [Nó 14: Temp >= 38.0]
                                                                            /             \
                                                             (V) [Nó 29: VERDE]  (F) [Nó 30: AZUL]
