import 'package:band_app/shared/formatters/hour_input_formatter.dart';
import 'package:band_app/shared/widgets/inputs/default_text_input.dart';
import 'package:band_app/ui/repertoire_day/cubits/cubits.dart';
import 'package:band_app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final CreateEventCubit cubit;
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode hourFocusNode = FocusNode();
  final FocusNode observationsFocusNode = FocusNode();

  @override
  void initState() {
    cubit = context.read<CreateEventCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateEventCubit, CreateEventState>(
      listener: (context, state) {
        if (state is CreateEventSuccess) {
          context.pop(true);
        } else if (state is CreateEventError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text('Criar Evento')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder(
              bloc: cubit,
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 12.0,
                          children: [
                            DefaultTextInput(
                              label: 'Título',
                              focusNode: titleFocusNode,
                              controller: titleController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira um título';
                                }
                                return null;
                              },
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      selectedDate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          Duration(days: 365),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 55,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Text(
                                        selectedDate != null
                                            ? StringUtils.convertToDateString(
                                                selectedDate!,
                                              )
                                            : 'Selecione a data',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: TextFormField(
                                    controller: hourController,
                                    focusNode: hourFocusNode,
                                    inputFormatters: [HourInputFormatter()],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira a hora';
                                      }
                                      if (!RegExp(
                                        r'^\d{2}:\d{2}$',
                                      ).hasMatch(value)) {
                                        return 'Formato inválido';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Hora',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),

                            DefaultTextInput(
                              label: 'Observações',
                              controller: observationsController,
                              focusNode: observationsFocusNode,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (state is CreateEventLoading ||
                            _formKey.currentState?.validate() != true) {
                          return;
                        }
                        DateTime dateHour = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          int.parse(hourController.text.split(':')[0]),
                          int.parse(hourController.text.split(':')[1]),
                        );
                        cubit.createEvent(
                          title: titleController.text,
                          date: dateHour,
                          observations: observationsController.text,
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                      ),
                      child: state is CreateEventLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Criar Evento',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
