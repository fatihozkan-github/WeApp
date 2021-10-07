import 'package:flutter/material.dart';


Future<bool> showConfirmDialog(String dialogText,BuildContext context, String buttonText,{String negativeButtonText,bool showOnlyConfirmButton = false}) {
  return showDialog<bool>(
      context: context,
      builder: (c) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: Text(
                '${dialogText}',

              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                if(!showOnlyConfirmButton)...[
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text(
                          negativeButtonText ?? 'İptal',
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                ],
                Flexible(
                    child: TextButton(
                      key: ValueKey('detailCompleteButton'),
                      onPressed: () {
                        Navigator.pop(c, true);
                      },
                      child: Text(
                        '${buttonText}',
                      ),
                    )),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ));
}
