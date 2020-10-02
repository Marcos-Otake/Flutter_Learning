import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/Contact.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;
  ContactPage({this.contact});
  

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool  edited = false;
  Contact _editContact;
  final _nameFocus = FocusNode();  
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editContact = Contact(null,'','',null);
    }else{
      _editContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(_editContact.name == '' ? 'New Contact' : 
        _editContact.name),
      ),
      floatingActionButton: FloatingActionButton(       
        onPressed: (){
          if(_editContact.name != null && _editContact.name.isNotEmpty ) {
            if(_editContact.email != null && _editContact.email.isNotEmpty){
              Navigator.pop(context,_editContact);
          }else{
            _showAlert();
            FocusScope.of(context).requestFocus(_emailFocus);
          }   
          }else{
            _showAlert();
            FocusScope.of(context).requestFocus(_nameFocus);
          }        
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.save),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
             width: 70,
             height: 70,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               image: DecorationImage(
                 image: _editContact.imagem != null ?
                 FileImage(File(_editContact.imagem)) :
                 AssetImage("image/emo3.png")
                 )
             ),
           ),
           onTap: (){
             ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
               if(file == null ) return;
               setState(() {
                 _editContact.imagem = file.path;
               });
             });
           },
          ),
          TextField(
            controller: _nameController,
            focusNode: _nameFocus,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (text){
              edited = true;
              setState(() {
                _editContact.name = text;                
              });
            },
          ),
          TextField(
            controller: _emailController,
            focusNode: _emailFocus,
            autofocus: true,           
            decoration: InputDecoration(labelText: 'Email'),
            onChanged: (text){
              edited = true;              
                _editContact.email = text;      
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    ),
   );
  }
 void _showAlert(){
   showDialog(
     context: context,
     builder: (BuildContext context){
       return AlertDialog(
         title: Text('Empty Field'),
         content: Text('Please fill in the field correctly'),
         actions: <Widget>[
           FlatButton(
             child: Text('Close'),
             onPressed: (){
               Navigator.of(context).pop();
             },
           )
         ],
       );
     }
     );
 }
}
