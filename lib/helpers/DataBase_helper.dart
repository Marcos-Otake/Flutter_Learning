import 'package:flutter_cookbook/models/Contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper{

static DatabaseHelper _databaseHelper;
static Database _database;

String contactTable = 'contact';
String colId = 'id';
String colName = 'name';
String colEmail = 'email';
String colImagem = 'imagem';

//constructor named to create an instance of the class
DatabaseHelper._createInstance();

factory DatabaseHelper(){

  if(_databaseHelper == null){
    //runs only once
    _databaseHelper = DatabaseHelper._createInstance();
  }
  return _databaseHelper;
}

Future<Database>get database async{
  if(_database == null){
    _database = await initializeDatabase();
  }
  return _database;
}

Future<Database> initializeDatabase() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + 'contacts.db';

  var contactDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
  return contactDatabase;
}

void _createDb(Database db, int newVersion) async{
  await db.execute('CREATE TABLE $contactTable($colId integer primary key autoincrement, $colName TEXT, $colEmail TEXT, $colImagem TEXT)');
}

// Include the contact object in the database
Future<int> insertContact(Contact contact) async{

  Database db = await this.database;
  var result = await db.insert(contactTable, contact.toMap());
  return result;

}

// Returns contact by id
 Future<Contact> getContact(int id) async {

   Database db = await this.database;

   List <Map> maps = await db.query(contactTable,
   columns:[colId, colName, colEmail, colImagem],
   where: "$colId = ?",
   whereArgs: [id]);

   if(maps.length > 0 ){
     return Contact.fromMap(maps.first);
   }else{
     return null;
   }
 }

 //Return all contacts
 Future<List<Contact>> getContacts() async{
   
   Database db = await this.database;

   var result = await db.query(contactTable);

   List<Contact> list = result.isNotEmpty ? 
   result.map((c) => Contact.fromMap(c)).toList() : [];

   return list;
 }

// Update the contact object and save to the database
 Future<int> updateContact(Contact contact) async{

   var db = await this.database;

   var result = await db.update(contactTable, contact.toMap(),
   where:'$colId = ?',
   whereArgs: [contact.id]);

   return result;
 }

// Delete a contact from the database
 Future<int> deleteContact(int id) async{
   var db = await this.database;
   var result = await db.delete(contactTable,
   where:'$colId = ?',
   whereArgs: [id]);

   return result;
 }

// Obtains the number of contact objects in the database

Future<int> getCount() async{
  Database db = await this.database;
  List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $contactTable');

  int result = Sqflite.firstIntValue(x);
  return result;
}

Future close() async {
  Database db = await this.database;
  db.close();
}


}