import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_app/state/medication_state.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  Widget build(BuildContext context) {
    final medState = context.watch<MedicationState>();
    final meds = medState.meds;
    final takenCount = medState.takenCount;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: () => _openEditDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medication Schedule",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 🔴 NEXT DOSE (STATE’DEN)
            _nextDoseCard(context),

            const SizedBox(height: 20),

            // 📋 TODAY'S MEDICINE
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Medicine",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (meds.isEmpty)
                    const Text(
                      "No medicines added yet.",
                      style: TextStyle(color: Colors.black54),
                    )
                  else
                    ...meds.asMap().entries.map((entry) {
                      final i = entry.key;
                      final m = entry.value;

                      return GestureDetector(
                        onTap: () =>
                            context.read<MedicationState>().toggleTaken(i),
                        onLongPress: () =>
                            _openEditDialog(context, index: i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: m.taken
                                ? Colors.green.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: m.taken
                                  ? Colors.green
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                m.taken
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color:
                                    m.taken ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    m.mg,
                                    style: const TextStyle(
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16,
                                      color: Colors.black45),
                                  const SizedBox(width: 4),
                                  Text(
                                    m.time,
                                    style: const TextStyle(
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📊 STATS
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: "Today",
                    value: "$takenCount/${meds.length}",
                    subtitle: "doses taken",
                    color: Colors.green.shade50,
                    textColor: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: "This Week",
                    value: "95%",
                    subtitle: "adherence",
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // NEXT DOSE CARD (STATE’TEN)
  // --------------------------------------------------
  Widget _nextDoseCard(BuildContext context) {
    final next = context.watch<MedicationState>().nextMedication;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffFF007C), Color(0xffFF4DA0)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: next == null
          ? const Text(
              "No upcoming medication",
              style: TextStyle(color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Next Dose",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 10),
                    Text(
                      next.name,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(next.time,
                        style: const TextStyle(color: Colors.white)),
                    Text(next.mg,
                        style: const TextStyle(
                            color: Colors.white70)),
                  ],
                ),
                const Icon(Icons.medication,
                    size: 40, color: Colors.white),
              ],
            ),
    );
  }

  // --------------------------------------------------
  // STAT CARD
  // --------------------------------------------------
  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: textColor)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
          Text(subtitle, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // ADD / EDIT / DELETE DIALOG
  // --------------------------------------------------
  void _openEditDialog(BuildContext context, {int? index}) {
    final state = context.read<MedicationState>();
    final isEdit = index != null;

    final nameCtrl = TextEditingController(
        text: isEdit ? state.meds[index].name : '',);
    final mgCtrl = TextEditingController(
        text: isEdit
            ? state.meds[index].mg.replaceAll('mg', '')
            : '');
    TimeOfDay? selectedTime =
        isEdit ? _parseTime(state.meds[index].time) : null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Edit Medicine" : "Add Medicine"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: mgCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Dosage (mg)"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final t = await showTimePicker(
                  context: ctx,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (t != null) selectedTime = t;
              },
              child: const Text("Pick Time"),
            ),
          ],
        ),
        actions: [
          if (isEdit)
            TextButton(
              onPressed: () async {
                await state.deleteMedicine(index: index);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedTime == null) return;

              final hh =
                  selectedTime!.hour.toString().padLeft(2, '0');
              final mm =
                  selectedTime!.minute.toString().padLeft(2, '0');
              final time = "$hh:$mm";

              if (isEdit) {
                await state.updateMedicine(
                  index: index,
                  name: nameCtrl.text,
                  mg: "${mgCtrl.text}mg",
                  time: time,
                );
              } else {
                await state.addMedicine(
                  name: nameCtrl.text,
                  mg: "${mgCtrl.text}mg",
                  time: time,
                );
              }

              if (!ctx.mounted) return;
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
