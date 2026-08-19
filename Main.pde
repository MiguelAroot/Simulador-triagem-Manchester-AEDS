//recursos de mapa, core, nunca apagar, ok
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



void setup() {
  size(697, 700);
  
  loadMapa("mapa.txt");
  encontrarGerador();
  calcularProximoSpawn();
  
  Coordenadas totem = encontrarTotem();
  if (totem != null) {
    mapaDistancesTotem = wf.calcular(totem.linha, totem.coluna, gridMapa, linhas, colunas);
  }
  tempoUltimoFrame = millis() / 1000.0;
  
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
void drawMapa() {
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      char celula = gridMapa[i][j];
      
      if (celula == '#') fill(100);
      else if (celula == '.') fill(240);
      else if (celula == 'G') fill(0, 255, 0);
      else if (celula == 'R') fill(255, 0, 0);
      else if (celula == 'A') fill(150, 75, 0);
      else if (celula == 'T') fill(255, 255, 0);
      else if (celula == 'E') fill(0, 255, 255);
      else if (celula == 'M') fill(0, 0, 255);
      
      stroke(200);
      rect(j * tamanhoCelula, i * tamanhoCelula, tamanhoCelula, tamanhoCelula);
    }
  }
  
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
