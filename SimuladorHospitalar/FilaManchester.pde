class FilaManchester {
  ListaPacientes filaVermelha = new ListaPacientes();
  ListaPacientes filaLaranja  = new ListaPacientes();
  ListaPacientes filaAmarela  = new ListaPacientes();
  ListaPacientes filaVerde    = new ListaPacientes();
  ListaPacientes filaAzul     = new ListaPacientes();


  void enfileirar(Paciente p) {
    if (p.corManchester == null) {
      return;
    }
    
    if (p.corManchester.equals("VERMELHO")) {
      filaVermelha.adicionar(p);
    }
    else if (p.corManchester.equals("LARANJA")) {
      filaLaranja.adicionar(p);
    }
    else if (p.corManchester.equals("AMARELO")) {
      filaAmarela.adicionar(p);
    }
    else if (p.corManchester.equals("VERDE")) {
      filaVerde.adicionar(p);
    }
    else if (p.corManchester.equals("AZUL")) {
      filaAzul.adicionar(p);
    }
    
  }


  Paciente desenfileirarProximo() {
    if (!filaVermelha.vazia()) {
      return filaVermelha.removerInicio();
    }
    if (!filaLaranja.vazia()) {
      return filaLaranja.removerInicio();
    }
    if (!filaAmarela.vazia()) {
      return filaAmarela.removerInicio();
    }
    if (!filaVerde.vazia()) {
      return filaVerde.removerInicio();
    }
    if (!filaAzul.vazia()) {
      return filaAzul.removerInicio();
    }
    return null;
    
  }


  boolean vazia() {
    return filaVermelha.vazia() && filaLaranja.vazia() &&
           filaAmarela.vazia()  && filaVerde.vazia()   && filaAzul.vazia();
  }
  
  
}
