import 'package:Reminders/screens/updateCard.dart';
import 'package:flutter/material.dart';
import 'package:Reminders/constans.dart';
import 'package:Reminders/db/dataCard.dart';
import 'package:Reminders/db/dataSession.dart';
import 'package:Reminders/models/cardModel.dart';
import 'package:Reminders/screens/addTabScreens.dart';
import 'package:Reminders/widgets/card.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class editor extends StatefulWidget {
  String title = "Default";
  int id = 0;
  final Function onRefresh;

  editor({
    super.key,
    required this.title,
    required this.id,
    required this.onRefresh,
  });

  @override
  State<editor> createState() => _editorState();
}

class _editorState extends State<editor> {
  List<cardModel> cards = [];

  _getCards() {
    dataCard().getCards(widget.id).then((value) {
      setState(() {
        cards = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 276,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      icon: const Icon(
                        Icons.delete,
                        size: 30,
                        color: AppColors.primaryColor,
                      ),
                      title: const Text('¿Desea eliminar esta sesión?'),
                      content: const Text(
                          'Se eliminarán todas las fichas que hayas creado en esta sesión e imágenes.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Se ha eliminado la sesión ${widget.title}',
                                  style: const TextStyle(
                                    color: AppColors.primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: AppColors.primaryColor,
                                behavior: SnackBarBehavior.floating,
                              ),
                            ),
                            await dataSession().deleteSession(widget.id),
                            widget.onRefresh(),
                            Navigator.pop(context, 'OK')
                          },
                          child: const Text(
                            'Aceptar',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: AppColors.primaryTextColor,
                    size: 25,
                  ),
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Permission.storage.request();
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => form(
                          id: widget.id,
                        ),
                      ),
                    );
                    if (refresh != null) {
                      widget.onRefresh();
                      List<cardModel> value =
                          await dataCard().getCards(widget.id);
                      setState(() {
                        cards = value;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primaryTextColor,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 10),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Permission.storage.request();
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => updateCard(
                          card: cards[index],
                        ),
                      ),
                    );
                    if (refresh != null) {
                      widget.onRefresh();
                      List<cardModel> value =
                          await dataCard().getCards(widget.id);
                      setState(() {
                        cards = value;
                      });
                    }
                  },
                  child: file(
                    title: cards[index].name,
                    path: cards[index].imagePath,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
