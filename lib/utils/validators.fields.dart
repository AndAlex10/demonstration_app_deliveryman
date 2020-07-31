

class FieldValidator{

  static String validateEmail(String user){
    if(user.isEmpty || !user.contains("@")) return "Usuário inválido!"; return null;
  }

  static String validateUser(String user){
    if(user.isEmpty) return "Usuário inválido!"; return null;
  }

  static String validatePassword(String pass){
    if(pass.isEmpty || pass.length < 4) return "Senha inválida!"; return null;
  }

  static String validateName(String name){
    if(name.isEmpty) return "Nome Inválido!"; return null;
  }

  static String validatePhone(String value){
    if(value.isEmpty) return "Telefone inválido!"; return null;
  }

  static String validateValue(String value){
    double val = value.isEmpty ? 0 : double.parse(value);
    if(val <= 0) return "Valor inválido!"; return null;
  }

  static String validateReason(String text){
    if(text.isEmpty) return "Informe o motivo!"; return null;
  }

}