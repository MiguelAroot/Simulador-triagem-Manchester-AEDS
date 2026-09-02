class Enfermeira {
  int contadorPreferencial = 0;
  Paciente sendoAtendido = null;
  float tempoDeAtendimento = 0;
  
  void atualizar() {
    if (sendoAtendido != null) {
      if (sendoAtendido.estado.equals("EM_ATENDIMENTO")) {
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
    Paciente proximo = null;

    // chama 2 pref e 1 normal
    if (contadorPreferencial < 2 && !triagem.filaPreferencial.vazia()) {
      proximo = triagem.filaPreferencial.removerInicio();
      contadorPreferencial++;
    } else if (!triagem.filaNormal.vazia()) {
        proximo = triagem.filaNormal.removerInicio();
        contadorPreferencial = 0; // chamou normal ent ggs
    } else if (!triagem.filaPreferencial.vazia()) {
      // chama mais pref se nao tiver normal
      proximo = triagem.filaPreferencial.removerInicio();
    }

    if (proximo != null) {
      if (proximo.assentoIndex != -1) {
        assentos[proximo.assentoIndex].estado = ASSENTO_LIVRE;
        proximo.assentoIndex = -1;
      }

      proximo.estado = EST_INDO_TRIAGEM;
      this.sendoAtendido = proximo;
      
      this.tempoDeAtendimento = random(3, 6); 
    }
  }
  
  void finalizarAtendimento() {
    if (sendoAtendido != null) {
      sendoAtendido.corManchester = manchester.classificar(sendoAtendido);
      sendoAtendido.estado = "TRIADO_" + sendoAtendido.corManchester; 
      sendoAtendido.jaFoiTriado = true;
      sendoAtendido.tentarReservarAssento();
      sendoAtendido = null;
    }
  }
  
}
