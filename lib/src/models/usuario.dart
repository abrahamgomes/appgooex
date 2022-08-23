//import 'dart:html';



import 'package:dio/dio.dart';
//import 'package:file_picker/file_picker.dart';

class Usuario {
  String firstName, lastName, user_id ,token, email, username, cpf, telefone , dataNasc ;
  bool transportador, entregador, empresa;
  String id;
  String _password;

  Usuario({
    this.id,
    this.firstName,
    this.lastName,
    this.token,
    this.email,
    this.username,
    this.transportador,
    this.telefone,
    String password,
    this.cpf,
   this.dataNasc,
    this.entregador,
    this.empresa,
    this.user_id
  }) : _password = password;

  


  Map<String, dynamic> toJsonPOST() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['password'] = this._password;
    data['telefone'] = this.telefone;
    data['cpf'] = this.cpf;
    data['transportador'] = this.transportador;
    data['entregador'] = this.entregador;
    data['empresa'] = this.empresa;
    data['dataNasc'] = this.dataNasc;
    return data;
  }
}