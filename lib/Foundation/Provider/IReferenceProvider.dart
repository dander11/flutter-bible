
import 'package:bible_bloc/Foundation/Models/ChapterReference.dart';

abstract class IReferenceProvider {

  Future<ChapterReference> getReferenceFromId(String referencePath, String referenceId);

  Future init();
}
