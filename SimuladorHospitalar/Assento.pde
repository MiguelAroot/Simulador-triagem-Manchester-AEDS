//estados da cadeira 
final String ASSENTO_LIVRE = "LIVRE";         
final String ASSENTO_RESERVADO = "RESERVADO"; // marcado a caminho
final String ASSENTO_OCUPADO = "OCUPADO";     

class Assento {
  int linha, coluna;          // Onde a cadeira fica no mapa
  String estado;              //situação da cadeira
  int[][] distanciasAteAqui;  // O Wavefront salvo 

  Assento(int l, int c) {
    this.linha = l;
    this.coluna = c;
    this.estado = ASSENTO_LIVRE; // cadeira começa liberada
  }
}

int buscarAssentoMaisProximo(int origemL, int origemC) { 
  int total = assentos.length;

  int[] indicesLivres = new int[total];     
  int[] distanciasLivres = new int[total];  
  int qtdLivres = 0;                       

  for (int i = 0; i < total; i++) { 
    if (assentos[i].estado.equals(ASSENTO_LIVRE)) { 
      int dist = assentos[i].distanciasAteAqui[origemL][origemC]; // distância navegando pelas paredes
      if (dist != -1) {                     // -1 obstaculo ignora
        indicesLivres[qtdLivres] = i;       // Salva o ID do assento
        distanciasLivres[qtdLivres] = dist; // Salva a distância dele
        qtdLivres++;
      }
    }
  }

  for (int i = 1; i < qtdLivres; i++) {
    int distAtual = distanciasLivres[i];
    int idxAtual = indicesLivres[i];
    int j = i - 1;
    while (j >= 0 && distanciasLivres[j] > distAtual) { 
      distanciasLivres[j + 1] = distanciasLivres[j];
      indicesLivres[j + 1] = indicesLivres[j];
      j--;
    }
    distanciasLivres[j + 1] = distAtual;
    indicesLivres[j + 1] = idxAtual;
  }

  if (qtdLivres == 0) return -1; 
  return indicesLivres[0];     
}
