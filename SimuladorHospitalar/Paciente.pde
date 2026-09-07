final String EST_INDO_TOTEM   = "INDO_TOTEM";
final String EST_INDO_ASSENTO = "INDO_ASSENTO";
final String EST_SENTADO      = "SENTADO";
final String EST_AGUARDANDO   = "AGUARDANDO";
final String EST_AGUARDANDO_T = "AGUARDANDO_TRIAGEM";
final String EST_INDO_TRIAGEM = "INDO_TRIAGEM";
final String EST_AGUARDANDO_M = "AGUARDANDO_MEDICO";
final String EST_INDO_MEDICO  = "INDO_MEDICO";
final String EST_ALTA         = "ALTA";

class Paciente {
  int preferencial;
  int id;
  int[] sinaisVitais;
  Coordenadas coordPaciente;
  
  Enfermeira enfermeiraDestino;
  Medico medicoDestino;
  
  boolean jaFoiTriado = false;
  String corManchester = null;

  String estado;
  String senha = null;     // pega depois de passar no totem
  int assentoIndex = -1;   // qual cadeira o paciente reservou
  int ultimoAssentoFalho = -1; // última cadeira que ele desistiu (pra não escolher de novo)

  int framesParado = 0;              // conta há quantos frames não anda
  final int LIMITE_ESPERA = 15;

