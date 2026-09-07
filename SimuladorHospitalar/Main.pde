// ESSA É A MAIN - mesmo nome p/ n bugar - recursos de mapa, core, nunca apagar, ok
char[][] gridMapa;
int linhas, colunas;
int tamanhoCelula = 29;
float escalaBoneco = 2.2; //em uma celula só tava osso de mais para enxergar o boneco

//recursos wavefront
Wavefront wf = new Wavefront();

//totem, assentos, enfermeira, medico e grid de ocupação física (true = célula com paciente)
Totem totem;
Enfermeira[] enfermeiras;
Medico[] medicos;
Assento[] assentos;
boolean[][] ocupacao;

//lista de pacientes e tudo mais
ListaPacientes pacientesAtivos = new ListaPacientes();
int contadorIds = 1;

//triagem e enfermeira
Triagem triagem = new Triagem();

// manchester e médico
Manchester manchester = new Manchester();
FilaManchester filaManchester = new FilaManchester();

//recursos de tempo
float tempoUltimoPasso = 0;
float intervaloPasso = 0.2;

float tempoUltimoFrame = 0;
float tempoAcumulado = 0;
float tempoProximoSpawn = 0;

// coords
int geradorL = -1, geradorC = -1;

//sprites do cenário 
PImage sprParede, sprChao, sprTotem, sprGerador, sprRemovedor;
PImage sprAssentoLivre, sprAssentoReservado, sprAssentoOcupado;
PImage sprPostoEnfermeira, sprPostoMedico;

void setup() {
  size(697, 700);

  carregarSprites();
  
  loadMapa("mapa1.txt");
  
  encontrarGerador();
  calcularProximoSpawn();
  
  inicializarTotem();
  inicializarAssentos();
  ocupacao = new boolean[linhas][colunas];
  
  encontrarEnfermeiras();
  encontrarMedicos();
  
  tempoUltimoFrame = millis() / 1000.0;
  
}


void carregarSprites() {
  sprParede = loadImage("sprites/parede.png");
  sprChao = loadImage("sprites/chao.png");
  sprTotem = loadImage("sprites/totem.png");
  sprRemovedor = loadImage("sprites/removedor.png");

  // ainda não tem sprite próprio de gerador, dai fica null e o drawMapa()
  // desenha um retângulo verde no lugar, pra não travar o sketch
  sprGerador = loadImage("sprites/gerador.png");

  // só existe uma imagem de assento por enquanto para os 3 estados
  sprAssentoLivre = loadImage("sprites/assento.png");
  sprAssentoReservado = loadImage("sprites/assento.png");
  sprAssentoOcupado = loadImage("sprites/assento.png");

  sprPostoEnfermeira = loadImage("sprites/enfermeira.png");
  sprPostoMedico = loadImage("sprites/medico.png");
}


void draw() {
  background(255);
  if (gridMapa != null) {
    drawMapa();
  }
  
  float tempoAtual = millis() / 1000.0;
  float deltaTime = tempoAtual - tempoUltimoFrame;
  tempoUltimoFrame = tempoAtual;
  tempoAcumulado += deltaTime;

    
  if (tempoAcumulado >= tempoProximoSpawn) {
    // só nasce paciente novo se a célula do gerador estiver livre (regra do enunciado)
    if (geradorL != -1 && !ocupacao[geradorL][geradorC]) {
      Paciente p = new Paciente(contadorIds++, geradorL, geradorC);
      pacientesAtivos.adicionar(p);
    }
    
    tempoAcumulado = 0;
    calcularProximoSpawn();
  }
  
  //passo e att a cada 0.2s
  if (tempoAtual - tempoUltimoPasso >= intervaloPasso) {
    pacientesAtivos.moverTodos();
    
    for (int i = 0; i < enfermeiras.length; i++) {
      enfermeiras[i].atualizar();
    }
    for (int i = 0; i < medicos.length; i++) {
      medicos[i].atualizar();
    }
    
    tempoUltimoPasso = tempoAtual;
  }
  
  pacientesAtivos.desenharTodos();
       
}


void calcularProximoSpawn() {
  
  float mediaSpawn = 5.0; 
  float u = random(0.0001, 0.9999); 
  tempoProximoSpawn = -mediaSpawn * log(1 - u);
  
}


void loadMapa(String arquivo) {
  
  String[] linhasArquivo = loadStrings(arquivo);
  
  String[] dimensoes = split(linhasArquivo[0], ' ');
  
  linhas = int(dimensoes[0]);
  colunas = int(dimensoes[1]);
  gridMapa = new char[linhas][colunas];
  
  for (int i = 0; i < linhas; i++) {
    String linhaAtual = linhasArquivo[i + 1];
    for (int j = 0; j < colunas; j++) {
      gridMapa[i][j] = linhaAtual.charAt(j);
    }
  }
  
}


