import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tremor_app/services/tremor_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tremor model inference (Android)', (tester) async {
    final service = TremorService();

    await service.init();

    final raw = List<double>.generate(
      250 * 6,
          (i) => 0.01 * (i % 6),
    );

    final processed = service.preprocessor.process(raw);
    final score = service.inference.run(processed);

    print('Tremor score: $score');

    expect(score.isFinite, true);
  });
}
