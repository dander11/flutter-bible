
import '../Models/ChapterReference.dart';

abstract class IReferenceProvider {

  Future<ChapterReference> getReferenceFromId(String referencePath, String referenceId);

  Future init();
}
