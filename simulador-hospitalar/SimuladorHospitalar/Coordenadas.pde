class Coordenadas {
  int linha;
  int coluna;
  
  Coordenadas(int l, int c) {
    this.linha = l;
    this.coluna = c;
  }
  
}
class NoCoordenadas {
  Coordenadas dado;
  NoCoordenadas proximo;

  NoCoordenadas(Coordenadas dado) {
    this.dado = dado;
    this.proximo = null;
  }
  
}



class FilaCoordenadas {
  NoCoordenadas inicio;
  NoCoordenadas fim;

  FilaCoordenadas() {
    this.inicio = null;
    this.fim = null;
  }
  
  boolean vazia() {
    return this.inicio == null;
  }

  void enfileirar(Coordenadas c) {
    NoCoordenadas novo = new NoCoordenadas(c);
    if (this.vazia()) {
      this.inicio = novo;
      this.fim = novo;
    }else {
      this.fim.proximo = novo;
      this.fim = novo;
    }
  }
  Coordenadas desenfileirar() {
    if (this.vazia()) return null;
    
    Coordenadas c = this.inicio.dado;
    this.inicio = this.inicio.proximo;
    
    if (this.inicio == null) {
      this.fim = null;
    }
    return c;
  }
  
}
