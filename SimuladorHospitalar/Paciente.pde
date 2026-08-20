final String EST_INDO_TOTEM   = "INDO_TOTEM";
final String EST_INDO_ASSENTO = "INDO_ASSENTO";
final String EST_SENTADO      = "SENTADO";

class Paciente {
  int preferencial;
  int id;
  int[] sinaisVitais;
  int x, y;

  String estado;
  String senha = null;     // pega depois de passar no totem
  int assentoIndex = -1;   // qual cadeira o paciente reservou

  Paciente(int id, int linha, int coluna) {
    this.id = id;
    this.x = linha;
    this.y = coluna;
    this.estado = EST_INDO_TOTEM;

    float chance = random(1);
    if (chance < 0.25) {
      this.preferencial = 1;
    }

    // com os valores baseados no protocolo manchester
    this.sinaisVitais = new int[4];
    this.sinaisVitais[0] = int(random(70, 101));
    this.sinaisVitais[1] = int(random(34, 43));
    this.sinaisVitais[2] = int(random(0, 11));
    this.sinaisVitais[3] = int(random(2));
  }


  void drawPaciente() {
    if (this.preferencial == 1) {
      fill(255, 100, 100);
    } else {
      fill(100, 100, 255);
    }

    float cx = this.y * tamanhoCelula + tamanhoCelula / 2.0;
    float cy = this.x * tamanhoCelula + tamanhoCelula / 2.0;
    ellipse(cx, cy, tamanhoCelula * 0.8, tamanhoCelula * 0.8);

    // desenha a senha em cima do paciente na tela
    if (this.senha != null) {
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(9);
      text(this.senha, cx, cy - tamanhoCelula * 0.65);
    }
  }


  void atualizar() {
    if (estado.equals(EST_INDO_TOTEM)) {
      mover(mapaDistanciasTotem);

      if (this.x == totem.linha && this.y == totem.coluna) {
        if (senha == null) {
          senha = totem.retirarSenha(preferencial);
        }
        tentarReservarAssento();
      }
    } else if (estado.equals(EST_INDO_ASSENTO)) {
      Assento destino = assentos[assentoIndex];
      mover(destino.distanciasAteAqui);

      if (this.x == destino.linha && this.y == destino.coluna) {
        destino.estado = ASSENTO_OCUPADO;
        estado = EST_SENTADO;
      }
    } else if (estado.equals(EST_SENTADO)) {
      // só aguardando a triagem
    }
  }


  void tentarReservarAssento() {
    int idx = buscarAssentoMaisProximo(this.x, this.y);
    if (idx != -1) {
      assentoIndex = idx;
      assentos[idx].estado = ASSENTO_RESERVADO;
      estado = EST_INDO_ASSENTO;
    }
  }


  void mover(int[][] distancias) {
    if (distancias == null || distancias[this.x][this.y] == 0) {
      return; // ja chegou no destino
    }

    int[] dLinha = {-1, 1, 0, 0};
    int[] dColuna = {0, 0, -1, 1};

    int[] candL = new int[4];
    int[] candC = new int[4];
    int[] candDist = new int[4];
    int qtd = 0;

    for (int i = 0; i < 4; i++) {
      int nL = this.x + dLinha[i];
      int nC = this.y + dColuna[i];

      if (nL >= 0 && nL < linhas && nC >= 0 && nC < colunas) {
        int d = distancias[nL][nC];
        if (d != -1) {
          candL[qtd] = nL;
          candC[qtd] = nC;
          candDist[qtd] = d;
          qtd++;
        }
      }
    }

    // ordenação dos vizinhos por menor distancia
    for (int i = 1; i < qtd; i++) {
      int dv = candDist[i], lv = candL[i], cv = candC[i];
      int j = i - 1;
      while (j >= 0 && candDist[j] > dv) {
        candDist[j + 1] = candDist[j];
        candL[j + 1] = candL[j];
        candC[j + 1] = candC[j];
        j--;
      }
      candDist[j + 1] = dv;
      candL[j + 1] = lv;
      candC[j + 1] = cv;
    }

    int minhaDistAtual = distancias[this.x][this.y];
    for (int i = 0; i < qtd; i++) {
      boolean melhorQueAtual = candDist[i] < minhaDistAtual;
      boolean livre = !ocupacao[candL[i]][candC[i]];
      if (melhorQueAtual && livre) {
        ocupacao[this.x][this.y] = false;
        ocupacao[candL[i]][candC[i]] = true;
        this.x = candL[i];
        this.y = candC[i];
        return;
      }
    }
    // se tiver tudo bloqueado, fica no mesmo lugar
  }

}

class NoPaciente {
  Paciente dado;
  NoPaciente proximo;

  NoPaciente(Paciente p) {
    this.dado = p;
    this.proximo = null;
  }
}

class ListaPacientes {
  NoPaciente inicio;

  void adicionar(Paciente p) {
    NoPaciente novo = new NoPaciente(p);
    if (inicio == null) {
      inicio = novo;
    } else {
      NoPaciente atual = inicio;
      while (atual.proximo != null) {
        atual = atual.proximo;
      }
      atual.proximo = novo;
    }
  }


  void moverTodos() {
    // limpa o grid antes de mover todo mundo
    for (int i = 0; i < linhas; i++) {
      for (int j = 0; j < colunas; j++) {
        ocupacao[i][j] = false;
      }
    }
    NoPaciente atual = inicio;
    while (atual != null) {
      ocupacao[atual.dado.x][atual.dado.y] = true;
      atual = atual.proximo;
    }

    // atualiza a posição de paciente por paciente
    atual = inicio;
    while (atual != null) {
      atual.dado.atualizar();
      atual = atual.proximo;
    }
  }

  void desenharTodos() {
    NoPaciente atual = inicio;
    while (atual != null) {
      atual.dado.drawPaciente();
      atual = atual.proximo;
    }
  }

}
