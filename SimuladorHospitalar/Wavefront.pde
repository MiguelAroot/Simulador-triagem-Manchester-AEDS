class Wavefront {

    int[][] calcular(int destinoL, int destinoC, char[][] mapa, int numLinhas, int numColunas) {
    int[][] distancias = new int[numLinhas][numColunas];

    //-1 pra conferir como não visitadas
    for (int i = 0; i < numLinhas; i++) {
      for (int j = 0; j < numColunas; j++) {
        distancias[i][j] = -1;
      }
    }

    // fila de coords
    FilaCoordenadas fila = new FilaCoordenadas();

    // define a distância do ponto de destino como 0 e coloca na fila
    distancias[destinoL][destinoC] = 0;
    fila.enfileirar(new Coordenadas(destinoL, destinoC));

    // vetores pra ver as posições próximas de si
    int[] dLinha = {-1, 1, 0, 0};
    int[] dColuna = {0, 0, -1, 1};

    while (!fila.vazia()) {
      Coordenadas atual = fila.desenfileirar();
    
      for (int i = 0; i < 4; i++) {
        int novoL = atual.linha + dLinha[i];
        int novoC = atual.coluna + dColuna[i];

        if (novoL >= 0 && novoL < numLinhas && novoC >= 0 && novoC < numColunas) {
          if (mapa[novoL][novoC] != '#' && distancias[novoL][novoC] == -1) {
            distancias[novoL][novoC] = distancias[atual.linha][atual.coluna] + 1;
            if (mapa[novoL][novoC] != 'A') {
            fila.enfileirar(new Coordenadas(novoL, novoC));
            }
          }
        }
      }
    }

    return distancias;
  }
}
