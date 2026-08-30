// 1. ESTRUTURA DO NÓ DA LISTA
class NoPaciente {
  Paciente paciente;
  NoPaciente proximo;

  NoPaciente(Paciente p) {
    this.paciente = p;
    this.proximo = null;
  }
}

// 2. ESTRUTURA DA LISTA ENCADEADA
class ListaPacientes{
    NoPaciente inicio;
    int tamanho;

    //Construtor:
    ListaPacientes() {
    this.inicio = null;
    this.tamanho = 0;
  }


    // MÉTODO 1: ADICIONAR PACIENTE NO FINAL
    void adicionar(Paciente p) {
    NoPaciente novoNo = new NoPaciente(p);

    if (inicio == null) {
      // Se a lista estiver vazia, o novo paciente é o primeiro
      inicio = novoNo;
    } else {
      // Se já tiver gente, percorre até achar o último
      NoPaciente atual = inicio;
      while (atual.proximo != null) {
        atual = atual.proximo;
      }
      // Pendura o novo paciente no final
      atual.proximo = novoNo;
    }
    tamanho++; // Aumenta o contador de pacientes na tela
  }


    // MÉTODO 2: REMOVER PACIENTE (QUANDO PISA NO REMOVEDOR)
    void remover(Paciente p) {
    if (inicio == null) {
      return; // A lista está vazia, não há o que remover
    }

    // Caso 1: O paciente a ser removido é o primeiro da lista
    if (inicio.paciente == p) {
      inicio = inicio.proximo;
      tamanho--;
      return;
    }

    // Caso 2: O paciente está no meio ou no final da lista
    NoPaciente atual = inicio;
    while (atual.proximo != null) {
      if (atual.proximo.paciente == p) {
        atual.proximo = atual.proximo.proximo; // "Pula" o nó do paciente, removendo-o da corrente
        tamanho--;
        return;
      }
      atual = atual.proximo;
    }
  }


    // MÉTODO 3: OBTER PACIENTE POR ÍNDICE (PARA O LOOP DE DESENHO/UPDATE)
   Paciente obter(int indice) {
    if (indice < 0 || indice >= tamanho) {
      return null;
    }

    NoPaciente atual = inicio;
    for (int i = 0; i < indice; i++) {
      atual = atual.proximo;
    }
    return atual.paciente;
  }

  // Retorna a quantidade de pacientes ativos
  int obterTamanho() {
    return tamanho;
  }
} // Fim da classe ListaPacientes
