import 'package:all_my_cards/models/payment_card.dart';
import 'package:all_my_cards/states/app_state.dart';
import 'package:all_my_cards/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

enum ManageCardPageModes {
  add,
  edit,
}

class ManageCardPage extends StatefulWidget {
  const ManageCardPage({this.mode = ManageCardPageModes.add, this.card});

  final ManageCardPageModes mode;
  final PaymentCard card;
  @override
  _ManageCardPageState createState() => _ManageCardPageState();
}

class _ManageCardPageState extends State<ManageCardPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  PaymentCard card;
  String title;

  @override
  void initState() {
    switch (widget.mode) {
      case ManageCardPageModes.add:
        title = 'Add';
        Provider.of<AppState>(context, listen: false).tempCard =
            PaymentCard(date: DateTime.now());
        break;
      case ManageCardPageModes.edit:
        title = 'Edit';
        Provider.of<AppState>(context, listen: false).tempCard = widget.card;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title Card')),
      body: Consumer<AppState>(
        builder: (context, state, child) => Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: ListView(
                key: ObjectKey(state.tempCard),
                padding: const EdgeInsets.all(16.0),
                primary: false,
                children: [
                  TextFormField(
                    initialValue: state.tempCard?.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Card Name'),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Too short';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state.tempCard = state.tempCard.copyWith(name: value);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue: state.tempCard?.nameOnCard,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name on Card'),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Too short';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state.tempCard =
                          state.tempCard.copyWith(nameOnCard: value);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue: '${state.tempCard?.limit}',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Card Limit'),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Too short';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state.tempCard =
                          state.tempCard.copyWith(limit: int.tryParse(value));
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue:
                        state.tempCard?.paymentDueDate?.toString() ?? '',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Payment Due Day'),
                    validator: (value) {
                      if (value.length < 1) {
                        return 'Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state.tempCard = state.tempCard
                          .copyWith(paymentDueDate: int.tryParse(value));
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue:
                        state.tempCard?.statementDate?.toString() ?? '',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Statement Day'),
                    validator: (value) {
                      if (value.length < 1) {
                        return 'Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state.tempCard = state.tempCard
                          .copyWith(statementDate: int.tryParse(value));
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Color',
                  //       // prefixText: '#',
                  //       prefix: CircleAvatar(
                  //         backgroundColor: state.tempCard.color,
                  //       ),
                  //       suffix: ),
                  //   validator: (value) {
                  //     if (value.length < 1) {
                  //       return null;
                  //     }
                  //     if (value.length < 6) {
                  //       return 'Too Short (Format is RRGGBB)';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     state.tempCard = state.tempCard
                  //         .copyWith(color: ColorUtils.fromHex('#$value'));
                  //   },
                  //   keyboardType: TextInputType.text,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.allow(
                  //       RegExp('/[[:xdigit:]]+/g'),
                  //       replacementString: '',
                  //     )
                  //   ],
                  // ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: CircleAvatar(
                      backgroundColor: state.tempCard.color,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  displayThumbColor: true,
                                  onColorChanged: (Color value) {
                                    state.tempCard =
                                        state.tempCard.copyWith(color: value);
                                    print(state.tempCard.toString());
                                  },
                                  pickerColor: state.tempCard.color,
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  child: Text('Done'),
                                  onPressed: Navigator.of(context).pop,
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              )),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16.0),
                      child: ElevatedButton(
                        child: Text('Save'),
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            switch (widget.mode) {
                              case ManageCardPageModes.add:
                                await state.addCard();
                                break;
                              case ManageCardPageModes.edit:
                                await state.editCard();
                                break;
                            }
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