  Paciente(int id, int linha, int coluna) {
    this.id = id;
    this.coordPaciente = new Coordenadas(linha, coluna);
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
    if (this.jaFoiTriado && this.corManchester != null) {
      if (this.corManchester.equals("VERMELHO"))      fill(255, 0, 0);
      else if (this.corManchester.equals("LARANJA"))  fill(255, 127, 0);
      else if (this.corManchester.equals("AMARELO"))  fill(255, 255, 0);
      else if (this.corManchester.equals("VERDE"))    fill(0, 200, 0);
      else if (this.corManchester.equals("AZUL"))     fill(0, 127, 255);
    } else if (this.preferencial == 1) {
      fill(#FFA5DB); // Preferencial (Rosa)
    } else {
      fill(#FFFAFD); // Normal (Branco/Claro)
    }

    float cx = this.coordPaciente.coluna * tamanhoCelula + tamanhoCelula / 2.0;
    float cy = this.coordPaciente.linha * tamanhoCelula + tamanhoCelula / 2.0;
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
    if (estado.equals(EST_INDO_TOTEM)) { // ENTROU
      mover(totem.mapaDistanciasTotem);

      if (this.coordPaciente.linha == totem.coordTotem.linha && this.coordPaciente.coluna == totem.coordTotem.coluna) {
        if (senha == null) {
          senha = totem.retirarSenha(preferencial);
        }
        tentarReservarAssento();
      }

    } else if (estado.equals(EST_AGUARDANDO)) { // RESERVANDO E ABRINDO ESPAÇO NO TOTEM
      afastarDoTotem();
      tentarReservarAssento();

    } else if (estado.equals(EST_INDO_ASSENTO)) { // INDO AO ASSENTO
      Assento destino = assentos[assentoIndex];

      // distância ATÉ A CADEIRA antes de tentar mover  isso é o que importa,
      // não a posição em si (posição pode mudar sem progresso real, ex: oscilando)
      int distAntes = destino.distanciasAteAqui[this.coordPaciente.linha][this.coordPaciente.coluna];
      int xAntes = this.coordPaciente.linha;
      int yAntes = this.coordPaciente.coluna;
      
      mover(destino.distanciasAteAqui);

      int distDepois = destino.distanciasAteAqui[this.coordPaciente.linha][this.coordPaciente.coluna];

      if (this.coordPaciente.linha == destino.coordAssento.linha && this.coordPaciente.coluna == destino.coordAssento.coluna) {
        // chegou: ocupa de verdade e reseta o contador
        destino.estado = ASSENTO_OCUPADO;
        estado = EST_SENTADO;
        ocupacao[this.coordPaciente.linha][this.coordPaciente.coluna] = false;
        framesParado = 0;

      } else if (distDepois < distAntes || this.coordPaciente.linha != xAntes || this.coordPaciente.coluna != yAntes) {
        // progrediu de verdade rumo à cadeira -reseta o contador
        framesParado = 0;

      } else {
        // não progrediu (parado OU só oscilando de um lado pro outro)  conta como travado
        framesParado++;

        if (framesParado >= LIMITE_ESPERA) {
          // desiste dessa cadeira: libera a reserva pra outro paciente poder pegá-la
          destino.estado = ASSENTO_LIVRE;
          ultimoAssentoFalho = assentoIndex;
          assentoIndex = -1;
          estado = EST_AGUARDANDO;
          framesParado = 0;
        }
      }

    } else if (estado.equals(EST_SENTADO)) { // SENTOU
        if (!jaFoiTriado) {
          //
          if(this.preferencial == 1) {
            triagem.filaPreferencial.adicionar(this);
          } else {
            triagem.filaNormal.adicionar(this);
          }
          //
          this.estado = EST_AGUARDANDO_T;
        } else {
          filaManchester.enfileirar(this);
          this.estado = EST_AGUARDANDO_M;
        }
    } else if (estado.equals(EST_AGUARDANDO_T)) { // CONTINUA ESPERANDO, ENFERM DESSA VEZ
        // waiting
    } else if (estado.equals(EST_INDO_TRIAGEM)) { // INDO PRA ENFERMEIRA
        mover(this.enfermeiraDestino.distanciaEnfermeira);
        if (this.coordPaciente.linha == this.enfermeiraDestino.coordEnfermeira.linha && this.coordPaciente.coluna == this.enfermeiraDestino.coordEnfermeira.coluna) {
          estado = "EM_ATENDIMENTO"; //NA ENFERMEIRA
        }
    } else if (estado.equals(EST_AGUARDANDO_M)) { // VOLTOU E TÁ ESPERANDO O MÉDICO
        //waiting dnv médico dessa vez
    } else if (estado.equals(EST_INDO_MEDICO)) {
        mover(this.medicoDestino.distanciaMedico);
        if (this.coordPaciente.linha == this.medicoDestino.coordMedico.linha && this.coordPaciente.coluna == this.medicoDestino.coordMedico.coluna) {
          estado = "EM_CONSULTA"; //NO MEDICO
        }
    }
    
  }


  void tentarReservarAssento() {
    int idx = buscarAssentoMaisProximo(this.coordPaciente.linha, this.coordPaciente.coluna, ultimoAssentoFalho);

    if (idx != -1) {
      assentoIndex = idx;
      assentos[idx].estado = ASSENTO_RESERVADO;
      estado = EST_INDO_ASSENTO;
    } else {
      estado = EST_AGUARDANDO;
    }
    
  }


  void afastarDoTotem() {
    int[] dLinha = {-1, 1, 0, 0};
    int[] dColuna = {0, 0, -1, 1};

    for (int i = 0; i < 4; i++) {
      int nL = this.coordPaciente.linha + dLinha[i];
      int nC = this.coordPaciente.coluna + dColuna[i];
      if (nL >= 0 && nL < linhas && nC >= 0 && nC < colunas) {
        if (gridMapa[nL][nC] != '#' && gridMapa[nL][nC] != 'A' && !ocupacao[nL][nC]) {
          ocupacao[this.coordPaciente.linha][this.coordPaciente.coluna] = false;
          ocupacao[nL][nC] = true;
          this.coordPaciente.linha = nL;
          this.coordPaciente.coluna = nC;
          return;
        }
      }
    }
    
  }


  void mover(int[][] distancias) {
    if (distancias == null || distancias[this.coordPaciente.linha][this.coordPaciente.coluna] == 0) {
      return;
    }

    int[] dLinha = {-1, 1, 0, 0};
    int[] dColuna = {0, 0, -1, 1};

    int[] candL = new int[4];
    int[] candC = new int[4];
    int[] candDist = new int[4];
    int qtd = 0;

    for (int i = 0; i < 4; i++) {
      int nL = this.coordPaciente.linha + dLinha[i];
      int nC = this.coordPaciente.coluna + dColuna[i];
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

    // ordena vizinhos por menor distância
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

    int minhaDistAtual = distancias[this.coordPaciente.linha][this.coordPaciente.coluna];

    // 1ª tentativa: só anda pra quem está mais perto do destino
    for (int i = 0; i < qtd; i++) {
      if (candDist[i] < minhaDistAtual && !ocupacao[candL[i]][candC[i]]) {
        moverPara(candL[i], candC[i]);
        return;
      }
    }

    // 2ª tentativa: travado -> aceita andar de lado (distância igual)
    // pra tentar contornar quem estiver bloqueando o caminho direto
    for (int i = 0; i < qtd; i++) {
      if (candDist[i] == minhaDistAtual && !ocupacao[candL[i]][candC[i]]) {
        moverPara(candL[i], candC[i]);
        return;
      }
    }
    // se estiver tudo mesmo bloqueado, fica parado nesse frame
    
  }

  void moverPara(int nL, int nC) {
    ocupacao[this.coordPaciente.linha][this.coordPaciente.coluna] = false;
    ocupacao[nL][nC] = true;
    this.coordPaciente.linha = nL;
    this.coordPaciente.coluna = nC;
    
  }


} // <-- fecha a classe Paciente (estava faltando)



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
      ocupacao[atual.dado.coordPaciente.linha][atual.dado.coordPaciente.coluna] = true;
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
  
  
  Paciente removerInicio() {
    if(inicio == null) {
      return null;
    }
    
    Paciente p = inicio.dado;
    inicio = inicio.proximo;
    return p;
    
  }
  
  
  boolean vazia() {
    return this.inicio == null;
    
  }
  
  
}
