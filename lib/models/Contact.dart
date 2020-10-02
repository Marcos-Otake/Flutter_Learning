class Contact{
int id;
String name;
String email;
String imagem;

Contact(this.id, this.name, this.email, this.imagem);

//converting an object to a map
Map<String,dynamic> toMap(){
  var map = <String,dynamic> {
    'id':id,
    'name':name,
    'email':email,
    'imagem':imagem
  };
  return map;
}

// //converting an map to a object
Contact.fromMap(Map<String,dynamic>map){
  id = map['id'];
  name = map['name'];
  email = map['email'];
  imagem = map['imagem'];
}

}