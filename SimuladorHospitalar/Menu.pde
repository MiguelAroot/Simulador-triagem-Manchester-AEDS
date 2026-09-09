class Menu {
  int estado = 0; 
  String mapaEscolhido = "mapa1.txt";

  void exibirInicial() {
    background(200, 220, 235);
    
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(40);
    text("SIMULADOR HOSPITALAR", width/2, height/4);
    
    textSize(20);
    text("Escolha o Mapa do Hospital:", width/2, height/2 - 40);
    
    desenharBotao(width/2 - 100, height/2, 200, 40, "Mapa 1", mapaEscolhido.equals("mapa1.txt"));
    desenharBotao(width/2 - 100, height/2 + 60, 200, 40, "Mapa 2", mapaEscolhido.equals("mapa2.txt"));
    
    desenharBotao(width/2 - 100, height - 100, 200, 50, "INICIAR", false);
  }

  void exibirPausa() {
    fill(0, 150);
    rect(0, 0, width, height);
    
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text("SISTEMA PAUSADO", width/2, height/3);
    
    desenharBotao(width/2 - 100, height/2, 200, 50, "RETOMAR", false);
    desenharBotao(width/2 - 100, height/2 + 70, 200, 50, "RESETAR JOGO", false);
  }

  void desenharBotao(int x, int y, int w, int h, String texto, boolean selecionado) {
    if (selecionado) fill(100, 200, 100);
    else fill(220);
    
    stroke(40);
    strokeWeight(3);
    rect(x, y, w, h, 5);
    
    fill(40);
    textSize(16);
    text(texto, x + w/2, y + h/2);
    strokeWeight(1);
  }

  void verificarCliques() {
    if (estado == 0) {
      if (clicou(width/2 - 100, height/2, 200, 40)) mapaEscolhido = "mapa1.txt";
      if (clicou(width/2 - 100, height/2 + 60, 200, 40)) mapaEscolhido = "mapa2.txt";
      
      if (clicou(width/2 - 100, height - 100, 200, 50)) {
        resetarSimulacao(mapaEscolhido);
        estado = 1;
      }
    } else if (estado == 2) {
      if (clicou(width/2 - 100, height/2, 200, 50)) estado = 1;
      if (clicou(width/2 - 100, height/2 + 70, 200, 50)) estado = 0;
    }
  }

  boolean clicou(int x, int y, int w, int h) {
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }
}
