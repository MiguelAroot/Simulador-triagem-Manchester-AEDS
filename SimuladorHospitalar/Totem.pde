// retira a senha (N#### normal, P#### preferencial).
// impede dois pacientes ao mesmo tempo, garantida pela matriz global "ocupacao".

class Totem {
  int linha, coluna;
  int proximaSenhaNormal = 1;
  int proximaSenhaPreferencial = 1;

  Totem(int l, int c) {
    this.linha = l;
    this.coluna = c;
  }

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
