import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController _controller;
  ///Usado para mostrar uma snackbar sem o contexto do scaffold
  GlobalKey<ScaffoldState> _globalKey;

  ThemeData get theme => Theme.of(context);

  @override
  void initState() {
    super.initState();

    _globalKey = GlobalKey<ScaffoldState>();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: _buildCloseButton(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildTextField(),
            const Spacer(),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Builder _buildCloseButton() {
    return Builder(
      builder: (context) {
        return Semantics(
          label: 'Toque duas vezes para voltar para a listagem de tarefas',
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Digite a descrição da tarefa',
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 48.0,
      child: Semantics(
        label: 'Toque duas vezes para adicionar a tarefa',
        child: FlatButton(
          color: theme.primaryColor,
          child: const Text(
            'Adicionar',
            style: const TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            } else {
              _globalKey.currentState.showSnackBar(
                const SnackBar(content: Text("Digite a descrição da tarefa no campo de texto"))
              );
            }
          },
        ),
      ),
    );
  }
}