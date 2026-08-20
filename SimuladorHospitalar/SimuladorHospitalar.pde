// ESSA É A MAIN - mesmo nome p/ n bugar - recursos de mapa, core, nunca apagar, ok
char[][] gridMapa;
int linhas, colunas;
int tamanhoCelula = 29;

//recursos wavefront
Wavefront wf = new Wavefront();
int[][] mapaDistancesTotem;

//lista de pacientes e tudo mais
ListaPacientes pacientesAtivos = new ListaPacientes();
int contadorIds = 1;

//recursos de tempo
float tempoUltimoPasso = 0;
float intervaloPasso = 0.2;

float tempoUltimoFrame = 0;
float tempoAcumulado = 0;
float tempoProximoSpawn = 0;

int geradorL = -1, geradorC = -1;

//sprites do cenário 
PImage sprParede, sprChao, sprTotem, sprGerador, sprRemovedor;
PImage sprAssentoLivre, sprAssentoReservado, sprAssentoOcupado;
PImage sprPostoEnfermeira, sprPostoMedico;

void setup() {
  size(697, 700);

  carregarSprites();
  loadMapa("mapas/mapa1.txt");
  encontrarGerador();
  calcularProximoSpawn();
  
  Coordenadas totem = encontrarTotem();
  if (totem != null) {
    mapaDistancesTotem = wf.calcular(totem.linha, totem.coluna, gridMapa, linhas, colunas);
  }
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
    if (geradorL != -1) {
      Paciente p = new Paciente(contadorIds++, geradorL, geradorC);
      pacientesAtivos.adicionar(p);
    }
    tempoAcumulado = 0;
    calcularProximoSpawn();
  }
  
  //passo a cada 0.2s
  if (tempoAtual - tempoUltimoPasso >= intervaloPasso) {
    pacientesAtivos.moverTodos(mapaDistancesTotem);
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

float escalaBoneco = 2.2; //em uma celula só tava osso de mais para enxergar o boneco

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
      
        image(sprAssentoLivre, px, py, tamanhoCelula, tamanhoCelula);
    
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
Coordenadas encontrarTotem() {
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (gridMapa[i][j] == 'T') {
        return new Coordenadas(i, j);
      }
    }
  }
  return null;
}
