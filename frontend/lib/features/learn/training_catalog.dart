import '../../domain/unusual_behaviour.dart';

enum TrainingFormat { video, course }

class TrainingModule {
  const TrainingModule({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.format,
    this.relatedCategory,
  });

  final String id;
  final String title;
  final String summary;
  final Uri url;
  final TrainingFormat format;
  final BehaviourCategory? relatedCategory;

  String get formatLabel => format == TrainingFormat.video ? 'VIDEO' : 'COURSE';
}

const catOperatorTrainingHost = 'catoperatortraining.com';

final catTrainingModules = [
  TrainingModule(
    id: 'engine-idle-shutdown',
    title: 'Engine Idle Shutdown on Cat Next Gen Excavators',
    summary:
        'Official Cat Operator Training on using automatic idle shutdown to cut wasted fuel and engine hours.',
    url: Uri.parse(
      'https://www.catoperatortraining.com/learn/video/engine-idle-shutdown-on-cat-next-gen-excavators',
    ),
    format: TrainingFormat.video,
    relatedCategory: BehaviourCategory.excessIdle,
  ),
  TrainingModule(
    id: '2d-e-fence-cab-avoidance',
    title: '2D E-Fence Cab Avoidance on the Next Gen Excavator',
    summary:
        'Learn how 2D E-Fence keeps the boom and stick out of the cab envelope during swing and lift.',
    url: Uri.parse(
      'https://www.catoperatortraining.com/learn/video/2d-e-fence-cab-avoidance-on-the-next-gen-excavator',
    ),
    format: TrainingFormat.video,
    relatedCategory: BehaviourCategory.harshSwingReversal,
  ),
  TrainingModule(
    id: 'next-gen-hex-efence-overview',
    title: 'Next Gen HEX E-Fence Overview',
    summary:
        'Course overview of hydraulic excavator E-Fence: set virtual walls, protect people, and stay inside the work envelope.',
    url: Uri.parse(
      'https://www.catoperatortraining.com/courses/next-gen-hex-efence-overview',
    ),
    format: TrainingFormat.course,
  ),
];

List<TrainingModule> recommendedTrainingFor(
  List<BehaviourInsight> insights,
) {
  final categories = insights.map((item) => item.category).toSet();
  final recommended = catTrainingModules
      .where(
        (module) =>
            module.relatedCategory != null &&
            categories.contains(module.relatedCategory),
      )
      .toList();
  if (recommended.isNotEmpty) return recommended;
  return catTrainingModules;
}
