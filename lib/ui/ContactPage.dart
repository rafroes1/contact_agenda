import 'dart:io';

import 'package:contact_agenda/helpers/ContactHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  Contact _editedContact;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isNameSet = false;
  bool _isPhoneSet = false;
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(context, _editedContact);
              } else {
                if (!_isNameSet) {
                  FocusScope.of(context).requestFocus(_nameFocus);
                } else if (!_isPhoneSet) {
                  FocusScope.of(context).requestFocus(_phoneFocus);
                }
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _editedContact.image != null
                                  ? FileImage(File(_editedContact.image))
                                  : AssetImage("images/person.png"),
                              fit: BoxFit.cover)),
                    ),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nome"),
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira um nome";
                      }
                      _isNameSet = true;
                      return null;
                    },
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact.name = text;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.email = text;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Numero"),
                    controller: _phoneController,
                    textInputAction: TextInputAction.done,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira um numero";
                      }
                      _isPhoneSet = true;
                      return null;
                    },
                    onEditingComplete: () => node.unfocus(),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.phone = text;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria'),
                      onTap: () {
                        ImagePicker picker = ImagePicker();
                        picker
                            .getImage(
                                source: ImageSource.gallery,
                                imageQuality: 100,
                                maxHeight: 140.0,
                                maxWidth: 140.0)
                            .then((value) {
                          if (value == null) return;
                          setState(() {
                            _editedContact.image = value.path;
                          });
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      ImagePicker picker = ImagePicker();
                      picker
                          .getImage(
                              source: ImageSource.camera,
                              imageQuality: 100,
                              maxHeight: 140.0,
                              maxWidth: 140.0)
                          .then((value) {
                        if (value == null) return;
                        setState(() {
                          _editedContact.image = value.path;
                        });
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair, as alterações serão perdidas"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
