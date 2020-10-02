import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/cookbook/pages/ContactPage.dart';
import 'package:flutter_cookbook/helpers/DataBase_helper.dart';
import 'package:flutter_cookbook/models/Contact.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();
  List<Contact> contacts = List<Contact>();

  @override
  void initState() {
    super.initState();    
     _getAllContacts();
   }


 void _getAllContacts(){
     db.getContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Schedule"),
        backgroundColor: Colors.indigo,
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displaysContactPage();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _listContacts(context, index);
          }),
    );
  }

  _listContacts(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Row(  
            mainAxisAlignment: MainAxisAlignment.spaceBetween,         
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: contacts[index].imagem != null
                            ? FileImage(File(contacts[index].imagem))
                            : AssetImage("image/emo2.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                        style: TextStyle(fontSize: 20)),
                    Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 15)),                        
                  ],
                ),
              ),
              IconButton(
               icon: Icon(
                 Icons.delete_forever,
                 color: Colors.red,
                 size: 30,
                 ),
                onPressed: (){
                  _confirmDelete(context, contacts[index].id, index);                 
                }
               ),
            ],
          ),
        ),
      ),
      onTap:(){
        _displaysContactPage(contact: contacts[index]);
      }
    );
  }

  void _displaysContactPage({Contact contact}) async {
    final contactReceived = await Navigator.push(context,  
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)
        )
     );
     if(contactReceived != null ){
       if(contact != null){
         await db.updateContact(contactReceived);
       }else{
         await db.insertContact(contactReceived);
       }
       _getAllContacts();
     }
  }

  void _confirmDelete(BuildContext context, int contactid, index){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Contact Delete'),
          content: Text('Do you confirm to delete this contact?'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              ),
              FlatButton(
              onPressed: (){
                setState(() {
                  contacts.removeAt(index);
                  db.deleteContact(contactid);
                });
                 Navigator.of(context).pop();
              },
              child: Text('Confirm'),
              ),
          ],
        );
      }
      );
  }
}
