import 'package:acessible_todo/models/task_model.dart';
import 'package:acessible_todo/screens/form/form_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Lista de tarefas em andamento
  List<TaskModel> _doingTasks;
  ///Lista de tarefas concluídas
  List<TaskModel> _doneTasks;
  ///Usado para mostrar uma snackbar sem o contexto do scaffold
  GlobalKey<ScaffoldState> _globalKey;

  ThemeData get theme => Theme.of(context);
  Size get screenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();

    _globalKey = GlobalKey<ScaffoldState>();

    //Inicializa as listas
    _doingTasks = <TaskModel>[];
    _doneTasks = <TaskModel>[];
  }

  void _navigateToForm(BuildContext context) async {
    String result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => FormPage())
    );

    if (result?.isNotEmpty ?? false) {
      setState(() {
        _doingTasks.add(
          TaskModel(
            id: _genId(),
            description: result
          )
        );
      });
      
      showSnackbar(context, 'Tarefa adicionada com sucesso');
    }
  }

  ///Gera um número para identificar as tarefas
  ///caso necessário remover/editar
  int _genId() {
    DateTime now = DateTime.now();

    return now.hour + now.minute + now.second;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _globalKey,
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatButton(context),
        body: TabBarView(
          children: <Widget>[
            _buildDoingTasks(),
            _buildDoneTasks(),
          ],
        ),
      ),
    );
  }

  Semantics _buildFloatButton(BuildContext context) {
    return Semantics(
      label: 'Toque duas vezes para criar uma nova tarefa',
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _navigateToForm(context),
      ),
    );
  }

  ///Builda a appbar com as tab bars
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Minhas tarefas',
        style: theme.textTheme.title.copyWith(
          fontSize: 24.0,
          color: Colors.white
        ),
      ),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            text: 'Afazer',
          ),
          Tab(
            text: 'Concluídas',
          ),
        ],
      ),
    );
  }

  ///Builda a listagem de tarefas concluídas
  Widget _buildDoneTasks() {
    if (_doneTasks.isEmpty) {
      return _buildEmptyList('Você não possui nenhuma tarefa concluída');
    } 

    return _buildList(
      _doneTasks,
      prefix: 'Tarefa concluída',
      onItemPressed: (TaskModel pressedTask) {
        setState(() {
          //Remove da lista de afazer
          _doneTasks.removeWhere((item) => item.id == pressedTask.id);

          //Adiciona na lista de concluídas
          _doingTasks.add(
            pressedTask.copyWith(
              checked: false
            )
          );
        });

        showSnackbar(context, 'A tarefa foi movida para a lista de afazeres');
      }
    );
  }

  ///Mostra uma mensagem em formato snackbar na tela
  void showSnackbar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );

    _globalKey.currentState.showSnackBar(snackBar);
  }

  ///Constrói uma listagem vazia
  Widget _buildEmptyList(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(text),
      ),
    );
  }

  ///Builda a listagem de tarefas afazer
  Widget _buildDoingTasks() {
    if (_doingTasks.isEmpty) {
      return _buildEmptyList('Você não possui nenhuma tarefa afazer');
    } 

    return _buildList(
      _doingTasks,
      prefix: 'Tarefa afazer',
      onItemPressed: (TaskModel pressedTask) {
        setState(() {
          //Remove da lista de afazer
          _doingTasks.removeWhere((item) => item.id == pressedTask.id);

          //Adiciona na lista de concluídas
          _doneTasks.add(
            pressedTask.copyWith(
              checked: true
            )
          );
        });

        showSnackbar(context, 'A tarefa foi movida para a lista de concluídas');
      }
    );
  }

  ///Abstrai um pouco o build das listagens
  Widget _buildList(List<TaskModel> list, {void Function(TaskModel) onItemPressed, String prefix}) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        TaskModel task = list[index];

        return Semantics(
          label: '$prefix $index ${task.description}',
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) => onItemPressed(task),
            value: task.checked,
            title: Text(
              task.description
            ),
          ),
        );
      },
    );
  }
}