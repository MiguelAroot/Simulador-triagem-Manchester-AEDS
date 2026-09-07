// retira a senha (N#### normal, P#### preferencial).
// impede dois pacientes ao mesmo tempo, garantida pela matriz global "ocupacao".

class Totem {
  int[][] mapaDistanciasTotem;
  Coordenadas coordTotem;
  
  int proximaSenhaNormal = 1;
  int proximaSenhaPreferencial = 1;


  String retirarSenha(int preferencial) {
    String senha;
    if (preferencial == 1) {
      senha = "P" + nf(proximaSenhaPreferencial, 4);
      proximaSenhaPreferencial++;
    } else {
      senha = "N" + nf(proximaSenhaNormal, 4);
      proximaSenhaNormal++;
    }
    return senha;
    
  }
  
  
}
