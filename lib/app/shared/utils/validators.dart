final class Validators {
  static String? rgValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o RG';
    }

    // Verifica se o RG tem exatamente 9 caracteres (sem contar pontos ou traços)
    if (value.length != 9) {
      return 'O RG deve ter 9 caracteres.';
    }

    // Verifica se o formato contém 8 números e um dígito opcional (número ou "X")
    if (!RegExp(r'^[0-9]{8}[0-9xX]?$').hasMatch(value)) {
      return 'RG inválido. O formato correto é 8 números seguidos de um número ou "X".';
    }

    // RG não pode começar com "0" (regra comum em alguns estados)
    if (value.startsWith('0')) {
      return 'RG inválido. Não deve começar com 0.';
    }

    // Aqui podemos adicionar outras validações específicas, como região, estados, etc.

    return null;
  }
}
