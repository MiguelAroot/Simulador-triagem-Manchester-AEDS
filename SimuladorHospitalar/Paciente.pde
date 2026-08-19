class Paciente {
  int preferencial;
  int id;
  int[] sinaisVitais;
  int x,y;
  
  String estado;
  
  Paciente(int id, int linha, int coluna) {
    this.id = id;
    this.x = linha;
    this.y = coluna;
    this.estado = "TOTEM";
    
    float chance = random(1);
    if (chance < 0.25) {
      this.preferencial = 1;
    }
    
    //com os valores baseados no protocolo manchester
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
    
    ellipse(this.y * tamanhoCelula + tamanhoCelula / 2.0, this.x * tamanhoCelula + tamanhoCelula / 2.0, tamanhoCelula * 0.8, tamanhoCelula * 0.8);
  }
  
  
  void mover(int[][] distancias) {
    if (distancias == null || distancias[this.x][this.y] == 0) { 
      return;
    }
  
    int[] dLinha = {-1, 1, 0, 0};
    int[] dColuna = {0, 0, -1, 1};
  
    int melhorL = this.x;
    int melhorC = this.y;
    int menorDist = distancias[this.x][this.y];
  
    for (int i = 0; i < 4; i++) {
      int nL = this.x + dLinha[i];
      int nC = this.y + dColuna[i];
  
      if (nL >= 0 && nL < linhas && nC >= 0 && nC < colunas) {
        int distVizinho = distancias[nL][nC];
        if (distVizinho != -1 && distVizinho < menorDist) {
          menorDist = distVizinho;
          melhorL = nL;
          melhorC = nC;
        }
      }
    }
     // atualização da posição do paciente no grid
    this.x = melhorL;
    this.y = melhorC;
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
    }else {
      NoPaciente atual = inicio;
      while (atual.proximo != null) {
        atual = atual.proximo;
      }
      atual.proximo = novo;
    }
  }
  
  
  void moverTodos(int[][] distancias) {
    NoPaciente atual = inicio;
    while (atual != null) {
      atual.dado.mover(distancias);
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
