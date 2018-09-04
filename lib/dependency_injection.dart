import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

enum Flavor {
  MOCK,
  PROD
}

class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final int _baseTimeIdGenerator = 1535970000000;

  static void configure(Flavor flavor){
    _flavor = flavor;
  }

  factory Injector() => _singleton;

  Injector._internal();

  Flavor get flavor => _flavor;
  FirebaseAuth get auth => _auth;
  FirebaseDatabase get database => _database;
  int get baseTimeIdGenerator => _baseTimeIdGenerator;


}