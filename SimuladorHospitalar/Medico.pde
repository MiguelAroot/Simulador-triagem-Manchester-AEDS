class Medico {
  Coordenadas coordMedico;
  int[][] distanciaMedico;
  
  Paciente sendoAtendido = null;
  float tempoDeAtendimento = 0;
  
  void atualizar() {
    if (sendoAtendido != null) {
      if (sendoAtendido.estado.equals("EM_CONSULTA")) {
        tempoDeAtendimento -= intervaloPasso; 
        
        if (tempoDeAtendimento <= 0) {
          finalizarAtendimento();
        }
      }
      return;
    }
    chamarProximo();
    
  }
  
  
  void chamarProximo() {
    Paciente proximo = filaManchester.desenfileirarProximo();
    
    if (proximo != null) {
      ocupacao[proximo.coordPaciente.linha][proximo.coordPaciente.coluna] = false;
      if (proximo.assentoIndex != -1) {
        assentos[proximo.assentoIndex].estado = ASSENTO_LIVRE;
        proximo.assentoIndex = -1;
      }

      proximo.estado = EST_INDO_MEDICO;
      this.sendoAtendido = proximo;
      proximo.medicoDestino = this;
      this.tempoDeAtendimento = random(5, 10); 
    }
    
  }
  
  
  void finalizarAtendimento() {
    if (sendoAtendido != null) {
      sendoAtendido.estado = EST_ALTA; 
      sendoAtendido = null;
    }
    
  }
  
  
}