void drawMapa() {
  
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      char celula = gridMapa[i][j];
      int px = j * tamanhoCelula;
      int py = i * tamanhoCelula;

      if (celula == '#') {
             image(sprParede, px, py, tamanhoCelula, tamanhoCelula);
           } else {
               image(sprChao, px, py, tamanhoCelula, tamanhoCelula);
           }
        }
      }

     int assentoIdxDraw = 0; // acompanha o array "assentos" na mesma ordem em que inicializarAssentos() o preencheu (varredura i,j)

     for (int i = 0; i < linhas; i++) { //passei dnv por cima para os bixinhos ficarem em cima do cenário
    for (int j = 0; j < colunas; j++) {
      char celula = gridMapa[i][j];
      int px = j * tamanhoCelula;
      int py = i * tamanhoCelula;

      if (celula == 'G') {
        if (sprGerador != null) {
          image(sprGerador, px, py, tamanhoCelula, tamanhoCelula);
        } else {
          // enquanto não existe AINDA sprites para o gerador
          fill(46, 160, 67);
          rect(px, py, tamanhoCelula, tamanhoCelula);
        }
      }
      
      else if (celula == 'R') image(sprRemovedor, px, py, tamanhoCelula, tamanhoCelula);
      else if (celula == 'T') image(sprTotem, px, py, tamanhoCelula, tamanhoCelula);
      else if (celula == 'E') desenharSpriteEstourando(sprPostoEnfermeira, px, py, escalaBoneco);
      else if (celula == 'M') desenharSpriteEstourando(sprPostoMedico, px, py, escalaBoneco);
      else if (celula == 'A') {
        // escolhe o sprite de acordo com o estado ATUAL desse assento
        // (livre / reservado / ocupado)
        String estadoAssento = assentos[assentoIdxDraw].estado;
        PImage sprAssento = sprAssentoLivre;
        if (estadoAssento.equals(ASSENTO_RESERVADO)) sprAssento = sprAssentoReservado;
        else if (estadoAssento.equals(ASSENTO_OCUPADO)) sprAssento = sprAssentoOcupado;
      
        image(sprAssento, px, py, tamanhoCelula, tamanhoCelula);
        assentoIdxDraw++;
      }
    }
  }
  
}


void desenharSpriteEstourando(PImage spr, int px, int py, float escala) {
  float tamanho = tamanhoCelula * escala;
  float destX = px + tamanhoCelula / 2.0 - tamanho / 2.0;
  float destY = py + tamanhoCelula - tamanho;
  image(spr, destX, destY, tamanho, tamanho);
}


//favor colocar os encontrar aqui
void encontrarGerador() {
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'G') {
        geradorL = i;
        geradorC = j;
        return;
      }
    }
  }
  
}


void encontrarMedicos() {
  int total = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'M') total++;
    }
  }
  
  medicos = new Medico[total];
  int idx = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'M') {
        Medico m = new Medico();
        m.coordMedico = new Coordenadas(i, j);
        m.distanciaMedico = wf.calcular(i, j, gridMapa, linhas, colunas);
        medicos[idx] = m;
        idx++;
      }
    }
  }
  
}


void encontrarEnfermeiras() {
  int total = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'E') total++;
    }
  }
  
  enfermeiras = new Enfermeira[total];
  int idx = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'E') {
        Enfermeira e = new Enfermeira();
        e.coordEnfermeira = new Coordenadas(i, j);
        e.distanciaEnfermeira = wf.calcular(i, j, gridMapa, linhas, colunas);
        enfermeiras[idx] = e;
        idx++;
      }
    }
  }
  
}


void inicializarTotem() {
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'T') {
        totem = new Totem();
        totem.coordTotem = new Coordenadas(i, j);
        // wavefront calculado UMA vez aqui: o totem não se move, então essa
        // matriz de distâncias serve para todo mundo que precisar ir até ele
        totem.mapaDistanciasTotem = wf.calcular(i, j, gridMapa, linhas, colunas);
        return;
      }
    }
  }
  
}


void inicializarAssentos() {
  int total = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'A') total++;
    }
  }
  
  assentos = new Assento[total];
  int idx = 0;
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'A') {
        Assento a = new Assento();
        a.coordAssento = new Coordenadas(i, j);
        // idem: cada assento é fixo, então seu wavefront é calculado uma
        // única vez no setup e reaproveitado por todos os pacientes
        a.distanciasAteAqui = wf.calcular(i, j, gridMapa, linhas, colunas);
        assentos[idx] = a;
        idx++;
      }
    }
  }
  
}
