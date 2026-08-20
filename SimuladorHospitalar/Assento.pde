//estados da cadeira 
final String ASSENTO_LIVRE = "LIVRE";         
final String ASSENTO_RESERVADO = "RESERVADO"; // marcado a caminho
final String ASSENTO_OCUPADO = "OCUPADO";     

class Assento {
  int linha, coluna;          // Onde a cadeira fica no mapa
  String estado;              // Como tá a situação da cadeira agora
  int[][] distanciasAteAqui;  // O Wavefront salvo pra não ter que recalcular rota toda hora

  Assento(int l, int c) {
    this.linha = l;
    this.coluna = c;
    this.estado = ASSENTO_LIVRE; // Toda cadeira começa liberada
  }
}

int buscarAssentoMaisProximo(int origemL, int origemC) { // Acha a cadeira perfeita pro paciente
  int total = assentos.length;

  int[] indicesLivres = new int[total];     // Lista de quem tá livre
  int[] distanciasLivres = new int[total];  // Lista de quão longe cada uma tá
  int qtdLivres = 0;                        // Quantas opções válidas achamos

  for (int i = 0; i < total; i++) { // Passa pente fino em todos os assentos
    if (assentos[i].estado.equals(ASSENTO_LIVRE)) { // Só interessa se tiver vaga
      int dist = assentos[i].distanciasAteAqui[origemL][origemC]; // Distância real navegando pelas paredes
      if (dist != -1) {                     // -1 é parede/bloqueado, então ignora
        indicesLivres[qtdLivres] = i;       // Salva o ID do assento
        distanciasLivres[qtdLivres] = dist; // Salva a distância dele
        qtdLivres++;
      }
    }
  }

  // Insertion sort na raça porque o professor/projeto proibiu usar biblioteca pronta
  for (int i = 1; i < qtdLivres; i++) {
    int distAtual = distanciasLivres[i];
    int idxAtual = indicesLivres[i];
    int j = i - 1;
    while (j >= 0 && distanciasLivres[j] > distAtual) { // Empurra o que for maior pra frente
      distanciasLivres[j + 1] = distanciasLivres[j];
      indicesLivres[j + 1] = indicesLivres[j];
      j--;
    }
    distanciasLivres[j + 1] = distAtual; // Encaixa o menorzinho aqui
    indicesLivres[j + 1] = idxAtual;
  }

  if (qtdLivres == 0) return -1; // Deu ruim: tudo cheio ou sem caminho
  return indicesLivres[0];       // Manda o ID da mais pertinho
}
