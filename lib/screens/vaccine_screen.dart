import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../utils/colors.dart';

class VaccineScreen extends StatefulWidget {
  final Pet pet;

  const VaccineScreen({
    super.key,
    required this.pet,
  });

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  final List<Map<String, dynamic>> vaccines = [];

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController notesController =
  TextEditingController();

  DateTime? appliedDate;
  DateTime? nextDate;

  Future<void> pickDate(bool isNext) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isNext) {
          nextDate = picked;
        } else {
          appliedDate = picked;
        }
      });
    }
  }

  void addVaccine() {
    if (nameController.text.isEmpty ||
        appliedDate == null ||
        nextDate == null) {
      return;
    }

    setState(() {
      vaccines.add({
        'name': nameController.text,
        'applied': appliedDate,
        'next': nextDate,
        'notes': notesController.text,
      });
    });

    nameController.clear();
    notesController.clear();

    setState(() {
      appliedDate = null;
      nextDate = null;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.pet.name} Vaccines',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// FORM
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade900
                    : Colors.white,

                borderRadius:
                BorderRadius.circular(24),
              ),

              child: Column(
                children: [
                  TextField(
                    controller: nameController,

                    decoration: const InputDecoration(
                      labelText: 'Vaccine Name',
                      prefixIcon: Icon(
                        Icons.vaccines_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: notesController,
                    maxLines: 3,

                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: Icon(
                        Icons.note_alt_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              pickDate(false),

                          child: Text(
                            appliedDate == null
                                ? 'Applied Date'
                                : appliedDate!
                                .toString()
                                .split(' ')[0],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              pickDate(true),

                          child: Text(
                            nextDate == null
                                ? 'Next Vaccine'
                                : nextDate!
                                .toString()
                                .split(' ')[0],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: addVaccine,

                      icon: const Icon(Icons.add),

                      label: const Text(
                        'Register Vaccine',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// LIST
            Expanded(
              child: vaccines.isEmpty
                  ? const Center(
                child: Text(
                  'No vaccines registered',
                ),
              )
                  : ListView.builder(
                itemCount: vaccines.length,

                itemBuilder: (context, index) {
                  final vaccine =
                  vaccines[index];

                  final expired =
                  vaccine['next']
                      .isBefore(
                    DateTime.now(),
                  );

                  return Container(
                    margin:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade900
                          : Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          expired
                              ? Colors.red
                              .withOpacity(
                            0.2,
                          )
                              : Colors.green
                              .withOpacity(
                            0.2,
                          ),

                          child: Icon(
                            expired
                                ? Icons
                                .warning_rounded
                                : Icons
                                .check_circle_rounded,

                            color: expired
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),

                        const SizedBox(
                          width: 16,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [
                              Text(
                                vaccine['name'],

                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(
                                'Applied: ${vaccine['applied'].toString().split(' ')[0]}',
                              ),

                              Text(
                                'Next: ${vaccine['next'].toString().split(' ')[0]}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}