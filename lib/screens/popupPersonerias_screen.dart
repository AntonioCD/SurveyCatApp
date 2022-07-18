import 'package:flutter/material.dart';

class PopupPersoneriasWidget extends StatefulWidget {
  const PopupPersoneriasWidget({Key? key}) : super(key: key);

  @override
  State<PopupPersoneriasWidget> createState() => _PopupPersoneriasWidgetState();
}

enum menuitem { natural, juridica }

class _PopupPersoneriasWidgetState extends State<PopupPersoneriasWidget> {
  menuitem? _mitem = menuitem.natural;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(50.0),
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Seleccione la personeria.',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25, right: 25, bottom: 10),
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              minVerticalPadding: 0,
              title: const Text(
                'Natural',
                style: TextStyle(fontSize: 20.0),
              ),
              trailing: Radio<menuitem>(
                activeColor: Color.fromARGB(255, 0, 70, 136),
                value: menuitem.natural,
                groupValue: _mitem,
                onChanged: (menuitem? value) {
                  setState(() {
                    _mitem = value;
                  });
                },
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            ListTile(
              title: const Text(
                'Juridica',
                style: TextStyle(fontSize: 20.0),
              ),
              trailing: Radio<menuitem>(
                value: menuitem.juridica,
                activeColor: Color.fromARGB(255, 0, 70, 136),
                groupValue: _mitem,
                onChanged: (menuitem? value) {
                  setState(() {
                    _mitem = value;
                  });
                },
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  if (_mitem == menuitem.natural) {
                    Navigator.of(context).pop('natural');
                  } else if (_mitem == menuitem.juridica) {
                    Navigator.of(context).pop('juridica');
                  } else {
                    Navigator.of(context).pop('null');
                  }
                },
                child: Container(
                    width: 140,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 70, 136),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: const Center(
                      child: Text('Aceptar',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
