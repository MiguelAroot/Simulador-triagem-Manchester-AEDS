class Manchester {
  String[] arvore;
  
  Manchester() {
    
    arvore = new String[15];
    
    arvore[1]  = "VERMELHO";
    arvore[11] = "LARANJA";
    arvore[12] = "AMARELO";
    arvore[13] = "VERDE";
    arvore[14] = "AZUL";
  }

  String classificar(Paciente p) {
    int i = 0;
    // primerio nó: se sim é emergencia
    if (p.sinaisVitais[0] < 85) {
      i = 2 * i + 1;
    } else {
      i = 2 * i + 2;
      
      // segundo: se sim, pode ser laranja ou amarelo
      // se não, pode ser verde ou blue
      if (p.sinaisVitais[1] > 38) {
        i = 2 * i + 1;
        
        // terceiro nó: se sim, laranja
        // se não, amarillo
        if (p.sinaisVitais[2] >= 8) {
          i = 2 * i + 1;
        } else {
          i = 2 * i + 2;
        }
      } else {
        i = 2 * i + 2; 
        
        // quarto nó: se sim, verde
        // se não, blue
        if (p.sinaisVitais[2] >= 4 || p.sinaisVitais[3] == 1) {
          i = 2 * i + 1; 
        } else {
          i = 2 * i + 2; 
        }
      }
    }
    // entendeu?
    return arvore[i];
  }
}
